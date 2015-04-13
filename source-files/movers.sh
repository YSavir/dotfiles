goCode(){
  cd ~/Documents/coding/
  for var in $@; do
    cd $(breadth_find $var)
  done
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

