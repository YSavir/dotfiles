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

goCode(){
  cd ~/Documents/coding/$1
#  for var in "$@"
#  do
#    echo "searching for $var"
#    find -type d -printf '%d\t%P\n'| sort -r -nk1 | cut -f2 | xargs echo
#    #cd $(find . -depth 1 -name $var -type d)
#  done  
}

goWorking(){
  cd ~/Documents/professional_needs/$1
}

goOvermen(){
  cd ~/Documents/games/overmen
}

goDots(){
  cd ~/dotfiles/source-files
}

### Copy JS files to Current Directory

getReact(){
  mv /Users/Yaniv/Documents/coding/resources/js/react.js .
}

getJSDependency(){
  echo $1
  if [[ ! -e $1 ]]
  then
    cp /Users/Yaniv/Documents/coding/resources/js/$1 .
  fi
}

getRaphael(){
  cp /Users/Yaniv/Documents/coding/resources/js/raphael.js .
  echo "Fetched Raphael"
}

getjQuery(){
  cp /Users/Yaniv/Documents/coding/resources/js/jquery-1.11.0.js .
  echo "Fetched jQuery"
}

getUnderscore(){
  cp /Users/Yaniv/Documents/coding/resources/js/underscore.js .
  echo "Fetched Underscore"
}

getBackbone(){
  dependencies='jquery-1.11.0.js underscore.js' 
  for dependency in $dependencies; do
    getJSDependency "$dependecy";
  done 
  cp /Users/Yaniv/Documents/coding/resources/js/backbone.js .
  echo "Fetched Backbone"
}

getAngular(){
  cp /Users/Yaniv/Documents/coding/resources/js/angular.js .
  echo "Fetched Angular"
}

getAngularResource(){
  angular="angular.js"
  if [[ ! -e $angular ]]
  then
    getAngular
  fi
  cp /Users/Yaniv/Documents/coding/resources/js/angular-resource.js .
  echo "Fetched Angular Resource"
}

getFirebase(){
  cp /Users/Yaniv/Documents/coding/resources/js/firebase.js .
}

getMocha(){
  cp /Users/Yaniv/Documents/coding/resources/js/mocha.js .
  echo "Fetched Mocha"
}


getHandlebars(){
  cp /Users/Yaniv/Documents/coding/resources/js/handlebars.js .
  cp /Users/Yaniv/Documents/coding/resources/js/handlebars_helpers.js .
  echo "Fetched Handlebars and helpers"
}

getGrips(){
  cp /Users/Yaniv/Documents/coding/my_projects/libraries/grips/lib/grips.js .
  echo 'fetched Grips'
}

getD3(){
  cp /Users/Yaniv/Documents/coding/resources/js/d3.js .
  echo "Fetched D3"
}

### Copy frameworks to current directory
getEmberStarterKit(){
  cp /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/README.md .
  cp /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/index.html .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/js .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/css .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/tests .
}

getBootstrap(){
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/css/ ./stylesheets
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/js/ ./javascripts
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/fonts/ ./fonts
  rm ./stylesheets/bootstrap-theme.min.css
  rm ./stylesheets/bootstrap.min.css
  rm ./javascripts/bootstrap.min.js
  echo "Fetched Bootstrap."
}

getFoundation(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/css/ ./stylesheets
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/img/ ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/js/ ./javascripts
  rm /css/foundation.min.css
  rm /js/foundation.min.js
}

getSkeleton(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/images ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/stylesheets ./stylesheets
}

getSkeleton1200(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/images ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/stylesheets ./stylesheets
  rm stylesheets/skeleton.css
  cp /Users/Yaniv/Documents/coding/coding_resources/css_files/bower_components/getskeleton1200/skeleton1200.css ./stylesheets
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

