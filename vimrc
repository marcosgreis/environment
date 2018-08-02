syntax on

let mapleader = ','

"set t_Co=256

set nocompatible
set backspace=2
set ruler
set laststatus=2

" auto-formating
set expandtab
set tabstop=4
set shiftwidth=4
set nu

map <F9> :!/usr/local/bin/clang-format<cr>
map <F10> mWggVG<F9>`Wzz<CR>

" tabs
nnoremap zc :tabnext<CR>
nnoremap zx :tabprev<CR>
nnoremap zn :tabedit

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

" no backup files
set nobackup
set nowb
set noswapfile

" set constants
let author = "Marcos Reis"

" Highlight search
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Plugins
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
"Plugin 'itchyny/lightline.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-commentary'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-fugitive'
call vundle#end()
filetype plugin indent on

" EasyMotion
map ff <Plug>(easymotion-f)
map FF <Plug>(easymotion-F)
map <Leader> <Plug>(easymotion-prefix)

" YCM
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_extra_conf_globlist = ['~/work/*']
nmap ;t :YcmCompleter GetType<CR>
nmap ;g :YcmCompleter GoTo<CR>
nmap ;u :YcmForceCompileAndDiagnostics<CR>
nmap ;r :YcmRestartServer<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" NERDTree configs
map za :NERDTreeToggle<CR>

" Lightline
let g:lightline = {
            \    'active': {
            \      'left': [['mode', 'paste'], ['filename', 'modified']],
            \      'right': [['lineinfo'], ['percent'], ['readonly']]
            \    },
            \    'component_type': {
            \      'readonly': 'error',
            \    }
            \}


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

" Fix colors
highlight YcmErrorLine ctermbg=052
highlight YcmErrorSign ctermbg=052
highlight YcmErrorSection ctermbg=052
highlight YcmWarningLine ctermbg=052
highlight YcmWarningSign ctermbg=052
highlight YcmWarningSection ctermbg=052
highlight Search ctermbg=178
