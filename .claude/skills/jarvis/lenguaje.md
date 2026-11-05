# Lenguaje Jarvis — chuleta

Referencia completa y verificada contra el kernel: `/mnt/c/work/soft/jarvis/docs/lang/`
(un fichero por capítulo). Aquí solo lo de uso diario, las trampas y dónde mirar.

## Dónde está cada cosa en lang/

| Tema | Fichero y sección |
| --- | --- |
| Precompilador: `#define`, `#dup`, `#dev`, `#pragma size/vers/desc/option/silent/debug` | `precompilador.md` |
| Tipos básicos, matrices, struct/autom, inicialización | `dispositivos.md` (Tipos básicos ... Inicialización de la declaración) |
| Cadenas y escapes, conversión de tipos | `dispositivos.md` (Cadenas de texto, Conversión de tipos) |
| Modificadores (`persistent auto volatile input output static file dindesc`) | `dispositivos.md` (Modificadores de tipo) |
| Expresiones, flujo, trazas (`? log trace warning error`) | `sentencias.md` (Expresiones, Sentencia de flujo, Comandos) |
| Mensajes (`msg_t`, `->`, `-> this`), `when` | `sentencias.md` (Mensajes, Modificación de dispositivos) |
| `every`, `ontime`, `time()`... | `sentencias.md` (Instrucciones de tiempo) |
| Estados de autómata (`public private temporal`), funciones, `return` | `sentencias.md` (Autómatas, Funciones declaradas) |
| Funciones globales (`rand hex pow sunrise file_*` ...) | `funciones.md` |
| Procedimientos de dispositivo (`validate stamp enable trap desc settype crc setlength substr` ...) | `procedimientos.md` |
| Redundancia | `redundancia.md` |
| Límites del kernel | `anex.md` (Constantes del kernel Jarvis) |

## Modelo de ejecución (lo que más se olvida)

- El cuerpo principal se ejecuta **una vez**, en orden de aparición. Después solo viven los
  autómatas y las sentencias de tiempo globales. No hay declaración adelantada: el orden de los
  `#include` importa.
- **El cuerpo de un `stat` se ejecuta una sola vez al entrar.** Lo repetitivo va en `every`,
  `ontime`, `when` o `msg` dentro del estado, y solo actúa mientras se está en él.
  Volver a entrar en el estado (`-> mismo;`) reinicia sus `ontime`: forma de encadenar pasos.
- El primer `stat` declarado es el inicial. `-> estado;` solo dentro del propio autómata.
- `msg` y `when` fuera de los estados actúan en cualquier estado.
- **`when` no salta con asignaciones hechas por los autómatas**, solo con cambios externos
  (driver, Shield). Para propagar uno interno como externo: driver `autolink`.
- Los mensajes se encolan; `when` es inmediato.
- El kernel NO hace scan de PLC: bucle continuo sin bloqueo (solo duerme con `-S`) que en cada vuelta lee a los
  drivers, envía las asignaciones pendientes, atiende **una foto** de la cola de mensajes (los encadenados
  esperan a la vuelta siguiente; overflow = 128 + nº de dispositivos) y ejecuta los autómatas con un `->`
  pendiente. Los drivers son procesos aparte comunicados por pipes (`jarvis.cpp` `Loop`, `autom.cpp` `Dispatch`).
- Un dispositivo no volátil se valida al asignarlo **solo si cambia**; para forzar el envío a
  Shield, `validate()`.

## Trampas

- `string` = **64 caracteres**. Para más: `char x[512]` (un único dispositivo de texto;
  `int x[N]` son N dispositivos).
- Sin operador coma. Máx. 4 `switch` anidados y 64 `case` entre todos.
- `every` con múltiplos de 5 s se alinea con el reloj **en GMT**: para ciclos de horas/días,
  usar `time()` y un flag.
- `d.format()` no está implementada (devuelve `"**"`).
- `file_open`: un solo fichero abierto a la vez.
- `d.clearlength()` también borra el contenido; `setlength(0)` vacía el buffer.
- `diginp/digoutp` solo funcionan en Moxa.
- `crc(1)` = CRC16 Modbus (el manual antiguo decía "-").
- `name` es función de dispositivo (`d.name()`, como `desc`): no vale como nombre de campo, da `parse error`. Usar `nom`.
- Una función de autómata que hace `-> estado` no puede llamarse desde el cuerpo principal: en ejecución da
  `RTERROR [641] internal: ctrl.uversion not an autom`, mensaje que no apunta a la causa.
- `#ifdef` funciona dentro del cuerpo de un `stat` (preprocesador textual): útil para `SIM`.
- `virtual` existe en el kernel, pero Vicente prefiere no usarla ni documentarla.
- `return;` en funciones `void` es válido (grammar.y), aunque las obras suelen usar cadenas
  `if/else`.
- Una función con tipo cuya última rama no hace `return` **devuelve 0** sin aviso (probado, 2.3.14). El compilador
  solo detecta `return;` sin valor. `ANA_FILTER_INT.refresh()` de misc.prg dependía de ello (`ANA_OK == 0`).

## Convenciones de las obras

- `typedef ENUM_A ENUM_B;` crea un alias que en Shield es otro tipo (otro icono) con los mismos
  valores (`typedef FAN FAN_L;`).
- El estado visible en Shield es un campo enum `cas`, no el estado del autómata; los
  modificadores de estado `public/private/temporal` casi no se usan.
- `enable(false)` = desactivado por fallo de comunicación; `trap(true)` = alarma.
- Traza estándar: `log cas.desc(), " -- texto = ", valor, "\n";` (automatismos con `log`,
  órdenes del operador con `?`).
- Exigir el nº de equipos: `#ifndef N_XXX` + `#pragma error "..."`.

## Si la documentación no basta

Manda el código: palabras clave y funciones en `kernel/jarvis/lex.cpp` (array `CSysFun fun[]`;
argumentos i int, d float, b bool, s string, c char, t tiempo, `*` el propio dispositivo),
gramática en `kernel/jarvis/grammar.y`, límites en `kernel/jarvis/ucsHead.h` y `typedef.h`,
procedimientos de dispositivo en `kernel/jarvis/dev.cpp` (`CDevice::fn_*`).
