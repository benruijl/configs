filetype plugin indent on
set nu
let g:EnhCommentifyUseAltKeys="yes"
let g:EnhCommentifyPretty="yes"
set pastetoggle=<F11>
map <F9>	:make<CR>
nmap <CR>       :nohlsearch<CR>
imap <C-V>      <ESC>"+pi
vmap <C-C>      "+y
map <F3> :w !detex \| wc -w<CR>
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'pdf'

" VIM extensions, not very VI compatible;
" this setting must be set because when vim
" finds a .vimrc on startup, it will set
" itself as "compatible" with vi
set nocompatible
set background=dark
set autochdir
set fileformats=unix,dos,mac
set hidden " you can change buffers without saving
set noerrorbells
set nostartofline
set novisualbell
set number
set ruler
set showcmd
set showmatch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ignore this script if we're not using vim7
" note: most (if not all) of this vimrc will work, since I've been
" using it since 2000; it's just that I don't have vim5/6 around
" anymore
" TL;DR: edit the next line to use on vim6 at your own risk
if version >= 700

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" User Interface
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax highlighting, only if the feature is available and the
" terminal can display colors (or we're running gvim)
if has('syntax') && (&t_Co > 2 || has('win32') || has('gui_running'))

    " enable syntax highlighting
    syntax on

    " I'm too lazy to fix termcap/terminfo in servers on N different
    " platforms, so I'll just do this here...
    if &term == "xterm-256color"
        set t_Co=256
    endif

    if has('gui_running')
        "set gfn=Monospace\ 10
        set guifont="Bitstream\ Vera\ Sans\ Mono\ 10
        colorscheme twilight
    elseif &t_Co == 256
        colorscheme elflord
    else
        " gah, fall back
        colorscheme elflord
    endif

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" display
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" welcome to the 21st century
set encoding=utf-8

" faster macros
set lazyredraw

" we like security
set nomodeline

" abbrev. of messages (avoids 'hit enter')
set shortmess+=a

" display the current mode
set showmode

" min num of lines to keep above/below the cursor
set scrolloff=2

" show line numbers
" I don't like this because it's annoying when copying and I'm used to ctrl-g
"set number

if has('cmdline_info')

    " show the ruler
    set ruler

    " a ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

    " show partial commands in status line and selected characters/lines in
    " visual mode
    set showcmd

endif

if has('statusline')
    
    " always show a status line
    set laststatus=2

    " a statusline, also on steroids
    set statusline=%<%f\ %=\:\b%n\[%{strlen(&ft)?&ft:'none'}/%{&encoding}/%{&fileformat}]%m%r%w\ %l,%c%V\ %P

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" editing
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" backspace for dummies
set backspace=indent,eol,start

" show matching brackets/parenthesis
set showmatch

" command <Tab> completion, list matches and complete the longest common
" part, then, cycle through the matches
set wildmode=list:longest,full


" wrap long lines
set wrap

" indent at the same level of the previous line
set autoindent

" use indents of 4 spaces
set shiftwidth=4

" the text width
" set textwidth=79

" basic formatting of text and comments
"set formatoptions+=tcq

" match, to be used with %
set matchpairs+=<:>

" spaces instead of tabs, CTRL-V<Tab> to insert a real space
set expandtab

" ignore these file types when opening
set wildignore=*.pyc,*.o,*.obj,*.swp


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" search
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" show search results as you type (enable this _only_ if you work with small
" files)
set incsearch

" highlight all search matches
set hlsearch


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" file types
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType c,cpp call <SID>cstuff()
function <SID>cstuff()
    set cindent
    set formatoptions+=croql
    set formatoptions-=t
endfunction

autocmd FileType python call <SID>pystuff()
function <SID>pystuff()
    set foldmethod=indent
    set foldlevel=999999
    set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
endfunction

" I have been working with cobol lately, the horror
au BufNewFile,BufRead *.CBL,*.cbl,*.cob     setf cobol

" clearsilver templates
au BufNewFile,BufRead *.cst      setf cs


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" misc, there is _always_ a misc section
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" real men _never_ _ever_ do backups
" (but real programmers use version control)
set nobackup


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" tabs
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" this settings are basically for gvim in gtk and windows
map <silent><C-t> :tabnew<CR>
map <silent><A-Right> :tabnext<CR>
map <silent><A-Left> :tabprevious<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" gvim- (here instead of .gvimrc)
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('gui_running') 
    "set guioptions-=mT          " remove the toolbar
    set lines=999
    if has("mac")
        set guifont=Monaco:h14
    elseif has("unix")
        set guifont=Monospace\ 10
    elseif has("win32") || has("win64")
        set guifont=Consolas:h10:cANSI
    endif
    set cursorline
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

endif " if version >= 700 (at the beggining of the file)

