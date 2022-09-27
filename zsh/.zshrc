################### Antigen ############################

source /usr/share/zsh/share/antigen.zsh

antigen use oh-my-zsh

# Load the plugins.
antigen bundles <<EOBUNDLES
  extract 
  command-not-found
  docker
  kubectl 
  helm
  fzf

  spaceship-prompt/spaceship-vi-mode@main

  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# Load the theme.
antigen theme spaceship-prompt/spaceship-prompt

# Tell Antigen that you're done.
antigen apply

################### Zsh ############################

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:/usr/local/bin:/opt:$HOME/scripts:$HOME/.local/bin

# Path to your oh-my-zsh installation.
# export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
#   docker
#   kubectl
#   helm
#   fzf
#   extract
#   command-not-found
#   zsh-fzf-history-search
#   zsh-vi-mode
#   zsh-autosuggestions
#   zsh-completions
#   zsh-history-substring-search
#   zsh-syntax-highlighting
# )

# source $ZSH/oh-my-zsh.sh

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

# default set to 'xterm-termite' but servers cannot handle this therefore:
# export TERM="xterm"
export EDITOR="vim"

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# haskell
# https://wiki.archlinux.org/title/Haskell#ghcup
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# flyctl
export FLYCTL_INSTALL="/home/florian/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

################### Aliases ############################

alias sem='cd /home/florian/Documents/01_Ausbildung/ETH/msc/Sem3'
alias vis='cd /home/florian/go/src/gitlab.ethz.ch/vis/cat'

alias code='exec code .'
alias open="xdg-open"

alias conmon="xrandr --output eDP-1 --auto --output HDMI-2 --auto --above eDP-1 --primary; i3-msg -q restart"
alias disconmon="xrandr --output HDMI-2 --off; i3-msg -q restart"
alias dupmon="xrandr --output HDMI-2 --same-as eDP-1 --auto; i3-msg -q restart"

alias getsecret="jq '.data.value' -r | base64 --decode | cut -c 1-"

alias mountdrive="sudo cryptsetup open /dev/sda drive; sudo mount /dev/mapper/drive /home/florian/media"
alias umountdrive="sudo umount /home/florian/media; sudo cryptsetup close drive"
alias backup="sudo rsync -aAXvP --delete --exclude=/dev --exclude=/lost+found --exclude=/media --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/run --exclude=/mnt --exclude=/var --exclude=/home/florian/Downloads --exclude=/home/florian/git --exclude=/home/florian/go --exclude=/home/florian/tmp --exclude=/home/florian/media --exclude=/home/florian/.cache / /home/florian/media"

alias copy='xclip -selection c'
alias paste='xclip -selection c -o'

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

################### Zsh Line Editor ############################
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

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

################### Autocompletion ############################

if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
if [ /usr/local/bin/helm ]; then source <(helm completion zsh); fi
if [ /usr/share/fzf ]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi
