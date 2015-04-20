go(){
  cd ~/
  for var in $@; do
    cd $(breadth_find $var)
  done
}

