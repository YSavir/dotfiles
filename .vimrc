"##### PREP and FORMATTING #####

set nocompatible              " be iMproved, required
set noswapfile

syntax on
filetype plugin on
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au BufReadPost *.hbs set syntax=html
au BufRead,BufNewFile *.html set wrap
au BufRead,BufNewFile *.rb,*.js set textwidth=80 colorcolumn=+1
au BufReadPost *.ccss set syntax=scss

" status line
set laststatus=2
set statusline=%f
set statusline+=\:
set statusline+=%l\,\%v


set directory=$HOME/.vim/swapfiles
set omnifunc=htmlcomplete#CompleteTags
set number
set sw=2
set smartindent
set autoindent
set tabstop=2
set expandtab
set backspace=2

"##### Search and Orientation #####

set incsearch
set hlsearch
set ignorecase
set smartcase
noh

set fdm=indent
set nofoldenable

function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
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
Bundle 'nathanaelkane/vim-indent-guides'

call vundle#end()            " required
filetype plugin indent on    " required

" NERD TREE
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1

"##### Autocomplete
set wildmode=longest,list
set wildmenu

" CTRLP
set wildignore+=*/node_modules/*,*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_show_hidden = 1 "show hidden files

set breakindent
