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
" Plugin 'ervandew/supertab'
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-commentary'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-fugitive'
Plugin 'itchyny/lightline.vim'
Plugin 'morhetz/gruvbox'
Plugin 'r0mai/vim-djinni'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/vim-peekaboo'

" - Experimental
Plugin 'kevalin/mermaid.nvim'
" Plugin 'neovim/nvim-lspconfig'

call vundle#end()
filetype plugin indent on

" Kotlin LSP: brew install JetBrains/utils/kotlin-lsp
" Use Neovim's built-in client; only start in Gradle projects.
if has('nvim-0.11') && executable('kotlin-lsp')
lua << EOF
vim.lsp.config('kotlin_lsp', {
  cmd = { 'kotlin-lsp', '--stdio' },
  filetypes = { 'kotlin' },
  root_markers = {
    { 'settings.gradle', 'settings.gradle.kts' },
    { 'build.gradle', 'build.gradle.kts' },
  },
  workspace_required = true,
  handlers = {
    ['window/logMessage'] = function(err, message, ctx, config)
      vim.lsp.handlers['window/logMessage'](err, message, ctx, config)
      if message and message.type == vim.lsp.protocol.MessageType.Error then
        vim.notify('Kotlin LSP: ' .. message.message, vim.log.levels.ERROR)
      end
    end,
  },
})
vim.api.nvim_create_user_command('KotlinLspReload', function()
  vim.lsp.enable('kotlin_lsp', false)
  -- enable(false) only stops initialized clients on Neovim 0.12.
  for _, client in ipairs(vim.lsp.get_clients({ name = 'kotlin_lsp', _uninitialized = true })) do
    if not client.initialized then
      client:stop(true)
    end
  end
  local stopped = vim.wait(5000, function()
    return #vim.lsp.get_clients({ name = 'kotlin_lsp', _uninitialized = true }) == 0
  end, 100)
  if not stopped then
    vim.notify('Kotlin LSP did not stop; retry :KotlinLspReload', vim.log.levels.ERROR)
    return
  end
  vim.lsp.enable('kotlin_lsp')
end, { desc = 'Restart Kotlin LSP and reimport the Gradle project' })
EOF
command! KotlinLspLog lua vim.cmd.vsplit(vim.lsp.log.get_filename())
endif

set runtimepath+=~/.vim/my-snippets/

" auto-formating
set nocompatible
set backspace=2
set ruler
set laststatus=2

set expandtab
set tabstop=2
set shiftwidth=2
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
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_extra_conf_globlist = ['~/*']
" let g:ycm_global_ycm_extra_conf = '~/work/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/bazel-compilation-database/.ycm_extra_conf.py'
" nmap ;t :YcmCompleter GetType<CR>
" nmap ;g :YcmCompleter GoTo<CR>
" nmap ;u :YcmForceCompileAndDiagnostics<CR>
" nmap ;r :YcmRestartServer<CR>
" nmap ;f :YcmCompleter FixIt<CR>
" nmap ;e :YcmDiags<CR>

" make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" make YCM compatible with peekaboo
" let g:ycm_filetype_blacklist = {
"    \    'peekaboo': 1,
"    \    'notes': 1,
"    \    'markdown': 1,
"    \    'netrw': 1,
"    \    'unite': 1,
"    \    'pandoc': 1,
"    \    'tagbar': 1,
"    \    'mail': 1,
"    \    'vimwiki': 1,
"    \    'text': 1,
"    \    'infolog': 1
"    \}


" better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" My snippets

" NERDTree configs
map za :NERDTreeToggle<CR>

" Lightline
let g:lightline = {
            \    'active': {
            \      'left': [['mode', 'paste'], ['relativepath', 'modified']],
            \      'right': [['lineinfo'], ['percent'], ['readonly'], ['filetype']]
            \    },
            \}

if has('nvim-0.11')
lua << EOF
function _G.KotlinLspStatus()
  if vim.bo.filetype ~= 'kotlin' then
    return ''
  end
  local client = vim.lsp.get_clients({ bufnr = 0, name = 'kotlin_lsp', _uninitialized = true })[1]
  if not client then
    return 'Kotlin: not attached'
  end
  if not client.initialized then
    return 'Kotlin: starting'
  end
  -- Pending tasks persist between reports, unlike vim.lsp.status() messages.
  local tasks = vim.tbl_values(client.progress.pending)
  table.sort(tasks)
  -- Idle means no reported work, not necessarily a successful import.
  return 'Kotlin: ' .. (#tasks > 0 and table.concat(tasks, ', ') or 'idle')
end

vim.api.nvim_create_autocmd({ 'LspProgress', 'LspAttach', 'LspDetach' }, {
  group = vim.api.nvim_create_augroup('KotlinLspStatus', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'kotlin_lsp' then
      vim.schedule(function()
        vim.cmd.redrawstatus()
      end)
    end
  end,
})
EOF
let g:lightline.component_function = {'kotlin_lsp': 'v:lua.KotlinLspStatus'}
call add(g:lightline.active.left, ['kotlin_lsp'])
endif

" Commentary
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Fuzzy finder
nmap ;; :Files<CR>
nmap ;b :Buffer<CR>
set rtp+=/opt/homebrew/bin/fzf
set rtp+=~/.fzf

" Quick fix window
nmap ;l :cnext<CR>
nmap ;k :cprev<CR>

" Quick search under cursor
nmap ;s :Rg <cword><CR>

" Force highlights
autocmd BufNewFile,BufRead *.mm   set syntax=objcpp
autocmd BufNewFile,BufRead *.BUILD   set syntax=bzl

" Fix colors
let g:gruvbox_bold=0
set background=dark
colorscheme gruvbox
" highlight YcmErrorLine ctermbg=052
" highlight YcmErrorSign ctermbg=052
" highlight YcmErrorSection ctermbg=052
" highlight YcmWarningLine ctermbg=052
" highlight YcmWarningSign ctermbg=052
" highlight YcmWarningSection ctermbg=052
" highlight Search cterm=NONE ctermfg=grey ctermbg=054

" NeoVim adjusts
set guicursor=

" command JsonPretty %!jq

" disable mouse
set mouse=

" Optional machine-local configuration, loaded before starting language servers.
if filereadable(expand('~/.vimrc.extra'))
  source ~/.vimrc.extra
endif

if has('nvim-0.11') && executable('kotlin-lsp')
  lua vim.lsp.enable('kotlin_lsp')
endif

" BEGIN optional LSP navigation bindings — remove this whole block to revert.
" gd: definition | grr: references | gi: implementation | gh: documentation
" Overrides normal-mode gi (last insert position) in LSP-attached buffers.
if has('nvim-0.11')
lua << EOF
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('OptionalLspNavigation', { clear = true }),
  callback = function(event)
    local function map(key, action, description)
      vim.keymap.set('n', key, action, {
        buffer = event.buf, silent = true, desc = description,
      })
    end
    map('gd', vim.lsp.buf.definition, 'LSP: go to definition')
    map('grr', vim.lsp.buf.references, 'LSP: find references')
    map('gi', vim.lsp.buf.implementation, 'LSP: go to implementation')
    map('gh', vim.lsp.buf.hover, 'LSP: hover documentation')
  end,
})
EOF
endif
" END optional LSP navigation bindings.
