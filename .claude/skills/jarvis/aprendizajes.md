# Bitácora de aprendizajes

Formato: `- AAAA-MM-DD — hecho. (fuente)`. Cuando una entrada se confirma y encaja en un
fichero temático, se mueve allí y se borra de aquí. Lo que sea referencia general de Jarvis
va a la documentación oficial (proponerlo a Vicente), no a esta skill.

## Pendiente de confirmar o clasificar

- 2026-11-01 — Las plantillas de `plantillas/` no se han compilado nunca: validarlas con
  Vicente la primera vez que se usen y anotar aquí las correcciones.
- 2026-11-02 — Fallos del código encontrados al contrastar la documentación con el kernel (la doc ya está
  corregida; esto es lo que habría que arreglar en el código, sin proponerlo si Vicente no lo pide):
  - action: el límite de 64 pasos se comprueba tarde (`CompileProg` ya ha escrito `m_step[64]` fuera del array).
  - mqtt: un módulo sin ninguna opción tras la IP (`.mqtt 192.168.0.76`, con o sin `:puerto`) da error de
    configuración (ip NULL) porque la IP solo se lee si hay coma. **Vicente no quiere que se le proponga nada
    sobre esto.**
  - redun.prg: condición `new != RS_RUNNING || new != RS_SUPERVISION` siempre verdadera (ver `patrones.md`).
- 2026-11-02 — Memoria_PLC_Jarvis.pdf (comercial) es inexacto: cita `hal_io.c`, `map_memory.c`, `plc_logic.c`
  (no existen en el kernel), describe un ciclo de scan clásico (el kernel es por eventos, ver `lenguaje.md`) y
  presenta ethraw como enlace entre nodos Jarvis (es para equipos de campo). No usarlo como referencia técnica.
- 2026-11-02 — Redundancia: detalles del kernel que no están en el capítulo (`dupctrl.cpp`, verificado): el
  conflicto se evalúa en `Refresh`, registrado con `TIMEOUT_DUPCTRL` = 100 ticks; los ticks de `CTimeout` son
  **milisegundos** (`COMMAFACTOR` = 1000, `current_ms()`), así que Refresh corre cada 100 ms y los 30 s de
  `COUNT_CONFLICT` son 300 llamadas; el intervalo de `#dup` es `COUNT_RUN` = intervalo·1000/100 vueltas del bucle de
  arranque (con `sleep_ms(100)`). `MSG_DEVICE_END` con la máquina en conflicto la pasa a `ENDING`. Puerto UDP 14018,
  máximo 4 máquinas y 5 min para volver a pedir variables son constantes del código (`PORT`, `MAX`, `COUNT_PST`).

## Herramientas

- 2026-11-01 — En este entorno `grep` es una función de Claude Code (ugrep con
  `--ignore-files`) que respeta `.gitignore` y **no encontraba nada en el árbol del kernel**
  (/mnt/c/work/soft/jarvis/kernel). Usar `command grep -a` ahí. Los fuentes del kernel están en
  Latin-1 con CRLF.
- 2026-11-02 — La documentación mkdocs (`soft/jarvis/docs/*.md`) está en **UTF-8**, no en Latin-1
  como las obras y el kernel. Casi todo con LF; commandline.md y dev/*.md con CRLF (o mezcla).
  Antes de subir cambios: `mkdocs build --strict` (el runner de GitLab también lo usa).
- 2026-11-02 — Repaso ortográfico: `hunspell -d es_ES -l` sobre la prosa (sin bloques de código);
  no detecta tildes que dan otra palabra válida ("por que", "continua", "si").
- 2026-11-02 — Capturas de la web: `mkdocs build --site-dir /mnt/c/Windows/Temp/...` y
  `msedge.exe --headless --screenshot` (Windows solo ve rutas bajo /mnt/c; `wslpath -w`). En
  `/mnt/c/Windows/Temp` no se puede listar ni usar comodines: borrar los temporales por nombre. Un fragmento `#`
  en la URL de `file:///` deja la captura en blanco. Un `.svg` suelto sin `xmlns` se muestra como XML: probarlo
  dentro de un HTML.
