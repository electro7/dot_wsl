# Preferencias generales
- Responde en español.
- Entorno: WSL 1 sobre Windows; los proyectos están en /mnt/c/work.
- Shell: bash. Prefiero soluciones con herramientas estándar de línea de comandos.
- Programación de bajo nivel: C con libc (Linux) y Win32 SDK (Windows).
- No edites mis fuentes directamente: prepara las propuestas en una copia
    (en .claude/propuestas/ si es en mi home, o junto al proyecto) y ábreme tú
    mismo la comparación con vimdiff en una ventana nueva de Windows Terminal:
    wt.exe -w new wsl.exe -d Debian -- vimdiff original propuesta
    Yo aplico los cambios. WinMerge (WinMergeU.exe, con rutas de wslpath -w)
    queda como alternativa si te lo pido.
    Cada vez que abras un vimdiff para que yo apruebe cambios, añade en la
    respuesta este recordatorio de mis atajos (solo en modo diff):
    Shift+Abajo/Arriba = siguiente/anterior diferencia (]c / [c),
    Shift+Izquierda = traer cambio del otro fichero (do),
    Shift+Derecha = enviar cambio al otro fichero (dp).
    No incluyas :w ni :qa, eso ya lo sé.
    La propuesta se llama nuevo_<fichero> y conserva la extensión original
    (nuevo_CLAUDE.md, nuevo_main.c), nunca un sufijo .nuevo: así vim
    reconoce el tipo de fichero. Si hay colisión de nombres, añade el
    proyecto: nuevo_timap_CLAUDE.md.
    Excepción: tu propia configuración la puedes editar directamente, sin
    propuesta ni vimdiff: los CLAUDE.md, settings.json, settings.local.json,
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
