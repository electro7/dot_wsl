# Patrones en las obras

Los patrones genéricos están en la documentación oficial
(`/mnt/c/work/soft/jarvis/docs/patterns.md`): estructura de un proyecto, equipo con mando y
retorno, medida analógica con filtro y niveles, protocolo propio sobre ethraw o serial, órdenes desde
SHIELD con botón, coordinación por mensajes, simulación, persistencia y contadores, recomendaciones.
Plantillas para copiar en `plantillas/` (validadas con `jarvis.exe`). Aquí, lo específico de las obras que no va en la documentación.

## Equipos (fan.prg, sem.prg, barrier.prg...)

- Localización: `TUBE tube; ZONE zone_ini, zone_fin;` asignadas en init.prg. `ready(TUBE t)`
  filtra por tubo.
- Ventiladores: `inv = true` si pueden invertir ante incendio en el otro tubo. Estados de
  animación `FAN_ON1..3` con `<o>` en type.dev y un `MSG_FANIM` global.
- Local/avería fuerzan `cmd = OFF`.
- Contador de horas: `USE use;` de misc.prg (`start()/stop()/reset()`, `HOURS auto persistent
  hours`), llamado desde `check()`.

## Analógicas (fan_meters.prg)

- `ANA_FILTER_INT` de misc.prg: `ini(top, low, ANA_WAGO|ANA_JETIO)` y
  `refresh(top, low, delta, noise)` → `ANA_OK / ANA_BAD / ANA_FAIL`. Tiene estado: llamarla **una vez por ciclo**
  y decidir con el resultado guardado.
- Cada sensor enlaza dos dispositivos: `x.in` (un bit, solo para que el autómata pertenezca al módulo modbus y reciba
  `MSG_MODBUS`) y `x.filter.in` (la word). ICP por modbus: `.modbus IP,slow=200`.
- Dos familias de `fan_meters.prg`: la simple (aucalsa/pando, aucalsa-ap66/vegaviesga: máquina off/prealm/alm por
  sensor y alarma de anemómetro parado `ANE_ALM`) y la de ventilación sanitaria con modos (audasa-ap9/pedra:
  `A_FMPARAM`, `FSENSOR_ALM`, `cas_avg`). Sin ventiladores basta la simple.
- WAGO 0-20 mA: 0..4095 cuentas; JETIO 4-20 mA: 4000..20000.
- Valor de fallo para Shield: `ANA_ERROR_FXD1` (según tipo fixed/fixed1/fixed2/int).
- Niveles `static auto persistent`, uno por línea; valores por defecto en `stat init` si
  `max == 0`. `ANA_FILTER_PARAM static auto persistent delta, noise`.
- El ejemplo `ANA_FILTER`/`A_CO` de «Medida analógica con filtro y niveles» es una simplificación escrita para la
  documentación; para una obra, partir de `misc.prg` + `fan_meters.prg` reales.

## Protocolos (fire_apsensing.prg, sos_*.prg, dai_*.prg)

- Tabla de lecturas como array de struct inicializado (`FIRE_REGISTER fire_reg[] = {...}`).
- Macros de extracción: `#define WORD(n) (int) ((in[9+n*2] << 8) | in[10+n*2])`.
- Estado de comunicación en un enum `XX_CTRL cas` (INIT / CORRECT / FAIL) visible en Shield.

## Mensajes globales (misc.prg)

`MSG_ACT_CLOSE, MSG_ACT_ALERT, MSG_ACT_FIRE, MSG_ACT_FIREOTHER, MSG_CLOSE_BARRIER,
MSG_OPEN_BARRIER, MSG_CCTV_CAM, MSG_LIGHT_DAI, MSG_MEGA_FIRE...`, con el tubo como argumento.

## Paneles DGT (panel_dgt, panel_sdgt, panel, panel_pmv, panel_af, panel_sp)

- Orden de `#include` obligatorio: `panel_dgt` (protocolo, `pbuf`/`prep`) → `panel_sdgt` (servicio SDGT) → `panel` (`PANEL`,
  `PANEL_COMM`) → `panel_pmv` / `panel_af` / `panel_sp`. `N_PANEL`, `N_PMV`, `N_PAF` (`N_PSV`) antes.
- Un `PANEL_COMM pcomN` por puerto ethraw (Nport); `panel[i].addr/port/idx`; cada equipo apunta a su `panel[i].idx`.
- Pictogramas sueltos (CLV, pictos) = `PANEL_PMV` con `PMV_TP_G`, `n_col = n_fil = 0`; `panel_sp.prg` solo si es limitador
  de velocidad con menú de velocidades (`speed.prg` es el limitador por salidas digitales).
- Memorias fijas en `init.prg`: `pmv_mem[n] = pmv[k].cnf + ";" + DGT_MSG_x + ";" + (int)SCAT_x + ";" + "^A^RNA^G1xx^."`; siempre
  terminan en `^.` (o `^,` en alternancia). Se emparejan con el panel por el valor de `cnf`.
- Carpetas `.cas`: `pmsg` en N, `sdgt_cmd` en N−100, `cnf` N+100, `mem` N+200, `pmv_mem[*]` N+300..N+500 (`DGT_INDEX_*`);
  al renumerar carpetas mover las cinco a la vez y los `.NNN` fijos (`sdgt_cat_cas`).
- `PMVMAKECNF(cl, fl, co, tp, pr, sp, nl, ve, tw, bd)`: `tw` = solo dos memorias con alternancia en el PLC
  (`msg_pmvact_fix`); sin `tw`, carga de memoria 100 + activación y el panel alterna con `^T`. `bd` = pictogramas BDU (`^G1N`).

## Acciones (actions2.prg)

`A_ACTION` por tubo: `ACT action[64]`, `int volatile control`, `string status`,
`ACTION_CMD cmd[64]` (Shield escribe 777 para lanzar), `ACTION_CNF cnf[64]` (byte 0 = valor
ACT_RUN a mostrar), `ACT_RUN cas`. Para lanzar desde un autómata:
`control = n; control.validate();`. Nombres editables: `ACTION dindesc cas;`.

## Simulación

`#ifdef SIM` en cada módulo; campo `XX_SIM sim;` mandable desde Shield con `when sim cas = ...;`.
La física simulada (velocidad de aire según ventiladores, etc.) va en sim.prg; escenarios de
formación en schemas.prg.

## Redundancia (redun.prg)

Explicación y esquemas en `docs/lang/redundancia.md`. En las obras: `#dup IP intervalo` por máquina en
jarvis.prg (dentro de `#ifndef SIM_REDUN`), `#include "redun.prg"` y `A_DUP redu[N];` con **una instancia por
máquina** (`index()` = índice de la máquina vigilada; `dupindex()` = la local). Las copias son prácticamente
idénticas (villaviciosa = cefontes, 118 líneas). Constantes: `DUP_T_CONFIRM` 5 s, `DUP_T_RESET` 5 s,
`DUP_T_MIX_RESET` 600 s, `DUP_RESET_ALL`. Reinicia con `system("sudo reboot -f")`.
Fallo conocido en la condición `new != RS_RUNNING || new != RS_SUPERVISION` (siempre verdadera; debería ser `&&`):
no cambia el resultado porque `wait` se corrige solo, pero no tocar sin avisar a Vicente.
Kernel (`dupctrl.cpp`, verificado 2026-11-02): el conflicto se evalúa en `Refresh` cada 100 ms (ticks de `CTimeout` en
ms); los 30 s de `COUNT_CONFLICT` son 300 llamadas; el intervalo de `#dup` es `COUNT_RUN` = intervalo·1000/100 vueltas
del bucle de arranque; puerto UDP 14018, máximo 4 máquinas y 5 min para volver a pedir variables (`PORT`, `MAX`,
`COUNT_PST`). `MSG_DEVICE_END` en conflicto pasa la máquina a `ENDING`.
