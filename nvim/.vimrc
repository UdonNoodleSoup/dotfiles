"" Basic settings
" - Vim.
let g:gruvbox_contrast_light = 'soft'
colorscheme gruvbox
set guifont=InputMono-Medium:h13
set mouse=a
set clipboard=unnamedplus
set number! relativenumber!
set background=light
set cmdheight=1
set autoindent
"" Keyboard
nnoremap <silent> /<space> :nohlsearch<CR>
nmap <silent><C-M-h> :PrimaryTerminalOpenSplit<CR>
nmap <silent><C-M-v> :PrimaryTerminalOpenVsplit<CR>
let mapleader = "\<space>"
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
" terminal
Plug 'https://github.com/bronzehedwick/vim-primary-terminal'
" File search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Linting
Plug 'https://github.com/dense-analysis/ale'
" Whitespace
Plug 'https://github.com/tpope/vim-sleuth'
call plug#end()

"" Ale config
let g:ale_fixers = {
\	'*': ['remove_trailing_lines','trim_whitespace'],
\	'haskell': ['stylish-haskell'],
\	'lua': ['luac'],
\	'markdown': ['write-good'],
\	'powershell': ['powershell'],
\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
"" Fuzzy search
let g:fzf_layout = { 'down': '50%'}
nnoremap <silent> ,<space> :FZF~ <CR>
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
