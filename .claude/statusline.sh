#!/bin/bash
# Linea de estado de Claude Code, al estilo de mi prompt (prompt_e7.sh):
#   ┌[directorio]─[rama ↑n ↓n ≈n ●n …]─[modelo ctx%]
# Claude Code envia por stdin un JSON con los datos de la sesion.

IFS=$'\t' read -r model dir ctx < <(
    jq -r '[.model.display_name // .model.id // "?",
            .workspace.current_dir // .cwd // "-",
            (.context_window.used_percentage // "-" | tostring)] | @tsv'
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

out="${c_dg}┌[${c_gy}${new_pwd}${c_dg}]"

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

# Modelo y contexto usado
info="${c_cy}${model}"
[ "$ctx" != "-" ] && info+="${c_gy} $(printf '%.0f' "$ctx")%"
out+="${c_dg}─[${info}${c_dg}]${c_of}"

printf '%s\n' "$out"
