#!/bin/bash
# PreToolUse(Edit|Write|NotebookEdit): no se editan fuentes directamente.
# Solo se permite sin preguntar la configuracion propia (~/.claude) y temporales;
# cualquier otra ruta exige confirmacion explicita del usuario (permissionDecision "ask").
f=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[ -n "$f" ] || exit 0

r=$(realpath -m -- "$f")
for ok in "$(realpath -m ~/.claude)" /tmp/claude-1000 /mnt/c/Windows/Temp; do
    case "$r/" in "$ok"/*) exit 0 ;; esac
done

# Excepcion: propuestas (ya estan bajo ~/.claude). Todo lo demas, a confirmar.
msg="Edicion directa de un fuente: $r. Las propuestas van a ~/.claude/propuestas/<proyecto>/ (nuevo_<fichero>) con vimdiff; confirma solo si lo has pedido explicitamente."
jq -n --arg m "$msg" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $m}}'
exit 0
