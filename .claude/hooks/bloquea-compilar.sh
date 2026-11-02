#!/bin/bash
# PreToolUse(Bash): bloquea la compilacion de fuentes (las builds las hace el usuario).
# Mira la primera palabra de cada segmento del comando (separado por ; & | y saltos
# de linea), sin ruta ni .exe. Tambien revisa lo que se lanza via powershell/cmd/wsl.
cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

re_comp='^(gcc|g\+\+|cc|c\+\+|clang|clang\+\+|tcc|make|gmake|mingw32-make|cmake|ninja|msbuild|devenv|nmake|cl|windres|rc|ld|as|ar)$|-(gcc|g\+\+|cc|ar|windres)$'
re_wrap='^(powershell|pwsh|cmd|wsl|bash|sh|env|sudo|time|nice)$'

bloquea() {
    # Salida JSON con exit 0: deniega la llamada con el motivo (Claude Code lo
    # muestra al usuario y se lo pasa a Claude).
    msg="Bloqueado: no se compila por iniciativa propia (de las builds se encarga el usuario). Comando: $1"
    jq -n --arg m "$msg" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $m}}'
    exit 0
}

while IFS= read -r seg; do
    set -- $seg
    # saltar asignaciones VAR=valor iniciales
    while [ $# -gt 0 ] && [[ "$1" == *=* ]]; do shift; done
    [ $# -gt 0 ] || continue
    w=${1##*/}; w=${w##*\\}; w=${w%.exe}; w=${w,,}
    if [[ "$w" =~ $re_comp ]]; then bloquea "$seg"; fi
    if [[ "$w" =~ $re_wrap ]]; then
        for t in "${@:2}"; do
            t=${t//[\"\']/}; t=${t##*/}; t=${t##*\\}; t=${t%.exe}; t=${t,,}
            if [[ "$t" =~ $re_comp ]]; then bloquea "$seg"; fi
        done
    fi
done < <(printf '%s\n' "$cmd" | sed -E 's/(&&|\|\||[;&|])/\n/g')
exit 0
