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
set background=dark
set spelllang=en_us

let mapleader=" "
map Q <Nop>

nnoremap <leader>so :source $HOME/.vimrc<CR>
nnoremap <leader>i :e $HOME/.vimrc<CR>
nnoremap <leader>e :Lexplore 30<CR>
nnoremap <leader>E :Lexplore %:h<CR>
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap - :Ex<CR>

autocmd filetype python nnoremap <F5> :update <bar> !python %<CR>
autocmd filetype javascript nnoremap <F5> :update <bar> !node %<CR>
autocmd filetype go nnoremap <F5> :update <bar> !go run %<CR>
autocmd filetype markdown :hi link markdownError Normal
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>

" Copy yank buffer to system clipboard
" Use OSC52 to put things into system clipboard, works over SSH!
function! Osc52yank()
  let buffer=system('base64 -w0', @0) " - w0 to disable 76 char line wrapping
  let buffer='\ePtmux;\e\e]52;c;'.buffer.'\x07\e\\'
  silent exe "!echo -ne ".shellescape(buffer)." > /dev/fd/2"
endfunction

nnoremap <leader>y :call Osc52Yank()<CR>

" colorscheme habamax
