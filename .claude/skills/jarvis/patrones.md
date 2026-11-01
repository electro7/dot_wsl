# Patrones probados en obra

Extraídos de 000_simulador (fan.prg, fire.prg, actions2.prg, modbus.prg, misc.prg) e
islares/hoz (fire_apsensing.prg). Plantillas listas en `plantillas/`.

## 1. Equipo digital con mando y retorno (ventilador, semáforo, circuito...)

```c
enum EQ { EQ_OFF, EQ_ON, EQ_MAN_OFF, EQ_MAN_ON, EQ_LOCAL, EQ_FAIL };

autom A_EQ
{
    TUBE tube;                          // localización (asignada en init.prg)
    ZONE zone_ini, zone_fin;
    bool pending_write;                 // orden en curso: no evaluar retornos
    EQ auto persistent cmd;             // última orden: se repone al recuperar comunicación

    bool input in_on, in_local, in_hot; // retornos
    bool volatile output out_on;        // mando

    EQ cas;                             // estado / órdenes Shield
    USE use;                            // horas de funcionamiento (misc.prg)

    EQ read() { ... }                   // retornos -> estado
    void check() {                      // compara cmd con retornos
        cas = read();
        if (cas != cmd) cas.trap(true); else if (cas.trapped()) cas.trap(false);
        cas.validate();
    }
    void write(EQ c) {
        if (!cas.enabled()) ? cas.desc(), " -- desactivado\n";
        else {
            cmd = c; pending_write = true;
            out_on = (c == EQ_ON || c == EQ_MAN_ON); out_on.validate();
            ontime (INTERVAL_CHECK) { pending_write = false; check(); }
        }
    }
    void cmd_auto(EQ c) { log cas.desc(), " -- orden automatismo = ", c, "\n"; cas = c; write(c); }
    bool ready(TUBE t) { return cas == EQ_OFF && cas.enabled() && !cas.trapped() && !pending_write && tube == t; }

    msg MSG_MODBUS (st) {
        switch (st) {
        case 0: cas.enable(false); -> init; break;
        case 2: cas.enable(true); ontime (1) { write(cmd); -> base; } break;
        }
    }

    stat init { -> base; }
    stat base {
        when cas { ? cas.desc(), " -- orden SCADA = ", cas, "\n"; write(cas); }
        when in_on, in_local, in_hot if (!pending_write) check();
    }
};
```
Claves: manual vs automático se distingue por el estado (`*_MAN_*`), el automatismo solo
toca equipos `ready()`; local/avería fuerzan `cmd = OFF`; estados de animación (`FAN_ON1..3`)
con `<o>` en type.dev y un `MSG_FANIM` global.

## 2. Analógica con filtro y niveles (CO, OPA, anemómetro, vibración)

- Struct `ANA_FILTER_INT` de misc.prg: `ini(top, low, ANA_WAGO|ANA_JETIO)` y
  `refresh(top, low, delta, noise)` → `ANA_OK / ANA_BAD / ANA_FAIL`.
- WAGO 0-20 mA: 0..4095 cuentas; JETIO 4-20 mA: 4000..20000.
- Valor de fallo para Shield: `ANA_ERROR_FXD1` (según tipo fixed/fixed1/fixed2/int).
- Niveles `fixed1 static auto persistent max, high, prehigh, low, prelow, min;` con valores
  por defecto en `stat init` si `max == 0`. Delta y ruido igual
  (`ANA_FILTER_PARAM static auto persistent delta, noise`).
- Lectura en `stat refresh { every (INTERVAL_ANALOG) read(); }`.

## 3. Protocolo propio sobre ethraw (o serial)

```c
autom A_XXCOM
{
    string output volatile out;
    char input in[256];
    bool eth;
    int r_comm, step;
    XX_CTRL cas;                         // FCL_INIT / CORRECT / FAIL

    void ask() { int w = 0; out[w++] = ...; out.setlength(w); if (eth) out.validate(); }
    bool chk() { return in[6] == 1 && in[7] == fun; }

    msg MSG_ETHRAW (st) { eth = st; if (!st && cas != FCL_FAIL) cas = FCL_FAIL; }

    stat init  { ontime (POLL) -> run; }
    stat run   { ontime (POLL) { step = -1; -> poll; } }
    stat poll  { if (++step >= N_STEPS) -> run; else -> query; }
    stat query {
        ask();
        ontime (TIMEOUT) {
            if (cas != FCL_FAIL && r_comm++ > RETRY) { warning cas.desc(), " -- Fallo comunicación!\n"; cas = FCL_FAIL; }
            -> run;
        }
        when in { if (chk()) { /* decodificar según step */ r_comm = 0; cas = FCL_CORRECT; } -> poll; }
    }
};
```
- Tabla de lecturas como array de struct inicializado (`FIRE_REGISTER fire_reg[] = {...}`).
- Macros de extracción: `#define WORD(n) (int) ((in[9+n*2] << 8) | in[10+n*2])`.
- Modbus TCP hecho a mano: cabecera MBAP de 7 bytes (trans, proto 0, len, id) + función.
- Re-entrar en `poll`/`query` reinicia los `ontime` del estado: es la forma de encadenar.

## 4. Orden desde Shield con botón

```c
BUTTON reset;                            // typedef bool BUTTON; type.dev: <x>Botón
when reset { if (reset) { MSG_RESET -> *; } reset = false; }
```

## 5. Coordinación por mensajes globales

misc.prg declara `MSG_ACT_CLOSE, MSG_ACT_ALERT, MSG_ACT_FIRE, MSG_ACT_FIREOTHER,
MSG_CLOSE_BARRIER, MSG_OPEN_BARRIER, MSG_CCTV_CAM, MSG_LIGHT_DAI, MSG_MEGA_FIRE...`.
Se envían con el tubo como argumento: `MSG_CLOSE_BARRIER (tube) -> *;` y cada receptor filtra
`if (t == tube)`.

## 6. Acciones (actions2.prg)

`A_ACTION` por tubo: `ACT action[64]`, `int volatile control`, `string status`,
`ACTION_CMD cmd[64]` (Shield escribe 777 para lanzar), `ACTION_CNF cnf[64]` (byte 0 = valor
ACT_RUN a mostrar), `ACT_RUN cas`. Para lanzar desde un autómata:
`control = n; control.validate();`.

## 7. Simulación

Cada módulo lleva `#ifdef SIM`: estado forzado a correcto, valores `rand()`, y un campo
`XX_SIM sim;` mandable desde Shield con `when sim cas = ...;`. Los automatismos simulan la
física (velocidad de aire según ventiladores, etc.) en sim.prg.

## 8. Persistencia y contadores

- `USE` (misc.prg): `start()`/`stop()`/`reset()`, horas en `HOURS auto persistent hours`.
- Para guardar periódicamente algo no auto: `every (10:00) x.remember();`.
- Los autómatas no se guardan solos: `remember()` explícito.
