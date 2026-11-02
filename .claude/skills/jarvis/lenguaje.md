# Lenguaje Jarvis — resumen operativo

Referencia completa: `/mnt/c/work/soft/jarvis/docs/lang.md`. Aquí lo que se usa a diario y lo
que más se olvida.

## Ejecución

- El kernel compila `jarvis.prg` (o el indicado) y ejecuta el **cuerpo principal una vez**.
  Después solo viven los autómatas y las sentencias de tiempo globales.
- No hay `main()`: el código global se ejecuta en orden de aparición (de ahí que las
  asignaciones de `init.prg` vayan tras las declaraciones).
- No existe declaración adelantada: hay que definir antes de usar (orden de los `#include`).

## Precompilador

`#define` (máx. 8 args, 256 caracteres expandidos), `#undef`, `#ifdef/#ifndef/#else/#endif`,
`#include "x.prg"`, y además:

| Directiva | Uso |
| --- | --- |
| `#pragma vers "LHOZ"` | Versión (≤10 car.). Shield construye el id del template con los alfanuméricos. |
| `#pragma desc NAME` | Descripción (≤80 car.), nombre inicial de la remota en Shield. |
| `#pragma size dev/string/code/log/enum N` | Zonas de memoria; subir si el compilador se queja. |
| `#pragma option "t"` | Opciones de línea de comandos (t = hora en trazas). |
| `#pragma silent` / `#pragma debug` | Desactiva / reactiva `?`. |
| `#pragma error "..."` | Error de compilación (se usa para exigir `N_XXX`). |
| `#pragma message "..."` | Mensaje en compilación. |
| `#driver "nombre opciones"` | Carga un driver (ver dispositivos.md). |
| `#dup "IP" [intervalo]` | Máquina redundante. |
| `#dev` | El resto del fichero es `.dev` (solo prototipos). |

## Tipos

`bool char int time_t tick_t float fixed fixed1 fixed2 string enum bitmask`.

- `fixed` = 3 decimales, `fixed2` = 2, `fixed1` = 1 (coma fija sobre int).
- `time_t` admite literales `hh:mm:ss`, `mm:ss` (p. ej. `every (10:00)` = 10 min).
- `enum`: desde 0, 16 bits. `bitmask`: 1, 2, 4...
- `string` mide **64 caracteres** (`DEFAULT_STRING` en kernel/jarvis/ucsHead.h; el manual
  dice 128 y está mal). Para textos o buffers mayores: `char x[512]`
  (`typedef char L_GRAPH[512];`).
- `typedef ENUM_A ENUM_B;` crea un alias que en Shield es otro tipo (otro icono) con los
  mismos valores: patrón habitual (`typedef FAN FAN_L;`).
- `char x[N]` es **un único dispositivo** de texto; `int x[N]` son N dispositivos.

## Modificadores

| Modificador | Efecto |
| --- | --- |
| `persistent` | Se guarda en `.pst` al hacer `remember()`. |
| `auto` | Con `persistent`: `remember()` automático al validar. |
| `volatile` | El valor es provisional hasta `validate()`; `revert()` vuelve al bueno. Típico en salidas. |
| `input` / `output` | Para drivers (modbus/jetio exigen que lo sean). |
| `static` | En struct/autom: campo de clase, compartido por todas las instancias (niveles de alarma). |
| `dindesc` | Descripción dinámica: reserva 64 caracteres para que la descripción cambie en ejecución (p. ej. nombre de acción editable desde Shield: `ACTION dindesc cas;`). |
| `file` | Flag DF_LOG (histórico). Aparece en ejemplos del manual (`int auto file x;`); no se usa en las obras. |
| `virtual` | Existe en el kernel (DF_VIRTUAL); sin uso conocido en obras. |

Palabras clave completas (kernel/jarvis/lex.cpp): `autom bitmask break case continue default
do else enum error every for if log msg msg_t ontime return stat struct switch this trace
typedef warning when while`.

Un dispositivo no volátil se valida al asignarlo **solo si cambia de valor**; para forzar el
envío a Shield, `validate()`.

## Estructuras y autómatas

```c
struct S { int a; int f(int x) { return a * x; } };   // clase con métodos, todo público
autom A : PADRE {                                      // herencia: redefine estados/métodos
    stat init { ... -> run; }
    stat run  { every (1) ...; }
} a, b[4];
```

- El primer `stat` declarado es el estado inicial.
- **El cuerpo de un `stat` se ejecuta una sola vez al entrar.** Lo que debe repetirse va en
  `every`, `ontime`, `when` o `msg` dentro del estado, y solo actúa mientras se esté en él.
- `msg` y `when` fuera de los estados actúan en cualquier estado.
- `-> estado;` solo dentro del propio autómata. Desde fuera: llamar a un método o enviar mensaje.
- Modificadores de estado: `public` (Shield puede pedirlo), `private` (no se puede salir desde
  fuera), `temporal` (no se notifica al SCADA). En la práctica no se usan: el estado visible es
  un campo enum `cas`.
- Dentro de un autómata, `index()` da su índice en la matriz; `name()`/`desc()` sus nombres.
- Límites: `MAX_STRUCT_FIELDS` = 256 en kernel/jarvis/typedef.h; `CTypeDef::AddField` lo comprueba para cualquier struct, no solo las que van en una matriz (anex.md corregido en la rama `docs`).

## Sentencias

C normal (`if/else for while do switch break continue return`) **sin operador coma**.
Máximo 4 `switch` anidados y 64 `case` en total entre ellos.

### Trazas
`? a, b, "\n";` (consola), `log`, `trace`, `warning`, `error` (consola + log con nivel).
Patrón de traza: `log cas.desc(), " -- texto = ", valor, "\n";`

### Tiempo
- `every (t) sentencia;` periódico. Los múltiplos de 5 s se alinean con el reloj **en GMT**
  (cuidado con ciclos de horas/días: usar `time()` y un flag).
- `ontime (t) sentencia;` una vez tras t (cancelado si se sale del estado).
- `time()` segundos del día, `date()` epoch (para diferencias), `clock()` ms, `wday mday month year`.

### Mensajes
```c
msg_t MSG_X;                 // declaración global
MSG_X -> *;  MSG_X (n) -> *; // broadcast (n siempre int)
MSG_X (n) -> autom;          // a uno
msg MSG_X (n) { ... }        // recepción, sin tipo en el argumento
```
Los mensajes se encolan; `when` es inmediato.

### when
```c
when x, y sentencia;      // x o y cambian desde FUERA (driver, Shield, autolink)
when m[i] ...;            // toda la matriz; i toma el índice cambiado (i no se declara)
when (cmd[x]) { ... }     // también con paréntesis
```
- **No salta con asignaciones hechas por los propios autómatas.** Para propagar un cambio
  interno como si viniera de fuera: driver `autolink`.
- No se puede asociar a un elemento concreto de una matriz.

## Funciones y métodos de dispositivo

Tabla real en `kernel/jarvis/lex.cpp` (array `CSysFun fun[]`; códigos de argumento:
i int, d double, b bool, s string, c char, t tiempo, `*` el propio dispositivo).

Globales: `rand(max) hex(v, dig) loops() cpu() mem_used() cpu_temp() system(cmd) shanswer()
dupindex() dupstat(n) keyboard(msg) shutdown() beep() hostname() pow(x, y)
sunrise(lat, lon) sunset(lat, lon)` (float), `diginp(n) digoutp(n, b)` (E/S locales),
ficheros `file_open(nombre, modo) file_write(s) file_read(n) file_seek(pos, origen) file_close()`.

Sobre cualquier dispositivo `d`: `validate() stamp(t) revert() remember() save() enable(b)
enabled() trap(b) trapped() desc() name() module() devcode() index() number() asoc(MSG)
debug(b) type() settype("TIPO") format(fmt)`.

Cadenas: `length() setlength(n) clearlength() substr(pos, n|-1) find(s) findfrom(s, p)
strchr(c) strchrfrom(c, p) crc(0=CRC16 CCITT|2=CRC32)`. Concatenación con `+`.
Conversión: `(int) "2"`, `(string) 2`, `(bool) x`.

`enable(false)` = desactivado por fallo (se ve en Shield); `trap(true)` = alarma.

## Límites del kernel (anex.md)

8 argumentos por función, 4 niveles de recursión, pila 1024, identificadores 80 car.,
256 tipos de mensaje, 256 tipos, 16 drivers, 65536 dispositivos. Cadena temporal en
expresiones: 2048 (`MAX_STRING_TEMP`). Si el manual y el kernel discrepan, manda
`kernel/jarvis/ucsHead.h`.
