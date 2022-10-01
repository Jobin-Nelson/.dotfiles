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
set undodir=~/.config/vim/undodir
set undofile
set hidden
set cm=blowfish2

let mapleader=" "
map Q <Nop>

nnoremap <leader>so :source $HOME/.config/nvim/init.vim<CR>
nnoremap <leader>e :Lexplore<bar> :vertical resize 30<CR>
nnoremap <leader>+ :vertical resize +3<CR>
nnoremap <leader>- :vertical resize -3<CR>
nnoremap <C-P> :Telescope find_files<CR>

autocmd filetype python nnoremap <F5> :w <bar> !python %<CR>
autocmd filetype javascript nnoremap <F5> :w <bar> !node %<CR>

colorscheme elflord
