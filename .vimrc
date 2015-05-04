"##### PREP and FORMATTING #####
syntax on
filetype plugin on
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au BufReadPost *.hbs set syntax=html

set directory=$HOME/.vim/swapfiles
set omnifunc=htmlcomplete#CompleteTags
set number
set sw=2
set smartindent
set autoindent
set tabstop=2
set expandtab
set nocompatible              " be iMproved, required
set mouse=a

filetype off                  " required

"##### REMAPS #####
:let mapleader = ','

nmap <Leader>. :tabn<CR>
nmap <Leader>, :tabp<CR>
map <Leader>p :CtrlP<CR>
nmap <Leader>\ :NERDTreeToggle<CR>

" VUNDLER and PLUGINS
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ervandew/supertab'
Bundle 'mattn/emmet-vim'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'pangloss/vim-javascript'

call vundle#end()            " required
filetype plugin indent on    " required

" NERD TREE
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1
