"##### PREP and FORMATTING #####

set nocompatible              " be iMproved, required

syntax on
filetype plugin on
set ruler
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au BufReadPost *.hbs set syntax=html
au BufRead,BufNewFile *.html set wrap
au BufRead,BufNewFile *.rb,*.js set textwidth=80 colorcolumn=+1
au BufReadPost *.ccss set syntax=scss


set directory=$HOME/.vim/swapfiles
set omnifunc=htmlcomplete#CompleteTags
set number
set sw=2
set smartindent
set autoindent
set tabstop=2
set expandtab

" set textwidth=80
" set colorcolumn=+1
"set wrap
"set linebreak
"set nolist
"set formatoptions-=t

"##### Search and Orientation #####

set incsearch
set hlsearch
set ignorecase
set smartcase
noh

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

function! ToggleComment()
  " Set comment character based on filetype
  if &filetype ==? 'ruby'
    let commentChar = "#"
  elseif &filetype ==? 'vim'
    let commentChar = '"'
  elseif &filetype ==? 'javascript'
    let commentChar = '\/\/'
  endif
  let line = getline('.')
  let matcher = '^\s*'.eval('commentChar')
  let isComment = matchstr(line, matcher)

  if (empty(isComment))
    execute 's/\(^\s*\)/\1'.eval('commentChar').' '
  else
    let uncomment = '\(^\s*\)'.eval('commentChar').'\s\='
    execute 's/' . uncomment . '/\1/'
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
nnoremap <C-l> :call ToggleComment()<cr>

filetype off                  " required

"##### REMAPS #####
:let mapleader = ','

nmap <Leader>. :tabn<CR>
nmap <Leader>m :tabp<CR>
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
Bundle 'plasticboy/vim-markdown'
Bundle 'suan/vim-instant-markdown'
Bundle 'jaxbot/browserlink.vim.git'
Bundle 'tpope/vim-fugitive.git'

call vundle#end()            " required
filetype plugin indent on    " required

" NERD TREE
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1

" CTRLP
set wildignore+=*/node_modules/*,*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_show_hidden = 1 "show hidden files

