source $VIMRUNTIME/defaults.vim
""""""""""""""
"""-OPTIONS"""""""
""""""""""""""
set relativenumber
set number
set cursorline
set splitbelow
set splitright
set ignorecase
set smartcase
set nowrap
set hlsearch
set history=2000
set scrolloff=10
set hidden
set ttimeoutlen=150
set sidescrolloff=10
set sidescroll=6
set startofline
set linebreak
set colorcolumn=80
"tabs are 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" mapping related stuff
let mapleader=" "   

""""""""""""""
"""-KEYMAPS"""""""
""""""""""""""
" leader key defined above under options
" automatically reselect after indenting
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>p "+p
nnoremap yp "0p
inoremap jj <Esc>
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>
