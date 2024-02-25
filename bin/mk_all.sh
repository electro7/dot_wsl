#!/bin/bash
#
# Script de generación de autom.tar.gz y bd.zip para remotas

COMMON="/mnt/c/work/obras/000_common/"
WORKS="/mnt/c/work/obras/"
PRG="siga.dev jarvis.dev"
BD="*.cwd *.swd"
N_FILES=5

cd $WORKS
# Automátas
AUT=""
for P in $PRG
do
    AUT="${AUT} $(find . -iname "$P" -type f)"
done
echo -en "$(tput setaf 9)"
echo Creando AUTOM.TAR.GZ -----------------------------------------------------
for D in $AUT
do
    cd $(dirname ${D}) >/dev/null 2>&1
    CNT=$(ls -l *.prg *.dev 2>/dev/null| wc -l)
    if [ $CNT -gt $N_FILES ] ; then
        echo -en "$(tput setaf 12)"
        echo -n $(pwd) "... "
        mk_inst.sh 2&>/dev/null
        OK=$(ls -b autom.tar.gz 2>/dev/null | wc -w) 
        if [ $OK -ne 1 ]; then
            echo -en "$(tput setaf 11)"
            echo "ERROR"
        else
            echo -en "$(tput setaf 2)"
            echo "OK"
        fi
    fi
    cd $WORKS
done
echo -en "$(tput setaf 9)"
echo --------------------------------------------------------------------------

cd $WORKS
# Base de datos
SHD=""
for P in $BD
do
    SHD="${SHD} $(find . -iname "$P" -type f)"
done
echo -en "$(tput setaf 9)"
echo Creando BD.ZIP -----------------------------------------------------------
for D in $SHD
do
    cd $(dirname ${D}) >/dev/null 2>&1
    cd ..
    echo -en "$(tput setaf 12)"
    echo -n $(pwd) "... "
    clean -c -f
    mk_bd.sh >/dev/null 2>&1
    OK=$(ls -b bd.zip 2>/dev/null | wc -w) 
    if [ $OK -ne 1 ]; then
        echo -en "$(tput setaf 11)"
        echo "ERROR"
    else
        echo -en "$(tput setaf 2)"
        echo "OK"
    fi
    cd $WORKS
done
echo -en "$(tput setaf 9)"
echo --------------------------------------------------------------------------

cd $WORKS
echo -en "$(tput sgr0)"
