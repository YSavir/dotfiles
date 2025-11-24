"##### PREP and FORMATTING #####

set nocompatible              " be iMproved, required
set noswapfile

set autoread

" prevent vim from automatically adding newlines to ends of files
:set nofixeol
:set nofixendofline

" let automatic regex engine be detected
" the default new engine is slow with react
set re=0

syntax on
filetype plugin on
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.jbuilder set filetype=ruby
au BufReadPost *.hbs set syntax=html
au BufRead,BufNewFile *.html set wrap
au BufRead,BufNewFile *.rb,*.js setlocal colorcolumn=80
au BufReadPost *.ccss set syntax=scss

" status line
set laststatus=2
set statusline=%f
set statusline+=\:
set statusline+=%l\,\%v
" status line color based on input mode
au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse

" highlight current line
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

let &t_SI="\033[4 q" " start insert mode
let &t_EI="\033[2 q" " end insert mode

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

function! CursorLineToggle()
  if(&cursorline == 1)
    set nocursorline
  else
    set cursorline
  endif
endfunc

function! ToggleComment()
  " Set comment character based on filetype
  if &filetype ==? 'ruby' || &filetype ==? 'sh'
    let commentChar = "#"
  elseif &filetype ==? 'vim'
    let commentChar = '"'
  elseif &filetype ==? 'javascript'
    let commentChar = '\/\/'
  elseif &filetype ==? 'css' || &filetype ==? 'scss'
    let commentChar = '\/\/'
  elseif &filetype ==? 'vue' || &filetype ==? 'vue'
    let commentChar = '\/\/'
  else
    let commentChar = ''
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

" Vim-Plug and Plugins
call plug#begin()

Plug 'posva/vim-vue'
Plug 'yssl/QFEnter'
Plug 'cakebaker/scss-syntax.vim'
Plug 'ervandew/supertab'
Plug 'mattn/emmet-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'suan/vim-instant-markdown'
Plug 'godlygeek/tabular'
Plug 'mhinz/vim-grepper'
Plug 'jparise/vim-graphql'

call plug#end()            " required
filetype plugin indent on  " required

"##### Autocomplete
set wildmode=longest,list
set wildmenu

" CTRLP
set wildignore+=*/node_modules/*,*/doc/*,*/tmp/*,*.so,*.swp,*.zip,*/public/packs-test/*,*/.git/*
let g:ctrlp_show_hidden = 1 "show hidden files

if executable('ag')
  let g:ctrlp_user_command = 'ag %s -U -l --nocolor --hidden -g ""'
endif

" QFEnter
" open quickfix links in new tab
let g:qfenter_keymap = {}
let g:qfenter_keymap.topen = ['<C-t>']

" Vim-Grepper
let g:grepper = {}
let g:grepper.tools = ['ag']

nmap gs <plug>(GrepperOperator)

set breakindent

" Tabular
vmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t, :Tabularize /,\zs/l0l1<CR>
vmap <Leader>tf, :Tabularize /^[^,]*,\zs<CR>
vmap <Leader>ti :Tabularize /from<CR>

vmap <Leader>t[ :Tabularize /{/l1l1<CR>
vmap <Leader>t] :Tabularize /}/l1l0<CR>

vmap <Leader>t; :Tabularize /:\zs/l0l1<CR>
vmap <Leader>tf; :Tabularize /^[^:]*:\zs/l0l1<CR>
vmap <Leader>ta; :Tabularize /[\w]*:\zs/l0l1<CR>

vmap <Leader>t{ :Tabularize /{/l1l1<CR>
vmap <Leader>t} :Tabularize /}/l1l0<CR>
