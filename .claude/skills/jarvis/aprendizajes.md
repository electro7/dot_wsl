# Bitácora de aprendizajes

Formato: `- AAAA-MM-DD — hecho. (fuente)`. Cuando una entrada se confirma y encaja en un
fichero temático, se mueve allí y se borra de aquí. Lo que sea referencia general de Jarvis
va a la documentación oficial (proponerlo a Vicente), no a esta skill.

## Pendiente de confirmar o clasificar

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

## Herramientas

- 2026-11-01 — En el kernel (`soft/jarvis/kernel`, Latin-1 CRLF) buscar con `command grep -a`:
  el `grep` del entorno respeta `.gitignore` y omite los Latin-1 (regla general en el CLAUDE.md global).
- 2026-11-02 — La documentación mkdocs (`soft/jarvis/docs/*.md`) está en **UTF-8**, no en Latin-1
  como las obras y el kernel. Casi todo con LF; commandline.md y dev/*.md con CRLF (o mezcla).
  Antes de subir cambios: `mkdocs build --strict` (el runner de GitLab también lo usa).
- 2026-11-02 — Repaso ortográfico: `hunspell -d es_ES -l` sobre la prosa (sin bloques de código);
  no detecta tildes que dan otra palabra válida ("por que", "continua", "si").
- 2026-11-02 — Capturas de la web: `mkdocs build --site-dir /mnt/c/Windows/Temp/...` y
  `msedge.exe --headless --screenshot` (no está en el PATH desde aquí: `/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe`; también sirve `--print-to-pdf`) (Windows solo ve rutas bajo /mnt/c; `wslpath -w`). En
  `/mnt/c/Windows/Temp` no se puede listar ni usar comodines: borrar los temporales por nombre. Un fragmento `#`
  en la URL de `file:///` deja la captura en blanco. Un `.svg` suelto sin `xmlns` se muestra como XML: probarlo
  dentro de un HTML.
- 2026-11-04 — Al preparar propuestas con `sed` sobre fuentes Latin-1, usar `LC_ALL=C sed`: con el locale UTF-8, `.`
  no casa con un byte Latin-1 suelto (p. ej. la `á` de «Semáforo») y la sustitución falla en silencio.
