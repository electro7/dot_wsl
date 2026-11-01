#
# My bash prompt using PROMPT_COMMAND to change PS1
#
#   - ssh conection
#   - working directory
#   - git status
#   - Current normaluser/root
#
# E7 - 05 sep 2019


# Colors
c_gray="\[\033[0;37m\]"
c_d_gray="\[\033[1;30m\]"
c_red="\[\033[1;31m\]"
c_green="\[\033[1;32m\]"
c_yellow="\[\033[1;33m\]"
c_blue="\[\033[1;34m\]"
c_purple="\[\033[1;35m\]"
c_cyan="\[\033[1;36m\]"
c_none="\[\033[0m\]"

# Prompt init
# ---------------------------------------------------------------------------
function __prompt_e7_init {
  # Terminal window title
  local title=""
  if [ -z "$TW_TITLE" ]; then
    title='\[\e]0;\h : \s (\w)\a\]'
  else
    title="${TW_TITLE}"
  fi
  # Truncate current dir
  local pwdmaxlen=30
  local trunc_symbol=".."
  local dir=${PWD##*/}
  pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  local new_pwd=${PWD/#$HOME/\~}
  local pwdoffset=$(( ${#new_pwd} - pwdmaxlen ))
  if [ ${pwdoffset} -gt "0" ]
  then
    new_pwd=${new_pwd:$pwdoffset:$pwdmaxlen}
    new_pwd=${trunc_symbol}/${new_pwd#*/}
  fi
  # Remote conection ?
  local prompt_init=""
  if [ -n "$SSH_CONNECTION" ]; then
    prompt_init="$title${c_d_gray}┌[${c_yellow}\h${c_d_gray}]─[${c_gray}${new_pwd}${c_d_gray}]"
  else
    prompt_init="$title${c_d_gray}┌[${c_gray}${new_pwd}${c_d_gray}]"
  fi

  printf "%s" "${prompt_init}"
}

# Prompt end
# ---------------------------------------------------------------------------
function __prompt_e7_end {
  local c_who=${c_cyan}
  [[ "$UID" = "0" ]] && c_who=${c_red}
  prompt_end="\n${c_d_gray}└ ${c_who}\\$ ${c_none}"

  printf "%s" "${prompt_end}"
}

# Git status
# ---------------------------------------------------------------------------
function __prompt_e7_git_status {
  # Una sola llamada a git (un unico recorrido del arbol de trabajo).
  # Antes eran 5 procesos git, cada uno recorriendo el arbol: en /mnt/c con
  # la cache fria eso eran varios segundos.
  local status_out
  status_out=$(git status --porcelain=v2 --branch 2>/dev/null) || return 1

  # No git repo (or no output) -> exit
  [ -z "$status_out" ] && return 1

  # colors
  local c_branch="$c_blue"
  local c_add="$c_cyan"
  local c_clean="$c_green"
  local c_mod="$esc$c_yellow"
  local c_untrack="$c_red"
  local c_ahead="$c_purple"
  local c_begind="$c_purple"
  local c_none="$c_none"

  # Char for status
  local add_ch="●"
  local unmerged_ch="✘"
  local mod_ch="≈"
  local clean_ch="√"
  local untrack_ch="…"
  local ahead_ch="↑"
  local behind_ch="↓"

  local unmerged_c=0 mod_c=0 untrack=0
  local add_c=0 is_clean=""

  # Parse de la salida de status (solo builtins de bash, sin mas procesos)
  #   # branch.head <rama>        # branch.ab +<ahead> -<behind>
  #   1/2 XY ...  (X = indice, Y = arbol de trabajo)
  #   u ...       (sin fusionar)       ? ...  (sin seguimiento)
  local branch="" behind_c=0 ahead_c=0
  local line xy
  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*) branch=${line#\# branch.head } ;;
      "# branch.ab "*)
        set -- ${line#\# branch.ab }
        ahead_c=${1#+}
        behind_c=${2#-}
        ;;
      "1 "*|"2 "*)
        xy=${line:2:2}
        [[ ${xy:0:1} != "." ]] && add_c=$(( add_c + 1 ))
        [[ ${xy:1:1} == "M" ]] && mod_c=$(( mod_c + 1 ))
        ;;
      "u "*) unmerged_c=$(( unmerged_c + 1 )) ;;
      "? "*) untrack=1 ;;
    esac
  done <<< "$status_out"
  [[ "$branch" == "(detached)" ]] && branch="HEAD"

  # Total count
  if [ $(( unmerged_c + mod_c + untrack + add_c )) -eq 0 ]
  then
    is_clean=1
  fi

  # Final status
  local lw_space=" "
  printf "%s" "${c_d_gray}─[${c_branch}${branch}"
  [[ $ahead_c -gt 0 ]] \
    && printf "%s" "${lw_space}${c_untrack}${ahead_ch}${ahead_c}"
  [[ $behind_c -gt 0 ]] \
    && printf "%s" "${lw_space}${c_begind}${behind_ch}${behind_c}"
  [[ $mod_c -gt 0 ]] \
    && printf "%s" "${lw_space}${c_mod}${mod_ch}${mod_c}"
  [[ $unmerged_c -gt 0 ]] \
    && printf "%s" "${lw_space}${c_untrack}${unmerged_c}"
  [[ $add_c -gt 0 ]] \
    && printf "%s" "${lw_space}${c_add}${add_ch}${add_c}"
  [[ $untrack -gt 0 ]] \
    && printf "%s" "${lw_space}${c_untrack}${untrack_ch}"
  [[ $is_clean -gt 0 ]] \
    && printf "%s" "${lw_space}${c_clean}${clean_ch}"
  printf "%s" "${c_d_gray}]${c_none}"

}

# main
# ---------------------------------------------------------------------------
function __prompt_e7 {
  PS1="$(__prompt_e7_init)$(__prompt_e7_git_status)$(__prompt_e7_end)"
}

if [[ ! "$PROMPT_COMMAND" == *__prompt_e7* ]]; then
    PROMPT_COMMAND='__prompt_e7;'
fi

#__prompt_e7

# vim: ts=2:sw=2:tw=0
