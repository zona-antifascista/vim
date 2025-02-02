" Jack + Joe do vim, since 2012
"
" Last major rework updated reflecting
" http://dougblack.io/words/a-good-vimrc.html " Vim needs a POSIX-Compliant shell. Fish is not.
if $SHELL =~ 'bin/fish'
  set shell=/bin/sh
endif

call plug#begin('~/.vim/plugged')

" Plugins {{{

Plug 'jiangmiao/auto-pairs'
Plug 'docunext/closetag.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'ervandew/supertab'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'andyl/vim-textobj-elixir'
Plug 'janko-m/vim-test'

" Nerdtree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" Snippets
if has('nvim')
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'rstacruz/vim-ultisnips-css'
endif

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" Syntax
Plug 'sheerun/vim-polyglot'

" Javascript
Plug 'othree/javascript-libraries-syntax.vim'

" Java
Plug 'rhysd/vim-clang-format'

" Formats
Plug 'mattn/emmet-vim'

" vim-scripts repos
Plug 'vim-scripts/L9'

" Yank fix
Plug 'bfredl/nvim-miniyank'

" }}}

" General {{{
noremap ; :

set encoding=utf8
set laststatus=2        " Always show the statusline
set nocompatible        " the future is now, use vim defaults instead of vi ones

syntax enable 		      " Enable syntax highlighting
filetype on             " /!\ doesn't play well with compatible mode
filetype plugin on      " trigger file type specific plugins
filetype indent on      " indent based on file type syntax

set clipboard^=unnamed,unnamedplus   " Yank everything to the system clipboard

set history=1000        " keep 1000 lines of command line history
set undolevels=200      " Undo history
set ttyfast             " Yes, we have a fast terminal
set title               " change the terminal title
set lazyredraw          " do not redraw when executing macros
set report=0            " always report changes
nnoremap Q <Nop>        " we don't do ex mode

" }}}

" UI Layout {{{
set cmdheight=1         " height of the command line
set number              " show line numbers
set hidden
set ruler               " show the cursor position all the time
set showcmd             " show command in bottom bar
set scrolloff=1         " Always show at least one line above/below the cursor.
set nocursorline        " highlight current line
set wildmenu
" }}}

" {{{ Editing
set nowrap                      " don't wrap lines
set nojoinspaces                " insert only one space after '.', '?', '!' when joining lines
set showmatch                   " briefly jumps the cursor to the matching brace on insert
set matchtime=4                 " blink matching braces for 0.4s
set backspace=indent,eol,start  " allow backspacing over everything

if !has('nvim')
  fixdel
endif

set tabstop=2
set softtabstop=2
set shiftwidth=2                " indent with 2 spaces
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set expandtab
set wrap                        " set linewrap

set lbr
set tw=500
set autoindent
set smartindent
set copyindent                  " Take indentation from previous line

" set list                      " Show invisible characters
set listchars=""                " Reset the listchars
set listchars=tab:»·,trail:·,eol:¬,nbsp:_

" reselect last selection after indent / un-indent in visual and select modes
vnoremap < <gv
vnoremap > >gv
vmap <Tab> >
vmap <S-Tab> <

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=256

" allow multiple pastes of the same content when pasting in visual mode.
vnoremap p pgvy
" }}}

" Better line joins
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

" == Silver Searcher ===========================

if executable('rg')
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column --ignore="*.map" --ignore="*.min.js" --ignore node_modules'
endif

cnoreabbrev Ack Ack!
cnoreabbrev ack Ack!
nnoremap <meLeader>* :Ack!<cr>

" == Buffers ==================================

set autoread         " Set to auto read when a file is changed from the outside
set nobomb           " don't clutter files with Unicode BOMs
set hidden           " enable switching between buffers without saving
set switchbuf=usetab " switch to existing tab then window when switching buffer
set fsync            " sync after write
set confirm          " ask whether to save changed files

if has("autocmd")
  augroup trailing_spaces
    " autocmd!
    autocmd BufWritePre * :%s/\s\+$//e " remove trailing spaces before saving
  augroup END
endif

" == Completion ==================================

set completeopt=longest,menuone,preview             " better completion
set wildmenu                                        " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=longest:full,list:longest
set wildignore=*.o,*.obj,*~                         " stuff to ignore when tab completing
set wildignore+=*node_modules*,*vim/backups*,*ts-build*
set wildignore+=.git,.yarn                          " ignore the .git directory
set wildignore+=*.DS_Store                          " ignore Mac finder/spotlight crap
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.DS_Store
set wildignore+=*.min.css,*.min.js,*.map

if exists("&wildignorecase")
  set wildignorecase
endif

" == Color + font ===================================

set ffs=unix,mac,dos	                              " Support all three, in this order

" == Git/SVN Errors =====================================

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" == Filetypes =======================================

au BufRead,BufNewFile *.heex                      set filetype=eelixir
au BufRead,BufNewFile *.less,*.scss               set filetype=css
au BufRead,BufNewFile *.tmpl,*.vue                set filetype=html
au BufRead,BufNewFile *.go                        set filetype=go
au BufRead,BufNewFile *.ru,*.rb,Deliverfile       set filetype=ruby
au BufNewFile,BufRead Fastfile,Appfile,Snapfile   set filetype=ruby
au BufNewFile,BufRead Scanfile,Gymfile,Matchfile  set filetype=ruby

" Searching {{{
set hlsearch                " Highlight search things
set incsearch               " Make search act like search in modern browsers
set ignorecase              " Case insensitive matching...
set smartcase               " ... unless they contain at least one capital letter
" }}}

" Files/Backup {{{
set nobackup                " do not keep a backup file, use versions instead
set nowritebackup
set nowb
set noswapfile
" }}}

" Visualbell {{{
set visualbell              " shut up
set noerrorbells            " shut up
set mousehide               " hide mouse pointer when typing
" }}}

" Supertab {{{
let g:SuperTabDefaultCompletionType = "<c-n>"
" }}}

" == Yank ================================

" Yank {{{
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
" }}}

" == Mouse =============================

" Enable mouse in all modes. -> https://bitheap.org/mouseterm/
set mouse=a
" Set mouse type to xterm.
if !has('nvim')
  set ttymouse=xterm2
endif

" == Source after saving ================

" Keyboard {{{
let mapleader = ","

" Save
nnoremap <leader>w :w<CR>
nnoremap <C-s> :w<CR>
" alias :lw to :w
cnoreabbrev lw w
" alias :we to :w
cnoreabbrev we w

" Show/hide hidden characters
nmap <leader>l :set list!<cr>

" Clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" Line Shortcuts {{{
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]
" }}}

" Sudo to write
cmap w!! w !sudo tee % >/dev/null
command! -nargs=0 Sw w !sudo tee % > /dev/null

if has("gui_running") " Fuck you, help key, seriously
  set fuoptions=maxvert,maxhorz
  noremap  <F1> :set invfullscreen<CR>
  inoremap <F1> <ESC>:set invfullscreen<CR>
endif

" switch between last two files
nnoremap <leader><Tab> <c-^>

" move to the position where the last change was made
noremap gI `.

" split line and preserve cursor position
nnoremap S mzi<CR><ESC>`z

" == Paste mode ===============================

nnoremap <F2> :set invpaste paste?<CR> " Enable F2 key for toggling pastemode
imap <F2> <C-O><F2>
set pastetoggle=<F2>

" == HTML ===============================

:vmap <leader><leader>b <S-S><strong>
:vmap <leader><leader>i <S-S><em>

map tgt diti<%= gettext("<ESC>p2la<Space>%><ESC>

" convert list of lines to <li>
map <leader><leader>l :s/\s\+$//e<CR>:'<,'>s/^/<li>/g<CR>:'<,'>s/$/<\/li>/g<CR>:nohl<CR>

" == fzf ===================================

nmap <C-p> :Files<CR>
nmap <C-t> :Tags<CR>

" == Emmet (previously Zencoding) ==========

" Emmet {{{
let g:use_emmet_complete_tag = 1
let g:user_emmet_leader_key = '<c-e>'
" }}}

" JSX
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\  'typescript' : {
\      'extends' : 'jsx',
\  },
\}

" == Java =============================

autocmd FileType java ClangFormatAutoEnable

" == Split windows ====================

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" switch between windows by hitting <Tab> twice
nmap <silent> <Tab><Tab> <C-w>w

" enlarge splits
map + 3<c-w>>
map - 3<c-w><

" == Search ==========================

" show number of matches after a search
nmap <leader>c :%s///gn<cr>

" == Golang ============================

" Clear filetype flags before changing runtimepath to force Vim to reload them.

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"

" == VIM JSX =======================================================

let g:jsx_ext_required = 0

" == Snippets ======================================================

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<c-tab>"

if has('nvim')
  let g:UltiSnipsUsePythonVersion = 2
else
  let g:UltiSnipsUsePythonVersion = 3
endif

" Do not interfere with vim mapping
inoremap <c-x><c-k> <c-x><c-k>

" == Javascript =============================

let g:javascript_plugin_flow = 1

" == Prettier =========================

" no save all, to prevent prettier errors
noremap :wq<cr> <nop>
noremap :x<cr> <nop>
nnoremap :wq<cr> <nop>
nnoremap :x<cr> <nop>
map :wq<cr> <nop>
map :x<cr> <nop>

" == Elixir format ====================

" roll our own
autocmd BufWritePost *.exs,*.ex silent :!source .env && mix format --check-equivalent %

au FileType elixir let $MIX_ENV = 'test'

" == Coc ===========================================================

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoC
let g:coc_global_extensions = ['coc-eslint', 'coc-css', 'coc-json', 'coc-pyls', 'coc-yaml', 'coc-ultisnips', 'coc-snippets', 'coc-elixir', 'coc-tailwindcss', 'coc-tag', 'coc-highlight', 'coc-lists', 'coc-phpls', 'coc-diagnostic', 'coc-prettier', 'coc-tsserver']

" == path helpers ====================================================

" copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>
  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>
  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>
  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
endif

" == Nerdtree ===============================

nmap <silent> <c-n> :NERDTreeToggle \| :silent NERDTreeMirror<CR>

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" set autochdir
let NERDTreeChDirMode = 1

" close Nerdtree when only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" == vim test ========================================================

if has('nvim')
  let test#strategy = "neovim"
  " escape insert mode in terminal easier
  tmap <C-o> <C-\><C-n>
endif

let test#elixir#exunit#executable = "source .env.test && mix test"

nnoremap <leader>ts :TestSuite<CR>    " test suite
nnoremap <leader>tf :TestFile<CR>     " test single file
nnoremap <leader>tn :TestNearest<CR>  " test nearest

" == User defined plugs =====================

if filereadable(expand("~/.vimrc.plugs.local"))
  source ~/.vimrc.plugs.local
endif

" == End vim-plug =====================

call plug#end()

" == User defined =====================
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
