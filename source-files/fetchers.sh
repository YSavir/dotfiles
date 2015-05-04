get(){
  if [ ! $2 ]
  then
    echo "Error -- Must pass both type of resource and resource name";
    return    
  fi

  resource_directory=$1

  if [[ ! -e /Users/Yaniv/Documents/coding/inhouse/resources/$resource_directory ]]
  then
    echo "Error --  No such resource directory"
    return
  fi

  shift
  for resource in $@; do
    if [[ ! -e $resource ]]
    then
      cp "/Users/Yaniv/Documents/coding/inhouse/resources/$resource_directory/$resource.js" .
      echo "Fetched $resource"
    fi
  done
}

getBackbone(){
  get js jquery underscore backbone
}

getBackboneFilter(){
  getBackbone
  get js backbone-route-filter
}

getAngularResource(){
  get js angular angular-resources
}

getHandlebarsHelpers(){
  get js handlebars handlebars_helpers
}

getGrips(){
  get js handlebars grips
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

