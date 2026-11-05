# Preferencias generales
- Responde en español.
- Entorno: WSL 1 sobre Windows; los proyectos están en /mnt/c/work.
- Shell: bash. Prefiero soluciones con herramientas estándar de línea de comandos.
- En este entorno `grep` es una función que lanza ugrep con `-I`: omite sin
    aviso los fuentes Latin-1 (casi todos los `.c/.h/.rc` de soft/). Buscar en
    ellos siempre con `grep -a` (o `command grep`); `sed` sobre ellos con `LC_ALL=C`.
- Programación de bajo nivel: C con libc (Linux) y Win32 SDK (Windows).
- Ficheros de instrucciones de proyecto: se llaman AGENTS.md, no CLAUDE.md
    (regla desde noviembre de 2026; los de obras, soft, shd, timap y titime ya
    están renombrados). Solo este fichero global conserva el nombre CLAUDE.md,
    porque Claude Code únicamente carga ~/.claude/CLAUDE.md a nivel de usuario.
    Si te pido guardar algo "en CLAUDE.md", recuérdame que la norma es
    AGENTS.md antes de hacerlo.
- No edites mis fuentes directamente: prepara las propuestas en una copia
    dentro de ~/.claude/propuestas/<proyecto>/ (nunca en el árbol del proyecto, para
    que no entren en git; <proyecto> es la carpeta del repositorio u obra, y si el
    original está en mi home, directamente en ~/.claude/propuestas/) y ábreme tú
    mismo la comparación con vimdiff mediante:
    ~/.claude/bin/propuesta.sh "<proyecto> · <tarea>" orig1 nuevo1 [orig2 nuevo2 ...]
    Abre una pestaña (con ese título) en la ventana "propuestas" de Windows
    Terminal, compartida por todas las sesiones, con un vim que lleva una
    pestaña diff por fichero. Todos los ficheros de una misma tanda van en
    UNA sola llamada, al final de la tanda, no una llamada por fichero.
    No uses wt.exe -w new ni vimdiff directamente. Yo reabro lo pendiente
    con ~/.claude/bin/revisar-propuestas [N]. La ventana se crea a 200x60
    (variable geom del script o PROPUESTA_WT_GEOM); el tamaño solo se
    aplica al crearla: si ya está abierta, la pestaña entra con el que tenga.
    Yo aplico los cambios. WinMerge (WinMergeU.exe, con rutas de wslpath -w)
    queda como alternativa si te lo pido.
    La propuesta se llama nuevo_<fichero> y conserva la extensión original
    (nuevo_AGENTS.md, nuevo_main.c), nunca un sufijo .nuevo: así vim
    reconoce el tipo de fichero. Si hay colisión de nombres dentro de esa
    carpeta, añade la ruta relativa: nuevo_docs_driver.md. Cuando yo aplique una
    propuesta, bórrala de ~/.claude/propuestas/.
    Documentos binarios u ofimáticos (docx, xlsx, pptx, pdf, odt...): no se
    usa vimdiff ni ~/.claude/propuestas/. La propuesta es una copia en el
    mismo directorio del original, con nombre <original>_propuesta.<ext>
    (Informe_propuesta.docx). Yo la reviso (p. ej. con "Comparar documentos"
    de Word) y la aplico o la borro. Para docx hay python3-docx y lxml en
    WSL (no hay pandoc ni node); verificar el resultado convirtiendo a PDF
    con el LibreOffice de Windows.
- En documentos para terceros, sin abreviaturas ("10 años y 5 meses", no
    "10 a 5 m"; "Código", no "Cód."): se leen mal o como rangos.
    Excepción: tu propia configuración la puedes editar directamente, sin
    propuesta ni vimdiff: los AGENTS.md y CLAUDE.md, settings.json, settings.local.json,
    memoria, skills (~/.claude/skills), subagentes (~/.claude/agents),
    statusline, hooks y keybindings. Esto incluye ir ampliando por tu cuenta
    las skills que mantienes (p. ej. "jarvis") cuando aprendas algo nuevo.
- Si te falta una herramienta o paquete para una tarea, para y pídeme que lo
    instale (dime el paquete y el comando, p. ej. `! sudo apt install ...`).
    No busques alternativas por tu cuenta (descargar wheels, pip --target,
    binarios sueltos...) ni sigas con un método peor sin decírmelo.
- No compiles por iniciativa propia: de las builds me encargo yo.
- En los mensajes de commit no pongas líneas de atribución (ni Co-Authored-By
    ni "Generated with").
- Los fuentes de mis proyectos Win32 suelen ser Latin-1 (cp1252) con CRLF:
    respeta la codificación y los finales de línea del original, toca solo las
    líneas necesarias (localizándolas por contenido, no por número de línea) y
    en ficheros nuevos evita acentos en los comentarios.
- Wiki MediaWiki de la empresa: http://wiki.tunelia.com/api.php (solo HTTP).
    Credenciales en ~/.config/wiki.cred (nunca las muestres ni las copies).
    Para anotar o editar usa la skill "wiki"; no publiques nada sin mi visto
    bueno tras revisar la comparación con vimdiff. Si al terminar un trabajo
    hay algo que merezca registrarse, proponlo, pero no lo escribas por tu
    cuenta.
