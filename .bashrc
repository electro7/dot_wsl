#======================================================================#
# .bashrc
# Fichero de opciones del shell bash
#
# Electro7
# 25 Feb 2024
# Versión común - WSL, debian y archlinux
#======================================================================#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#----------------------------------------------------------------------#
# Prompt
#----------------------------------------------------------------------#

# Título para las ventanas de consola en la X
TW_TITLE='\[\e]0;\h : \s (\w)\a\]'

# Añade retorno de carro y el cambio del titulo de la ventana al P1 actual
function __promptadd
{
  local col_n="\[\033[0m\]"                     # Reset
  local col_u="\[\033[1;36m\]"                  # User > cyan
  [[ "$UID" = "0" ]] && col_u="\[\033[1;31m\]"  # Root > red

  PS1="$TW_TITLE$PS1\n${col_u} \\$ ${col_n}"
}

# Prompt a traves de promptline.vim
# Es un plugin de VIM para crear un prompt con simbolos powerline.
# Entrar en vim y hacer un :PromptlineSnapShot ~/.shell_prompt.sh
function prompt_line
{
  source ~/bin/prompt_powerline.sh
  PROMPT_COMMAND="$PROMPT_COMMAND; __promptadd;"
}

# Prompt "normal" sin carácteres raros
function prompt_term
{
  # Mi chequeo de git propio
  source ~/bin/prompt_e7.sh
}

# Selección de prompt según el tipo de terminal
case "$TERM" in
  rxvt*)
    prompt_line
    ;;
  *)
    prompt_term
    ;;
esac

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

alias lsmp3='ls -1 --indicator-style=none *.mp3'
alias lsepub='ls -1 -R --indicator-style=none | grep epub'
export GREP_COLORS="mt=1;31"
alias grep='grep --color=auto'
export LESS="-R"
export PAGER="most"

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
#export QT_STYLE_OVERRIDE=GTK
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=0

#----------------------------------------------------------------------#
# Alias
#----------------------------------------------------------------------#

# Alias WSL
if [[ -n $(grep -E 'WSL|icrosoft' /proc/version) ]]; then
  alias start="explorer.exe"
  alias s="start"
  alias gv="start gvim.exe"
  alias ping='sudo ping'
  alias z="sudo mount -t drvfs '\\\\192.168.60.10\\obras' /mnt/z"
  alias diff="/mnt/c/datos/curro/soft/000_misc/WinMerge/WinMergeU.exe"
fi

# Alias contra borrados accidentales.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Alias del shell
alias h='history'
alias v='vim'
alias vi='vim'
alias j="jobs -l"
alias psl='ps -aux | less'
alias ..='cd ..'
alias 'cd..'='cd ..'
alias df="df -h"
alias more='less'
alias du='du -h'
alias rs='rsync -W -ahvzi --progress'

# Alias para el su (root)
alias reboot="sudo /sbin/reboot"
alias halt="sudo /sbin/poweroff"
alias poweroff="sudo /sbin/poweroff"
alias pacman="sudo pacman"
alias paclean="sudo pacman -S --clean --clean"
alias dpkg="sudo dpkg"

# Alias del git
alias gia="git add"
alias gcm="git commit -a -m"
alias gs="git status"
alias gp="git push"
alias gg="git pull"
alias gd="git diff"
alias greset="git reset --hard"
alias gco="git checkout"
alias gb="git branch"
alias gm="git merge"

# Alias/Función para crear commit, tag y subir todo
gtag() {
  if [ -z "$1" ]; then
    echo "Error: Debes indicar la versión."
    echo "Uso: gtag <versión>"
    echo "Ejemplo: gtag v1.2.0"
    return 1
  fi

  git add .

  # Abrir el editor para el mensaje extenso
  echo "Abriendo editor para el mensaje del commit..."
  if git commit; then
    # Capturamos el mensaje
    local MSG=$(git log -1 --pretty=%B)
    git tag -a "$1" -m "$MSG"
    git push origin --all
    git push origin --tags
    echo "Todo subido: Rama y Tag $1"
  else
    echo "Commit cancelado. No se creó el tag."
  fi
}

# Mis chuletas
alias chuleta="vim ~/.vim/doc/chuletario.txt"
alias todo="vim ~/work/ToDo.txt"

# Cambio colores de terminal
alias col_dark="sh ~/.config/termcolours/dark.sh"
alias col_light="sh ~/.config/termcolours/light.sh"
alias col_default="sh ~/.config/termcolours/default.sh"

# Wifi on/off
alias wifi_on="sudo netctl start"
alias wifi_off="sudo netctl stop"
alias wifi_status="iw dev wlan0 info"
alias wifi_menu="wifi-menu"

# App varias
alias mldonkey="mldonkey -stdout -verbosity verb"
alias netload="speedometer -r eth0 -t eth0"
alias ko="export DISPLAY=:0.0; kodi &"
alias vbox="export DISPLAY=:0.0; virtualbox &"
alias vbox_start="export DISPLAY=:0.0; VBoxManage startvm"
alias vbox_ctrl="VBoxManage controlvm"
alias vbox_ls="VBoxManage list vms"

# SSH
alias ssh_sistemas="ssh root@192.168.60.90"
alias ssh_ofi1="ssh root@192.168.60.91"
alias ssh_ofi2="ssh root@192.168.60.92"
alias ssh_ofi3="ssh root@192.168.60.93"
alias ssh_taller="ssh root@192.168.70.241"
alias ssh_git="ssh root@git.tunelia.com"
alias ssh_man="ssh root@obras.tunelia.com"
alias ssh_plan="ssh root@plan.tunelia.com"
alias ssh_dev="ssh root@proyectos.tunelia.com"
alias ssh_portainer1="ssh tunelia@portainer.tunelia.com"
alias ssh_portainer2="ssh tunelia@192.168.60.95"
alias ssh_wiki="ssh root@wiki.tunelia.com"
alias ssh_jarvis0="ssh tunelia@192.168.60.55"
alias ssh_jarvis1="ssh tunelia@192.168.60.56"
alias ssh_jarvis2="ssh tunelia@192.168.60.57"
alias ssh_jarvis3="ssh tunelia@192.168.60.58"
alias ssh_jarvis4="ssh tunelia@192.168.60.59"
alias ssh_wine1="ssh tunelia@192.168.60.61"
alias ssh_wine2="ssh tunelia@192.168.60.62"
alias ssh_jarvis5="ssh tunelia@192.168.60.63"
alias ssh_jarvis_sim="ssh tunelia@192.168.60.64"
alias ssh_wazuh="ssh root@wazuh.tunelia.com"
alias ssh_siem="ssh root@siem.tunelia.com"

# Alias util
alias view_net="sudo ss -tuanp"
alias view_con="sudo lsof -i -np"

#----------------------------------------------------------------------#
# Funiones propias
#----------------------------------------------------------------------#

# MSTSC
mstsc() {
  start mstsc.exe /v:$1 /w:1920 /h:1080 /noConsentPrompt
}

# Cambiar a directorio obras
cdc() {
  cd "$(find /mnt/c/work/obras -maxdepth 3 -type d -iname *$1* | tail -n 1)"
}

# Cambiar a directorio obras en NAS
cdo() {
  sudo mount -t drvfs '\\192.168.60.10\obras' /mnt/z
  cd "$(find /mnt/z -maxdepth 1 -type d -iname *$1* | tail -n 1)"
}

# Busqueda recursiva
gr() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Uso: gr <texto_a_buscar> <extension>"
    echo "Ejemplo: gr hola  *.prg"
    return 1
  fi
  grep -rain . -e "$1" --include="$2"
}

# Arrancar y parar máquinas vituales de vbox
vbox_on() {
  VBoxManage startvm $1 --type headless
}
vbox_off() {
  VBoxManage controlvm $1 savestate
}

# Contar líneas de código
code_cnt() {
  find . \( -name "*.c" -o -name "*.cpp" -o -name "*.h" \) -exec wc -l {} +
}
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

# Man coloreador - hay que instalar less
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjvf $1    ;;
        *.tar.gz)    tar xzvf $1    ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xjvf $1    ;;
        *.tgz)       tar xzvf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Para que a los VT100 no se les fastidie el terminal con los colores
if [ $TERM = vt100 ]; then
  alias ls='ls -F --color=never';
fi

# Check umask
if [[ $(umask) != "0022" ]]; then umask 0022; fi

#----------------------------------------------------------------------#
# Jarvis
#----------------------------------------------------------------------#
export SYS="Debian"

#----------------------------------------------------------------------#
# SSH KEY
#----------------------------------------------------------------------#

# Borra temporal si existe
if [ `ps -ef | grep ssh-agent | grep -v grep | wc -l` -eq 0 ]; then
  rm -f /tmp/ssh-agent* 2&> /dev/null
fi

# attempt to connect to a running agent, sharing over sessions (putty)
check-ssh-agent() {
  [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

check-ssh-agent || export SSH_AUTH_SOCK=/tmp/ssh-agent.sock_$USER
check-ssh-agent || eval "$(ssh-agent -s -a /tmp/ssh-agent.sock_$USER)" > /dev/null

#Add identities if not exist
if [[ -n $(ssh-add -l | grep 'The agent has no identities') ]] ; then
  ssh-add 2> /dev/null
fi

# vim: ts=2:sw=2:
