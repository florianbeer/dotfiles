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
if v:version >= 704
  Plugin 'SirVer/ultisnips'
endif
call vundle#end()

" ack-vim
let g:ackhighlight = 1
let g:ack_default_options = " -s -H --smart-case --follow"

" Colors
set background=dark
colorscheme atom-dark-256
syntax enable
highlight lineNr ctermbg=bg
hi vertsplit ctermbg=bg ctermfg=bg

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
set noshowmode
set hidden
set spelllang=en
let mapleader = "\<space>"

" Tabs and Spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
filetype plugin indent on

" UI Layout
" set showcmd
set number
set laststatus=2
highlight StatusLine cterm=bold ctermfg=255 ctermbg=235
highlight StatusLineNC cterm=bold ctermfg=240 ctermbg=235
au InsertLeave * highlight StatusLine cterm=bold ctermfg=255 ctermbg=235
au InsertEnter * highlight StatusLine cterm=bold ctermfg=16 ctermbg=24
set statusline=%*%t\ \ %h%m%r%w%=\ %{fugitive#statusline()}\ %c\|%02l\ %p%%\ %L

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
  autocmd!
  " When editing a file, always jump to the last known cursor position. Don't
  " do it for commit messages, when the position is invalid, or when inside an
  " event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  au BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java :call <SID>StripTrailingWhitespaces()
  " Set up comment styles
  autocmd FileType php setlocal commentstring=//\ %s
  autocmd FileType apache setlocal commentstring=#\ %s
  au Filetype gitcommit setlocal spell textwidth=72
  au BufNewFile,BufRead *.json set ft=javascript
  au BufNewFile,BufRead *.md set ft=markdown spell
  autocmd BufRead,BufNewFile *.blade.php set filetype=html
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Activate syntax completion
set omnifunc=syntaxcomplete#Complete

" Improve completion menu
set completeopt=longest,menuone

" <ENTER> inserts current completion selection
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" keep menu item always highlighted in completion
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <C-p> pumvisible() ? '<C-p>' :
  \ '<C-p><C-r>=pumvisible() ? "\<lt>Up>" : ""<CR>'

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
nnoremap <silent>Q :nohlsearch<CR>

" Paste from clipboard in paste mode
map <silent><Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>

" TAB and S-TAB to switch buffers
nnoremap <silent><TAB> :bp<CR>
nnoremap <silent><S-TAB> :bn<CR>

" Open CtrlP for buffers and MRU
nmap <silent> <Leader>b :CtrlPBuffer<CR>
nmap <silent> <Leader>m :CtrlPMRU<CR>

" Dont search here with CtrlP
set wildignore+=*/vendor/**,node_modules
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Show hidden files/dirs in CtrlP
let g:ctrlp_show_hidden = 1

" Show current file in CtrlP
let g:ctrlp_match_current_file = 1

" Unclutter CtrlP item listing
let g:ctrlp_line_prefix = '' 

" Function called in augroup above
function! <SID>StripTrailingWhitespaces()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

" Prettyprint for JSON, HTML & XML
command! PrettyPrintJSON %!python -m json.tool
command! PrettyPrintHTML !tidy -mi -html -wrap 0 %
command! PrettyPrintXML !tidy -mi -xml -wrap 0 %

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
