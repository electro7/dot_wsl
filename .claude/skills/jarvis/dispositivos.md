# Ficheros de dispositivos (.dev) y drivers — chuleta

Referencia completa: `/mnt/c/work/soft/jarvis/docs/filedev.md` (módulos, tipos,
matrices con `*`, parámetros `@`) y `docs/driver/` (un fichero por driver).
Ante la duda manda el código del driver (`kernel/<driver>/*.cpp`).

## Sintaxis mínima

```
.<driver> [módulo]        // abre módulo
dispositivo   descripción // la descripción la interpreta el driver
.<driver>                 // cierra (recomendado)
@param  dispositivo       // parámetro de dispositivo
```
Matrices: `dev[*].x  Elemento *` (0..N-1), `*+` (1..N), `*3` (3 cifras), `1*3` (1000...).
Un dispositivo solo puede estar enlazado a **un** driver.

## Drivers usados en las obras

| Driver | Línea típica en jarvis.prg | Documentación | Para qué |
| --- | --- | --- | --- |
| cas | `#driver "cas"` | `driver/cas.md` | Shield. Siempre el primero. |
| ethraw | `#driver "ethraw -m MSG_ETHRAW"` | `driver/ethraw.md` | Equipos por TCP/UDP; el protocolo va en el .prg. |
| modbus | `#driver "modbus -n -p -t 100 -m MSG_MODBUS"` | `driver/modbus.md` | Cabeceras WAGO / Modbus TCP. |
| action | `#driver "action -w 10"` | `driver/action.md` | Acciones configurables desde Shield. Siempre el último. |
| jetio | `#driver "jetio -p -t 100 -m MSG_JETIO"` | `driver/jetio.md` | Módulos de coils simples (ICP). |
| autolink | `#driver "autolink"` | `driver/autolink.md` | Propagar un cambio interno como externo (dispara `when`). |
| serial | `#driver "serial"` | `driver/serial.md` | Puertos serie. |
| smodbus | `#driver "smodbus"` (a veces `-c`) | `driver/smodbus.md` | Jarvis como servidor modbus (en ~30 obras). |
| csnmp | `#driver "csnmp -m MSG_SNMP"` | `driver/csnmp.md` | Lectura SNMP (SAI, switches). |
| mqtt | `#driver "mqtt -m MSG_MQTT"` | `driver/mqtt.md` | Cliente MQTT (4 obras). El módulo necesita al menos una opción tras la IP (`,silent=30`). |
| varser | `#driver "varser -y -t -x 8 -S 60 -p 15000 -i PcLonIP"` | `driver/varser.md` | Servidor de variables (1 obra; ahí la clave `-i` es `PcLonIP`). |
| timetab | `#driver "timetab"` | `driver/timetab.md` | Horarios y calendarios editables desde Shield. Solo en `olot/siga` (antiguo). |

Mensaje de estado (solo a los autómatas con dispositivos en el módulo): `0` sin comunicación, `1` conectado.
modbus y jetio añaden `2` (todo actualizado), `>100` (excepción: 100 + código) y `200` (trama fuera de orden);
ethraw solo envía `0` y `1`. Cada driver solo notifica cuando el valor cambia.

## Lo más usado, de memoria

```
.modbus 192.168.240.60[,read-holding][,modbus-id=1][,silent=S]
fan[0].in_on    %IX096.0      // I entrada, Q salida, M memoria; X bit, W word, D dword
co[0].filter.in %IW001
upd[0].in       %IP000.0      // presencia de cabecera (convención obras)

.ethraw 192.168.0.90:4000,tcp,silent=30   // sin IP = servidor; UDP por omisión
port.inp                        // input: cada bloque recibido SUSTITUYE (no acumula)
port.out                        // output volatile + setlength + validate
port.cnf    config              // opcional: "ip:puerto"

.serial COM3,9600,8,N,1,silent=30  // COM1 = /dev/ttyS0; silent en centésimas
x.in        input                  // descripciones input/output (NO read/write)
x.out       output

.autolink .                        // '.' = solo valor; otro nombre = valor + enable
origen      destino

.cas Ventiladores 1300             // carpeta + código inicial (orden de memoria, no del fichero)
fan[0].cas  <r>Ventilador 1
fan[1].cas  .1305 <r>Ventilador 2  // código fijo, al principio de la descripción
```

## Convenciones de las obras (no están en la documentación)

- IPs como `#define IP_LT_1_1 ...` en jarvis.dev; cada cabecera en su `mb_<cabecera>.dev`,
  incluido entre `.modbus IP` y `.modbus`, todo dentro de `#ifndef SIM`.
- Códigos `@N` de type.dev y códigos de carpeta `.cas`: únicos en la obra; mirar los existentes
  antes de añadir.
- Códigos fijos `.NNN` en carpetas `.cas` (Vicente, 2026-11-04): Shield autoasigna desde el código de la carpeta en
  **orden de declaración en el código**, no del `cas.dev` (en `.cas Ventilación 500` el 500 es de `copa_alarm`). Para que
  una ampliación no desplace códigos ya dados de alta: variables sueltas y especiales (parámetros, `.sim`, `.alm`) con
  código fijo agrupado por decenas (`copa_alarm .560`, `co[0].sim .570`, `no[0].sim .575`); matrices de equipos
  (`fan[*].cas`) sin código. Entradas nuevas en una carpeta existente: código fijo libre del bloque de decenas.
- Retornos propios de salidas WAGO: la salida `%QXw.b` se lee en `%IX(512+w).b` (Hoz: `%QX096.x` ↔ `%IX608.x`);
  trazas de palabras `%IW000..` (entradas) y `%IW512..` (salidas).
- El compilador acepta un bit > 15 (`%IX512.25`) sin aviso y `-de` lo lista tal cual: revisar los bits a ojo
  (vegaviesga, 2026-11-04; candidato a aviso del kernel).
- `typedef ENUM ENUM_X;` para otro icono: en `type.dev` el derivado va **sin cuerpo** (`BAR_L <i|bar_l.bmp>Barrera Izq. @76`),
  hereda los estados del tipo base, que sí lleva cuerpo e `@id` propio.
- Los dispositivos que toca `action` no se reenvían solos a Shield: hace falta un `when` que
  valide o actúe (normalmente ya existe `when cas` en el equipo).
- Acciones: un módulo `.action` por tubo; secuencias iniciales en `jarvis.act`
  (`00:01 arrow[0].cas  ARROW_ARROW`).
- `jarvis.cas`: textos de dispositivos `dindesc` (mensajes de PMV `pmv_mem[n]=`, nombres de
  acciones). `jarvis.cio`: descripciones de E/S con `*`.
- timetab: struct con `data` (timetab) y `cas` (Shield) sincronizados con dos `when`;
  configuración en `jarvis.cal` / `jarvis.def` (`tipo = franjas`).
- csnmp: `#define SNMP_BASE 1.3.6...` y `SNMP_BASE.25` funciona; `status` > 2 = fallo.
- Puertos de cas: Jarvis escucha en 14017 (`-p`), Shield en 14016 (`-x`).
- Flags de presentación `<...>` de tipos, dispositivos, carpetas y estados: tabla completa en
  `driver/cas.md`, sección «Flags de presentación». Los más usados: `<r>` solo lectura, `<m>` estado-comando en menú,
  `<T0>` alarma técnica, `<o>` no log (animaciones), `<i|fichero.bmp>` icono.
