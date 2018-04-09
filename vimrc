set encoding=utf-8
scriptencoding utf-8

let s:dein_dir = expand('~/.vim/dein')

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
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})

" 自動補完機能
  if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    elseif has('lua')
      call dein#add('Shougo/neocomplete.vim')
    endif
  endif

  call dein#add('Shougo/neco-vim')
  call dein#add('Shougo/neco-syntax')

" 括弧補完
  call dein#add('cohama/lexima.vim')

" ステータスラインの表示内容強化
  call dein#add('itchyny/lightline.vim')

" インデント可視化
  call dein#add('Yggdroot/indentLine')

" カラーテーマ
  call dein#add('tomasr/molokai')

" Git系
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')

" スニペット
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')

" Unite系
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimproc')

" Tag系
  call dein#add('tsukkee/unite-tag', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload' : {
      \   'unite_sources' : ['tag', 'tag/file', 'tag/include']
      \ }})

  call dein#add('soramugi/auto-ctags.vim')

" Ruby, Rails系
  call dein#add('alpaca-tc/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }})

  call dein#add('tpope/vim-rails', { 'autoload' : {'filetypes' : ['haml', 'ruby', 'eruby'] }})

  call dein#add('basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : [
      \     'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \     'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \     'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \     'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \     'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \     'rails/stylesheet', 'rails/view'
      \   ]
      \ }})


" 設定終了
  call dein#end()
  call dein#save_state()
endif

if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
elseif dein#tap('neocomplete.vim')
  let g:neocomplete#enable_at_startup = 1
endif

" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

function! s:remove_dust()
  let cursor = getpos(".")
" 保存時に行末の空白を除去する
  %s/\s\+$//ge
" 保存時にtabを2スペースに変換する
  %s/\t/  /ge
  call setpos(".", cursor)
  unlet cursor
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    autocmd BufWritePre * call <SID>remove_dust()
  augroup END
  call ZenkakuSpace()
endif

" 最後のカーソル位置を復元する
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" lightline用の設定
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'fugitive#head',
      \   'filename': 'LightlineFilename'
      \ },
      \ }

function! LightlineFilename()
  let filename = expand('%:p') !=# '' ? expand('%:p') : '[No Name]'
  return filename
endfunction

" auto-ctag用の設定
let g:auto_ctags = 1
let g:auto_ctags_directory_list = ['.git', '.svn']
let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
let g:auto_ctags_tags_name = '.tags'

" indentLine用の設定
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#708090'

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" コマンドラインに使われる画面上の行数
set cmdheight=2

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

" 検索結果をハイライト表示する
set hlsearch

" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch

" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden

" 不可視文字を表示する
set list

" □や○文字が崩れる問題を解決
set ambiwidth=double

" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<

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

" コマンドモードの補完
set wildmenu

" 保存するコマンド履歴の数
set history=5000

" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" 不可視文字を表示する
set list

" タブを >--- 半スペを . で表示する
set listchars=tab:>-,trail:･

" クリップボードを使わせる
set clipboard=unnamed,autoselect

" 削除キーの有効化
set backspace=indent,eol,start

" カラースキーム
colorscheme molokai
syntax on
set t_Co=256
set termguicolors
hi SpecialKey guibg=NONE guifg=Gray40
hi LineNr guifg=Gray70
