execute pathogen#infect()

set autoread
if !has('nvim')
  set encoding=utf-8
endif
set scrolloff=6
set rnu
set wrap
set number
set linebreak
set nolist  " list disables linebreak
let g:pymode_lint_checkers=['pyflakes', 'pep8']
let g:pymode_options_max_line_length = 79
let g:EasyGrepFilesToExclude = '*.swp,*~,*.pyc'

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  if !has('nvim')
    set ttymouse=sgr
  endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set backupdir=~/.config/nvim/tmp,~/.vim/tmp,.
set directory=~/.config/nvim/tmp,~/.vim/tmp,.

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" from https://github.com/spf13/spf13-vim/blob/master/.vimrc
if has('statusline')
	set laststatus=2
	" Broken down into easily includeable segments
	set statusline=%<%f\    " Filename
	set statusline+=%w%h%m%r " Options
	set statusline+=%{fugitive#statusline()} "  Git Hotness
	set statusline+=%#warningmsg#
	set statusline+=%*
	let g:syntastic_enable_signs=1
	set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

autocmd FileType javascript autocmd BufWritePre <buffer> :%s/\s\+$//e

au BufEnter new-commit setlocal filetype=gitcommit
" au CursorHoldI * stopinser
" au InsertEnter * let updaterestore=&updatetime | set updatetime=5000
" au InsertLeave * let &updatetime=updaterestore
" au FocusLost * stopinser

let g:pymode_rope = 0
command! Gsu Git submodule update
command! Gpr Git pull --rebase
command! Grc Git rebase --continue
command! -nargs=+ Gcheckout execute 'silent Git checkout <args>'
command! Gcm Gcheckout master

function! UseClosureStyle()
	setlocal tabstop=2
	setlocal softtabstop=2
	setlocal shiftwidth=2
	setlocal expandtab
	" add a visual guide line at the 80th column
	setlocal textwidth=80
	setlocal colorcolumn=81
	hi ColorColumn guibg=lightgrey ctermbg=red
	" tell syntastic to use gjslint for checking JavaScript's syntax
	let b:syntastic_javascript_checkers = [ 'gjslint' ]
endfunction

set tabstop=2
set shiftwidth=2
set expandtab

au FileType javascript call UseClosureStyle()

au TabLeave * let t:wd=getcwd()
au TabEnter * if exists('t:wd') | exe "cd" t:wd | endif

nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>

let g:EasyGrepSearchCurrentBufferDir=0
let g:EasyGrepRecursive=1

nnoremap # *
nnoremap * #
colo materialbox
set bg=dark

autocmd! CursorMoved,CursorMovedI *.md if getline(".") =~# "^\s*\|" | setlocal tw=0 | else | setlocal tw=80 | endif
autocmd! BufEnter **/en_US/**/*.md silent! setlocal spell spelllang=en_US
autocmd! BufEnter **/fr_CA/**/*.md silent! setlocal spell spelllang=fr_CA

" Unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

if has('nvim')
  command! -nargs=+ Arc exe '-tabe term://.//arc\ '.fnameescape('<args>') <bar> startinsert
endif

" let g:ycm_auto_trigger=0

cmap w!! w !sudo tee >/dev/null %
map Y y$

set wildignore=*.pyc
set termguicolors
