# Ficheros de dispositivos (.dev) y drivers

Referencias: `docs/filedev.md`, `docs/driver.md`, `kernel/help/{cas,ethraw,autolink,serial}.txt`.

## Sintaxis general

```
.<driver> [módulo]        // abre módulo
dispositivo   descripción // una línea por dispositivo; la descripción la interpreta el driver
.<driver>                 // cierra (recomendado)
@param  dispositivo       // param es parámetro de dispositivo (fuera de módulo)
#include / #define / #ifdef  como en .prg
```

Matrices con asterisco: `dev[*].x  Elemento *` (0..N-1), `*+` (1..N), `*3` (3 cifras),
`1*3` → 1000, 1001... Un dispositivo solo puede estar enlazado a **un** driver.

## Drivers usados en las obras (por frecuencia en .dev)

| Driver | Línea típica en jarvis.prg | Para qué |
| --- | --- | --- |
| cas | `#driver "cas"` | Shield. Siempre el primero. `-c` traza paquetes, `-s` estadísticas. |
| ethraw | `#driver "ethraw -m MSG_ETHRAW"` | Integrar equipos directamente por TCP/UDP: el protocolo se programa en el .prg. |
| modbus | `#driver "modbus -n -p -t 100 -m MSG_MODBUS"` | Cabeceras WAGO / Modbus TCP. |
| action | `#driver "action -w 10"` | Acciones configurables desde Shield. Siempre el último. |
| autolink | `#driver "autolink"` | Propagar un cambio interno como externo (dispara `when`). |
| jetio | `#driver "jetio -p -t 100 -m MSG_JETIO"` | Módulos de coils simples (ICP). |
| smodbus | | Jarvis como servidor modbus. |
| serial | `#driver "serial"` | Puertos serie. |
| csnmp | `#driver "csnmp -m MSG"` | Lectura SNMP (SAI, equipos de red). |
| timetab | `#driver "timetab"` | Horarios y calendarios editables desde Shield. |

Mensaje de estado (modbus, jetio, ethraw), enviado solo a los autómatas con dispositivos de
ese módulo: `0` sin comunicación / inicio, `1` conectado, `2` todo actualizado,
`>100` excepción modbus (101 función ilegal, 102 dirección ilegal...).

## modbus

```
.modbus 192.168.240.60[:502][,read-holding][,modbus-id=1][,udp][,silent=S][,nogroup][,debug]
upd[0].in               %IP000.0      // presencia de cabecera (convención obras)
fan[0].in_on            %IX096.0      // bit 0 de la palabra de entrada 96
fan[0].out_on           %QX096.0      // bit 0 de la palabra de salida 96
co[0].filter.in         %IW001        // palabra (analógica)
x.y                     %IX700.14-15  // rango de bits
x.f                     %ID10         // DWORD intel (C = parte alta primero); vale para float
.modbus
```
Memoria: `I` entrada (input), `Q` salida (output), `M` memoria (input output).
Tipo: `X` bit, `W` word, `S` byte, `D`/`C` dword. Direcciones desde 0.
Opciones de driver: `-n` no volcar salidas al conectar, `-p` arranque gradual, `-t ms`
latencia, `-r N` reintentos antes de avisar fallo, `-u` udp.

En las obras, las IP van como `#define IP_LT_1_1 ...` en jarvis.dev y cada cabecera tiene su
`mb_<cabecera>.dev` incluido entre `.modbus IP` y `.modbus`, todo dentro de `#ifndef SIM`.

## jetio

```
.jetio 192.168.0.10
icp[0].in               %I13
ct_sec[0].out_bell      %O0
icp_e.in                input_stat    // máscara de 32 entradas
.jetio
```
Máx. 16 E / 16 S por módulo.

## ethraw

```
.ethraw 192.168.0.90:4000,tcp[,debug][,silent=SS][,xml]   // cliente (con IP)
.ethraw 4001,tcp                                          // servidor (sin IP)
port.inp                      // string/char[] input: lo recibido
port.out                      // string output (volatile + setlength + validate)
port.cnf      config          // opcional: "ip:puerto" para cambiar destino
.ethraw
```
Máx. 128 conexiones. Patrón de autómata en patrones.md.

Uso (confirmado por Vicente, 2026-11-01): integrar equipos de campo directamente por TCP o
UDP. El driver solo mueve bytes; el protocolo "simple" (Modbus TCP o RTU encapsulado a mano,
tramas propietarias de SOS, DAI, SAI, centrales de incendio...) se programa en el propio .prg
con buffers `char[]`, `setlength()` y `crc()`. No es un enlace entre nodos Jarvis (para eso
están varcli/varser). Ejemplos: fire_apsensing.prg (Modbus TCP a mano), sos_*.prg, dai_*.prg.

## serial

```
.serial COM2,9600,8,N,1[,485][,silent=20][,endchar=13][,debug=1]
port.inp      read
port.out      write
.serial
```
También `config`, `dtr`, `rts`.

## autolink

```
.autolink Unifilo      // nombre normal: propaga valor y estado
.autolink .            // empieza por '.': solo valor
origen       destino   // al cambiar origen (incluso desde autómata) cambia destino y salta su when
.autolink
```
Usos: unifilares (salida de una línea a entrada de la siguiente), puentear retornos.

## action

```
.action /
act_t1.control       control   // int volatile: índice de acción a lanzar
act_t1.status        status    // string: estado de ejecución
act_t1.action[*].act *         // ACTION (char[512] auto persistent): cada secuencia
.action
```
Un módulo = un grupo (un tubo): solo una acción activa a la vez. Las secuencias iniciales
están en `jarvis.act`:
```
action_ta.action[0].act
00:01 arrow[0].cas      ARROW_ARROW
00:05 semrav[0].cas     RAV_RED
```
Los dispositivos tocados por action no se reenvían solos a Shield: hace falta un `when` que
valide o que actúe (normalmente ya existe `when cas` en el equipo).

## csnmp (cliente SNMP, solo GET cíclico)

```
#driver "csnmp [-t] [-s] [-m MSG]"     // MSG en cada vuelta completa (arg = nº de vuelta)
.csnmp 192.168.0.50
sai.estado      1.3.6.1.4.1.26038.1    // solo OID numéricos (abreviables con #define)
sai.com         status                 // nº de errores: dar fallo con > 2
.csnmp
```

## timetab (horarios y calendarios)

```
#driver "timetab [-k] [-d]"
.timetab /
cal.data                 // calendario (sin comentario)
horA.data   a            // horario: enciende/apaga el dispositivo a
.timetab
```
- Las variables de horario/calendario son `char[512]` con formato privado compartido con un
  servicio de Shield (editor gráfico). Patrón: struct con `data` (timetab) y `cas` (Shield)
  sincronizados con dos `when`.
- Configuración real en `jarvis.cal` (tipos de día, ≤16: `nombre : r,g,b` + días: `*`, `sun`,
  `25/dec`, `01/jul - 31/aug`, `aug`...) y `jarvis.def` (`horA.data : "Nombre"` y
  `tipo = OFF | ON | HH:MM - HH:MM[, HH:MM - HH:MM]`); si existen `.cal.new`/`.def.new`, se usan esas.
- Ejemplo completo: manual de Shield (PDF), apartado 8.10.

## cas (Shield)

```
.cas Ventiladores 1300          // carpeta en Shield + código inicial (consecutivos por orden de declaración en memoria)
fan[0].cas      <r>Ventilador 1 T1
fan[1].cas      .1305 <r>Ventilador 2   // código fijo
.cas
```
Fichero `jarvis.cas`: name, desc, diff, memos y textos para paneles (`pmv_mem[n]=`) y
nombres de acciones (`action_ta.action[n].cas=`). `jarvis.cat`: categorías MEMO.
Parámetros: `@scom.ss[0].cam scom.sos[0]` (texto → post-it; escalar → configuración).

## type.dev: presentación en Shield

```
bool @1   char @2   int @3   time_t @4   fixed @5   fixed1 @6   fixed2 @7   string @8   // fijos

FAN          <i|fan_r.bmp>Ventilador D @70      // tipo con icono, código único
{
    FAN_OFF      <m>Apagado automático          // estado-comando en menú
    FAN_HOT      <T0>Avería                     // alarma técnica
    FAN_ON1      <o>Encendido directo           // no se guarda en log (animación)
}
FAN_L        <i|fan_l.bmp>Ventilador I @71      // alias: hereda estados del enum
CO <li|co.bmp>CO$ppm { A_CO.min A_CO.prelow A_CO.low A_CO.prehigh A_CO.high A_CO.max } @51
```
- `$unidad` tras la descripción. Niveles: nombres de los campos `static` del autómata.
- Los códigos `@N` deben ser únicos en la obra; mirar los existentes antes de añadir.

Flags que solo recoge el manual de Shield (PDF, apartado 8.3.1), no `AutoCreateFlags.md`:
- Tipo: `N` asociación del tipo por nombre, `?` tiene entrada de ayuda en Shield.
- Dispositivo: `u` único (no se cruza su valor con el gemelo en redundancia),
  `s` texto interpretable como orden de sistema.
- Carpeta (`.cas <...>Nombre código`): `'otra'` hereda la configuración de otra carpeta
  (termina en `>` o en otra `'`), `k` autoenlazar carpetas hermanas, `h` oculta, `x` solo nombre.
- Estado: `k` autoenlazable, `T#` con nivel 0 (más grave) a 7 (informativo, no alarma).

Flags (`AutoCreateFlags.md`):
- Tipo/dispositivo: `x` solo nombre, `n` todo, `h` oculto, `i` icono, `v` icono+valor,
  `V` valor, `r` solo lectura, `0-3` decimales, `M` actuar sin menú, `D` no en detalle,
  `P` persistente, `p` privado, `c` confirmar, `l` log, `L` log + 20 últimos,
  `T`/`F` alarma bool a 1/0, `'XXXX` control ADC (`'TEND2`, `'INFP`, `'AUTO`, `'ACT2`, `'BMSL`),
  `|f.bmp` icono.
- Estados: `m` comando, `a` comando solo admin, `c` comando con confirmación, `t` comando
  solo en alarma, `o` no log, `n` sin icono, `f` parpadea, `p` pulsado, `e` temporal,
  `T0/T1/T2` alarma técnica/incidencia/informativa, `W` incidencia.
