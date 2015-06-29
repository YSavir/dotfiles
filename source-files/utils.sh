### Aliases

alias ll='ls -la'
alias getbash='vim ~/.bash_profile'
alias setbash='source ~/.bash_profile'
alias kitty='cat /Users/Yaniv/Pictures/ascii/kitty.txt; echo ""'
alias chrome='open -a "Google Chrome"'
alias firefox='open -a "Firefox"'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export PS1='\[\e[48;5;247;38;5;54m\u@\h:\e[0m\e[38;5;54m \w\e[0m $([[ -n $(git branch 2> /dev/null) ]] && echo " ")\[\033[1;33m\]$(parse_git_branch)\[\033[1;37m\]\n$ \[\e[0m\]'

makeMe () { 
  if [ $1 ]; then
    mkdir $1;
    cd $1;
   else
     echo "No directory name provided.";
   fi
}

breadth_find(){
  i=0
  while results=$(find . -mindepth $i -maxdepth $i -name "$1" -print -quit); do
    if [[ -n $results ]]; then
      echo $results;
      return 0
    else
      ((i++))
    fi
  done
}

go(){
  cd ~/
  for dir in $@; do
    cd $(breadth_find $dir)
  done
}


# Handlebars

precHB(){
  handlebars -m $1 -f $2
}

########################
##### MISCELLANIUS #####
########################

### SSH Connections
alias sshOvermen='ssh overmenr@overmenrpg.com'

