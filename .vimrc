" Options
syntax on
set mouse=a
set clipboard+=unnamedplus
set list listchars=tab:󰅂\ ,trail:-,nbsp:+
set showcmd
set ignorecase smartcase
set scrolloff=8 sidescrolloff=10
set splitbelow splitright
set number relativenumber
set tabstop=2 softtabstop=2 shiftwidth=2 smartindent
set breakindent breakindentopt=list:2,min:20,sbr
set smoothscroll
set nowrap linebreak
set path+=**
set wildmenu wildignore+=*/.git/*,*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*
set incsearch
set nohlsearch
set noswapfile
set nobackup
set undofile undodir=~/.config/vim/undodir
set hidden
set cm=blowfish2
set background=dark
set spelllang=en_us
set completeopt=menu,menuone,noinsert,noselect,popup
set termguicolors
set pumheight=10
set formatoptions=crnjq
set belloff=all
set foldenable foldlevelstart=1

let g:markdown_folding=1
let g:netrw_keepdir=0
let g:netrw_liststyle=3
let g:netrw_bufsettings='noma nomod nowrap ro nobl nu rnu'

colorscheme retrobox

" Mappings
let mapleader=" "
map Q <Nop>
nnoremap <leader>i <cmd>e $HOME/.vimrc<CR>
nnoremap <leader>e <cmd>Lexplore 30<CR>
nnoremap <leader>E <cmd>Lexplore %:h<CR>
nnoremap <C-Up> <cmd>resize +2<CR>
nnoremap <C-Down> <cmd>resize -2<CR>
nnoremap <C-Right> <cmd>vertical resize +2<CR>
nnoremap <C-Left> <cmd>vertical resize -2<CR>
nnoremap - <cmd>Ex<CR>
vnoremap < <gv
vnoremap > <gv
vnoremap P "_dP
nnoremap ]q <cmd>cnext<CR>
nnoremap [q <cmd>cprevious<CR>
nnoremap ]Q <cmd>clast<CR>
nnoremap [Q <cmd>crewind<CR>
nnoremap ]<C-q> <cmd>cnfile<CR>
nnoremap [<C-q> <cmd>cpfile<CR>
nnoremap ]l <cmd>lnext<CR>
nnoremap [l <cmd>lprevious<CR>
nnoremap ]L <cmd>llast<CR>
nnoremap [L <cmd>lrewind<CR>
nnoremap ]<C-l> <cmd>lnfile<CR>
nnoremap [<C-l> <cmd>lpfile<CR>
nnoremap ]t <cmd>tnext<CR>
nnoremap [t <cmd>tprevious<CR>
nnoremap ]T <cmd>tlast<CR>
nnoremap [T <cmd>trewind<CR>
nnoremap ]<C-t> <cmd>ptnext<CR>
nnoremap [<C-t> <cmd>ptprevious<CR>
nnoremap ]a <cmd>next<CR>
nnoremap [a <cmd>previous<CR>
nnoremap ]A <cmd>last<CR>
nnoremap [A <cmd>rewind<CR>
nnoremap ]b <cmd>bnext<CR>
nnoremap [b <cmd>bprevious<CR>
nnoremap ]b <cmd>blast<CR>
nnoremap [b <cmd>brewind<CR>
nnoremap ]<Space> ok
nnoremap [<Space> Oj
nnoremap <leader>bo <cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>
nnoremap <leader>bk <cmd>call delete(expand("%:p")) <bar> bdelete!<cr>
tnoremap <C-w> <C-\\><C-n><C-w>
nnoremap <leader>js :%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>jyf <cmd>let @+=@% <bar> echo "Filepath " . expand("%") . " copied"<cr>
nnoremap <leader>jp <cmd>set relativenumber! number! showmode! showcmd! hidden! ruler!<cr>
vnoremap <leader>jT :!tr -s ' ' \| column -t -s '\|' -o '\|'<cr>
nnoremap <leader>jo :<Up><Home>put=execute('<End>')<cr>

" Autocommands
augroup JobinGroup
  autocmd!
  autocmd filetype markdown :hi link markdownError Normal | setl wrap linebreak
  autocmd filetype netrw setl bufhidden=wipe
  "autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END

" Copy yank buffer to system clipboard
" Use OSC52 to put things into system clipboard, works over SSH!
function! Osc52yank()
  let buffer=system('base64 -w0', @0) " - w0 to disable 76 char line wrapping
  let buffer='\ePtmux;\e\e]52;c;'.buffer.'\x07\e\\'
  silent exe "!echo -ne ".shellescape(buffer)." > /dev/fd/2"
endfunction

nnoremap <leader>y :call Osc52Yank()<CR>
