syntax on

filetype plugin on

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd vimenter * NERDTree

:let mapleader = ','

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

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ervandew/supertab'
Bundle 'mattn/emmet-vim'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <Leader>\ :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

nmap <Leader>. :tabn<CR>
nmap <Leader>, :tabp<CR>
nmap <Leader>p :CtrlP<CR>
