#!/bin/bash
# Linea de estado de Claude Code, al estilo de mi prompt (prompt_e7.sh):
#   ┌[directorio]─[rama ↑n ↓n ≈n ●n …]─[modelo ctx%]
# Claude Code envia por stdin un JSON con los datos de la sesion.

IFS=$'\t' read -r model eff dir ctx r5 r7 cost dur < <(
    jq -r '[.model.display_name // .model.id // "?",
            (.effort.level // .effort // "-" | tostring),
            .workspace.current_dir // .cwd // "-",
            (.context_window.used_percentage // "-" | tostring),
            (.rate_limits.five_hour.used_percentage // "-" | tostring),
            (.rate_limits.seven_day.used_percentage // "-" | tostring),
            (.cost.total_cost_usd // "-" | tostring),
            (.cost.total_duration_ms // "-" | tostring)] | @tsv'
)
[ "$dir" = "-" ] && dir=$PWD

# Colores (los mismos que prompt_e7.sh)
c_dg=$'\e[1;30m'    # gris oscuro: marcos
c_gy=$'\e[0;37m'    # gris: directorio
c_bl=$'\e[1;34m'    # azul: rama
c_gr=$'\e[1;32m'    # verde: limpio
c_ye=$'\e[1;33m'    # amarillo: modificado
c_rd=$'\e[1;31m'    # rojo: conflictos / ahead
c_cy=$'\e[1;36m'    # cian: staged / modelo
c_pu=$'\e[1;35m'    # purpura: behind
c_of=$'\e[0m'

# Directorio truncado a 30 caracteres, como en el prompt
new_pwd=${dir/#$HOME/\~}
max=30; base=${dir##*/}
(( max < ${#base} )) && max=${#base}
off=$(( ${#new_pwd} - max ))
if (( off > 0 )); then
    new_pwd=${new_pwd:$off:$max}
    new_pwd="../${new_pwd#*/}"
fi

out="${c_dg}[${c_gy}${new_pwd}${c_dg}]"

# --no-optional-locks: no pelear por el indice con git del usuario.
# -uno: no recorrer ficheros sin seguimiento (lento en /mnt/c).
if st=$(git -C "$dir" --no-optional-locks status --porcelain -b -uno 2>/dev/null); then
    mod=0 staged=0 conf=0 ahead=0 behind=0
    head=${st%%$'\n'*}
    branch=${head#\#\# }
    branch=${branch%%...*}
    branch=${branch%% *}
    [[ $branch == "No" || $branch == HEAD* ]] &&
        branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    [[ $head =~ ahead\ ([0-9]+) ]] && ahead=${BASH_REMATCH[1]}
    [[ $head =~ behind\ ([0-9]+) ]] && behind=${BASH_REMATCH[1]}

    while IFS= read -r l; do
        [[ $l == "##"* || -z $l ]] && continue
        x=${l:0:1}; y=${l:1:1}
        if [[ $x == U || $y == U || $l == AA* || $l == DD* ]]; then
            conf=$(( conf + 1 )); continue
        fi
        [[ $x != " " ]] && staged=$(( staged + 1 ))
        [[ $y != " " ]] && mod=$(( mod + 1 ))
    done <<< "$st"

    g="${c_dg}─[${c_bl}${branch}"
    (( ahead  > 0 )) && g+=" ${c_rd}↑${ahead}"
    (( behind > 0 )) && g+=" ${c_pu}↓${behind}"
    (( mod    > 0 )) && g+=" ${c_ye}≈${mod}"
    (( conf   > 0 )) && g+=" ${c_rd}✘${conf}"
    (( staged > 0 )) && g+=" ${c_cy}●${staged}"
    (( ahead + behind + mod + conf + staged == 0 )) && g+=" ${c_gr}√"
    out+="${g}${c_dg}]"
fi

# Bloque 1, alineado a la derecha: [modelo | esfuerzo | % de contexto]
sep="${c_dg} | "
info="${c_cy}${model}"
[ "$eff" != "-" ] && info+="${sep}${c_gy}${eff}"
[ "$ctx" != "-" ] && info+="${sep}${c_gy}$(printf '%.0f' "$ctx")%"
right="${c_dg}[${info}${c_dg}]"

# Bloque 2: [now % | week %], consumo del limite de la sesion (5 h) y de la semana.
# Solo existe con suscripcion Claude.ai y tras la primera respuesta.
# Color: gris <70%, amarillo >=70%, rojo >=90%.
quota() {    # quota etiqueta porcentaje
    local p c
    p=$(printf '%.0f' "$2")
    c=$c_gy
    (( p >= 70 )) && c=$c_ye
    (( p >= 90 )) && c=$c_rd
    printf '%s%s %s%%' "$c" "$1" "$p"
}
q=""
[ "$r5" != "-" ] && q+="$(quota now "$r5")"
[ "$r7" != "-" ] && q+="${q:+$sep}$(quota week "$r7")"
[ -n "$q" ] && right+=" ${c_dg}[${q}${c_dg}]"

# Bloque 3: [coste de la sesion | tiempo transcurrido]
t=""
[ "$cost" != "-" ] && t+="${c_gy}$(printf '$%.2f' "$cost")"
if [ "$dur" != "-" ]; then
    s=$(( ${dur%.*} / 1000 ))
    if   (( s >= 3600 )); then d=$(printf '%dh%02dm' $(( s / 3600 )) $(( s % 3600 / 60 )))
    elif (( s >= 60 ));   then d="$(( s / 60 ))m"
    else d="${s}s"; fi
    t+="${t:+$sep}${c_gy}${d}"
fi
[ -n "$t" ] && right+=" ${c_dg}[${t}${c_dg}]"
right+="${c_of}"

# Ancho del terminal: COLUMNS, o el tty de control; si no hay, sin alinear
cols=${COLUMNS:-}
[[ $cols =~ ^[0-9]+$ ]] || cols=$(stty size </dev/tty 2>/dev/null | cut -d' ' -f2)
[[ $cols =~ ^[0-9]+$ ]] || cols=0

# Longitud visible (sin secuencias de color)
strip() { sed -e $'s/\e\\[[0-9;]*m//g' <<< "$1"; }
l=$(strip "$out");   l=${#l}
r=$(strip "$right"); r=${#r}

margen=4    # Claude Code deja un pequeno margen a los lados
pad=$(( cols - margen - l - r ))
if (( cols > 0 && pad >= 1 )); then
    printf -v sp '%*s' "$pad" ''
    out+="${c_of}${sp}${right}"
else
    out+="${c_dg}─${right}"
fi

printf '%s\n' "$out"
