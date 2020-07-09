set nocompatible
filetype indent plugin on
syn on

auto BufRead,BufNewFile *.mako set sts=2 ft=mako sw=2
auto BufRead,BufNewFile *.jinja set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.jinja2 set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.less set filetype=less
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType less set omnifunc=csscomplete#CompleteCSS

au FileType python set sts=4 sw=4 et
au FileType json set sts=2 sw=2 et
au FileType go set sts=8 sw=8 noet

" virtualevn
if has('python')
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

call pathogen#infect()

set wildmenu
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set autoread

" tabs
map <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>i

map <Leader>T :noautocmd vim TODO **/*py<CR>:cw<CR>
imap <Leader>T <Esc>:noautocmd vim TODO **/*py<CR>:cw<CR>

set formatoptions+=1
set nrformats=

nnoremap <Leader>_ yypVr=

" minimal above/below scroll lines
set so=3

" additional
set hidden
set wildmode=list:longest
" set cursorline
set tf " fast tty
set ls=2 " last status - linia z nazwami plikow
set cc=80 " color column
" set list
au FocusLost * :wa
nnoremap <silent> <Leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sc :Scratch<CR>
nnoremap <silent> <Leader>so :so $MYVIMRC<CR>
nnoremap <silent> <Leader>bn :bn<CR>
nnoremap <silent> <Leader>bp :bp<CR>
nnoremap <silent> <Leader>z :bn<CR>
nnoremap <silent> <Leader>x :bp<CR>
inoremap jj <Esc>

set nobackup
set directory=~/.vim/.tmp,.
set undodir=~/.vim/.tmp,.

" system clipboard without shift
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" with shift
imap <S-insert> <c-r>*
map <S-insert> "+p

" better block indentin/deindenting
vnoremap > >gv
vnoremap < <gv

" no docstring window popup on completion
autocmd FileType python setlocal completeopt-=preview
autocmd FileType go setlocal nowrap

" auto remove eol whitespaces on buf write
autocmd BufWritePre *.py,*.sh :%s/\s\+$//e

" for jedi
let g:jedi#use_tabs_not_buffers=0
let g:jedi#popup_select_first=0

set bg=dark

" plugins
set runtimepath+=~/.vim/vim-addon-manager

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'
  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif
  call vam#ActivateAddons([], {'auto_install' : 0})
endfun

filetype off
call SetupVAM()

autocmd FileType python VAMActivate jedi-vim vim-flake8 pylint
" autocmd FileType go VAMActivate github:fatih/vim-go
VAMActivate github:fatih/vim-go
autocmd FileType proto VAMActivate github:belltoy/vim-protobuf
" VAMActivate ctrlp vim-gitgutter commentary repeat surround unimpaired github:vim-scripts/L9 AutoComplPop ack github:majutsushi/tagbar github:tpope/vim-fugitive github:scrooloose/nerdtree github:Xuyuanp/nerdtree-git-plugin
VAMActivate ctrlp vim-gitgutter commentary repeat surround unimpaired github:vim-scripts/L9 github:roxma/SimpleAutoComplPop ack github:majutsushi/tagbar github:tpope/vim-fugitive github:scrooloose/nerdtree github:Xuyuanp/nerdtree-git-plugin github:sjl/splice.vim github:mileszs/ack.vim github:junegunn/limelight.vim github:vim-syntastic/syntastic github:Raimondi/delimitMate github:w0rp/ale github:sheerun/vim-polyglot github:xolox/vim-notes

filetype plugin indent on

nmap <F7> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

let g:ale_linters = {"go": ['golint', 'go vet'], "python": ["python -m flake8"], }

nmap <Leader>l :Limelight!!<CR>
xmap <Leader>l :Limelight!!<CR>

highlight Comment cterm=italic
let g:jsonnet_fmt_on_save = 1
let g:jsonnet_fmt_options = '--string-style d'

autocmd FileType jsonnet set sw=2 et
autocmd FileType yaml set sw=2 et
