#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls --color=auto -la'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(zoxide init bash)"

export PATH=$PATH:/home/rluzuriaga/.cargo/bin:/home/rluzuriaga/.local/share/nvim/mason/staging/htmx-lsp/bin

export GPG_TTY=$(tty)
