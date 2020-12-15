syntax on

let mapleader = ','

"set t_Co=256

" Emojis
" 🤔
imap <C-v>ut <C-v>U0001F914

" z commands
nnoremap <silent> z<Up> :wincmd k<CR>
nnoremap <silent> z<Down> :wincmd j<CR>
nnoremap <silent> z<Left> :wincmd h<CR>
nnoremap <silent> z<Right> :wincmd l<CR>
nnoremap <silent> zk :wincmd k<CR>
nnoremap <silent> zj :wincmd j<CR>
nnoremap <silent> zh :wincmd h<CR>
nnoremap <silent> zl :wincmd l<CR>
nnoremap <silent> ZH Hzz
nnoremap <silent> ZL Lzz
nnoremap <silent> ZM :tabmove -1<CR>
nnoremap <silent> zm :tabmove +1<CR>
nnoremap ZZ <nop>
inoremap <C-c> <Esc>

" tabs
nnoremap zv :tabnext<CR>
nnoremap zx :tabprev<CR>
nnoremap zn :tabedit

" diffs
vnoremap ;dp :'<,'>diffput<CR>
vnoremap ;dg :'<,'>diffget<CR>
vnoremap ;du :diffupdate<CR>


" Plugins
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" - Stable
Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-commentary'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-fugitive'
Plugin 'itchyny/lightline.vim'
Plugin 'morhetz/gruvbox'
Plugin 'r0mai/vim-djinni'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/vim-peekaboo'

" - Experimental

" Plugin 'grailbio/bazel-compilation-database'

call vundle#end()
filetype plugin indent on

set runtimepath+=~/.vim/my-snippets/

" auto-formating
set nocompatible
set backspace=2
set ruler
set laststatus=2

set expandtab
set tabstop=4
set shiftwidth=4
set nu

" F-keys
" - Toggle outline
map <F2> :TagbarToggle<cr>
" - Run formatting on selection
map <F8> :!clang-format -style=file<cr>
" map <F8> :!~/work/capi/bazel-capi/external/llvm_toolchain/bin/clang-format -style=file<cr>
" - Run formatting on method
map <F9> mW[[va{<F8>`Wzz<cr>
" - Run formatting on fike
map <F10> mWggVG<F8>`Wzz<CR>

" no backup files
set nobackup
set nowb
set noswapfile

" set constants
let author = "Marcos Reis"

" Highlight search
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set noincsearch

" EasyMotion
map ff <Plug>(easymotion-f)
map FF <Plug>(easymotion-F)
map <Leader> <Plug>(easymotion-prefix)

" YCM
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_extra_conf_globlist = ['~/*']
let g:ycm_global_ycm_extra_conf = '~/work/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/bazel-compilation-database/.ycm_extra_conf.py'
nmap ;t :YcmCompleter GetType<CR>
nmap ;g :YcmCompleter GoTo<CR>
nmap ;u :YcmForceCompileAndDiagnostics<CR>
nmap ;r :YcmRestartServer<CR>
nmap ;f :YcmCompleter FixIt<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" make YCM compatible with peekaboo
let g:ycm_filetype_blacklist = {
   \    'peekaboo': 1,
   \    'notes': 1,
   \    'markdown': 1,
   \    'netrw': 1,
   \    'unite': 1,
   \    'pandoc': 1,
   \    'tagbar': 1,
   \    'mail': 1,
   \    'vimwiki': 1,
   \    'text': 1,
   \    'infolog': 1
   \}


" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" My snippets

" NERDTree configs
map za :NERDTreeToggle<CR>

" Lightline
let g:lightline = {
            \    'active': {
            \      'left': [['mode', 'paste'], ['relativepath', 'modified']],
            \      'right': [['lineinfo'], ['percent'], ['readonly'], ['filetype'], ['ycmCount']]
            \    },
            \    'component_function': {
            \       'ycmCount': 'MyYcmCount'
            \    }
            \}

function! MyYcmCount()
    " if &filetype !=# 'cpp'
        return ''
    " endif
    " let eCount = youcompleteme#GetErrorCount()
    " let wCount = youcompleteme#GetWarningCount()
    " return 'E:' . eCount . ' W:' . wCount . ' |'
endfunction

" Commentary
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Fuzzy finder
nmap ;; :Files<CR>
nmap ;b :Buffer<CR>
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf

" Quick fix window
nmap ;l :cnext<CR>
nmap ;k :cprev<CR>

" Quick search under cursor
nmap ;s :Rg <cword><CR>

" java stuff
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Force highlights
autocmd BufNewFile,BufRead *.mm   set syntax=objcpp
autocmd BufNewFile,BufRead *.BUILD   set syntax=bzl

" Fix colors
let g:gruvbox_bold=0
set background=dark
colorscheme gruvbox
highlight YcmErrorLine ctermbg=052
highlight YcmErrorSign ctermbg=052
highlight YcmErrorSection ctermbg=052
highlight YcmWarningLine ctermbg=052
highlight YcmWarningSign ctermbg=052
highlight YcmWarningSection ctermbg=052
" highlight Search cterm=NONE ctermfg=grey ctermbg=054

" NeoVim adjusts
set guicursor=

" command JsonPretty %!jq
