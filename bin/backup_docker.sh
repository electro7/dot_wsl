#!/usr/bin/env bash

# Copia de seguridad de contenedores Dockers
#
# - Detiene el docker
# - Realiza copia de seguridad
# - Rearranca docker
#
# Meterlo en cron: "crontab -u root -e"
# - Todos los viernes -> 0 0 * * 5 /root/backup_docker.sh
#
# Borra los ficheros más antiguos de X dias=SAVE_DAY

# CONFIG GLOBAL
###################################################################

# Directorio destino de los backups. Sin '/' al final
DEST_DIR="/root/backup"
# Dias para guardar backup. Borra lo más antiguos
SAVE_DAY=30
# Fecha y hora para ficheros
TIMESTAMP=$(date "+%d%m%Y")

# CONFIG
###################################################################

# 1
# Lista de dockers a detener para realizar copia de seguridad
# Solo es necesario parar los que dependen de BD; mysql, etc..
# Campo "NAMES de docker ps
DOCKERS="AdGuardHome PiAlert"

# 2
# Lista de backup a realizar. Nombre identificativo en mayúsculas
BACKUPS="PORTAINER HOMEPAGE ADGUARD PIALERT"

# 3
# Por cada BACKUP, directorio fuente. Sin '/' al final
PORTAINER="/var/lib/docker/volumes/portainer_data"
HOMEPAGE="/var/lib/docker/volumes/homepage_config"
ADGUARD="/var/lib/docker/volumes/adguard_cnf"
PIALERT="/var/lib/docker/volumes/pialert_conf"

#  Chequea opciones
###################################################################

# Parametros:  $1 -> BACKUPS
check_config () {
    DIR="${1}"

    if [ ! -d ${DEST_DIR} ]
    then
        echo "Creando directorio destino...${DEST_DIR}"
        mkdir -p ${DEST_DIR}
        if [ ${?} -ne 0 ]
        then
            echo "Error creando ${DEST_DIR}!"
            echo "Terminando script..."
            exit 1
        fi
    fi

    if [ ! -d ${!DIR} ]
    then
        echo "${!DIR}: El directorio no existe!"
        echo "Terminando script..."
        exit 2
    fi

    if [ "${DEST_DIR}" == "${!DIR}" ]
    then
        echo "\$${DEST_DIR} y \$${DIR} son el mismo!"
        echo "Terminando script..."
        exit 3
    fi

}

#  Bucle backup
###################################################################

# Parametros:  $1 -> BACKUPS
do_backup () {
    DIR="${1}"
    LOWERCASE=$(echo ${1} | tr '[:upper:]' '[:lower:]')
    FILE=${DEST_DIR}/backup_${LOWERCASE}_${TIMESTAMP}.tar.gz

    echo "Backup de ${1}: ${!DIR} en ${FILE}"
    tar czf ${FILE} ${!DIR} 2>/dev/null

    if [ $? -ne 0 ]
    then
        echo "tar: Errores!"
        rm ${TEMPFILE}
        echo "Terminando script..."
        exit 3
    fi
}


#  MAIN
###################################################################

main () {
    # Chequea opciones
    for cnf in ${BACKUPS[@]}
    do
        check_config ${cnf}
    done

    # Detiene dockers
    for dock in ${DOCKERS[@]}
    do
        echo -e "Parando docker ${dock}..."
        docker stop ${dock}
    done

    # Periodo de gracia
    echo "Tiempo de espera de 10 s..."
    sleep 10

    # Realiza backups
    for back in ${BACKUPS[@]}
    do
        do_backup ${back}
    done

     # Rearranca dockers
    for dock in ${DOCKERS[@]}
    do
        echo -e "Arrancando docker ${dock}..."
        docker start ${dock}
    done

    # Borra backups antiguos
    find ${DEST_DIR} -type f -mtime +${SAVE_DAY}
}

main

