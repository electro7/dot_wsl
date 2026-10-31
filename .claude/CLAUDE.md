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
