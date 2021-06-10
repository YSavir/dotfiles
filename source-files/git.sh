parse_git_branch(){ 
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
 }

alias g='git status'
alias gComm='git commit -m'
alias gAdd='git add -A'
alias gBranch='git checkout -b'
alias gp='git push'
alias prettyGraph='git log --oneline --graph --all --decorate --abbrev-commit'

gSave(){
  git stash save $*
}

gApply(){
  git stash apply stash^{/$*};
}

gShow(){
  git stash show stash^{/$*}; 
}

gChangedFiles() {
  git diff $1 $2 --name-only
}
