" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" keep a backup file
set history=80		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set foldmethod=indent
set novisualbell
set t_vb=
set hidden
set smartindent
set fo+=cr


set nu
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P 
set laststatus=2

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


"
"===============================================================================
"==========  load example vimrc from the distribution  =========================
"===============================================================================
"
runtime vimrc_example.vim
"
filetype plugin on
"
"===============================================================================
"==========  CUSTOMIZATION (vimrc)  ============================================
"===============================================================================
"
" Platform specific items:
" - central backup directory (has to be created)
" - default dictionary
" Uncomment your choice.  
if  has("win16") || has("win32")     || has("win64") || 
  \ has("win95") || has("win32unix") 
    "
"    runtime mswin.vim
"    set backupdir =$VIM\vimfiles\backupdir
"    set dictionary=$VIM\vimfiles\wordlists/german.list
else
"    set backupdir =$HOME/.vim.backupdir
"    set dictionary=$HOME/.vim/wordlists/german.list
endif
"
"-------------------------------------------------------------------------------
" Enable the use of the mouse for certain terminals.
"-------------------------------------------------------------------------------
if &term =~ "xterm"
  set mouse=a
endif
"
"-------------------------------------------------------------------------------
" Use of dictionaries
"-------------------------------------------------------------------------------
set complete=""
" Из текущего буфера
set complete+=.
" Из словаря
set complete+=k
" Из других открытых буферов
set complete+=b
" из тегов 
set complete+=t
"
"-------------------------------------------------------------------------------
" Various settings
"-------------------------------------------------------------------------------
"set autochdir             " change the current working directory
set autoread              " read open files again when changed outside Vim
set autowrite             " write a modified buffer on each :next , ...
set browsedir  =current   " which directory to use for the file browser
set incsearch             " use incremental search
set nowrap                " do not wrap lines
set shiftwidth =4         " number of spaces to use for each step of indent
set tabstop    =4         " number of spaces that a <Tab> in the file counts for
set visualbell            " visual bell instead of beeping
set softtabstop =4
"
"-------------------------------------------------------------------------------
"  some additional hot keys
"-------------------------------------------------------------------------------
"    F2   -  write file without confirmation
"    F3   -  call file explorer Ex
"    F4   -  show tag under curser in the preview window (tagfile must exist!)
"    F5   -  close error window
"    F6   -  (re)open error window
"    F7   -  display previous error
"    F8   -  display next error   
"-------------------------------------------------------------------------------
"map   <silent> <F2>    :write<CR>
"map   <silent> <F3>    :Explore<CR>
"nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
"map   <silent> <F5>    :cclose<CR>
"map   <silent> <F6>    :copen<CR>
"map   <silent> <F7>    :cp<CR>
"map   <silent> <F8>    :cn<CR>
"
"imap  <silent> <F2>    <Esc>:write<CR>
"nunmap  <Leader>ex    <Esc>:Explore<CR>
"imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
"imap  <silent> <F5>    <Esc>:cclose<CR>
"imap  <silent> <F6>    <Esc>:copen<CR>
"imap  <silent> <F7>    <Esc>:cp<CR>
"imap  <silent> <F8>    <Esc>:cn<CR>
"
"-------------------------------------------------------------------------------
" autocomplete parenthesis, brackets and braces
"-------------------------------------------------------------------------------
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
"
vnoremap ( s()<Esc>P<Right>
vnoremap [ s[]<Esc>P<Right>
vnoremap { s{}<Esc>P<Right>
"
"-------------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"-------------------------------------------------------------------------------
map  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
imap  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
"
"-------------------------------------------------------------------------------
" Leave the editor with Ctrl-q (KDE): Write all changed buffers and exit Vim
"-------------------------------------------------------------------------------
map  <C-q>    :wqa<CR>
"
"-------------------------------------------------------------------------------
" Filename completion
" 
"   wildmenu : command-line completion operates in an enhanced mode
" wildignore : A file that matches with one of these
"              patterns is ignored when completing file or directory names.
"-------------------------------------------------------------------------------
set wildmenu
set wildignore=*.bak,*.o,*.e,*~
"
"-------------------------------------------------------------------------------
" print options  (pc = percentage of the media size)
"-------------------------------------------------------------------------------
set printoptions=left:8pc,right:3pc

"-------------------------------------------------------------------------------
" taglist.vim : toggle the taglist window
" taglist.vim : define the title texts for Perl
"-------------------------------------------------------------------------------
"noremap <silent> <F11>  <Esc><Esc>:Tlist<CR>
"inoremap <silent> <F11>  <Esc><Esc>:Tlist<CR>

let tlist_perl_settings  = 'perl;c:constants;l:labels;p:package;s:subroutines;d:POD'

map <F2> :w<cr>
imap <F2> <esc>:w<cr>i
map <F3> :q!<cr>
imap <F3> <esc>:q!<cr>
map <F4> :wq<cr>
imap <F4> <esc>:wq<cr>
imap <F5> <esc>v
map <F5> y
imap <F6> <esc>v
map <F6> d
imap <F8> <esc>ddi
map <F8> dd
map <S-down> <S-v>
imap <S-down> <esc><S-v>
vmap <S-down> <down>
vmap < <gv
vmap > >gv


map <S-Insert> <MiddleMouse>
nmap ; :%s/\<<c-r>=expand("<cword>")<cr>\>/

"set wildmenu
"set wcm=<Tab>

source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F7> :emenu <C-Z>

set wildmenu
set cpo-=<
set wcm=<C-Z>
menu Encoding.Read.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.Read.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.Read.cp866 :e ++enc=cp866<CR>
menu Encoding.Read.utf-8 :e ++enc=utf8 <CR>
menu Encoding.Write.koi8-r :set fenc=koi8-r<CR>
menu Encoding.Write.windows-1251 :set fenc=cp1251<CR>
menu Encoding.Write.cp866 :set fenc=cp866<CR>
menu Encoding.Write.utf-8 :set fenc=utf8 <CR>
map <S-F7> :emenu Encoding.<C-Z>

" Автозавершение слов по tab =)
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
    else
    return "\<c-p>"
    endif
    endfunction
imap <tab> <c-r>=InsertTabWrapper()<cr>

" Настраиваем переключение раскладок клавиатуры по <C-^>
set keymap=russian-jcukenwin
" Раскладка по умолчанию - английская
set iminsert=0

" Переключение раскладок и индикация выбранной
" в данный момент раскладки.
" -->
" Переключение раскладок будет производиться по <C-F>
"
" При английской раскладке статусная строка текущего окна будет синего
" цвета, а при русской - зеленого.

function MyKeyMapHighlight()
if &iminsert == 0
hi StatusLine ctermfg=DarkBlue guifg=DarkBlue
else
hi StatusLine ctermfg=DarkGreen guifg=DarkGreen
endif
endfunction

" Вызываем функцию, чтобы она установила цвета при запуске Vim'a
call MyKeyMapHighlight()

" При изменении активного окна будет выполняться обновление
" индикации текущей раскладки
au WinEnter * :call MyKeyMapHighlight()

cmap <silent> <C-F> <C-^>
imap <silent> <C-F> <C-^>X<Esc>:call MyKeyMapHighlight()<CR>a<C-H>
nmap <silent> <C-F> a<C-^><Esc>:call MyKeyMapHighlight()<CR>
vmap <silent> <C-F> <Esc>a<C-^><Esc>:call MyKeyMapHighlight()<CR>gv
" <--
