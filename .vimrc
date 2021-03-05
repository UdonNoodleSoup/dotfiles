"" Settings
" - VIM.
set termguicolors
let g:contrast_gruvbox_dark='hard'
:colorscheme gruvbox
set guifont='FiraCode_NF_SemiBold:h22'
set mouse=a
set clipboard=unnamedplus
set number! relativenumber!
set background=dark
set autoindent
scriptencoding utf-8
set encoding=utf-8
set shell=pwsh.exe
set shell=pwsh
set cmdheight=1
autocmd FileType help wincmd L
"" Statusline
func! VimMode() abort
    let md = mode()
    if md == 'n'
        return 'NORMAL'
    elseif md == 'v'
        return 'VISUAL'
    elseif md == 'i'
        return 'INSERT'
    elseif md == 't'
        return 'TERMINAL'
    elseif md == 'c'
        return 'COMMAND'
    else " check mode() help to define other mode names here
        return 'OTHER'
    endif
    
endfunc
set laststatus = '2'
set statusline=%{VimMode()}\ \\|
set statusline+=\ %F\ \\|
set statusline+=\ %y
set statusline+=%=
set statusline+=\ %m \ \\|
set statusline+=\ %l:%c\ \\| 
set statusline+=\ %{strftime('%b%d')}\ \\| 
set statusline+=\ %{strftime('%H:%M')}
"" Keyboard
nmap <silent><C-M-h> :PrimaryTerminalOpenSplit<CR>
nmap <silent><C-M-v> :PrimaryTerminalOpenVsplit<CR>
map / <Nop>
inoremap qq <Esc>
let mapleader = "/"
""" Toggle folds
nnoremap <silent> <leader><Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <leader><space> zf
""" AutoPair
inoremap { {}<ESC>ha
inoremap ( ()<ESC>ha
inoremap [ []<ESC>ha
inoremap < <><ESC>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha
"" Vim windows
""" resize horzontal split window
nmap <silent><M-Down> <C-W>-<C-W>-
nmap <silent><M-Up> <C-W>+<C-W>+
""" resize vertical split window
nmap <silent><M-Right> <C-W>><C-W>>
nmap <silent><M-Left> <C-W><<C-W><
""" window switching
nnoremap <silent><C-Up> <C-w>k
nnoremap <silent><C-Down> <C-w>j
nnoremap <silent><C-Right> <C-w>l
nnoremap <silent><C-Left> <C-w>h
""" Open new tiles
nmap <silent><C-h> :split<CR>
nmap <silent><C-v> :vsplit<CR>
""" new tab
nmap <silent><C-t> :tabedit <CR>
nmap <F2> :echo 'Current date and time are ' . strftime('%c')<CR>
"" Plugins
call plug#begin()
Plug 'https://github.com/bronzehedwick/vim-primary-terminal'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/dense-analysis/ale'
Plug 'https://github.com/tpope/vim-sleuth'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/godlygeek/csapprox'
Plug 'pprovost/vim-ps1'
Plug 'https://github.com/easymotion/vim-easymotion'
call plug#end()

"" Ale config
let g:ale_sign_error                  = '✘'
let g:ale_sign_warning                = '⚠'
highlight ALEErrorSign ctermbg        =NONE ctermfg=red
highlight ALEWarningSign ctermbg      =NONE ctermfg=yellow
let g:ale_linters_explicit            = 1
let g:ale_lint_on_text_changed        = 'never'
let g:ale_lint_on_enter               = 0

let g:ale_fixers = {
\	'*': ['remove_trailing_lines','trim_whitespace'],
\	'haskell': ['stylish-haskell'],
\	'lua': ['luac'],
\	'markdown': ['proselint'],
\	'powershell': ['powershell'],
\}
let g:ale_completion_enabled = 1
"" Fuzzy search
let g:fzf_layout = { 'down': '50%'}
nnoremap <silent> ,<space> :FZF~ <CR>

"" Easymotion conf
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
"" Folding
""" defines a foldlevel for each line of code
function! VimFolds(lnum)
  let s:thisline = getline(a:lnum)
  if match(s:thisline, '^"" ') >= 0
    return '>2'
  endif
  if match(s:thisline, '^""" ') >= 0
    return '>3'
  endif
  let s:two_following_lines = 0
  if line(a:lnum) + 2 <= line('$')
    let s:line_1_after = getline(a:lnum+1)
    let s:line_2_after = getline(a:lnum+2)
    let s:two_following_lines = 1
  endif
  if !s:two_following_lines
      return '='
    endif
  else
    if (match(s:thisline, '^"""""') >= 0) &&
       \ (match(s:line_1_after, '^"  ') >= 0) &&
       \ (match(s:line_2_after, '^""""') >= 0)
      return '>1'
    else
      return '='
    endif
  endif
endfunction

""" defines a foldtext
function! VimFoldText()
  " handle special case of normal comment first
  let s:info = '('.string(v:foldend-v:foldstart).' l)'
  if v:foldlevel == 1
    let s:line = ' ◇ '.getline(v:foldstart+1)[3:-2]
  elseif v:foldlevel == 2
    let s:line = '   ●  '.getline(v:foldstart)[3:]
  elseif v:foldlevel == 3
    let s:line = '     ▪ '.getline(v:foldstart)[4:]
  endif
  if strwidth(s:line) > 80 - len(s:info) - 3
    return s:line[:79-len(s:info)-3+len(s:line)-strwidth(s:line)].'...'.s:info
  else
    return s:line.repeat(' ', 80 - strwidth(s:line) - len(s:info)).s:info
  endif
endfunction

""" set foldsettings automatically for vim files
augroup fold_vimrc
  autocmd!
  autocmd FileType vim
                   \ setlocal foldmethod=expr|
                   \ setlocal foldexpr=VimFolds(v:lnum) |
                   \ setlocal foldtext=VimFoldText() |
                   \ set foldcolumn=2 foldminlines=2

