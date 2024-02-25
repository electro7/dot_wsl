#======================================================================#
# .bashrc
# Fichero "mínimo" de opciones del shell bash
#
# Versión 1.0 - 25 Feb 2024 - Tunelia Ingenieros S.L.
#======================================================================#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#----------------------------------------------------------------------#
# Prompt
#----------------------------------------------------------------------#

# Colores a utilizar
COLV="\[\033[0;32m\]" # Verde
COLC="\[\033[0;36m\]" # Cyan
COLA="\[\033[0;33m\]" # Amarillo
COLB="\[\033[0;34m\]" # Blue
COLP="\[\033[0;35m\]" # Purple
COLR="\[\033[0;31m\]" # Rojo
COLN="\[\033[0m\]"    # Reset
COL="$COLC"           # Usuario normal

[[ "$UID" = "0" ]] && COL=$COLR # Rojo para root

# Prompt final
PS1="$COLV--[$COL\u$COLV]-[$COLC\h$COLV]-[$COLA\w$COLV]\n$COL \\$ $COLN"


#----------------------------------------------------------------------#
# Colores
#----------------------------------------------------------------------#

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_OPTIONS='--color=auto'
    alias l='ls $LS_OPTIONS'
    alias ll='ls $LS_OPTIONS -l -N -F'
    alias ls='ls $LS_OPTIONS -A -N -hF'
fi

export GREP_COLOR="1;31"
alias grep='grep --color=auto'
export LESS="-R"

#----------------------------------------------------------------------#
# PATH
#----------------------------------------------------------------------#
export PATH="$PATH:$HOME/bin"

#----------------------------------------------------------------------#
# Variables variadas
#----------------------------------------------------------------------#

# Por defecto.
export EDITOR="vim"
export BROWSER="firefox"

#----------------------------------------------------------------------#
# Alias
#----------------------------------------------------------------------#

# Alias contra borrados accidentales.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Alias del shell
alias h='history'
alias v='vim'
alias gv='gvim'
alias j="jobs -l"
alias psl='ps -aux | less'
alias ..='cd ..'
alias 'cd..'='cd ..'
alias reboot="sudo reboot -f"

#----------------------------------------------------------------------#
# OTROS
#----------------------------------------------------------------------#

# Auto-completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Para que a los VT100 no se les fastidie el terminal con los colores
if [ $TERM = vt100 ]; then
        alias ls='ls -F --color=never';
fi
