#!/bin/bash

####### Variables

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bash_profile .bashrd .pryrc .vimrc .zshrc .guard.rb .rspec .rspec-setup.rb"

##############

# Create dotfiles_old in homdir for backup
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

#change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homdir to dotfiles_old then create symlinks
for file in $files; do
  echo "Moving any existing dotfiles form ~ to $olddir"
  mv ~/$file ~/dotfiles_old/
  echo "Creating symlinks to $file in home directory"
  ln -s $dir/$file ~/$file
done
