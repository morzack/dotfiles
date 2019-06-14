call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'plasticboy/vim-markdown'
Plug 'jlanzarotta/colorschemeexplorer'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
call plug#end()

filetype plugin indent on

set encoding=UTF-8

syntax on

colorscheme clarity

syntax enable

set tabstop=4
set softtabstop=4
set expandtab

set number
set wildmenu
set lazyredraw
set showmatch
set nofoldenable

set incsearch
set hlsearch

set laststatus=0

set smartcase

inoremap kj <Esc>

autocmd FileType markdown set spell spelllang=en_us

let g:airline_theme='minimalist'
let g:airline_powerline_fonts=1

set conceallevel=2

let g:vim_markdown_math = 1
