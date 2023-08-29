# zmodload zsh/zprof # for profiling: linked to last line

################### Zsh Line Editor ############################
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# https://wiki.archlinux.org/title/zsh#Key_bindings

export KEYTIMEOUT=1
bindkey -v
bindkey -M viins '^B' backward-kill-word
bindkey -M viins '^W' vi-forward-blank-word
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^E' end-of-line
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down

# bindkey | rg '"\^\w"'
# disable bindkey

################### Antigen ############################

source /usr/share/zsh/share/antigen.zsh

antigen use oh-my-zsh

# Load the plugins.
antigen bundles <<EOBUNDLES
  extract 
  command-not-found
  fzf

  spaceship-prompt/spaceship-vi-mode@main

  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-history-substring-search
  zdharma-continuum/fast-syntax-highlighting
EOBUNDLES

# Load the theme.
antigen theme spaceship-prompt/spaceship-prompt

# Tell Antigen that you're done.
antigen apply

################### Zsh ############################

# If you come from bash you might have to change your $PATH.
export PATH="$PATH:/usr/local/bin:/opt:$HOME/.local/bin:$HOME/scripts"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# dont store commands starting with a space in the history
setopt HIST_IGNORE_SPACE

################### Environment variables ############################

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_GB.UTF-8
export LC_ALL="en_GB.UTF-8"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

export EDITOR="vim"

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

# haskell
# https://wiki.archlinux.org/title/Haskell#ghcup
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# flyctl
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# bat, fd
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"

# monitors
export MONITOR_0=$(xrandr | rg "\bconnected\b" | awk '{ print $1 }' | sed -n '1 p')
export MONITOR_1=$(xrandr | rg "\bconnected\b" | awk '{ print $1 }' | sed -n '2 p')

# ansi escape code: color
# 0; = regular
export REGULAR="\033[0m" # no color
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export BLUE="\033[0;34m"
export PURPLE="\033[0;35m"
export CYAN="\033[0;36m"
export WHITE="\033[0;37m"
# 1; = bold
export BBLACK="\033[1;30m"
export BRED="\033[1;31m"
export BGREEN="\033[1;32m"
export BYELLOW="\033[1;33m"
export BBLUE="\033[1;34m"
export BPURPLE="\033[1;35m"
export BCYAN="\033[1;36m"
export BWHITE="\033[1;37m"
# 4; = underline
export UBLACK="\033[4;30m"
export URED="\033[4;31m"
export UGREEN="\033[4;32m"
export UYELLOW="\033[4;33m"
export UBLUE="\033[4;34m"
export UPURPLE="\033[4;35m"
export UCYAN="\033[4;36m"
export UWHITE="\033[4;37m"

################### Aliases ############################

alias conmon="xrandr --output $MONITOR_0 --auto --output $MONITOR_1 --auto --above $MONITOR_0 --primary; i3-msg -q restart"
alias disconmon="xrandr --output $MONITOR_1 --off; i3-msg -q restart"
alias dupmon="xrandr --output $MONITOR_1 --same-as $MONITOR_0 --auto; i3-msg -q restart"

alias mirrormon='pipectl -n wl-present -o | wl-mirror -S `slurp -b \#00000000 -B \#00000000 -c \#859900 -w 4 -f %o -or`'

alias sem='cd $HOME/Documents/01_Ausbildung/ETH/msc/Sem4'
alias vis='cd $HOME/go/src/gitlab.ethz.ch/vis/cat'

alias code='exec code .'
alias open="xdg-open"

alias getsecret="jq '.data.value' -r | base64 --decode | cut -c 1-"

alias mountdrive="sudo cryptsetup open /dev/sda drive; sudo mount /dev/mapper/drive $HOME/media"
alias umountdrive="sudo umount $HOME/media; sudo cryptsetup close drive"
alias backup="sudo rsync -aAXvP --delete --exclude=/dev --exclude=/lost+found --exclude=/media --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/run --exclude=/mnt --exclude=/var --exclude=$HOME/Downloads --exclude=$HOME/git --exclude=$HOME/go --exclude=$HOME/tmp --exclude=$HOME/media --exclude=$HOME/.cache / $HOME/media"

alias copy='clipcopy'
alias paste='clippaste'

alias ls='exa'

alias bell='echo -ne "\007"'

alias gitlog='fd --type d -H ".git" . | while read d; do
   cd $d/..;
   echo "${BGREEN}$PWD${REGULAR} >";
   git --no-pager log --pretty=tformat:"%ad%x09%s" --author="Florian Bütler" --since=7.days;
   echo "";
   cd $OLDPWD;
done'

alias gitpull='fd --type d -H ".git" . \
  | while read d; 
      do cd $d/..; 
      echo "${BGREEN}${PWD}${REGULAR} >"; 
      git pull; 
      cd $OLDPWD; 
    done'

# https://github.com/github/hub
alias git=hub

################### Functions ############################

function dip() {
  OUTPUT="ID; Name; IPs; Ports; PublishedPorts\n"
  docker ps --filter status=running --format "{{.ID}}" | while read -r line; do
    PORTS=$(docker port "$line" | sed 's/\/.*:/ -> /g' | cut -f2 -d: | tr '\n' ', ')
    if [ -z "${PORTS}" ]; then
      OUTPUT="${OUTPUT}$(echo $line";" $(docker inspect --format '{{ .Name }}; {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}; {{range $port, $val := .NetworkSettings.Ports }}{{ $port }} {{end}}; ' $line | sed 's/\///') 'none')\n"
    else
      OUTPUT="${OUTPUT}$(echo $line";" $(docker inspect --format '{{ .Name }}; {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}; {{range $port, $val := .NetworkSettings.Ports }}{{ $port }} {{end}}; ' $line | sed 's/\///') ${PORTS})\n"
    fi
  done
  echo $OUTPUT | column -t -s ';'
}

decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 1 ]; then
    result="${1}==="
  elif [ $len -eq 2 ]; then
    result="${1}=="
  elif [ $len -eq 3 ]; then
    result="${1}="
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

decode_jwt() {
  decode_base64_url $(echo -n $2 | cut -d "." -f $1) | jq .
}

# Decode JWT header
alias jwth="decode_jwt 1"

# Decode JWT Payload
alias jwtp="decode_jwt 2"

sha256() {
  echo "$(cat $1) $2" | sha256sum --check
}

################### Spaceship ############################
# https://spaceship-prompt.sh/config/prompt/#prompt-order

SPACESHIP_PROMPT_ORDER=(
  venv
  dir       # Current directory section
  git       # Git section (git_branch + git_status)
  exec_time # Execution time
  line_sep  # Line break
  vi_mode   # Vi-mode indicator
  jobs      # Backgound jobs indicator
  exit_code # Exit code section
  char      # Prompt character
)

# https://github.com/spaceship-prompt/spaceship-vi-mode
eval spaceship_vi_mode_enable

################### Autocompletion ############################

# eagerily
# function kubectl() {
#   if ! type __start_kubectl >/dev/null 2>&1; then
#     source <(command kubectl completion zsh)
#   fi

#   command kubectl "$@"
# }

# function helm() {
#   if ! type __start_helm >/dev/null 2>&1; then
#     source <(command helm completion zsh)
#   fi

#   command helm "$@"
# }

# lazily
#if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
#if [ /usr/local/bin/helm ]; then source <(helm completion zsh); fi

#if [ /usr/share/fzf ]; then
#  source /usr/share/fzf/key-bindings.zsh
#  source /usr/share/fzf/completion.zsh
#fi

# reload autocompletion once a day and dump it in zcompdump
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
autoload -Uz compinit
if [ $(date +'%j') != $(stat --format '@%Y' "$zcompdump" | xargs date +'%j' -d) ]; then
  compinit -d "$zcompdump"
else
  compinit -d "$zcompdump" -C
fi
# compile zcompdump, if modified, to increase startup speed
{
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

################### Managed by others ############################

# zprof
