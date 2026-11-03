# Preferencias generales
- Responde en español.
- Entorno: WSL 1 sobre Windows; los proyectos están en /mnt/c/work.
- Shell: bash. Prefiero soluciones con herramientas estándar de línea de comandos.
- Programación de bajo nivel: C con libc (Linux) y Win32 SDK (Windows).
- No edites mis fuentes directamente: prepara las propuestas en una copia
    dentro de ~/.claude/propuestas/<proyecto>/ (nunca en el árbol del proyecto, para
    que no entren en git; <proyecto> es la carpeta del repositorio u obra, y si el
    original está en mi home, directamente en ~/.claude/propuestas/) y ábreme tú
    mismo la comparación con vimdiff en una ventana nueva de Windows Terminal:
    wt.exe -w new wsl.exe -d Debian -- vimdiff original propuesta
    (wt.exe toma ';' como separador de sus subcomandos: para ordenes
    compuestas, lanzar un script, `wt.exe ... -- bash script.sh`).
    Yo aplico los cambios. WinMerge (WinMergeU.exe, con rutas de wslpath -w)
    queda como alternativa si te lo pido.
    La propuesta se llama nuevo_<fichero> y conserva la extensión original
    (nuevo_CLAUDE.md, nuevo_main.c), nunca un sufijo .nuevo: así vim
    reconoce el tipo de fichero. Si hay colisión de nombres dentro de esa
    carpeta, añade la ruta relativa: nuevo_docs_driver.md. Cuando yo aplique una
    propuesta, bórrala de ~/.claude/propuestas/.
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
