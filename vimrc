set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936,gbk,gb2312,gb18030
source $VIMRUNTIME/vimrc_example.vim
try
        exec 'source '.fnamemodify($MYVIMRC,":p:h").'/wikicfg_vimrc'
        exec 'source '.fnamemodify($MYVIMRC,":p:h").'/personal_vimrc'
        exec 'source '.fnamemodify($MYVIMRC,":p:h").'/police_vimrc'
catch
endtry
exec 'source '.fnamemodify($MYVIMRC,":p:h").'/myscript/myautoload.vim'
exec 'source '.fnamemodify($MYVIMRC,":p:h").'/myscript/BufOnly.vim'
let mapleader = " "
let g:mapleader = " "
if has('win32') && has('win64')
    exec 'source '.fnamemodify($MYVIMRC,":p:h").'/win_vimrc'
endif
set guioptions=
"去除界面上所有东西
set showtabline=1
"只在需要时显示tabline
set relativenumber 
"设置相对行号
"vim的菜单乱码解决
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"vim提示信息乱码的解决
filetype on
filetype indent on
filetype plugin indent on
"colorscheme evening "配色方案
"colorscheme desert 
set helplang=cn "设置中文帮助
set history=500 "保留历史记录
set guifont=consolas:h14 "设置字体为Monaco，大小10
set gfw=幼圆:h14 "设置中文字体
set tabstop=4 "设置tab的跳数
set expandtab
set backspace=2 "设置退格键可用
set nu "设置显示行号
set wrap "设置自动换行
"set nowrap "设置不自动换行
set linebreak "整词换行，与自动换行搭配使用
"set list "显示制表符

set autochdir "自动设置当前目录为正在编辑的目录
set hidden "自动隐藏没有保存的缓冲区，切换buffer时不给出保存当前buffer的提示
set scrolloff=5 "在光标接近底端或顶端时，自动下滚或上滚
"Toggle Menu and Toolbar "隐藏菜单栏和工具栏
"set showtabline=2 "设置显是显示标签栏
set autoread "设置当文件在外部被修改，自动更新该文件
set mouse=a "设置在任何模式下鼠标都可用
set nobackup "设置不生成备份文件
"set go= "不要图形按钮
set noswapfile
"===========================
"查找/替换相关的设置
"===========================
set hlsearch "高亮显示查找结果
set incsearch "增量查找

"===========================
"状态栏的设置
"===========================
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%] "显示文件名：总行数，总的字符数
set ruler "在编辑过程中，在右下角显示光标位置的状态行

"===========================
"代码设置
"===========================
"syntax enable "打开语法高亮
syntax on "打开语法高亮
set showmatch "设置匹配模式，相当于括号匹配
set smartindent "智能对齐
"set shiftwidth=4 "换行时，交错使用4个空格
set autoindent "设置自动对齐
set ai! "设置自动缩进
"set cursorcolumn "启用光标列
set cursorline "启用光标行
set guicursor+=a:blinkon0 "设置光标不闪烁
"set fdm=indent "折叠模式

"==========================
"自动执行python,go,md
"==========================
nnoremap <F9> :call RunProgram()<cr>
nnoremap <F8> :call RunProgramInPrefix()<cr>
:noremap <F7> :AsyncRun gcc "%" -o "%<"<cr> 
"==========================
"插件定义
"==========================
call plug#begin(fnamemodify($MYVIMRC,":p:h").'/plugged')
if has('win32') && has('win64')
        Plug 'iamcco/markdown-preview.nvim',{ 'do': 'cd app & yarn install'  } "markdown预览
endif
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs' "自动括号插件
Plug 'vimwiki/vimwiki' "笔记插件
Plug 'skywind3000/asyncrun.vim' "异步插件
Plug 'vim-airline/vim-airline' "底部美化
Plug 'vim-airline/vim-airline-themes' "美化主题
Plug 'mattn/emmet-vim' " html补全插件 c-y,
Plug 'tpope/vim-surround' " 两边补符号插件 ds cs ys
Plug 'tpope/vim-fugitive' " git命令嵌入vim G
Plug 'Yggdroot/LeaderF',{ 'do': ':LeaderfInstallCExtension' }
Plug 'tpope/vim-repeat' " repeat
Plug 'sbdchd/neoformat' "format
Plug 'easymotion/vim-easymotion' "easymotion
Plug 'SirVer/ultisnips' " 代码片段
Plug 'honza/vim-snippets' "各种片段
Plug 'vim-latex/vim-latex' "latex
Plug 'altercation/vim-colors-solarized'
"Plug 'itchyny/lightline.vim'
"-------------------------------
"各种文本对象
"-------------------------------
Plug 'kana/vim-textobj-user' " 自己定制文本对象的插件
Plug 'kana/vim-textobj-entire' " 整个buff ae ie
Plug 'kana/vim-textobj-line' " 一行al il
Plug 'jceb/vim-textobj-uri' "uri au iu
Plug 'michaeljsmith/vim-indent-object' "缩进用ai ii aI iI
Plug 'jeetsukumaran/vim-pythonsense' "python用def class ac ic af if
"Plug 'glts/vim-textobj-comment' "注释文本对象,和下面的键位冲突
"Plug 'reedes/vim-textobj-sentence' "也是键位冲突,而且不知道怎么用
"Plug 'wellle/targets.vim' "留着观察
call plug#end()

"==========================
"键盘映射 kepmap
"==========================
nnoremap <c-h> <c-w><c-h> 
nnoremap <c-j> <c-w><c-j>                   
nnoremap <c-k> <c-w><c-k>                   
nnoremap <c-l> <c-w><c-l>                    
"改变当前目录为正在编辑文件的目录
nnoremap <silent><leader>. :cd %:p:h<cr>
"nmap <F5> :NERDTreeToggle<cr>
nmap <F5> :Explore<cr>
noremap! <c-b> <left>
noremap! <c-f> <right>
noremap! <c-e> <end>
noremap! <c-a> <home>
noremap <BS> :nohl<cr>
nnoremap <silent><leader>pp :set filetype=python<cr>
nnoremap <silent><leader>md :set filetype=markdown<cr>
nnoremap <silent><leader>wd :e d:\zhangbin\doc\strangeword.txt<cr>
nnoremap <silent><leader>my :e d:\zhangbin\doc\mothermedical.txt<cr>
nnoremap <silent><leader>yl :e ~\vimwiki\diary\yulu.md<cr>
tnoremap <c-n> <c-w>N
"翻译,前面需要pip install ici
"nnoremap <leader>y :!ici <C-R><C-W><CR>
"for fugitive
nnoremap <leader>gc :Gcommit <cr>
nnoremap <leader>gw :Gwrite <cr>
nnoremap <leader>gr :Gread <cr>
nnoremap <leader>ga :Git! add % <cr>
nnoremap <leader>gs :Gstatus <cr>
nnoremap <leader>gps :Gpush udisk dev <cr>
nnoremap <leader>gpl :Gpull udisk dev <cr>
"chrome
nnoremap <leader>ch :!start chrome<cr>
"leaderf
nnoremap <leader>fm :LeaderfMru<cr>
nnoremap <leader>fl :LeaderfLineAll<cr>
nnoremap <leader>fc :LeaderfHistoryCmd<cr>
nnoremap <leader>fs :LeaderfHistorySearch<cr>
nnoremap <leader>ft :LeaderfBufTagAll<cr>
nnoremap <leader>fn :exec "LeaderfFile ".fnamemodify($MYVIMRC,":p:h")."\\plugged\\vim-snippets\\"<cr>
"设置拼写检查
nnoremap <leader>sc :set spell!<cr>
"滚屏
nnoremap <M-u> :call Tools_PreviousCursor(0)<cr>
inoremap <M-u> <esc>:call Tools_PreviousCursor(0)<cr>a
nnoremap <M-d> :call Tools_PreviousCursor(1)<cr>
inoremap <M-d> <esc>:call Tools_PreviousCursor(1)<cr>a
"term发信息
nnoremap <silent><leader>ss :call Sent_term()<cr>
xnoremap <expr> <silent><leader>ss Sent_term()
nnoremap <silent><leader>ss :call Sent_term()<cr>
nnoremap <silent><leader><cr> :call Sent_cr()<cr>
xnoremap <expr> <silent><leader>ss Sent_term()
nnoremap <silent><leader>al :ALEToggle<cr>
nnoremap <leader>ls :call Fix_mkses_path() <cr>
"==========================
"ultisnips设定
"==========================
let g:UltiSnipsSnippetsDir= fnamemodify($MYVIMRC,":p:h").'/UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"==========================
"vim-latex设定
"==========================
let g:tex_flavor='latex'

"==========================
"leaderF设定
"==========================
let g:Lf_MruMaxFiles = 1000

"==========================
"asyncrun设定
"==========================
let asyncrun_encs = 'gbk'
"防止Asyncrun出现乱码
let g:asyncrun_status = ''
"for airline
"let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
"command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
"for fugitive Gpush Gfetch
"linux
"let g:asyncrun_exit = "silent call system('afplay ~/.vim/notify.wav &')"
"let g:asyncrun_exit = 'silent !start c:\users\administrator\vimfiles\win\playwav.exe "c:\users\administrator\vimfiles\win\sound_4.wav" 200'
"执行完毕播放声音

"==========================
"leaderf设置
"==========================
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'
let g:one_allow_italics = 1 " I love italic for comments
" set background=light " for the light version
"==========================
"markdown-preview.nvim设定
"==========================
let g:mkdp_browser = 'chrome'
"let g:mkdp_open_to_the_world = 1
"let g:mkdp_open_ip = '192.168.199.125'
"let g:mkdp_port = 8080
"open your markdown curren to the world!!!!!!!!!!
"function! g:Open_browser(url)
"    silent exe '!lemonade open 'a:url
"endfunction
"let g:mkdp_browserfunc = 'g:Open_browser'
"let g:mkdp_markdown_css='d:\tmp\bootstrap.css'

"==========================
"自己定义的配置
"==========================
nnoremap <silent><M-c> :call TaggleQuickWin()<cr>
inoremap <silent><M-c> <esc>:call TaggleQuickWin()<cr>
"绑定关闭quickfix窗口快捷键
nnoremap <M-o> :pclose<cr>
inoremap <M-o> <esc>:pclose<cr>a
"绑定关闭preview窗口快捷键
nnoremap <M-y> :let g:ycm_auto_trigger=0<cr>
nnoremap <M-Y>  :let g:ycm_auto_trigger=1<cr>
"切换是否开启ycm补全
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt=0
set completeopt=menu,menuone
"设置默认不开启proview窗口
nnoremap <M-s> :call Switchpreview()<cr>
"切换补ycm全时是否出现preview窗口
nnoremap <leader>cc "*yiw
"为了使用翻译软件少用几个按键和goldendict的ctrl-cc适应
" let g:XkbSwitchLib = '~\vimfiles\dll\libxkbswitch64.dll'
"切换中文输入法补丁（目前不能用）

"==========================
"all ab and iab
"==========================
iab xdate <c-r>=strftime("%Y年%m月%d日%H:%M:%S")<cr>
"插入时间 iab为插入模式下缩写
ab vimrc exec 'e '.fnamemodify($MYVIMRC,":p:h").'/vimrc'
"直接打开vimrc文件
ab ner NERDTree
"让打开目录快一些
ab ti tab term ipython
ab vi vert term ipython
" 快速打开ipython
ab ap AsyncRun python
" 异步执行python
ab xbase d:\zhangbin
ab xstd d:\zhangbin\code\mypractice
ab dtp d:\temp
"==========================
"myscript.vim
"==========================
nnoremap <F7> :call test#testecho() <cr>

"==========================
"other function
"==========================
"git ignore配置
command! InitGitignore call InitGitignore()
au BufRead,BufNewFile *.gitignore		set filetype=gitignore
autocmd BufNewFile .gitignore exec "call InitGitignore()"

" BrowserOpen: 打开文件或网址
command! -nargs=+ BrowserOpen call BrowserOpen(<q-args>)

"搜索vimwiki中的关键字
noremap <leader>sm  <Esc>:call Vimgrepsm()<CR>
noremap <leader>sw  <Esc>:call Vimgrepsw()<CR>
noremap <leader>sa  <Esc>:call Vimgrepsa()<CR>

"自动打开文件所在目录
noremap <silent> <F2> <Esc>:call FileExplore()<CR>
command! FileExplore call FileExplore()

"===========================
"各种文件类型设置
"===========================
"vue文件类型关联
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css sw=2
autocmd BufRead,BufNewFile *.html setlocal  sw=2
autocmd BufRead,BufNewFile *.go setlocal  sw=4
"===========================
"主题和各种界面设置
"===========================
set laststatus=2
if !has('gui_running')
    set t_Co=256
endif
let g:solarized_termcolors=256
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste'  ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified'  ]  ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#statusline'
    \ },
    \ }
set noshowmode
set background=dark
try
        colorscheme solarized
catch        
endtry        
"tmux的esc延迟设置
set ttimeout
if $TMUX !=''
        set ttimeoutlen=20
elseif &ttimeoutlen > 60 || &ttimeoutlen <= 0
        set ttimeoutlen=60
endif

if !has('win32') || !has('win64')
    exec "map \ec <M-c>"
    exec "map \ek <M-k>"
    exec "map \eu <M-u>"
    exec "map \ed <M-e>"
    exec "map \ed <M-e>"
    exec "map \eo <M-o>"
    exec "map \ey <M-y>"
    exec "map \es <M-s>"
endif
