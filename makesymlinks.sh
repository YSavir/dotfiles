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

# Symlink claude config into ~/.claude/.
# - Top-level files (e.g. CLAUDE.md) become file symlinks in ~/.claude/.
# - Subdirectories are walked recursively; each leaf file becomes an individual
#   symlink so ~/.claude/<subdir>/ can hold both managed (symlinked) and
#   unmanaged files side by side. Intermediate directories are created as plain
#   dirs, not symlinks.
claudeDir=~/dotfiles/claude
mkdir -p ~/.claude

symlinkClaudeFile() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -f "$target" ] && [ ! -L "$target" ]; then
    local backupName="claude_${label//\//_}"
    echo -n "backing up and "
    mv -f "$target" "$olddir/$backupName"
  fi

  echo "creating symlink for .claude/$label"
  ln -sf "$source" "$target"
}

symlinkClaudeTree() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -d "$source" ]; then
    mkdir -p "$target"
    for sub in "$source"/*; do
      [ -e "$sub" ] || continue
      local subName
      subName=$(basename "$sub")
      symlinkClaudeTree "$sub" "$target/$subName" "$label/$subName"
    done
  else
    symlinkClaudeFile "$source" "$target" "$label"
  fi
}

for entry in "$claudeDir"/*; do
  entryName=$(basename "$entry")
  symlinkClaudeTree "$entry" ~/.claude/"$entryName" "$entryName"
done

