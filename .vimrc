" Setting up Vundle
let VundleInstalled=1
let vundle_readme=expand($HOME.'/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme) 
		echo "Installing Vundle ..."
		echo ""
		silent !mkdir -p $HOME/.vim/bundle
		silent !git clone https://github.com/VundleVim/Vundle.vim $HOME/.vim/bundle/Vundle.vim
		let VundleInstalled=0
endif
set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tobyS/pdv'
Plugin 'tobyS/vmustache'
Plugin 'editorconfig/editorconfig-vim'
if v:version >= 704
  Plugin 'SirVer/ultisnips'
endif
if VundleInstalled == 0
  echo "Installing Plugins, please ignore key map error messages"
  echo ""
  :PluginInstall
endif
call vundle#end()

" Colors
syntax enable
set background=dark
colorscheme atom-dark-256
highlight lineNr ctermbg=bg
highlight vertsplit ctermbg=bg ctermfg=bg
highlight StatusLine cterm=bold ctermfg=255 ctermbg=235
highlight StatusLineNC cterm=bold ctermfg=240 ctermbg=235
au InsertEnter * highlight StatusLine cterm=bold ctermfg=16 ctermbg=24
au InsertLeave * highlight StatusLine cterm=bold ctermfg=255 ctermbg=235

" Editor Config
set hidden
set number
set ttyfast
set autoread
set ttimeout
set noshowmode
set splitbelow
set splitright
set scrolloff=3
set laststatus=2
set nojoinspaces
set shortmess+=I
set spelllang=en
set encoding=utf-8
set ttimeoutlen=100
set formatoptions+=j
set virtualedit+=onemore
set backspace=indent,eol,start
set statusline=%*%t\ \ %h%m%r%w%=\ %{fugitive#statusline()}\ %c\|%02l\ %p%%\ %L

" Tabs and Spaces
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
filetype plugin indent on

" Searching
set hlsearch
set incsearch
set smartcase
set ignorecase

" Backup
set backup
set writebackup
set backupskip=/tmp/*,/private/tmp/*
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Undo
if exists("+undofile")
	if isdirectory($HOME . '/.vim/undodir') == 0
		:silent !mkdir -p ~/.vim/undodir > /dev/null 2>&1
	endif
	set undofile
	set undolevels=5000
	set undoreload=10000
  set undodir=~/.vim/undodir//
endif

" Settigs for certain filetypes
augroup configgroup
  autocmd!
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  au BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java :call <SID>StripTrailingWhitespaces()
  au FileType php setlocal commentstring=//\ %s
  au FileType apache setlocal commentstring=#\ %s
  au FileType css,scss,sass setlocal iskeyword+=-
  au FileType gitcommit startinsert
  au Filetype gitcommit setlocal spell textwidth=72
  au BufNewFile,BufRead *.json set ft=javascript
  au BufNewFile,BufRead *.md set ft=markdown spell
  au BufRead,BufNewFile *.blade.php set filetype=html
  au BufWritePost .vimrc source %
augroup END

" ack-vim
let g:ackhighlight = 1
let g:ack_default_options = " -s --with-filename"

" Set space as leader key
let mapleader = "\<space>"

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

" Save file with sudo
cnoremap w!! w !sudo tee % >/dev/null

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Keep visual selection on indent
vnoremap < <gv
vnoremap > >gv

" emacs style key mappings for start/end of line
imap <C-a> <C-o>^
imap <C-e> <C-o>$
map <C-a> ^
map <C-e> $

" highlight last inserted text
nnoremap gV `[v`]

" Map Ctrl-J to insert line break (opposite of J)
nnoremap <NL> i<CR><ESC>

" Map ESC to jk
:imap jk <ESC>

" Remap Q to disable search highlighting
nnoremap <silent>Q :nohlsearch<CR>

" Toggle line numbering
nnoremap <silent> <Leader>n :silent set number!<CR>

" Copy to system clipboard
map <leader>c "*y

" Paste from system clipboard
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

" Always show current file in CtrlP
let g:ctrlp_match_current_file = 1

" Unclutter CtrlP item listing
let g:ctrlp_line_prefix = '' 

" Function to strip trailing whitespace
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

" See difference between current buffer changes you made
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Make 'gf' useful in PHP files on class names
set includeexpr=substitute(v:fname,'\\\','/','g')                                                                                                    
set suffixesadd+=.php
set path+=$PWD/vendor/**
set path+=$PWD/app/**

" super quick search and replace
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand("<cword>")<CR>\>/

" page facing view: side-by-side view of same buffer scrollbound
nnoremap <leader>vs :<C-u>let @z=&so<cr>:set so=0 noscb<cr>:bo vs<cr>Ljzt:setl scb<cr><C-w>p:setl scb<cr>:let &so=@z<cr>

" Ultisnips / PHP Documentor
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <leader>d :call pdv#DocumentWithSnip()<CR>
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
