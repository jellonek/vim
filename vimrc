set nocompatible

filetype indent plugin on
syn on

call plug#begin()

Plug 'kien/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/L9'
Plug 'roxma/SimpleAutoComplPop'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'sjl/splice.vim'
Plug 'mileszs/ack.vim'
Plug 'junegunn/limelight.vim'
Plug 'Raimondi/delimitMate'
Plug 'sheerun/vim-polyglot'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'mtth/scratch.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'rafamadriz/friendly-snippets'


Plug 'rhysd/vim-healthcheck'

call plug#end()

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gi <plug>(lsp-definition)
  nmap <buffer> gd <plug>(lsp-declaration)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gl <plug>(lsp-document-diagnostics)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> K <plug>(lsp-hover)

  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


auto BufRead,BufNewFile *.mako set sts=2 ft=mako sw=2
auto BufRead,BufNewFile *.jinja set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.jinja2 set sts=2 sw=2 ft=htmljinja
auto BufRead,BufNewFile *.less set filetype=less
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType less set omnifunc=csscomplete#CompleteCSS

au FileType python set sts=4 sw=4 et
au FileType json set sts=2 sw=2 et
" au FileType go set sts=8 sw=8 noet

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
set rnu
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
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+Y
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

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

filetype plugin indent on

nmap <F7> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

let g:ale_linters = {"go": ['golint', 'go vet'], "python": ["python -m flake8"], }

nmap <Leader>l :Limelight!!<CR>
xmap <Leader>l :Limelight!!<CR>

let g:jsonnet_fmt_on_save = 1
let g:jsonnet_fmt_options = '--string-style d'

autocmd FileType jsonnet set sw=2 et
autocmd FileType yaml set sw=2 et

set gp=git\ grep\ -n

colo wombat256mod
set path +=**
