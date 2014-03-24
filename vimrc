set nocompatible | filetype indent plugin on | syn on

auto BufRead,BufNewFile *.mako set sts=2 ft=mako sw=2
auto BufRead,BufNewFile *.jinja set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.jinja2 set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.less set filetype=less
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType less set omnifunc=csscomplete#CompleteCSS

au FileType python set sts=4 sw=4 et

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
inoremap jj <Esc>

set nobackup
set directory=~/.vim/.tmp,.

" system clipboard without shift
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" better block indentin/deindenting
vnoremap > >gv
vnoremap < <gv

" no docstring window popup on completion
autocmd FileType python setlocal completeopt-=preview

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

call SetupVAM()
VAMActivate jedi-vim vim-flake8 ctrlp pylint vim-gitgutter commentary repeat surround unimpaired L9 AutoComplPop
