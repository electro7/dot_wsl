#!/bin/bash
# SessionStart: inyecta el handoff del proyecto si existe.
# La carpeta de memoria se deduce del cwd como hace Claude Code: todo caracter
# no alfanumerico pasa a '-' (tambien '_' y '.', no solo '/').
# No se inyecta tras una compactacion: el handoff seria anterior al trabajo
# de la propia sesion.
entrada=$(cat)
cwd=$(printf %s "$entrada" | jq -r '.cwd // empty')
origen=$(printf %s "$entrada" | jq -r '.source // empty')
[ -n "$cwd" ] || exit 0
[ "$origen" = "compact" ] && exit 0
f="$HOME/.claude/projects/$(printf %s "$cwd" | sed 's/[^A-Za-z0-9]/-/g')/memory/handoff.md"
[ -s "$f" ] || exit 0

dias=$(( ( $(date +%s) - $(stat -c %Y "$f") ) / 86400 ))
case $dias in
    0) edad="de hoy" ;;
    1) edad="de ayer" ;;
    *) edad="de hace $dias dias" ;;
esac
echo "Handoff de la sesion anterior, $edad (fichero: $f). Resume en una linea donde nos quedamos y propon continuar; borra el fichero cuando la tarea termine."
if [ "$dias" -ge 7 ]; then
    echo "Tiene mas de una semana: antes de continuar, pregunta al usuario si sigue vigente."
fi
echo
cat "$f"
