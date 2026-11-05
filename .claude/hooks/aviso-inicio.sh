#!/bin/bash
# UserPromptSubmit: anota la hora de inicio y un resumen del prompt por sesion,
# para que aviso-fin.sh pueda avisar si la tarea ha durado mas del umbral.
d=~/.claude/hooks/estado
mkdir -p "$d"
in=$(cat)
sid=$(jq -r '.session_id // empty' <<<"$in")
[ -n "$sid" ] || exit 0
p=$(jq -r '.prompt // ""' <<<"$in" | tr '\n\r\t' '   ' | cut -c1-80)
printf '%s\n%s\n' "$(date +%s)" "$p" > "$d/$sid"
# limpieza de restos de sesiones viejas (> 2 dias)
find "$d" -type f -mtime +2 -delete 2>/dev/null
exit 0
