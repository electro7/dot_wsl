LXC="101 102"

L_101_BACKUPS="WIKI FIREDB FIREUP CADDY VWARDEN"

# 3
# Por cada BACKUP
# <LXC>_<BACKUP>_DIR="/path/to/dir"
# Sin '/' al final
AAA_WIKI_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/dokuwiki_config"
AAA_FIREFLY_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/firefly_db"
AAA_FIREDB_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/firefly_upload"
AAA_CADDY_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/vaultwarden_caddy_cnf"
AAA_VWARDEN_DIR="/vault/subvol-101-disk-0/var/lib/docker/volumes/vaultwarden_data"

#  Buble backup
###################################################################
do_lxc () {
    echo ${1}
    BCK="${1}_BACKUPS"
    echo ${!BCK}
    for bck in ${BCK[@]}
    do
        DIR="${1}_${bck}_DIR"
        echo $DIR
    done
}

# Por cada LXC, detiene, realiza su backup y arranca
main () {
    for l in ${LXC[@]}
    do
        do_lxc ${l}
    done
}

main
