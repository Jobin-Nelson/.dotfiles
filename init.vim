syntax on 
set mouse=a
set clipboard=unnamedplus
set showcmd
set ignorecase
set smartcase
set sidescrolloff=10
set scrolloff=8
set splitbelow splitright
set number relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set nowrap
set path+=**
set wildmenu
set wildignore+=**/venv/**
set incsearch
set nohlsearch
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set hidden

let mapleader=" "
map Q <Nop>

nnoremap <leader>so :source $HOME/.config/nvim/init.vim<CR>
nnoremap <leader>e :Lexplore<bar> :vertical resize 30<CR>
nnoremap <leader>+ :vertical resize +3<CR>
nnoremap <leader>- :vertical resize -3<CR>
nnoremap <C-P> :Telescope find_files<CR>

autocmd filetype python nnoremap <F5> :w <bar> !python %<CR>
autocmd filetype javascript nnoremap <F5> :w <bar> !node %<CR>

" Plugins
call plug#begin('~/.config/nvim/plugged')
" Plug 'sainnhe/gruvbox-material'
" Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-surround'
call plug#end()

" Colors
let g:material_terminal_italics=1
colorscheme material

