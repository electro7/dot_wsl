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

La documentación ya no lleva numeración de capítulos (decisión 2026-11-02, rama `docs_reformat`): cita por
fichero y título (`driver/cas.md`, sección «Flags de presentación»; `lang/funciones.md`, función `hex`).
**Mientras `docs_reformat` no esté fusionada en master**, master conserva el `lang.md` y el `driver.md`
antiguos y numerados.

Si la documentación y el kernel discrepan, manda el kernel (y proponer a Vicente corregir la doc).

## Ficheros de esta skill (lo que no está en la documentación)

| Fichero | Cuándo leerlo |
| --- | --- |
| `lenguaje.md` | Chuleta del lenguaje: modelo de ejecución, trampas, convenciones de las obras y mapa de `lang/`. |
| `dispositivos.md` | Chuleta de .dev y drivers: líneas típicas, sintaxis de memoria y convenciones de las obras. |
| `patrones.md` | Detalles de los módulos reales (misc.prg, fan_meters, actions2, redun...) que complementan `patterns.md`. |
| `obra.md` | Estructura de los repositorios de obra, `jarvis.prg` tipo y dominio de túneles. |
| `catalogo.md` | **Antes de escribir un módulo nuevo**: qué módulos existen y dónde está su versión más reciente. |
| `regenerar_catalogo.py` | Calcula copias y versión más reciente (por último commit) para actualizar `catalogo.md`. |
| `plantillas/` | Esqueletos para copiar y adaptar. |
| `aprendizajes.md` | Bitácora de lo descubierto y aún sin clasificar. Leerla en tareas no triviales. |
| `tareas/documentacion.md` | Historial de la tarea de documentación (2026-11-02). |
| `tareas/revision-web.md` | Informe del revisor de legibilidad de la web y fases acordadas (2026-11-02). |

## Otras fuentes

- Código del kernel y drivers: `/mnt/c/work/soft/jarvis/kernel/<driver>/*.cpp`. Palabras clave y
  funciones en `kernel/jarvis/lex.cpp`, límites en `ucsHead.h`/`typedef.h`, gramática en
  `grammar.y`. Buscar con `command grep -a` (el `grep` del entorno respeta `.gitignore`).
- `kernel/help/*.txt` ya no existe (Vicente lo quitó el 2026-11-02, commit 4e97a66): la documentación
  es la única ayuda. Los .txt antiguos (webser, cgi, xgi, lontcp, sigacgi...) siguen en la historia:
  `git -C /mnt/c/work/soft/jarvis show 4e97a66^:kernel/help/<driver>.txt`.
- Flags de Shield: `/mnt/c/work/soft/shd/docs/AutoCreateFlags.md` (resumidos en `driver/cas.md`, «Flags de presentación»).
- PDF en `/mnt/c/work/obras/`: `Manual desarrollo Shield.pdf` (2018, ya superado por la
  documentación oficial) y `Memoria_PLC_Jarvis.pdf` (comercial; mapa de ficheros del kernel).
- Obra de referencia: `/mnt/c/work/obras/000_simulador/jarvis/`.

## Si hay que tocar la documentación (`soft/jarvis/docs`)

- Rama `docs_reformat` (pendiente de fusionar): ahí se edita directamente; en cualquier otra rama, propuesta en
  `~/.claude/propuestas/jarvis/`. Sin commit ni push si Vicente no lo pide.
- Convenciones: sin numeración de capítulos; nombres de driver en minúsculas y en código en línea (`cas`);
  protocolos (Modbus, MQTT, SNMP) con mayúsculas; UTF-8; avisos como admoniciones; esquemas en SVG en línea
  (`includes/*.svg`), nunca Mermaid (depende de internet).
- Validar con `mkdocs build --strict --site-dir <fuera del repo>`; nunca dejar `site/` en el repositorio.
  Historial y técnica de capturas en `tareas/revision-web.md`.

## Flujo de trabajo con Vicente

1. Buscar en `catalogo.md` y en las obras un módulo parecido; partir de él antes que de cero.
2. Las fuentes de las obras **no se editan**: propuesta `nuevo_<fichero>.prg` en `~/.claude/propuestas/<obra>/`,
   en la **misma codificación (Latin-1) y finales de línea** que el original, tocando solo lo
   necesario, y abrir vimdiff (ver CLAUDE.md global). Ficheros nuevos: sin acentos en comentarios.
3. No compilar ni ejecutar Jarvis por iniciativa propia.
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
- Si un módulo nuevo se crea o se localiza una versión mejor, actualizar `catalogo.md`.
- Mencionar a Vicente en una línea qué se ha anotado.
