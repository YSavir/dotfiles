export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export PS1='\[\e[48;5;247;38;5;54m\u@\h:\e[0m\e[38;5;54m \w\e[0m $([[ -n $(git branch 2> /dev/null) ]] && echo " ")\[\033[1;33m\]$(parse_git_branch)\[\033[1;37m\]\n$ \[\e[0m\]'


