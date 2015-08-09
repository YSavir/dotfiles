### Aliases

alias ll='ls -la'
alias getbash='vim ~/.bash_profile'
alias setbash='source ~/.bash_profile'
alias kitty='cat /Users/Yaniv/Pictures/ascii/kitty.txt; echo ""'
alias chrome='open -a "Google Chrome"'
alias firefox='open -a "Firefox"'

alias MKDIR='mkdir -p'

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

..(){
  isNumber='^[0-9]+$'
  COUNTER="0"
  if [[ "$#" -eq "0" ]] || [[ ! $1 =~ $isNumber ]] ; then
    END='1'
  else
    END="$1"
  fi
  echo $END
  while [ "$COUNTER" -lt "$END" ]; do
    cd ..
    let COUNTER=COUNTER+1
  done
}


# Handlebars

precHB(){
  handlebars -e hbs -m $1 -f $2
}

# Tree

## Skip NPM files

alias tree="tree -I 'node_modules'"
