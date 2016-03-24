set incsearch
set nocompatible
set autoindent
" set spell
set complete+=kspell
if &t_Co > 1 || has("gui_running")
    syntax on
    set hlsearch
endif
filetype plugin indent on			    
