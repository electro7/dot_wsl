#!/bin/bash

HOWCALLED=`basename $0`

# Verificar que se pasaron los argumentos correctos
if [ "$#" -ne 2 ]; then
    echo "Duplicar ficheros del servidor modbus incrementando el puerto".
    echo
    echo "Uso: ${HOWCALLED} <archivo_origen> <n_copias>"
    exit 1
fi

file="$1"
cnt="$2"

# Verificar que el file existe
if [ ! -f "$file" ]; then
    echo "Error: El file '$file' no existe."
    exit 1
fi

# Extraer el número del puerto actual
port=$(grep -oP 'port=\K\d+' "$file")

if [ -z "$port" ]; then
    echo "Error: No se encontró una línea con 'port='."
    exit 1
fi

# Crear las copias con puertos incrementados
for ((i=1; i<=cnt; i++)); do
    new_port=$((port + i))
    new_file="${file%.*}_$new_port.${file##*.}"

    sed "s/port=$port/port=$new_port/" "$file" > "$new_file"
    echo "Creado: $new_file con port=$new_port"
done
