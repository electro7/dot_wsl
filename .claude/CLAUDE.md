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
    La propuesta se llama nuevo_<fichero> y conserva la extensión original
    (nuevo_CLAUDE.md, nuevo_main.c), nunca un sufijo .nuevo: así vim
    reconoce el tipo de fichero. Si hay colisión de nombres, añade el
    proyecto: nuevo_timap_CLAUDE.md.
- No compiles por iniciativa propia: de las builds me encargo yo.
- En los mensajes de commit no pongas líneas de atribución (ni Co-Authored-By
    ni "Generated with").
- Los fuentes de mis proyectos Win32 suelen ser Latin-1 (cp1252) con CRLF:
    respeta la codificación y los finales de línea del original, toca solo las
    líneas necesarias (localizándolas por contenido, no por número de línea) y
    en ficheros nuevos evita acentos en los comentarios.
