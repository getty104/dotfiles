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

  " 本体の設定
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc', { 'build': 'make' })

  " vimのpython環境をanacondaのものにする
  call dein#add('cjrh/vim-conda')

  " 自動補完機能
  if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
  endif

  " 括弧補完
  call dein#add('cohama/lexima.vim')

  " ステータスラインの表示内容強化
  call dein#add('itchyny/lightline.vim')

  " インデント可視化
  call dein#add('Yggdroot/indentLine')

  " 全角スペースの可視化
  call dein#add('thinca/vim-zenspace')

  " カラーテーマ
  call dein#add('crusoexia/vim-monokai')

  " Git系
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')

  " スニペット
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')

  " Unite系
  call dein#add('Shougo/unite.vim')

  " Codic系
  call dein#add('koron/codic-vim')
  call dein#add('rhysd/unite-codic.vim', {
        \ 'depends' : ['Shougo/unite.vim']
        \ })

  " Tag系
  call dein#add('tsukkee/unite-tag', {
        \ 'depends' : ['Shougo/unite.vim'],
        \ 'autoload' : {
        \   'unite_sources' : ['tag', 'tag/file', 'tag/include']
        \ }})

  call dein#add('soramugi/auto-ctags.vim')

  " Ruby, Rails系
  call dein#add('tpope/vim-rails', { 'autoload' : {'filetypes' : ['haml', 'ruby', 'eruby'] }})

  call dein#add('basyura/unite-rails', {
        \ 'depends' : ['Shougo/unite.vim'],
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

  " NERDTree
  call dein#add('scrooloose/nerdtree')

  " JS系
  call dein#add('pangloss/vim-javascript')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('maxmellon/vim-jsx-pretty',{
        \ 'depends' : ['pangloss/vim-javascript', 'leafgarland/typescript-vim']
        \ })

  " Solidity
  call dein#add('tomlion/vim-solidity')

  " Latex
  call dein#add('vim-latex/vim-latex')


  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" 補完系の設定
if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_complete_delay = 50
  let g:deoplete#auto_complete_start_length = 2
  let g:deoplete#enable_camel_case = 0
  let g:deoplete#enable_ignore_case = 0
  let g:deoplete#enable_refresh_always = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#file#enable_buffer_path = 1
  let g:deoplete#max_list = 5
  inoremap <expr><tab> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
  imap <C-c>     <Plug>(neosnippet_expand_or_jump)
  smap <C-c>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-c>     <Plug>(neosnippet_expand_target)
  imap <C-c>     <Plug>(neosnippet_expand_or_jump)

  " 自分用 snippet ファイルの場所
  let g:neosnippet#snippets_directory = '~/.vim/snippets/'
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
  let filename = expand('%:P') !=# '' ? expand('%:P') : '[No Name]'
  return filename
endfunction

" auto-ctag用の設定
set tags+=.git/tags
let g:auto_ctags = 1
let g:auto_ctags_directory_list = ['.git']
let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'

" indentLine用の設定
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#708090'

" NERDTree用の設定
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks=1
let NERDTreeWinSize=24
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Latex用の設定
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
let g:Tex_CompileRule_pdf = 'ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
let g:Tex_CompileRule_dvi = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_BibtexFlavor = 'upbibtex'
let g:Tex_MakeIndexFlavor = 'upmendex $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_pdf = 'Skim'
let g:Tex_AutoFolding = 1
let g:Imap_FreezeImap = 1

" カラースキーム
syntax on
colorscheme monokai
set t_Co=256

hi SpecialKey ctermbg=NONE ctermfg=240
hi LineNr ctermbg=NONE ctermfg=248
hi Normal ctermbg=NONE

" *******************ライブラリに依存しない設定*******************


function! RemoveDust()
  " 保存時に行末の空白を除去する
  %s/\s\+$//ge
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

if has("autocmd")
  augroup vimrc-checktime
    autocmd!
    autocmd WinEnter * checktime
  augroup END

  autocmd BufReadPost * call <SID>recovery_position()
  autocmd BufWritePre * call <SID>save_handler()
endif


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
set autoread

" ビープ音の停止
set noerrorbells
set vb t_vb=

" インデント設定
filetype plugin indent on

" エイリアス
command T  tabnew
command Uf Unite file
command Ut Unite tag
command Um Unite rails/model
command Uc Unite rails/controller
command Uv Unite rails/view
command Ur Unite rails/route
command Uh Unite rails/helper
command Ud Unite rails/db
command Uj Unite rails/job
command Ug Unite rails/bundled_gem
command Ucd Unite codic
command Em Emodel
command Ec Econtroller
command Ev Eview
command Eg Emigration
command Es Eschema
command Er Einitializer
command Gadd Gwrite
command B Bookmark

" normalキーマッピング
noremap <C-f> :call CodeFormat()<CR>
noremap <C-y> :%y<CR>
noremap <ESC><ESC> :noh<CR>
noremap <C-e> :NERDTreeToggle<CR>
