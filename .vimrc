set nocompatible               " be iMproved
filetype off                   " required!

" ----------------- PLUG SETTINGS -----------------------"

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'Valloric/YouCompleteMe'
Plug 'bling/vim-airline'
Plug 'flazz/vim-colorschemes'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'
" Plug 'vim-scripts/SQLComplete.vim'
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'chase/vim-ansible-yaml', { 'for': 'yaml' }
Plug 'mitsuhiko/vim-jinja', { 'for': 'html' }
" for markdown syntax highlighting 2015-08-05 00:23
Plug 'godlygeek/tabular', { 'for': 'mkd' }
Plug 'plasticboy/vim-markdown', { 'for': 'mkd' }
" added for text and tex stuff - need to look further -	2015-08-05 00:23
Plug 'reedes/vim-pencil', { 'for': ['tex', 'text', 'mkd', 'markdown'] }
" added for html - 2015-08-05 12:48
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'dkprice/vim-easygrep'

call plug#end()

filetype plugin indent on     " required!

" ------------------- General settings ----------------------------"

syntax on
" persistent undo - support undo's even if you have closed the file
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature  
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
endif  
" ignore other tex types - plaintex etc
let g:tex_flavor='latex'
" show active line
set cursorline
" line numbering 
set number " line numbering stuff
set numberwidth=3 " how much width the column is at the beginning
" show 3 lines above and below
set scrolloff=3
" automatically read changes made outside vim if not changed in vim
set autoread
set backspace=indent,eol,start
" don't want annoying sounds - 2015-08-05 00:05
set visualbell "No sounds - Thank you sooooo much! : https://github.com/skwp/dotfiles
" Make searches match incrementally! - 2015-08-05 00:16
set incsearch
"
" -------------------- Bad habit removal ------------------------------"

nmap <Left> [f
nmap <Right> ]f
vmap <Left> [f
vmap <Right> ]f

nmap <Up> [l
nmap <Down> ]l
vmap <Up> [l
vmap <Down> ]l

set mouse=a
map <ScrollWheelUp> 4<C-Y>
map <ScrollWheelDown> 4<C-E>
" -------------------- Text folding ------------------------------"

set foldmethod=indent
set foldlevel=99

" ----------------- Indentation settings --------------------------" 

set shiftwidth=4
set tabstop=4
" set expandtab " don't replace tabs by default
set softtabstop=4

" ------------- Colorscheme settings ----------------"

"colorscheme railscasts
colorscheme jellybeans

" ------------------- General keybindings -------------------------------"

nnoremap <F4> :NERDTree<CR>
nnoremap <F5> :GundoToggle<CR>

" ------------------- Airline settings ----------------------------------"

set laststatus=2 "used for airline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme='understated'

" --------------------- Syntastic settings ------------------------------"
" C support "
let g:syntastic_c_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
" Be able to jump to errors with :lnext and :lprev
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['pyflakes', 'pep8']

" ------------------- YouCompleteMe settings ----------------------------"

" use tab for autocompletion and ctrl plus up or down
" to select completion - 2015-08-05 00:25
let g:ycm_key_list_select_completion=['<Tab>', '<C-k>']
let g:ycm_key_list_previous_completion=['<C-j>']
" close window that shows prototypes after completion
let g:ycm_autoclose_preview_window_after_completion = 1
" close window that shows prototypes after exiting insertion mode
" let g:ycm_autoclose_preview_window_after_insertion = 1

" added by grv - Wed 19 Aug 2015 08:08:29 AM EEST
" use eclim for java
let g:EclimCompletionMethod = 'omnifunc'

" use shift plus tab for snippet completion 
" then ctrl plus direction to skip completes - 2015-08-05 00:24
let g:UltiSnipsExpandTrigger="<S-Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"                                           
let g:UltiSnipsJumpBackwardTrigger="<C-h>"

" ------------------- Pencil settings ----------------------------"

" configured pencil - added by grv - Sat, 08 Aug 2015 16:20:35
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
  autocmd FileType tex          call pencil#init()
augroup END

"------------------- Filetype Specifics --------------------------"
"-------------------------- HTML --------------------------"
" smaller indentation for html
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
"-------------------------- Python --------------------------"
" change tabs to spaces for python
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
" easy print using surround with char p
autocmd FileType python let g:surround_112 = "print(\r)"
"-------------------------- C++ --------------------------"
" change tabs to spaces for C++
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
" easy print using surround with char p
autocmd FileType cpp let g:surround_112 = "std::cout<<\r<<std::endl;"
"-------------------------- TeX --------------------------"
" smaller indentation for tex. we also want greek support
autocmd FileType tex setlocal shiftwidth=2 tabstop=2 softtabstop=2 " keymap=greek_utf-8
" support surrounding with tex environments
autocmd FileType tex let g:surround_108 = "\\begin{\1environment: \1}\n\r\n\\end{\1\1}"
" support surrounding with tex command - eg \textbf{}
autocmd FileType tex let g:surround_112 = "\\\1environment: \1{\r}"
" use evince as previewer for tex
autocmd FileType tex let g:livepreview_previewer = 'evince'
"-------------------------- Java --------------------------"
" change tabs to spaces for Java
autocmd FileType java setlocal shiftwidth=4 tabstop=4 softtabstop=4
" easy print using surround with char p
autocmd FileType java let g:surround_112 = "System.out.println(\r);"

"-------------------------- Yaml --------------------------"
" support yaml syntax using ansible
autocmd FileType yaml set ft=ansible

" Stuff about how the window looks - 2015-08-05 00:04
" The colors of the numbers - 2015-08-05 00:04
highlight CursorLineNr term=bold ctermfg=Blue guifg=Blue
highlight LineNr term=bold ctermfg=LightGray guifg=LightGray
" Vertical split colors and settings - 2015-08-05 00:04
set fillchars+=vert:*
highlight VertSplit term=bold ctermfg=blue guifg=blue
" set fillchars+=stl:*
" set fillchars+=stlnc:*
