---
name: jarvis
description: Programación de autómatas con Jarvis PLC (Tunelia) para control de túneles de carretera. Usar siempre que se lean, escriban, revisen o expliquen ficheros .prg, .dev, .act, .cas de Jarvis, se cree un módulo de equipo (ventiladores, semáforos, barreras, incendio, iluminación, PMV, SOS, DAI, SAI, grupos...), se integre un protocolo (modbus, jetio, ethraw, serial) o se monte una obra en /mnt/c/work/obras. También para dudas sobre el kernel o los drivers de Jarvis en /mnt/c/work/soft/jarvis.
---

# Jarvis PLC

Jarvis es la máquina virtual de autómatas de Tunelia: compila un C ampliado
(`.prg`) con estados, tiempos y mensajes, y enlaza variables con el exterior
mediante drivers declarados en ficheros de dispositivos (`.dev`). El SCADA es
Shield, que habla con Jarvis por el driver `cas`.

## Documentación oficial: la referencia principal

`/mnt/c/work/soft/jarvis/docs/` (publicada en http://gitdoc.tunelia.com/jarvis/intro/),
completada y verificada contra el kernel el 2026-11-02. Leerla en local, por apartados:

| Fichero | Contenido |
| --- | --- |
| `lang/*.md` | Lenguaje: `precompilador`, `dispositivos` (tipos, modificadores), `sentencias`, `funciones` (tabla resumen de funciones generales), `procedimientos` (funciones de dispositivo), `redundancia`; `lang/index.md` es el índice |
| `filedev.md`, `filemore.md` | Ficheros .dev, persistencias, log, ficheros de drivers |
| `driver/*.md` | Un fichero por driver: `action`, `modbus`, `jetio`, `smodbus`, `varcli`, `varser`, `mqtt`, `cas`, `ethraw`, `serial`, `autolink`, `csnmp`, `timetab`; `driver/index.md` es la tabla resumen |
| `commandline.md` | Opciones de línea de comandos |
| `patterns.md` | Patrones de desarrollo |
| `anex.md` | Límites del kernel y otros drivers |

La documentación no lleva numeración de capítulos: cita por fichero y título
(`driver/cas.md`, sección «Flags de presentación»; `lang/funciones.md`, función `hex`).

Si la documentación y el kernel discrepan, manda el kernel (y proponer a Vicente corregir la doc).

## Ficheros de esta skill (lo que no está en la documentación)

| Fichero | Cuándo leerlo |
| --- | --- |
| `lenguaje.md` | Chuleta del lenguaje: modelo de ejecución, trampas, convenciones de las obras y mapa de `lang/`. |
| `dispositivos.md` | Chuleta de .dev y drivers: líneas típicas, sintaxis de memoria y convenciones de las obras. |
| `patrones.md` | Detalles de los módulos reales (misc.prg, fan_meters, actions2, redun...) que complementan `patterns.md`. |
| `obra.md` | Estructura de los repositorios de obra, `jarvis.prg` tipo, dominio de túneles y **convención `espec/`** (ficha, listados de señales, `mapa.csv`): leerla al empezar una obra nueva. |
| `catalogo.md` | **Antes de escribir un módulo nuevo**: qué módulos existen y dónde está su versión más reciente. |
| `regenerar_catalogo.py` | Calcula copias y versión más reciente (por último commit) para actualizar `catalogo.md`. |
| `plantillas/` | Esqueletos para copiar y adaptar: `equipo_digital.prg`, `cabecera_modbus.dev`, `protocolo_tcp.prg` (validadas con `jarvis.exe`), `obra.md` (ficha de remota para `espec/`) y `jarvis_prueba.prg` (stub para compilar un módulo suelto con `probar.sh`). |
| `probar.sh` | Lanza `jarvis.exe` en una carpeta de prueba y muestra la salida (ver «Probar un .prg»). |
| `aprendizajes.md` | Bitácora de lo descubierto y aún sin clasificar. Leerla en tareas no triviales. |

## Otras fuentes

- Código del kernel y drivers: `/mnt/c/work/soft/jarvis/kernel/<driver>/*.cpp`. Palabras clave y
  funciones en `kernel/jarvis/lex.cpp`, límites en `ucsHead.h`/`typedef.h`, gramática en
  `grammar.y`. Buscar con `command grep -a` (el `grep` del entorno respeta `.gitignore`).
- `kernel/help/*.txt` ya no existe (Vicente lo quitó el 2026-11-02, commit 4e97a66): la documentación
  es la única ayuda. Los .txt antiguos (webser, cgi, xgi, lontcp, sigacgi...) siguen en la historia:
  `git -C /mnt/c/work/soft/jarvis show 4e97a66^:kernel/help/<driver>.txt`.
- Flags de Shield: `/mnt/c/work/soft/shd/docs/AutoCreateFlags.md` (resumidos en `driver/cas.md`, «Flags de presentación»).
- Obra de referencia: `/mnt/c/work/obras/000_simulador/jarvis/`.

## Si hay que tocar la documentación (`soft/jarvis/docs`)

- Propuesta `nuevo_<fichero>` en `~/.claude/propuestas/jarvis/` y vimdiff, salvo que Vicente indique otra cosa.
  Sin commit ni push si Vicente no lo pide.
- Convenciones: sin numeración de capítulos; nombres de driver en minúsculas y en código en línea (`cas`);
  protocolos (Modbus, MQTT, SNMP) con mayúsculas; UTF-8; avisos como admoniciones; esquemas en SVG en línea
  (`includes/*.svg` en la raíz del repo, incluidos con `--8<--` dentro de `<div markdown="0">`), nunca Mermaid (depende de internet).
- Ejemplos completos de un driver: sección «Ejemplo completo» con el código en un desplegable
  (`??? example "Código del ejemplo"`), como en `driver/timetab.md` y `driver/action.md`.
- Un `<nombre>` en prosa fuera de código lo traga el HTML (desaparece): escribirlo siempre `` `<nombre>` ``.
- Glosario con tooltips en `includes/abreviaturas.md` (raíz del repo; solo siglas). Sin redirecciones de URLs viejas.
- No mencionar en la doc xscada, dlmod, drvgen ni sunrise; no hay capítulo de «patrones de túneles»
  (es `patterns.md`, «Patrones de desarrollo»), ni nombres de obras ni datos internos.
- Validar con `mkdocs build --strict --site-dir <fuera del repo>`; nunca dejar `site/` en el repositorio.
  Técnica de capturas de la web en `aprendizajes.md` (Herramientas).

## Probar un .prg con jarvis.exe (autorizado por Vicente, 2026-11-02)

- Solo en una carpeta temporal bajo `/mnt/c` (p. ej. `/mnt/c/Windows/Temp/jarvis_test`; Windows no ve el resto),
  nunca en una obra real, y borrarla al terminar (`rm -rf`). Sin drivers que abran puertos o conecten con equipos:
  para comprobar enlaces de un `.dev` con IPs reales, comentar los `#driver` (compila y enlaza igual); `modbus` solo
  contra `127.0.0.1`; `ethraw` nunca (el clasificador de permisos lo bloquea, 2026-11-04).
- Usar `probar.sh CARPETA [SEGUNDOS] ["ARGS"] [drivers]` (por defecto `-q -u`: sin log ni `.pst`). Lanza con PowerShell,
  con entrada y salida a fichero, y mata el proceso por PID al acabar el tiempo: Jarvis se queda en su bucle y un
  `timeout` de bash dejaría el proceso de Windows vivo. Comprobar al final que no quedan `jarvis*`/drivers.
- `jarvis.exe` (instalado en `C:\Program Files (x86)\Jarvis`, 2.3.14 o posterior) ya no espera tecla al salir si la
  entrada no es consola; las versiones anteriores se quedaban en `getch()`. Los errores de compilación salen por la
  salida y termina solo. `jarvis_w32.exe` es gráfico: no sirve para capturar salida (solo logs en `%appdata%`).
- Para simular señales de campo (los `when` solo reaccionan a drivers): driver `autolink` (`driver/autolink.md`).
- Para compilar un módulo suelto de una obra: copiar a la carpeta su `misc.prg` y el módulo, y usar
  `plantillas/jarvis_prueba.prg` como `jarvis.prg` (pragmas, `INTERVAL_*`, `msg_t`, instancias). El compilador se para
  en el **primer** error: corregir en la copia e iterar. Para plantillas: stubs mínimos (`TUBE`, `ZONE`, `USE`...).
- Un `.dev` no se prueba solo: un `jarvis.prg` que declare sus dispositivos (cada `autom` necesita al menos un `stat`) y un
  `jarvis.dev` que lo incluya; con `-de` se listan los dispositivos ya enlazados. Para modbus, `.modbus 127.0.0.1`.

## Flujo de trabajo con Vicente

1. Obra nueva: partir de `espec/` de la remota (ficha, listados, mapa; ver `obra.md`). Buscar en `catalogo.md` y en las obras un módulo parecido; partir de él antes que de cero.
2. Las fuentes de las obras **no se editan**: propuesta `nuevo_<fichero>.prg` en `~/.claude/propuestas/<obra>/`,
   en la **misma codificación (Latin-1) y finales de línea** que el original, tocando solo lo
   necesario, y abrir vimdiff (ver CLAUDE.md global). Ficheros nuevos: sin acentos en comentarios.
3. Jarvis solo se ejecuta para probar, en una carpeta temporal y con `probar.sh` (ver «Probar un .prg»); nunca en una obra
   real. No compilar el código C del kernel.
4. Respetar el estilo de la obra: 4 espacios, separadores `// ----`, cabecera
   `INSTALACIÓN / DESCRIPCIÓN`, `vim: set et ts=4 sw=4 sts=4:` al final.

## Mantener esta skill

Esta skill se amplía sobre la marcha (permiso explícito de Vicente, se edita directamente):

- Cada vez que se descubra algo de Jarvis no recogido aquí (una trampa, un patrón, una opción
  de driver, una corrección de Vicente), anotarlo **en el momento** en `aprendizajes.md` con
  fecha y fuente. Si es referencia general (no interna de Tunelia), proponer además a Vicente
  añadirlo a la documentación oficial; no duplicar aquí lo que ya está allí.
- Cuando una entrada esté confirmada y encaje en un fichero temático, moverla allí y borrarla
  de la bitácora.
- Anotar solo lo que cambia cómo se trabaja con Jarvis (trampas, herramientas, correcciones de Vicente); no detalles de uso
  que ya estén en la documentación ni cosas menores.
- Si un módulo nuevo se crea o se localiza una versión mejor, actualizar `catalogo.md`.
- Mencionar a Vicente en una línea qué se ha anotado.
