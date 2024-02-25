#!/bin/bash
#
# Script de generación de autom.tar.gz para remotas

if [ -e bd.zip ]; then rm -f bd.zip; fi
echo --------------------------------------------------------------------------
echo -n "Borrando temporales..."
clean -c -f
echo " OK"
echo --------------------------------------------------------------------------
echo -e "Comprimiendo..."
zip -r bd.zip bd
echo --------------------------------------------------------------------------
echo -en "$(tput setaf 9)"
ls -l bd.zip
echo -en "$(tput sgr0)"
echo --------------------------------------------------------------------------
