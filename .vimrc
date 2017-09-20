set nocompatible               " be iMproved
filetype off                   " required!
" https://github.com/vim/vim/issues/993
" set Vim-specific sequences for RGB colors

" ----------------- PLUG SETTINGS -----------------------"

" automatically install vim plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" plugin section
call plug#begin()

" pope section
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-git'
Plug 'tpope/vim-dispatch'
" aesthetics
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'
" utils
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'tomtom/tcomment_vim'
" Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
" Plug 'mileszs/ack.vim'
Plug 'jmcantrell/vim-virtualenv'
Plug 'christoomey/vim-tmux-navigator'
" autocomplete + snippets
Plug 'Valloric/YouCompleteMe'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
" syntax + tags + highlighting
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular', { 'for': 'mkd' }
Plug 'chase/vim-ansible-yaml', { 'for': 'yaml' }
Plug 'plasticboy/vim-markdown', { 'for': 'mkd' }
Plug 'mitsuhiko/vim-jinja', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'html'] }
Plug 'pangloss/vim-javascript', { 'for': ['html', 'javascript'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ternjs/tern_for_vim', { 'for': ['javascript'] }
Plug 'maksimr/vim-jsbeautify', { 'for': ['html*','css','javascript'] }
Plug 'tshirtman/vim-cython', { 'for': ['pyrex', 'cython']}
Plug 'keith/tmux.vim', { 'for': 'tmux' }
Plug 'cakebaker/scss-syntax.vim', { 'for': ['scss','sass'] }
" text and tex stuff
Plug 'lervag/vimtex', { 'for': ['tex'] }
Plug 'reedes/vim-pencil', { 'for': ['tex','text','mkd','markdown'] }
" ipython intergration
" Plug 'ivanov/vim-ipython'

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
" show 4 lines above and below
set scrolloff=4
" automatically read changes made outside vim if not changed in vim
set autoread
" view outer changes if any when selecting the window
au FocusGained,BufEnter * :silent! !

" add title to vim window!
set title

set backspace=indent,eol,start
" don't want annoying sounds - 2015-08-05 00:05
set visualbell "No sounds - Thank you sooooo much! : https://github.com/skwp/dotfiles
" Make searches match incrementally! - 2015-08-05 00:16
set incsearch

" use menu with autocompletions
set wildmenu
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*.class,*.so,*.swp

set splitright

set shortmess=a
set cmdheight=2
" make vim search for tags in .tags as well
set tags+=.tags
" quicker window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -------------------- Bad habit removal ------------------------------"
nnoremap <Right> :tnext<CR>
nnoremap <Left> :tprev<CR>

nmap <Up> [l
nmap <Down> ]l
vmap <Up> [l
vmap <Down> ]l

set mouse=a
map <ScrollWheelUp> 4<C-Y>
map <ScrollWheelDown> 4<C-E>

" I have never used ex mode for the time being..
nnoremap Q <Nop>
" -------------------- Text folding ------------------------------"

set foldmethod=indent
set foldlevel=99

" ------------------- Indentation settings ------------------------" 

set shiftwidth=4
set tabstop=4
" set expandtab " don't replace tabs by default
set softtabstop=4

" ------------------- Colorscheme settings ------------------------"

set termguicolors
colorscheme gruvbox
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_improved_warnings=1

" ------------------- General keybindings -------------------------------"

" run make
nnoremap <F3> :Make<CR>
nnoremap <F4> :NERDTree<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap <F6> :TagbarToggle<CR>
" create ctags file
nnoremap <F8> :!/usr/bin/ctags -R<CR>

" ------------------- Airline settings ----------------------------------"

set laststatus=2 "used for airline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme='gruvbox'

" --------------------- Ctrlp settings ------------------------------"

let g:ctrlp_working_path_mode = 'a'

" --------------------- Syntastic settings ------------------------------"
" add checking for javascript + more options grv added @ 2015-11-01 21:04
let g:syntastic_enable_signs = 1
" let g:syntastic_auto_jump = 1
" C support "
let g:syntastic_c_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_cpp_include_dirs = ['include', '../include']
let g:syntastic_c_include_dirs = ['include', '../include']
" Be able to jump to errors with :lnext and :lprev
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['pyflakes', 'pep8']
let g:syntastic_javascript_checkers = ['eslint']

" ------------------- YouCompleteMe settings ----------------------------"

" use tab for autocompletion and ctrl plus up or down
" to select completion - 2015-08-05 00:25
let g:ycm_key_list_select_completion=['<Tab>', '<C-k>']
let g:ycm_key_list_previous_completion=['<C-j>']
" close window that shows prototypes after completion
" let g:ycm_autoclose_preview_window_after_completion = 1
" close window that shows prototypes after exiting insertion mode
let g:ycm_autoclose_preview_window_after_completion = 1
" close window that shows prototypes after exiting insertion mode
" let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_auto_trigger = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_invoke_completion = '<C-Space>'
" added by grv - Wed 19 Aug 2015 08:08:29 AM EEST
" use eclim for java
let g:EclimCompletionMethod = 'omnifunc'

" use shift plus tab for snippet completion 
" then ctrl plus direction to skip completes - 2015-08-05 00:24
let g:UltiSnipsExpandTrigger="<S-Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"

if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif

" ------------------- Pencil settings ----------------------------"

" configured pencil - added by grv - Sat, 08 Aug 2015 16:20:35
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
let g:pencil#textwidth = 79

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,text,tex call pencil#init()
augroup END

augroup LightTextMode
	autocmd!
	autocmd FileType text,tex,markdown,mkd set background=light
augroup END

"------------------- Filetype Specifics --------------------------"

"-------------------------- Python --------------------------"
augroup Python
	autocmd!
	" change tabs to spaces for python
	autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
	" easy print using surround with char p
	autocmd FileType python let g:surround_112 = "print(\r)"
augroup END

"-------------------------- C++ --------------------------"
augroup Cpp
	autocmd!
	" change tabs to spaces for C++
	autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
	" easy print using surround with char p
	autocmd FileType cpp let g:surround_112 = "std::cout<<\r<<std::endl;"
	" Make options 
	autocmd QuickFixCmdPost * nested cwindow | redraw!
augroup END

"-------------------------- TeX --------------------------"
augroup TeX
	autocmd!
	" smaller indentation for tex. we also want greek support
	autocmd FileType tex setlocal shiftwidth=2 tabstop=2 softtabstop=2 " keymap=greek_utf-8
	" support surrounding with tex environments
	autocmd FileType tex let g:surround_108 = "\\begin{\1environment: \1}\n\r\n\\end{\1\1}"
	" support surrounding with tex command - eg \textbf{}
	autocmd FileType tex let g:surround_112 = "\\\1environment: \1{\r}"

	autocmd FileType tex let g:vimtex_view_general_viewer = 'okular'
	autocmd FileType tex let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
	autocmd FileType tex let g:vimtex_view_general_options_latexmk = '--unique'
	autocmd FileType tex let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
	autocmd FileType tex let g:tex_conceal = ""
augroup END

"-------------------------- Java --------------------------"
augroup Java
	autocmd!
	" change tabs to spaces for Java
	autocmd FileType java setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab
	" easy print using surround with char p
	autocmd FileType java let g:surround_112 = "System.out.println(\r);"
augroup END
"-------------------------- Yaml --------------------------"
" support yaml syntax using ansible
augroup Yaml
	autocmd!
	autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
	autocmd FileType yaml set ft=ansible
augroup END

"-------------------------- JSON --------------------------"
augroup JSON
	autocmd!
	autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
augroup END
"-------------------------- HTML --------------------------"
augroup HTML
	autocmd!
	" smaller indentation for html
	autocmd FileType xml,html,htmldjango,htmljinja setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	autocmd FileType xml,html,htmldjango,htmljinja noremap <buffer> <leader>r :call HtmlBeautify()<cr>
augroup END
"-------------------------- CSS ---------------------------"
augroup CSS
	autocmd!
	autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
	autocmd FileType css noremap <buffer> <leader>r :call CSSBeautify()<cr>
augroup END
"----------------------- Javascript -----------------------"
augroup Javascript
	autocmd!
	autocmd FileType javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
	autocmd FileType javascript noremap <buffer> <leader>r :call JsBeautify()<cr>
augroup END
"----------------------- JSX -----------------------"
augroup JSX
	autocmd!
	autocmd FileType javascript.jsx setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
	autocmd FileType javascript.jsx noremap <buffer> <leader>r :call JsBeautify()<cr>
augroup END

" Vertical split colors and settings - 2015-08-05 00:04
set fillchars+=vert:*
" https://sookocheff.com/post/vim/italics/
highlight Comment cterm=italic

" Make changing modes snappy
" See (https://www.reddit.com/r/vim/comments/2391u5/delay_while_using_esc_to_exit_insert_mode/)
" and https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" Also note that running vim in tmux can have the same effect
" use 'set -s escape-time 0' in tmux.conf
augroup FastEscape
	autocmd!
	au InsertEnter * set timeoutlen=0
	au InsertLeave * set timeoutlen=1000
augroup END
