---
name: jarvis
description: Programación de autómatas con Jarvis PLC (Tunelia) para control de túneles de carretera. Usar siempre que se lean, escriban, revisen o expliquen ficheros .prg, .dev, .act, .cas de Jarvis, se cree un módulo de equipo (ventiladores, semáforos, barreras, incendio, iluminación, PMV, SOS, DAI, SAI, grupos...), se integre un protocolo (modbus, jetio, ethraw, serial) o se monte una obra en /mnt/c/work/obras. También para dudas sobre el kernel o los drivers de Jarvis en /mnt/c/work/soft/jarvis.
---

# Jarvis PLC

Jarvis es la máquina virtual de autómatas de Tunelia: compila un C ampliado
(`.prg`) con estados, tiempos y mensajes, y enlaza variables con el exterior
mediante drivers declarados en ficheros de dispositivos (`.dev`). El SCADA es
Shield, que habla con Jarvis por el driver `cas`.

## Ficheros de esta skill (leer según la tarea)

| Fichero | Cuándo leerlo |
| --- | --- |
| `lenguaje.md` | Escribir o revisar cualquier `.prg`: sintaxis, modificadores, `when`/`msg`/`every`, funciones, límites y trampas. |
| `dispositivos.md` | Escribir `.dev`: drivers, direccionamiento modbus/jetio, ethraw, autolink, `.cas`, `type.dev` y flags `<...>` de Shield. |
| `patrones.md` | Crear un autómata de equipo o un protocolo: patrones probados en obra. |
| `obra.md` | Montar o modificar una obra completa: estructura de ficheros, `jarvis.prg`, `init.prg`, acciones, SIM. |
| `catalogo.md` | **Antes de escribir un módulo nuevo**: qué módulos existen y dónde está su versión más reciente. |
| `plantillas/` | Esqueletos para copiar y adaptar. |
| `aprendizajes.md` | Bitácora de lo descubierto y aún sin clasificar. Leerla en tareas no triviales. |

## Tareas en curso

- **Completar la documentación oficial (mkdocs)**: plan y preguntas pendientes en
  `tareas/documentacion.md`. Si Vicente retoma el tema, empezar por sus preguntas pendientes.

## Fuentes de verdad (si esta skill no basta)

- Manual: `/mnt/c/work/soft/jarvis/docs/` (lang.md, filedev.md, driver.md, commandline.md, anex.md).
- Ayuda de drivers que no está en el manual: `/mnt/c/work/soft/jarvis/kernel/help/*.txt` (Latin-1): cas, ethraw, autolink, serial, timetab...
- Código del kernel y drivers: `/mnt/c/work/soft/jarvis/kernel/<driver>/*.cpp`. Manda sobre el
  manual cuando discrepan: palabras clave y funciones en `kernel/jarvis/lex.cpp`, límites en
  `kernel/jarvis/ucsHead.h`, gramática en `kernel/jarvis/grammar.y`. Buscar ahí con
  `command grep -a` (el `grep` del entorno respeta `.gitignore` y no ve esos ficheros).
- Flags de Shield: `/mnt/c/work/soft/shd/docs/AutoCreateFlags.md`.
- PDF en `/mnt/c/work/obras/` (leer con `pdftotext -layout` o Read con `pages`):
  - `Manual desarrollo Shield.pdf` (v1.8, 2018, 67 págs.): mismo contenido que el mkdocs más
    los drivers cas (flags completos, 8.3.1), csnmp, ethraw, serial y timetab.
  - `Memoria_PLC_Jarvis.pdf` (2026, 8 págs.): documento comercial; útil por el mapa de
    ficheros del kernel (qué hace cada .cpp) para buscar en el código.
- Obra de referencia: `/mnt/c/work/obras/000_simulador/jarvis/`.

## Flujo de trabajo con Vicente

1. Buscar en `catalogo.md` y en las obras un módulo parecido; partir de él antes que de cero.
2. Las fuentes de las obras **no se editan**: propuesta `nuevo_<fichero>.prg` junto al original,
   en la **misma codificación (Latin-1) y finales de línea** que el original, tocando solo lo
   necesario, y abrir vimdiff (ver CLAUDE.md global). Ficheros nuevos: sin acentos en comentarios.
3. No compilar ni ejecutar Jarvis por iniciativa propia.
4. Respetar el estilo de la obra: 4 espacios, separadores `// ----`, cabecera
   `INSTALACIÓN / DESCRIPCIÓN`, `vim: set et ts=4 sw=4 sts=4:` al final.

## Mantener esta skill

Esta skill se amplía sobre la marcha (permiso explícito de Vicente, se edita directamente):

- Cada vez que se descubra algo de Jarvis no recogido aquí (una trampa, un patrón, una opción
  de driver, una corrección de Vicente), anotarlo **en el momento** en `aprendizajes.md` con
  fecha y fuente.
- Cuando una entrada esté confirmada y encaje en un fichero temático, moverla allí y borrarla
  de la bitácora.
- Si un módulo nuevo se crea o se localiza una versión mejor, actualizar `catalogo.md`.
- Mencionar a Vicente en una línea qué se ha anotado.
