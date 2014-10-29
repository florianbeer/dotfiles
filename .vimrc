" Colors
colorscheme twilight256
set background=dark
syntax enable

" Editor Config
set ttyfast
set encoding=utf-8
set backspace=indent,eol,start
set ttimeout
set ttimeoutlen=100
set scrolloff=1
set autoread

" Tabs and Spaces
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
set smarttab
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

" Filetypes
augroup configgroup
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
  autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md :call <SID>StripTrailingWhitespaces()
  autocmd Filetype gitcommit setlocal spell textwidth=72
  autocmd BufNewFile,BufRead *.json set ft=javascript
  autocmd BufNewFile,BufRead *.md set ft=markdown spell
augroup END

" Save file with sudo
cnoremap w!! w !sudo tee % >/dev/null

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

" allows cursor change in tmux mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
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
