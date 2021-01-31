# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME="spaceship"
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git extract web-search git-extras docker zsh-syntax-highlighting zsh-autosuggestions history-substring-search zsh-completions virtualenv)

source $ZSH/oh-my-zsh.sh

# User configuration

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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#add script dir to path to not have to type ./
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:/opt"

#default set to 'xterm-termite' but servers cannot handle this therefore:
export TERM="xterm"
export EDITOR="vim"

alias sem='cd $HOME/Documents/01_Ausbildung/ETH/Sem7'
alias vis='cd $HOME/go/src/gitlab.ethz.ch/vis/cat'
alias restartwifi='systemctl restart NetworkManager'
alias code='exec code .'

alias open="xdg-open"

alias conmon="xrandr --output eDP-1 --auto --output HDMI-2 --auto --above eDP-1 --primary; i3-msg -q restart"
alias disconmon="xrandr --output HDMI-2 --off; i3-msg -q restart"
alias dupmon="xrandr --output HDMI-2 --same-as eDP-1 --auto"
alias getsecret="jq '.data.value' -r | base64 --decode | cut -c 1-"
alias mountdrive="sudo cryptsetup open /dev/sda drive; sudo mount /dev/mapper/drive $HOME/media"
alias umountdrive="sudo umount $HOME/media; sudo cryptsetup close drive"
alias backup="sudo rsync -aAXvP --delete --exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* --exclude=/run/* --exclude=/mnt/* --exclude=/media/* --exclude=$HOME/Downloads/* --exclude=$HOME/git/* --exclude=$HOME/go/* --exclude=$HOME/tmp/* --exclude=$HOME/media/* --exclude=$HOME/.cache/* --exclude=/lost+found / $HOME/media"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

#eval $(keychain --eval id_rsa) &>/dev/null
#eval $(ssh-agent -s) &>/dev/null
#ssh-add ~/.ssh/other_id_rsa &>/dev/null

alias copy='xclip -selection c'
alias paste='xclip -selection c -o'

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

bindkey -v

bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^r' history-incremental-search-backward
bindkey '^f' history-incremental-search-forward
bindkey '^b' backward-kill-word
bindkey '^w' vi-forward-blank-word
bindkey '^e' end-of-line

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

################### Spaceship stuff ############################

SPACESHIP_PROMPT_ORDER=(
  venv
  time          # Time stampts section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Backgound jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)


if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/mc mc

complete -o nospace -C /usr/local/bin/mc mc

