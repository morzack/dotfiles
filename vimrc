inoremap kj <Esc>
nnoremap ow :w<Cr>
nnoremap mb :make build<Cr>
nnoremap me :cwindow<Cr>
nnoremap mr :make run<Cr>
set rnu
set nu

syntax on
filetype on
filetype plugin on
filetype indent on

set expandtab
set tabstop=4
set shiftwidth=4

set nobackup

set wrap

set incsearch

set ignorecase
set smartcase

set showmode
set showmatch
set hlsearch

set nofoldenable

call plug#begin()

Plug 'dylanaraps/wal.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdtree'

Plug 'airblade/vim-gitgutter'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

silent! colorscheme wal

" c-g filetree
nnoremap <C-g> :NERDTreeFocus<CR>

" c-p file search
nnoremap <C-p> :Files<CR>

" c-b buffer search
nnoremap <C-b> :Buffers<CR>

" c-pj all line search
nnoremap <C-p>j :RG<CR>

" c-f lines in current buffer
nnoremap <C-f> :BLines<CR>

" c-fj lines in all buffers
nnoremap <C-f>j :Lines<CR>

" changes to make coq happy
set nobackup
set nowritebackup

set updatetime=300 " ms
set signcolumn=yes

" set tab complete with enter
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
" nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
" nmap <silent><nowait> gr <Plug>(coc-references)

set noemoji
