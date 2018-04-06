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

hi SpellBad     cterm=underline ctermfg=darkred ctermbg=none
hi CursorLineNr                 ctermfg=yellow
hi CursorLine   cterm=none      ctermfg=none    ctermbg=black
hi MatchParen   cterm=reverse   ctermfg=none    ctermbg=none
hi Search       cterm=standout  ctermfg=none    ctermbg=none

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

set scrolloff=3              "Start scrolling when we're 3 lines away from margins
"set sidescrolloff=15
"set sidescroll=1

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
let g:netrw_liststyle = 3
let g:netrw_altv = 1
noremap <silent> <C-F> :Lex<CR>

" ===== Autocomplete ================================
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" ==== Toggle Comments ==============================
autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
autocmd FileType sh,ruby,python   let b:comment_leader = '#'
autocmd FileType conf,fstab       let b:comment_leader = '#'
autocmd FileType tex              let b:comment_leader = '%'
autocmd FileType mail             let b:comment_leader = '>'
autocmd FileType vim              let b:comment_leader = '"'
fun! CommentToggle()
	execute ':silent! s/\([^ ]\)/' . b:comment_leader . ' \1/'
	execute ':silent! s/^\( *\)' . b:comment_leader . ' \?' . b:comment_leader . ' \?/\1/'
endf
map <C-r> :call CommentToggle()<CR>

" ==== Create a Header ==============================
fun! Header(word, ...)
	"assume other filetypes have been set above (Toggle Comments)
	let a:sym = b:comment_leader[0] "symbol to start and end header lines
	let a:symbol = get(a:, 1, '*')  "symbol to fill header lines
	let a:width = 80 - (2 * strlen(a:sym))
	let a:inserted_word = ' ' . a:word . ' ' 
	let a:word_width = strlen(a:inserted_word)
	let a:length_before = (a:width - a:word_width) / 2 
	let a:hashes_before = repeat(a:symbol, a:length_before)
	let a:hashes_after = repeat(a:symbol, a:width - (a:word_width + a:length_before))
	let a:hash_line = repeat(a:symbol, a:width)
	let a:word_line = a:hashes_before . a:inserted_word . a:hashes_after

	:put =a:sym . a:hash_line . a:sym
	:put =a:sym . a:word_line . a:sym
	:put =a:sym . a:hash_line . a:sym
endf
command! -nargs=+ Header call Header(<f-args>)
