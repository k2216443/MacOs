# =============================================================================================== #
# Initialization of ssh-agent during ZSH run                                                      #
# =============================================================================================== #
if [ ! -e $HOME/.ssh/ssh-agent.socket ]; then
  ssh-agent -a $HOME/.ssh/ssh-agent.socket
  echo -e "ssh-agent:: starting new"
else
  echo -e "ssh-agent:: exists"
fi

export TERM="xterm-256color"
export SSH_AUTH_SOCK="${HOME}/.ssh/ssh-agent.socket"

# =============================================================================================== #
# Конфигурация History                                                                            #
# =============================================================================================== #
HISTSIZE=5000
HISTFILE=~/.zssh_history 
SAVEHIST=64000
HISTDUP=erase                     # Стираем дубликаты в history

setopt appendhistory              # Добавление к истории
setopt sharehistory               # Одна история между сессиями
setopt incappendhistory           # Мнговенное примерение
setopt extended_history
setopt hist_ignore_dups


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
##
# Поиск по истории с учетом подстрок
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down


source ~/.zshrc_cmd
source ~/.zshrc_base

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/godscream/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/godscream/Applications/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/godscream/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/godscream/Applications/google-cloud-sdk/completion.zsh.inc'; fi


sg()
{
  env | grep -i SSH_AUTH_SOCK | awk -F= '{ print $2 }'
}

# gd_ssh_keygen()

sc()
{
  echo "SSH switcher started --> $1"
  if [ x"$1" = "x" ]; then
    echo "Argument not founded"
    return 
  fi
  echo "Argument founded"

  SOCK_REQUESTED="${HOME}/.ssh/ssh-agent-${1}.socket"
  SOCK_CURRENT=$(env | grep -i SSH_AUTH_SOCK | awk -F'=' '{ print $2 }')

  echo "SOCK_CURRENT: ${SOCK_CURRENT}"
  if [ "${SOCK_CURRENT}" = "${SOCK_REQUESTED}" ]; then
    echo "Requested is current: ${SOCK_REQUESTED} = ${SOCK_CURRENT}"
    return
  fi

  if [ ! -e "${SOCK_REQUESTED}" ]; then
    ssh-agent -a "${SOCK_REQUESTED}"
    echo -e "ssh-agent:: starting new ssh-agent --> ${SOCK_REQUESTED}"
  fi

  export SSH_AUTH_SOCK="${SOCK_REQUESTED}"
  export SSH_AUTH_PROFILE=$1
  PROMPT="${PROMPT#*]} "
  PROMPT="[${SSH_AUTH_PROFILE}] ${PROMPT}"
}

a() {
  OPTIONS=""
  if [ -n "$ANSIBLE_USER" ]; then
    OPTIONS="--user=${ANSIBLE_USER}"
  fi
  time ansible-playbook $OPTIONS --diff $@
}