"
" Archivo de configuración del editor VIM (er mejo!)
"
" ~/.vimrc      -> linux $VIM/.vimrc    -> win
"
" Electro7 - Version 3.4 - 25 Feb 2024 
"==============================================================================

"
" Compability {{{
" -----------------------------------------------------------------------------
"
set nocompatible        " use vim defaults instead of vi
set encoding=utf-8      " always encode in utf

" Settings {{{
" -----------------------------------------------------------------------------

" General
set backspace=2                     " enable <BS> for everything
set number                          " Show line numbers
set completeopt=longest,menuone     " Autocompletion options
set complete=.,w,b,u,t,i,d          " autocomplete options (:help 'complete')
set hidden                          " hide when switching buffers, don't unload
set laststatus=2                    " always show status line
set lazyredraw                      " don't update screen when executing macros
set noshowmode                      " don't show mode, since I'm already using airline
set nowrap                          " disable word wrap
set showbreak="+++ "                " String to show with wrap lines
set nonumber                        " show line numbers
set showcmd                         " show command on last line of screen
set showmatch                       " show bracket matches
set textwidth=0                     " don't break lines after some maximum width
set ttyfast                         " increase chars sent to screen for redrawing
"set ttyscroll=3                    " limit lines to scroll to speed up display
set title                           " use filename in window title
set wildmenu                        " enhanced cmd line completion
set wildchar=<TAB>                  " key for line completion
set noerrorbells                    " no error sound
set splitright                      " Split new buffer at right

" Tabs
set autoindent                      " copy indent from previous line
set noexpandtab                     " no replace tabs with spaces
set shiftwidth=4                    " spaces for autoindenting
set smarttab                        " <BS> removes shiftwidth worth of spaces
set softtabstop=4                   " spaces for editing, e.g. <Tab> or <BS>
set tabstop=4                       " spaces for <Tab>

" Searches
set hlsearch                        " highlight search results
set incsearch                       " search whilst typing
set ignorecase                      " case insensitive searching
set smartcase                       " override ignorecase if upper case typed
set more                            " Stop in list

" Status bar -> Replace with vim-airplane plugin
set laststatus=2                    " show ever
set showmode                        " show mode
set showcmd                         " show cmd
set ruler                           " show cursor line number
set shm=atI                         " cut large messages

" Modelines -> set commands in file comments
set modeline
set modelines=5

"}}}
" Mappings {{{
" -----------------------------------------------------------------------------

" Fixes linux console keys
" "od -a" and get the code
" "^[" is <ESC> at vim
map <ESC>Ob <C-Down>
map <ESC>Oc <C-Right>
map <ESC>Od <C-Left>
map <ESC>Oa <C-Up>
map <C-@> <C-Space>
map! <ESC>Ob <C-Down>
map!<ESC>Oc <C-Right>
map! <ESC>Od <C-Left>
map! <ESC>Oa <C-Up>
map! <C-@> <C-Space>

"}}}
" Abreviations {{{
" -----------------------------------------------------------------------------

" Time
iab _datetime <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
iab _time <C-R>=strftime("%H:%M")<CR>
iab _date <C-R>=strftime("%d %b %Y")<CR>

" Personal
iab _name Vicente Gimeno Morales - Electro7
iab _mail vgimeno@grupocener.com


" HOME
iab _home ~/

"}}}

" vim: et tabstop=4 shiftwidth=4 softtabstop=4
