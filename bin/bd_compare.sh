#!/bin/bash
# Script para comparar BD de texto de Shield

HOWCALLED=`basename $0`

# Colores
c_yellow=$(tput setaf 11)
c_blue=$(tput setaf 12)
c_purple=$(tput setaf 13)
c_red=$(tput setaf 9)
c_none=$(tput sgr0)

# Uso
function usage() {
  echo
  echo -e "${c_yellow}Comparador de BDT de SHIELD${c_none}"
  echo
  echo "Ignora campos temporales; fecha, horas, último valor, etc.."
  echo
  echo -e "Uso: ${c_blue}$HOWCALLED [tabla] [dir1] [dir2]${c_none}"
  echo
  echo "Tablas:"
  echo -e "     ${c_red}device${c_none}   : Disposivos -> device.bdt"
  echo -e "     ${c_red}refvar${c_none}   : Tipos dispositivo -> refvar.bdt"
  echo -e "     ${c_red}folder${c_none}   : Carpetas -> folder.bdt"
  echo
  echo "[dir1] [dir2] : directorio base shield a comparar"
}

HOWCALLED=`basename $0`

if [ $# -ne 3 ]
 then
   usage
   exit 1
fi

SRC=${2}/Data
DST=${3}/Data

if [ ! -d ${SRC} ]; then
    echo -e "${c_red}${SRC}${c_none} no existe!"
    exit 1
fi
if [ ! -d ${DST} ]; then
    echo -e "${c_red}${DST}${c_none} no existe!"
    exit 1
fi

case "$1" in
    device)
        SRC=${2}/Data/Device.BDT
        DST=${3}/Data/Device.BDT
        # Campos nombre, carpeta, módulo, código, tipo
        vimdiff <(awk -F',' '{print $2,"Fol="$3,"Mod="$8,"Cod="$11,"Typ="$12}' ${SRC}) \
            <(awk -F',' '{print $2,"Fol="$3,"Mod="$8,"Cod="$11,"Typ="$12}' ${DST})
        ;;
    refvar)
        SRC=${2}/Data/RefVar.BDT
        DST=${3}/Data/RefVar.BDT
        # Campos nombre, carpeta, módulo, objeto, código, tipo
        vimdiff <(awk -F',' '{print $2,"Mod="$8,"Cod="$10,"Log="$11,"Dec="$12,"Uni="$13}' ${SRC}) \
            <(awk -F',' '{print $2,"Mod="$8,"Cod="$10,"Log="$11,"Dec="$12,"Uni="$13}' ${DST})
        ;;
    folder)
        SRC=${2}/Data/Folder.BDT
        DST=${3}/Data/Folder.BDT
        # Campos nombre, carpeta, icono, subcarpeta, tipo módulo, carpeta enlazada
        vimdiff <(awk -F',' '{print $2,"Fol="$3,"Ico="$8,"Sub="$9,"Typ="$10,"Lnk="$12}' ${SRC}) \
            <(awk -F',' '{print $2,"Fol="$3,"Ico="$8,"Sub="$9,"Typ="$10,"Lnk="$12}' ${DST})
        ;;
    *)
        echo
        echo -e "Tabla ${c_red}"$1"${c_none}   : no existe!"
        ;;
esac

