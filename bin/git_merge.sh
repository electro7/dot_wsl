#!/bin/bash
# Convertimos las rutas de Linux ($1 y $2) a formato Windows usando wslpath
LOCAL_WIN=$(wslpath -w "$1")
REMOTE_WIN=$(wslpath -w "$2")

# Ejecutamos WinMerge pasando las rutas correctas
/mnt/c/datos/curro/soft/000_misc/WinMerge/WinMergeU.exe "$LOCAL_WIN" "$REMOTE_WIN"
