set incsearch
set nocompatible
set autoindent
" -- Spelling
" + you can force spelling manually: set spell; set nospell
" + to choose correction use:  z=
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell " spelling only for git commit messages
set complete+=kspell
if &t_Co > 1 || has("gui_running")
    syntax on
    set hlsearch
endif
filetype plugin indent on			    
