```sh
#~/.vimrc
" use extended feature of vim (no compatible with vi)
set nocompatible

" specify character encoding
set encoding=utf-8

" specify file encoding
" to specify multiple entries, write them with comma separated
set fileencodings=utf-8

" specify file formats
set fileformats=unix,dos

" take backup
" opposite is [ set nobackup ]
set backup

" specify backup directory
set backupdir=~/backup

" number of search histories
set history=50

" ignore case when searching
set ignorecase

" distinct Capital if you mix it in search words
set smartcase

" highlights matched words
" opposite is [ set nohlsearch ]
set hlsearch

" use incremental search
" opposite is [ set noincsearch ]
set incsearch

" show line number
" opposite is [ set nonumber ]
set number

" visualize break ( $ ) or tab ( ^I )
set list

" highlights parentheses
set showmatch

" not insert LF at the end of file
set binary noeol

" enable auto indent
" opposite is [ noautoindent ]
set autoindent

" show color display
" opposite is [ syntax off ]
syntax on

" change colors for comments if it's set [ syntax on ]
highlight Comment ctermfg=LightCyan

" wrap lines
" opposite is [ set nowrap ]
set wrap

" Set backspace key behavior
" indent : erase indent with backspace
" eol : erase end of line with backspace
" start : erase beyond the start of the insert with backspace
set backspace=indent,eol,start
```
