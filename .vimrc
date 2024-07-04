set   ambiwidth=double
set   autoindent
set   background=dark
set   backspace=indent,eol,start
set nobackup
"set   cindent
set   cinoptions+=:0
set   cmdheight=1
"set   cscopetag
set   cscopetagorder=1
set nocscopeverbose
set   cursorline
set   directory=/tmp
set noerrorbells
set   fileencodings=utf-8,eucjp-ms,cp932,iso-2022-jp-3,ucs-bom,default,latin1
set   fileformats=unix,dos,mac
"set   foldclose=all
"set   foldmethod=manual
set   formatoptions=mMcroql
set   grepprg=ag\ --no-heading
set   guioptions+=a
set   guioptions+=f
set   guioptions-=T
set   hlsearch
set   iminsert=0
set   imsearch=0
set   infercase
set   ignorecase
set noincsearch
set   laststatus=2
set   list
set   listchars=tab:>-,trail:-
set   matchpairs+=<:>
set   modeline
set   number
"set   paste
set   report=1
set   restorescreen
set   ruler
"set   shortmess+=I
set   shortmess=aoOTI
set   showcmd
set   showmatch
set   showmode
set   smartcase
set   smartindent
set noswapfile
set   splitbelow
set   splitright
set   statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set   t_vb=
set   tabpagemax=99
set   tags+=tags;,.tags;
set   viminfo=
set novisualbell
set   whichwrap=b,s,h,l,<,>,~,[,]
set   wildmenu
set   wildmode=list:full
set   wrap
set   writebackup
set nowrapscan

syntax enable

if $TERM == "xterm-256color"
  colorscheme default
else
  colorscheme evening
endif

imap <C-H> <BS>
imap <Nul> <Nop>
vmap g<CR> y/<C-R>"<CR>
nnoremap <C-L> :noh<CR><C-L>
nnoremap gn gt
nnoremap gp gT
nnoremap <S-tab> gt
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
nnoremap :sp :bel<Space>sp
nmap <c-w><c-h> <c-w>h
nnoremap H H0
nnoremap M M0
nnoremap L L0
"nnoremap <C-g><C-f> :Gtags -f %<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>
nnoremap <C-k><C-f> :Gtags -f %<CR>
nnoremap <expr> <C-k><C-r> ':Gtags -r ' . expand("<cword>") . '<CR>'
nnoremap <expr> <C-k><C-]> ':Gtags ' . expand("<cword>") . '<CR>'
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
"inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
nnoremap <silent><expr> * v:count ? '*'
\ : ':sil exe "keepj norm! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'

"au BufEnter * execute ":lcd " . expand("%:p:h")
au BufEnter * if &buftype != "terminal" | execute ":lcd " . expand("%:p:h") | endif

au FileType c,cpp set sw=4 ts=4 et lcs=tab:>-
au FileType c,cpp nnoremap [f my[[?(<CR>:let l=line(".")<CR>:let f=getline(".")<CR>:nohl<CR>`y:delm y<CR>:echo l . "\t" . f<CR>
au FileType java nnoremap [f my[m?(<CR>:let l=line(".")<CR>:let f=getline(".")<CR>:nohl<CR>`y:delm y<CR>:echo l . f<CR>
au FileType java set sw=4 ts=4 et
au FileType make set sw=8 ts=8 noet
au FileType perl set sw=4 ts=4
au FileType stp  set sw=4 ts=4 et
au FileType go set sw=4 ts=4 lcs=tab:\ \ 
"au BufEnter *.py setlocal indentkeys+=0#
au FileType python setlocal nosmartindent
au FileType yaml setlocal indentkeys-=0#

au QuickFixCmdPost *grep*,make cwindow

augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END


filetype plugin indent on


"
" netrw
"
" hide header
let g:netrw_banner=0
" tree view
"let g:netrw_liststyle=3


"
" cscope
"
if has("cscope")
    if filereadable(".cscope.out")
        cs add .cscope.out
    else
        let cscope_file=findfile(".cscope.out", ".;")
        if !empty(cscope_file) && filereadable(cscope_file)
            exe "cs add" cscope_file
        endif
    endif
    set csre
endif
function! CsFindC()
    let cscope_file=findfile(".cscope.out", ".;")
    let cscope_base=fnamemodify(cscope_file, ":p:h")
    exe "lcd " . cscope_base
    exe "cs find c <cword>"
    exe "lcd " . expand("%:p:h")
endfunction
function! CsFindS()
    let cscope_file=findfile(".cscope.out", ".;")
    let cscope_base=fnamemodify(cscope_file, ":p:h")
    exe "lcd " . cscope_base
    exe "cs find s <cword>"
    exe "lcd " . expand("%:p:h")
endfunction
function! CsReload()
    exe "cs kill -1"
    let cscope_file=findfile(".cscope.out", ".;")
    if !empty(cscope_file) && filereadable(cscope_file)
        exe "cs add" cscope_file
    endif
endfunction

" Called
nnoremap <expr> <C-\>  ':cs f c ' . expand("<cword>") . '<CR>'
" Symbols
nnoremap <expr> g<C-\> ':cs f s ' . expand("<cword>") . '<CR>'
" Definition
nnoremap <expr> d<C-\> ':cs f g ' . expand("<cword>") . '<CR>'
" reload
nnoremap <Leader>cs :call CsReload()<CR>


"
" 挿入モード時、ステータスラインの色を変更
"
"let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
"
"if has('syntax')
  augroup InsertHook
    autocmd!
"    autocmd InsertEnter * call s:StatusLine('Enter')
"    autocmd InsertLeave * call s:StatusLine('Leave')
    autocmd InsertEnter * highlight StatusLine ctermfg=yellow ctermbg=black
    autocmd InsertLeave * highlight StatusLine ctermfg=white ctermbg=black
  augroup END
"endif


"
" Tab page & tab line
"
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
"    let no = i - 1 " display 0-origin tabpagenr.
    let no = i  " display 1-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '(+) ' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
"    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
"    let s .= '%#TabLineFill# '
"    let s .= ' '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示


"
" 現在のファイルにある関数の一覧を表示する
"
function! Navi()
  if &ft ==? "c" || &ft ==? "cpp"
    vimgrep /^[^ \t#/\\*]\+[0-9A-Za-z_ :\t\\*]\+([^;]*$/j %
  elseif &ft ==? "lisp"
    " defun のみ検索
    vimgrep /^[ \t]*(defun[ \t]\+.*$/j %
    " Emacs Lisp (defvar なども検索)
    "vimgrep /^[ \t]*(defun[ \t]\+.*$/j %
  elseif &ft ==? "perl"
    vimgrep /^[ \t]*sub[ \t]\+.*$/j %
  elseif &ft ==? "ruby"
    vimgrep /^[ \t]*\(class\|module\|def\|alias\)[ \t]\+.*$/j %
  elseif &ft ==? "python"
    vimgrep /^[ \t]*\(class\|def\)[ \t]\+.*$/j %
  elseif &ft ==? "javascript"
    vimgrep /^[ \t]*function[ \t]\|[a-zA-Z_$][a-zA-Z0-9_$]*[ \t]*[=:][ \t]*function[ \t]*(/j %
  elseif &ft ==? "sh"
    vimgrep /^[ \t]*\(\h\w*[ \t]*()\|function[ \t]\+\h\w*\)/j %
  elseif &ft ==? "html"
    vimgrep /\c^\([ \t]*<h[123456].*\|[ \t]*<head.*\|[ \t]*<body.*\|[ \t]*<form.*\)$/j %
  elseif &ft ==? ""
    "Text (「1.」型の箇条書き)
    vimgrep /^[ \t]*[1234567890]\+[\.]\+.*$/j %
  elseif &ft ==? "tex"
    vimgrep /^\(\\chapter.*\|\\section.*\|\\subsection.*\|\\subsubsection.*\)$/j %
  elseif &ft ==? "pascal"
    vimgrep /\c^procedure.*$/j %
  elseif &ft ==? "java"
    vimgrep /^[ \t]*[^#/\*=]\+[0-9a-zA-Z_ \t\*,.()]\+{[^;]*$/j %
  elseif &ft ==? "vb"
    vimgrep /\c^\(private\|public\|sub\|function\)[ \t]\+.*$/j %
  elseif &ft ==? "diff"
    "diff (unified format)
    vimgrep /^@@[0-9 \t,+-]\+@@$/j %
  else
    echo "This filetype is not supported."
  endif
  cw
endfunction
