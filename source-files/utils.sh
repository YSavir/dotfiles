### Aliases

alias ll='ls -la'
alias getbash='vim ~/.bash_profile'
alias setbash='source ~/.bash_profile'
alias kitty='cat /Users/Yaniv/Pictures/ascii/kitty.txt; echo ""'
alias chrome='open -a "Google Chrome"'
alias firefox='open -a "Firefox"'
alias subl='open -a "Sublime Text"'

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

fileCount() {
  totalCount=$(tree -a $1 --noreport | wc -l)
  directoryCount=$(tree -da $1 --noreport | wc -l)
  echo "$((totalCount-directoryCount))"
}

findObsoleteVueBridges() {
  directivesPath='app/javascript/src/vue/ng-vue-bridge/vue-directives.js'
  matches=$(ag -o "component\('\K((\w|-)*)" $directivesPath)

  for match in $matches; do
    dashedMatch=$(echo $match         \
     | sed 's/\(.\)\([A-Z]\)/\1-\2/g' \
     | tr '[:upper:]' '[:lower:]')


    result=$(ag "ngv-$dashedMatch" )

    if [[ -z $result ]]; then
      echo $dashedMatch
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
