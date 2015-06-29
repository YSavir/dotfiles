#!/bin/bash

####### Variables

dir=~/dotfiles
olddir=~/dotfiles_old

# Create dotfiles_old in homdir for backup
if [ ! -d $olddir ]; then
  echo "Creating $olddir for backup of any existing dotfiles in ~"
  mkdir -p $olddir
fi

# find all hidden files in $dir
dotFiles=$(find $dir -name '.*'  -maxdepth 1 -type f)

# move any existing dotfiles in homdir to dotfiles_old then create symlinks
for file in $dotFiles; do
  fileName=$(basename $file)
  
  # backup old file if exists
  if [ -f ~/$fileName ]; then
    # and remove old backup if exists
    if [ -f $olddir/$fileName ]; then
      rm $olddir/$fileName
    fi

    echo -n "backing up and "
    mv -f ~/$fileName $olddir
  fi

  echo "creating symlink for $fileName"
  ln -s $dir/$fileName ~/$fileName
done

