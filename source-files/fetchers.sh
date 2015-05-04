getJSResource(){
  if [[ ! -e $1 ]]
  then
    cp "/Users/Yaniv/Documents/coding/inhouse/resources/js/$1" .
    echo "Fetched $1"
  fi
}

getRaphael(){
  getJSResource raphael.js
}

getBackbone(){
  dependencies='jquery-1.11.0.js underscore.js' 
  for dependency in $dependencies; do
    getJSDependency $dependency;
  done 
  getJSResource backbone.js
}

getBackboneFilter(){
  bb='backbone.js'
  if [[ ! -e $bb ]]; then
    getBackbone
  fi
  getJSResource backbone-router-filter.js
}

getReact(){
  getJSResource react.js
}

getAngular(){
  getJSResource angular.js
}

getAngularResource(){
  dependencies="angular.js"
  for dependency in $dependencies; do
    getJSDependency $dependency;
  done 
  getJSResource angular-resources.js
}

getFirebase(){
  getJSResource firebase.js
}

getMocha(){
  getJSResource mocha.js
}


getHandlebars(){
  getJSResource handelbars.js
}

getHandlebarsHelpers(){
  dependencies='handlebars.js'
  for dependency in $dependencies; do
    getJSResource $dependency
  done
  getJSResource handlebars_helpers.js
}

getGrips(){
  dependencies='handlebars.js'
  for dependency in $dependencies; do
    getJSResource $dependency
  done
  getJSResource grips.js
}

getD3(){
  getJSResource d3.js
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
  cp -r /Users/Yaniv/Documents/coding/inhouse/resources/css/twitter_bootstrap/css/ ./stylesheets
  cp -r /Users/Yaniv/Documents/coding/inhouse/resources/css/twitter_bootstrap/js/ ./javascripts
  cp -r /Users/Yaniv/Documents/coding/inhouse/resources/css/twitter_bootstrap/fonts/ ./fonts
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

