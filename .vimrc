" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-fugitive'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'SirVer/ultisnips'
call vundle#end()

" ack-vim
let g:ackhighlight = 1
let g:ack_default_options = " -s -H --smart-case --follow"

" Colors
set background=dark
colorscheme atom-dark-256
syntax enable

" Editor Config
set ttyfast
set encoding=utf-8
set backspace=indent,eol,start
set ttimeout
set ttimeoutlen=100
set scrolloff=1
set autoread
set virtualedit+=onemore
set shortmess+=I " Hide intro menu
set splitbelow " New split goes below
set splitright " New split goes right
set hidden
set spelllang=en
let mapleader = ","

" Tabs and Spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
filetype plugin indent on

" UI Layout
set showcmd
set number
set laststatus=2
highlight StatusLine cterm=bold ctermfg=255 ctermbg=235
highlight StatusLineNC cterm=bold ctermfg=240 ctermbg=235
au InsertLeave * highlight StatusLine cterm=bold ctermfg=255 ctermbg=235
au InsertEnter * highlight StatusLine cterm=bold ctermfg=black ctermbg=65
set statusline=%*%t\ [%{strlen(&fenc)?&fenc:'none'},\ %{&ff}]\ %y%=\ %h%m%r%w\ %{fugitive#statusline()}\ [%l,%02c]\ [%L,%p%%]

" Searching
set ignorecase
set incsearch
set smartcase
set hlsearch

" Backup
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" Undo
if exists("+undofile")
	if isdirectory($HOME . '/.vim/undodir') == 0
		:silent !mkdir -p ~/.vim/undodir > /dev/null 2>&1
	endif
	set undodir=~/.vim/undodir//
	set undofile
	set undolevels=5000
	set undoreload=10000
endif

" Filetypes
augroup configgroup
  " When editing a file, always jump to the last known cursor position. Don't
  " do it for commit messages, when the position is invalid, or when inside an
  " event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  au BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md :call <SID>StripTrailingWhitespaces()
  " Set up comment styles
  autocmd FileType php setlocal commentstring=//\ %s
  autocmd FileType apache setlocal commentstring=#\ %s
  au Filetype gitcommit setlocal spell textwidth=72
  au BufNewFile,BufRead *.json set ft=javascript
  au BufNewFile,BufRead *.md set ft=markdown spell
  autocmd BufRead,BufNewFile *.blade.php set filetype=html
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Start insertmode in git commit messages
au FileType gitcommit startinsert

" Save file with sudo
cnoremap w!! w !sudo tee % >/dev/null

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep visual selection on indent
vnoremap < <gv
vnoremap > >gv

" emacs style key mappings for start/end of line
imap <C-a> <C-o>0
imap <C-e> <C-o>$
map <C-e> $
map <C-a> 0

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]

" Map Ctrl-J to insert line break (opposite of J)
nnoremap <NL> i<CR><ESC>

" Map ESC to jk
:imap jk <ESC>

" Remap Q to disable search highlighting
nnoremap Q :nohlsearch<CR>

" Hit CTRL Space to insert word under cursor in search
cmap <Nul> <C-R><C-W>

" Paste from clipboard in paste mode
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>

" Open CtrlP for buffers
nmap <silent> <Leader>b :CtrlPBuffer<CR>

" allows cursor change in tmux mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=1\x7"
endif

" Function called in augroup above
function! <SID>StripTrailingWhitespaces()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

