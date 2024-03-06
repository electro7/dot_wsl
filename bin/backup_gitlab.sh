#!/usr/bin/env bash

# Copia de seguridad de GitLab
#
# - Detiene el docker
# - Realiza copia de seguridad
# - Rearranca docker
#
# Meterlo en cron: "crontab -u root -e"
# - lunes, miercoles y viernes -> 0 1 * * 1,3,5 /root/backup_gitlab.sh
#
# Borra los ficheros más antiguos de X dias=SAVE_DAY
#
# Los backups se crean con usuario git y grupo git, con derecho de lectura

# CONFIG GLOBAL
###################################################################

# Dias para guardar backup. Borra lo más antiguos
SAVE_DAY=15
# Fecha y hora para ficheros
TIMESTAMP=$(date "+%d%m%Y")

# CONFIG
###################################################################

# Directorio donde se almacena los backup DE BD
DEST_DIR="/var/opt/gitlab/backups"


#  Chequea
###################################################################

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

}

check_perms () {
    echo "Cambiado permisoss..."
    echo "-------------------------------------------------"
    chown -R git:git ${DEST_DIR}
    chmod -R g+rx ${DEST_DIR}
}


#  backup
###################################################################

# Parametros:
do_backup () {

    echo "Backup de configuración..."
    echo "-------------------------------------------------"
    gitlab-ctl backup-etc --backup-path ${DEST_DIR}

    if [ $? -ne 0 ]
    then
        echo "Backup de configuración: Error!"
        rm ${TEMPFILE}
        echo "Terminando script..."
        exit 2
    fi

    echo "Backup de datos..."
    echo "-------------------------------------------------"
    gitlab-backup create CRON=1

    if [ $? -ne 0 ]
    then
        echo "Backup de datos: Error!"
        rm ${TEMPFILE}
        echo "Terminando script..."
        exit 3
    fi

}


#  MAIN
###################################################################

main () {
    # Chequea opciones
    check_config

    # Realiza 
    do_backup

    # Borra backups antiguos
    echo "Borra backups más antiguos de ${SAVE_DAY}"
    echo "-------------------------------------------------"
    find ${DEST_DIR} -type f -mtime +${SAVE_DAY} -delete

    # Cambia permisos
    check_perms

}

main

