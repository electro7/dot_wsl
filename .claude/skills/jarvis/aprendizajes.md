# Bitácora de aprendizajes

Formato: `- AAAA-MM-DD — hecho. (fuente)`. Cuando una entrada se confirma y encaja en un
fichero temático, se mueve allí y se borra de aquí.

## Pendiente de confirmar o clasificar

- 2026-11-01 — Huecos de la documentación oficial: los drivers cas, ethraw, autolink y serial
  solo están en kernel/help/*.txt; el manual está mal en el tamaño de `string` (dice 128, son
  64) y en el límite de campos de struct (dice 64, son 256); faltan funciones (sunrise, sunset,
  format, file_*, pow, hostname, cpu, mem_used, cpu_temp, stamp, devcode, type) y los
  modificadores dindesc/virtual. Posible entrada para la wiki o corrección del mkdocs:
  proponer a Vicente, no escribir.
- 2026-11-01 — El manual de Shield (PDF 2018) arrastra las mismas erratas que el mkdocs
  (string 128, struct 64 campos). Ahí "Cadenas 64 caracteres" del apéndice sí es correcto.
- 2026-11-01 — Memoria_PLC_Jarvis.pdf: el diagrama de flujo cita `hal_io.c`, `map_memory.c` y
  `plc_logic.c`, que no existen en el kernel; el resto de ficheros citados sí existen. El
  diagrama describe un ciclo de scan clásico (leer E/S → lógica → escribir E/S); el manual
  describe un modelo por eventos (estados al entrar, when/msg, timers) con drivers por
  tuberías. Sin verificar en jarvis.cpp cuál es el bucle real. Avisado a Vicente.
  Además describe ethraw como enlace entre nodos Jarvis; Vicente confirma que es para
  integrar equipos por TCP/UDP con protocolos programados en el .prg (ya en dispositivos.md).
- 2026-11-01 — Semántica exacta de `format(fmt)`, `stamp(t)`, `file_open(nombre, modo)` y
  `sunrise/sunset`: falta leer sus implementaciones (CDevice::fn_format en kernel/jarvis).

- 2026-11-01 — No he visto `return;` sin valor en funciones `void` en las obras (se usan
  cadenas if/else). Confirmar en grammar.y antes de usarlo. Las plantillas lo evitan.
- 2026-11-01 — Las plantillas de `plantillas/` no se han compilado nunca: validarlas con
  Vicente la primera vez que se usen y anotar aquí las correcciones.

## Herramientas

- 2026-11-01 — En este entorno `grep` es una función de Claude Code (ugrep con
  `--ignore-files`) que respeta `.gitignore` y **no encontraba nada en el árbol del kernel**
  (/mnt/c/work/soft/jarvis/kernel). Usar `command grep -a` ahí. Los fuentes del kernel están en
  Latin-1 con CRLF.
