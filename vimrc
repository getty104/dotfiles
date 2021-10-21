set encoding=utf-8
set fileformats=unix,dos,mac
set fileencoding=utf-8
scriptencoding utf-8

" 起動したら必ず走らせるスクリプト
call system("git branch -d $(git branch --merged | grep -v master | grep -v '*')")

if has('python3')
  silent! python3 1
endif

let s:dein_dir = expand('~/.vim/dein')
let s:toml_dir = s:dein_dir . '/toml/dein.toml'
let s:lazy_toml_dir = s:dein_dir . '/toml/dein_lazy.toml'

" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_dir,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml_dir, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

syntax on
colorscheme monokai
set t_Co=256

hi SpecialKey ctermbg=NONE ctermfg=240
hi LineNr ctermbg=NONE ctermfg=248
hi Comment ctermbg=NONE ctermfg=244
hi Normal ctermbg=NONE


" *******************ライブラリに依存しない設定*******************


function! RemoveDust()
  if (&ft!='markdown')
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
  endif

  " 保存時にtabを2スペースに変換する
  %s/\t/  /ge
endfunction

" 定位置でのコード整形
function! CodeFormat()
  let cursor = getpos(".")
  exe "normal! gg=G"
  call setpos(".", cursor)
  unlet cursor
endfunction

" 現在位置を変更せずに関数を実行する
function! s:save_handler()
  let cursor = getpos(".")
  call RemoveDust()
  call setpos(".", cursor)
  unlet cursor
endfunction

" 最後のカーソル位置を復元する
function! s:recovery_position()
  if line("'\"") > 0 && line ("'\"") <= line("$") |
    exe "normal! g'\""
  endif
endfunction

augroup vimrc-checktime
  autocmd!
  autocmd CursorHold * checktime
augroup END

augroup handler
  autocmd!
  autocmd BufReadPost * call <SID>recovery_position()
  autocmd BufWritePre * call <SID>save_handler()
augroup END

" grepするとquickfix-windowを自動でだす
autocmd QuickFixCmdPost *grep* cwindow

" コマンドラインに使われる画面上の行数
set cmdheight=1

" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2

" 現在のモードを表示
set showmode

" カーソルが何行目の何列目に置かれているかを表示する
set ruler

" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title

" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu

" 保存するコマンド履歴の数
set history=5000

" 検索結果をハイライト表示する
set hlsearch

" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch

" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden

" 行番号を表示する
set number

" 対応する括弧やブレースを表示する
set showmatch

" 改行時に前の行のインデントを継続する
set autoindent

" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent

" タブをスペースに変換
set expandtab

" タブ文字の表示幅
set tabstop=2

" Vimが挿入するインデントの幅
set shiftwidth=2

" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab

" 不可視文字を表示する
set list

" □や○文字が崩れる問題を解決
set ambiwidth=double

" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<

" タブを >- 半スペを . で表示する
set listchars=tab:>-,trail:･

" クリップボードを使わせる
set clipboard=unnamed

" 削除キーの有効化
set backspace=indent,eol,start

" swapファイルを作成しない
set noswapfile

" backupファイルを作成しない
set nobackup

" ファイルを自動リロード
" set autoread

" 更新の時間
" set updatetime=6000
" ビープ音の停止
set noerrorbells
set vb t_vb=

" インデント設定
filetype plugin indent on

" エイリアス
command T  tabnew

" normalキーマッピング
noremap <C-f> :call CodeFormat()<CR>
noremap <C-y> :%y<CR>
noremap <ESC><ESC> :noh<CR>
noremap r :e!<CR>
vnoremap p "0p
