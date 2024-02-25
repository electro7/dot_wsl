#!/usr/bin/env bash

# Copia de seguridad de contenedores LXC
#
# - Detiene el LXC
# - Realiza copia de seguridad
# - Rearranca LXC
#

# CONFIG GLOBAL
###################################################################

# Directorio destino de los backups
DEST_DIR="/vault/backup"
# Dias para guardar backup. Borra lo más antiguos
SAVE_DAY=30
# Fecha y hora para ficheros
TIMESTAMP=$(date "+%d%m%Y")

# CONFIG
###################################################################

# 1
# Lista de LXC a detener para realizar copia de seguridad
# Campo VMID de "pct list"
LXC="101 102"

# 2
# Por cada LXC lista de backup que se realizan. Siempre en mayús.
# L_<LXC>_BACKUPS="<backup1> <backup2> ..."
L_101_BACKUPS="WIKI FIREDB FIREUP CADDY VWARDEN"

# 3
# Por cada BACKUP
# <LXC>_<BACKUP>_DIR="/path/to/dir"
# Sin '/' al final
L_101_WIKI_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/dokuwiki_config"
L_101_FIREFLY_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/firefly_db"
L_101_FIREDB_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/firefly_upload"
L_101_CADDY_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/vaultwarden_caddy_cnf"
L_101_VWARDEN_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/vaultwarden_data"

#  Chequea opciones
###################################################################

# Parameter:    $1 -> {101_WIKI, 101_FIREFLY, ...}
check_config () {
    DIR="${1}_DIR"

    if [ ! -d ${!DEST_DIR} ]
    then
        echo "Creating...${!DEST_DIR}"
        mkdir -p ${!DEST_DIR}
        if [ ${?} -ne 0 ]
        then
            echo "Error creando ${!DEST_DIR}!"
            echo "Terminando script..."
            exit 1
        fi
    fi

    if [ ! -d ${!DIR} ]
    then
        echo "${!DIR}: El direcotio no existe!"
        echo "Terminando script..."
        exit 2
    fi

    if [ "${!DEST_DIR}" == "${!DIR}" ]
    then
        echo "\$${DEST_DIR} y \$${DIR} son el mismo!"
        echo "Terminando script..."
        exit 3
    fi

}

#  Buble backup
###################################################################
do_lxc () {
    echo ${1}
    BCK=${"L_${1}_BACKUPS"}
    echo ${L_101_BACKUPS}
    echo ${BCK}
    for bck in ${BCK[@]}
    do
        DIR="L_${1}_${bck}_DIR"
        echo $DIR
    done
}

###################################################################
#                        conduct_backup()                         #
###################################################################

# Takes a backup of the ${<some-token>_DIR} directory and temporarily
# stores it in /tmp/. if the 'tar' command exits with no errors, the
# temporary file is moved to the directory held in ${<some-token>_DEST_DIR}.
#
# Parameter:    $1 -> {WIKI, CLOUD, ...}
#conduct_backup () {
#    DEST_DIR="${1}_DEST_DIR"
#        DIR="${1}_DIR"
#    TEMPFILE="$(mktemp /tmp/backup.XXXXXX)"
#    PATH_TOKENS=$(echo ${!DIR} | tr "/" " ")
#
#    for token in ${PATH_TOKENS[@]}
#    do
#        continue
#    done
#
#    PATHTODIR=${!DIR/\/$token}
#
#    echo -e "\nBacking up ${!DIR} ..."
#    echo -e "This might take some time!\n"
#
#    tar -zcf ${TEMPFILE} -C ${PATHTODIR} ./${token}
#
#    if [ $? -ne 0 ]
#    then
#        echo "tar: Exited with errors!"
#        rm ${TEMPFILE}
#        echo "Script will now exit..."
#        exit 3
#    fi
#
#    TOKEN_LOWERCASE=$(echo ${1} | tr '[:upper:]' '[:lower:]')
#    mv ${TEMPFILE} ${!DEST_DIR}/backup_${TOKEN_LOWERCASE}_${TIMESTAMP}.tar.gz
#}

#  MAIN
###################################################################

# Por cada LXC, detiene, realiza su backup y arranca
main () {
    for l in "${LXC[@]}"
    do
        do_lxc ${l}
    done
}

main
