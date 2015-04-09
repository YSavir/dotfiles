### Aliases

alias ll='ls -la'
alias getbash='vim ~/.bash_profile'
alias setbash='source ~/.bash_profile'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export PS1='\[\e[48;5;247;38;5;54m\u@\h:\e[0m\e[38;5;54m \w\e[0m $([[ -n $(git branch 2> /dev/null) ]] && echo " ")\[\033[1;33m\]$(parse_git_branch)\[\033[1;37m\]\n$ \[\e[0m\]'

function goCode(){
  cd ~/Documents/coding
  for var in "$@"
  do
    echo "searching for $var"
    find . -depth 1 -name $var -type d | xargs echo
    cd $(find . -depth 1 -name $var -type d)
  done  
}

function goWorking(){
  cd ~/Documents/professional_needs/$1
}

function goOvermen(){
  cd ~/Documents/games/overmen
}

### Copy JS files to Current Directory
function getRaphael(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/raphael.js .
  echo "Fetched Raphael"
}

function getjQuery(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/jquery-1.11.0.js .
  echo "Fetched jQuery"
}

function getUnderscore(){
  jquery="jquery-*.js"
  if [[ ! -e $jquery ]]
  then
    getjQuery
  fi
  cp /Users/Yaniv/Documents/coding/resources/js_files/underscore.js .
  echo "Fetched Underscore"
}

function getBackbone(){
  underscore="underscore.js"
  if [[ ! -e $underscore ]]
  then
    getUnderscore
  fi
  cp /Users/Yaniv/Documents/coding/resources/js_files/backbone.js .
  echo "Fetched Backbone"
}

getAngular(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/angular.js .
  echo "Fetched Angular"
}

getAngularResource(){
  angular="angular.js"
  if [[ ! -e $angular ]]
  then
    getAngular
  fi
  cp /Users/Yaniv/Documents/coding/resources/js_files/angular-resource.js .
  echo "Fetched Angular Resource"
}

getFirebase(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/firebase.js .
}

function getMocha(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/mocha.js .
  echo "Fetched Mocha"
}


function getHandlebars(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/handlebars.js .
  cp /Users/Yaniv/Documents/coding/resources/js_files/handlebars_helpers.js .
  echo "Fetched Handlebars and helpers"
}

function getGrips(){
  cp /Users/Yaniv/Documents/coding/my_projects/libraries/grips/lib/grips.js .
  echo 'fetched Grips'
}

getD3(){
  cp /Users/Yaniv/Documents/coding/resources/js_files/d3.js .
  echo "Fetched D3"
}

### Copy frameworks to current directory
function getEmberStarterKit(){
  cp /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/README.md .
  cp /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/index.html .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/js .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/css .
  cp -r /Users/Yaniv/Documents/coding/coding_resources/frameworks/ember_starter-kit-1.4.0/tests .
}

function getBootstrap(){
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/css/ ./stylesheets
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/js/ ./javascripts
  cp -r /Users/Yaniv/Documents/coding/resources/css/twitter_bootstrap/fonts/ ./fonts
  rm ./stylesheets/bootstrap-theme.min.css
  rm ./stylesheets/bootstrap.min.css
  rm ./javascripts/bootstrap.min.js
  echo "Fetched Bootstrap."
}

function getFoundation(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/css/ ./stylesheets
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/img/ ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/foundation-5.0.3/js/ ./javascripts
  rm /css/foundation.min.css
  rm /js/foundation.min.js
}

function getSkeleton(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/images ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/stylesheets ./stylesheets
}

function getSkeleton1200(){
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/images ./images
  cp -r /Users/Yaniv/Documents/coding/coding_resources/css_files/skeleton/dhg-Skeleton-7ab6820/stylesheets ./stylesheets
  rm stylesheets/skeleton.css
  cp /Users/Yaniv/Documents/coding/coding_resources/css_files/bower_components/getskeleton1200/skeleton1200.css ./stylesheets
}

# Handlebars

function precHB(){
  handlebars -m $1 -f $2
}

########################
##### MISCELLANIUS #####
########################

### SSH Connections
alias sshOvermen='ssh overmenr@overmenrpg.com'

