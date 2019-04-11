" remove toolbar in gvim
set guioptions -=T

" plugin manager, vim-plug
" initialization of existingplugins
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
" let g_gruvbox_termcolors = '16'
call plug#end()

" set colorscheme (gruvbox, find on github)
" make sure to have the dark part because otherwise it looks like shit
colorscheme gruvbox
set background=dark

" enable syntax processing
syntax enable

set tabstop=4       " number of visual spaces per tab
set softtabstop=4   " number of spaces in tab when editing (?)
set expandtab       " make all tabs insert spaces now

" ui configuration
set number       " show line numbers
set cursorline   " highlight current line
set wildmenu     " visual autocomplete in command menu
set lazyredraw   " reduce redraw rate, only do so when needed
set showmatch    " show matching parentheses and brackets
set nofoldenable " disable folding

" search configuration
set incsearch   " live searching as characters are entered
set hlsearch    " highlight matches when searching

" powerline config
" set rtp+=/lib/python3.7/site-packages/powerline/bindings/vim/
set laststatus=0 " show statusline
