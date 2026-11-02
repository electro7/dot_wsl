#!/bin/bash
# SessionStart: inyecta el handoff del proyecto si existe.
# La carpeta de memoria se deduce del cwd (/ -> -), como hace Claude Code.
cwd=$(jq -r '.cwd // empty')
[ -n "$cwd" ] || exit 0
f="$HOME/.claude/projects/${cwd//\//-}/memory/handoff.md"
[ -s "$f" ] || exit 0
echo "Handoff de la sesion anterior (fichero: $f). Resume en una linea donde nos quedamos y propon continuar; borra el fichero cuando la tarea termine."
echo
cat "$f"
