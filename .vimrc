" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ General Config ====================

set title                       "Allow vim to set the terminal title
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set spell                       "Enable spell checking
set hlsearch                    "Highlight all search results
set incsearch                   "Start searching when you type
set mouse=a                     "Better mouse scrolling
set cursorline

hi SpellBad cterm=underline ctermbg=none
hi CursorLine cterm=none ctermbg=black

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

"move between splits more easily
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ================ Turn Off Swap Files ==============

set nobackup
set nowb
set noswapfile

" ================ Indentation ======================

set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

filetype plugin on
filetype indent on

set wrap                        "Wrap lines
set linebreak                   "Wrap lines at convenient points

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=3              "Start scrolling when we're 8 lines away from margins
"set sidescrolloff=15
"set sidescroll=1

filetype plugin indent on    " use the file type plugins

" ================= Syntastic =======================
"mark syntax errors with :signs
let g:syntastic_enable_signs=1
"automatically jump to the error when saving the file
let g:syntastic_auto_jump=0
"show the error list automatically
let g:syntastic_auto_loc_list=1
"don't care about warnings
let g:syntastic_quiet_warnings=0

" ====== Make tabs be addressable via Apple+1 or 2 or 3, etc
" Use numbers to pick the tab you want (like iTerm)
map <silent> <D-1> :tabn 1<cr>
map <silent> <D-2> :tabn 2<cr>
map <silent> <D-3> :tabn 3<cr>
map <silent> <D-4> :tabn 4<cr>
map <silent> <D-5> :tabn 5<cr>
map <silent> <D-6> :tabn 6<cr>
map <silent> <D-7> :tabn 7<cr>
map <silent> <D-8> :tabn 8<cr>
map <silent> <D-9> :tabn 9<cr>

" ===== Add some shortcuts for ctags ================
"map <Leader>tt <esc>:TagbarToggle<cr>
" TODO: get open tag in new tab working
" http://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks
"map <C-\>:tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"map <A-]>:vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" ===== Support for github flavored markdown ========
" via https://github.com/jtratner/vim-flavored-markdown
" with .md extensions
augroup markdown
	au!
	au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" ===== File browser (netrw) ========================
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

fun! VexToggle(dir)
	if exists("t:vex_buf_nr")
		call VexClose()
	else
		call VexOpen(a:dir)
	endif
endf

fun! VexOpen(dir)
	let g:netrw_browse_split=4
	let vex_width = 25

	exec "Vex " . a:dir
	let t:vex_buf_nr = bufnr("%")
	wincmd H

	call VexSize(vex_width)
endf

fun! VexClose()
	let cur_win_nr = winnr()
	let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

	1wincmd w
	close
	unlet t:vex_buf_nr

	exec (target_nr - 1) . "wincmd w"
	call NormalizeWidths()
endf

fun! VexSize(vex_width)
	exec "vertical resize" . a:vex_width
	set winfixwidth
	call NormalizeWidths()
endf

fun! NormalizeWidths()
	let eadir_pref = &eadirection
	set eadirection=hor
	set equalalways! equalalways!
	let &eadirection = eadir_pref
endf

augroup NetrwGroup
	autocmd! BufEnter * call NormalizeWidths()
augroup END

noremap <silent> <C-F> :call VexToggle(getcwd())<CR>
