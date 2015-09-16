"basic
set nocompatible
set encoding=utf-8
set fenc=utf-8
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set wrap
set number
set ruler
set clipboard+=unnamed  ",autoselect
set backupdir=~/Documents/Vimfiles/backupfiles
set directory=~/Documents/Vimfiles/backupfiles
set undodir=~/Documents/Vimfiles/backupfiles
set backup
set writebackup
set list                    " 不可視文字の可視化
set hlsearch
set incsearch
set undofile
set scrolloff=5
set cursorline
set showmatch
set matchtime=1             " 対応括弧のハイライト表示秒数
set infercase               " 補完時に大文字小文字を区別しない
set colorcolumn=80          " 80行目にラインを入れる
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲  " 不可視文字を代替
"hi CursorLine ctermbg=green 
syntax enable

" バッファファイルを切り替える
:noremap <C-n> bn<CR>
:noremap <C-p> bp<CR>

filetype plugin indent on
"Python
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4
"Ruby
autocmd FileType ruby setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
"Java
autocmd FileType java setl smartindent cinwords=public,if,else,swich,case,while,for,do,class,try,catch,finally
" Markdown
au BufRead,BufNewFile *.md set filetype=markdown    " ファイルタイプの設定
autocmd BufReadPost *.md setl nofoldenable      " 折りたたみを無効にする
" テンプレート
autocmd BufNewFile *.py 0r $HOME/Documents/Vimfiles/templates/template.py
autocmd BufNewFile *.html 0r $HOME/Documents/Vimfiles/templates/template.html

autocmd BufWritePre *:%s/\s\+$//ge  " 保存時に行末の空白を除去
autocmd BufWritePre *:%s/\t/ /ge    " 保存時にtabをスペースに変換する

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

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
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
" タブ拡張ここまで

"バイナリ編集(xxd)モード
"(vim -b での起動、もしくは *.binファイルを開くと発動します)
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoBundle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif
    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/')) " Required:
NeoBundleFetch 'Shougo/neobundle.vim' " Required:
" My Bundles here:
NeoBundle 'plasticboy/vim-markdown'     " markdownのシンタックスハイライト
NeoBundle 'kannokanno/previm'           " markdownのプレビュー
NeoBundle 'tyru/open-browser.vim'       " ブラウザでファイルを開く
NeoBundle 'tyru/caw.vim'                " コメントのトグル
NeoBundle 'othree/html5.vim'            " html.erbのオートインデント
NeoBundle 'tomasr/molokai'              " color scheme
NeoBundle 'sjl/badwolf'                 " color scheme
NeoBundle 'scrooloose/nerdtree'         " ツリー形式でディレクトリ構造を表示
"NeoBundle 'nathanaelkane/vim-indent-guides' " インデントに色を付けて見やすくする
NeoBundle 'Yggdroot/indentLine'         " インデント表示
NeoBundle 'mattn/emmet-vim'             " html補助
                                        " 構文チェッカーの結果をvimに表示する :SyntasticCheck :Errors
NeoBundle 'scrooloose/syntastic', {'build': {'others': 'pip install flake8'}}
NeoBundle 'vim-scripts/SearchComplete'  " 検索時にもタブで補完
NeoBundle 'rhysd/committia.vim'         " gitのcommitコメント補助
NeoBundle 'Shougo/neocomplete.vim'      " 補完
NeoBundle 'tpope/vim-surround'          " 囲う記号を操作する
NeoBundle 'wakatime/vim-wakatime'       " WakaTime
NeoBundle "davidhalter/jedi-vim", {
      \ "autoload": {
      \   "filetypes": ["python"],
      \ },
      \ "build": {
      \   "others": "pip install jedi",
      \ }}                              " 補完
call neobundle#end() " Required:
filetype plugin indent on
NeoBundleCheck
" -- Neobundle ----------------------------------------------------------
" tyru/open-browser.vim
let g:previm_open_cmd = 'open -a Google\ Chrome'    " :PrevimOpen でmarkdownのプレビュー
"tyru/caw.vim
nmap <Leader>c <Plug>(caw:i:toggle)     " gicでコメントアウト \cでコメント
vmap <Leader>c <Plug>(caw:i:toggle)     " giaで行末コメント追記 \cでコメント解除
" vim-indent-guides
" set background=dark
" let g:indent_guides_enable_on_vim_startup = 1
" hi IndentGuidesOdd  ctermbg=black
" hi IndentGuidesEven ctermbg=darkgrey
" indentLine
let g:indentLine_faster = 1
let g:indentLine_color_term = 239
" syntastic
let g:syntastic_python_checkers = ["flake8"]
" color scheme
syntax on
colorscheme badwolf
" jedi-vim
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
  " jediにvimの設定を任せると'completeopt+=preview'するので
  " 自動設定機能をOFFにし手動で設定を行う
  let g:jedi#auto_vim_configuration = 0
  " 補完の最初の項目が選択された状態だと使いにくいためオフにする
  let g:jedi#popup_select_first = 0
  autocmd FileType python setlocal omnifunc=jedi#completions    " ここからneocompleteとの競合を解決するための設定
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
  let g:neocomplete#force_omni_input_patterns.python = '\%([^.  \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
" -- powerline -------------------------------------------------------------------------
