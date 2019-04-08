source $VIMRUNTIME/vimrc_example.vim
if has('win32') && has('win64')
        behave mswin
        noremap <f11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
        noremap <f12> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleTransparency', "247,180")<cr>
        "全屏和透明窗体,需要gvim_fullscreen.dll支持
endif

set guioptions=
"去除界面上所有东西
set showtabline=1
"只在需要时显示tabline

let mapleader = ','
let g:mapleader = ','
"修改leaderkey

set relativenumber 
"设置相对行号
"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg1 = substitute(arg1, '!', '\!', 'g')
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg2 = substitute(arg2, '!', '\!', 'g')
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let arg3 = substitute(arg3, '!', '\!', 'g')
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      if empty(&shellxquote)
"        let l:shxq_sav = ''
"        set shellxquote&
"      endif
"      let cmd = '"' . $VIMRUNTIME . '\diff"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  let cmd = substitute(cmd, '!', '\!', 'g')
"  silent execut '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
"  if exists('l:shxq_sav')
"    let &shellxquote=l:shxq_sav
"  endif
"endfunction

"设置文件的代码形式 utf8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936
"vim的菜单乱码解决
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"vim提示信息乱码的解决
language messages zh_CN.utf-8
filetype on
filetype plugin indent on
"colorscheme evening "配色方案
colorscheme desert
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
syntax enable "打开语法高亮
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
"自动执行python
"==========================
nnoremap <F9> :call RunPython()<cr>
nnoremap <F8> :call CompileRunGcc()<cr>

func! CompileRunGcc()
          exec "w"
          if &filetype == 'markdown' || &filetype == 'vimwiki'
                  exec    "MarkdownPreview"
          endif
          if &filetype == 'python'
                  if search("@profile")
                          exec "AsyncRun kernprof -l -v %"
                          exec "copen"
                          exec "wincmd p"
                  elseif search("set_trace()")
                          exec "!python %"
                  else
                          exec "AsyncRun -raw python %"
                          exec "copen"
                          exec "wincmd p"
                  endif
          endif

endfunc

func! RunPython()
        exec "w"
        if &filetype == 'python'
                exec "!python %"
        endif
endfunc

"==========================
"插件定义
"==========================
call plug#begin('~/vimfiles/plugged')
Plug 'iamcco/markdown-preview.nvim',{ 'do': 'cd app & yarn install'  } 
"markdown预览
Plug 'scrooloose/nerdtree' "目录树插件
Plug 'jiangmiao/auto-pairs' "自动括号插件
Plug 'sillybun/vim-repl' "自动括号插件
Plug 'Valloric/YouCompleteMe' "自动补全插件
Plug 'vimwiki/vimwiki' "笔记插件
Plug 'skywind3000/asyncrun.vim' "异步插件
Plug 'vim-airline/vim-airline' "底部美化
Plug 'vim-airline/vim-airline-themes' "美化主题
Plug 'mattn/emmet-vim' " html补全插件 c-y,
Plug 'tpope/vim-surround' " 两边补符号插件 ds cs ys
Plug 'tpope/vim-fugitive' " git命令嵌入vim G
Plug 'Yggdroot/LeaderF',{ 'do': '.\install.bat' } " leaderf
call plug#end()

"==========================
"键盘映射
"==========================

nmap <F5> :NERDTreeToggle<cr>
noremap! <c-b> <left>
noremap! <c-f> <right>
noremap! <c-e> <end>
noremap! <c-a> <home>
noremap <BS> :nohl<cr>
"翻译,前面需要pip install ici
"nnoremap <leader>y :!ici <C-R><C-W><CR>
"noremap! <caps lock> <esc>
"绑定搜索vimwiki diary的主题
nnoremap <leader>w<leader>s :vimgrep /<C-R><C-W>/j ~/vimwiki/diary/*.wiki <cr>




"==========================
"python调试插件REPL插件设定 
"==========================
nnoremap <a-r> :REPLToggle<Cr>
let g:repl_width = 0
let g:repl_height = 0
let g:sendtorepl_invoke_key = "<a-w>"
let g:repl_position = 0
let g:repl_stayatrepl_when_open = 0

"nnoremap <c-h> <c-w><c-h> "精简分屏模式下移动方式快捷键
"nnoremap <c-j> <c-w><c-j>                   
"nnoremap <c-k> <c-w><c-k>                   
"nnoremap <c-l> <c-w><c-l>                    

let g:repl_program = {
    \ "python": "ipython",
    \ "default": "bash"
    \  }

let g:repl_exit_commands = {
                        \ "ipython":"quit()<cr>",
                        \ "bash":"exit",
                        \ "zhs":"exit",
                        \ "default":"exit",
                        \ }



"==========================
"ycm插件设定
"==========================
                        
let g:ycm_server_python_interpreter="C:\\ProgramData\\Anaconda3\\Python.exe"
"let g:ycm_server_python_interpreter="C:\\Program Files\\python37\\Python.exe"
let g:ycm_global_ycm_extra_conf="~\\vimfiles\\bundle\\YouCompleteMe\\.ycm_extra_conf.py"
"let g:ycm_key_invoke_completion='<c-z>' 
"设置基于语义补全的快捷键
let g:ycm_semantic_triggers={
                      \ 'python,javascript,cs':['re!\w{2}'],
                      \ }
"设置激活自动补全的符号，这里设置输入前两个字符就自动弹出
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black
"设置补全弹出框的颜色
nnoremap <leader>jd :YcmCompleter GoTo<CR>
"ycm的跳转到定义
"set completeopt=menu,menuone
"let g:ycm_add_preview_to_completeopt=0
"取消补全中显示函数详细信息的补全设置
"let g:ycm_filetype_whitelist = {
"                \"python":1,
"                \"javascript":1,
"                \"html":1,
"                \}
"设置补全白名单

"==========================
"vimwiki设置
"==========================
"let g:vimwiki_list = [{'path': '~/my_diary/', 'path_html': '~/my_diary_html/'},
"                     \{'path': '~/my_wiki/', 'path_html': '~/my_wiki_html/'}]
let g:vimwiki_list = [{'path': '~/vimwiki/',
                          \ 'syntax': 'markdown', 'ext': '.md'}]
"使用markdown方式记录wiki
map <Leader>tt <Plug>VimwikiToggleListItem
"Todo快捷键


"==========================
"自己定义的配置
"==========================
let asyncrun_encs = 'gbk'
"防止Asyncrun出现乱码
nnoremap <silent><M-c> :call TaggleQuickWin()<cr>
inoremap <silent><M-c> <esc>:call TaggleQuickWin()<cr>
func! TaggleQuickWin()
        if getqflist({'winid':1}).winid
                exec "cclose"
        else
                exec "copen"
        endif
endfunction
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
func! Switchpreview()
  if g:ycm_add_preview_to_completeopt==1
    set completeopt=menu,menuone
    let g:ycm_add_preview_to_completeopt=0 
    echo 'add preview to 0'
  else
    set completeopt=preview,menuone
    let g:ycm_add_preview_to_completeopt=1
    echo 'add preview to 1'
  endif
endfunction
"切换补ycm全时是否出现preview窗口
let g:asyncrun_encs='gbk'
"Asnycrun显示中文
nnoremap <leader>c "*yiw
"为了使用翻译软件少用几个按键和goldendict的ctrl-cc适应
" let g:XkbSwitchLib = '~\vimfiles\dll\libxkbswitch64.dll'
"切换中文输入法补丁（目前不能用）

"==========================
"自己写的插件(仅限公安网)
"==========================
nnoremap <silent><M-9> :py3file ~\vimfiles\myscript\spider.py<cr>
"获取省厅治安总队和市局主页的通知并输出到当前buffer
nnoremap <silent><M-8> :py3file ~\vimfiles\myscript\sql_anytime.py<cr>
"自动查询sql语句


"==========================
"all ab and iab
"==========================
iab xdate <c-r>=strftime("%Y年%m月%d日%H:%M:%S")<cr>
"插入时间 iab为插入模式下缩写
ab vimrc :e ~\vimfiles\vimrc
"直接打开vimrc文件
iab ifname if __name__=='__main__':<cr>
"你懂的
ab ner NERDTree
"让打开目录快一些
ab ti tab term ipython
" 快速打开ipython


"==========================
"test
"==========================

nnoremap <F7> :call <cr>


func! Searchwiki()
        call setcmdpos(1) 
endfunc


"==========================
"other function
"==========================
" InitGitignore: 个人 gitignore 默认配置
" [[[
command! InitGitignore call InitGitignore()
au BufRead,BufNewFile *.gitignore		set filetype=gitignore
autocmd BufNewFile .gitignore exec "call InitGitignore()"
function! InitGitignore()
    if &filetype ==# 'gitignore'
        let s:ignore = [
                    \'test.*', 'tmp.*',
                    \ '.tags', '*.pyc', '*.o', '*.out', '*.log',
                    \ '.idea/', '/.idea',
                    \ 'build/',
                    \ '__pycache__'
                    \]
        let s:lines = line('$')
        normal O
        call append(0, s:ignore)
    endif
endfunction
" ]]]

" BrowserOpen: 打开文件或网址
" [[[
command! -nargs=+ BrowserOpen call BrowserOpen(<q-args>)
function! BrowserOpen(obj)
    " windows(mingw)
    if has('win32') || has('win64') || has('win32unix')
        let cmd = 'rundll32 url.dll,FileProtocolHandler ' . a:obj
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
        let cmd = 'open ' . a:obj
    elseif executable('xdg-open')
        let cmd = 'xdg-open ' . a:obj
    else
        echoerr "No browser found, please contact the developer."
    endif

    if exists('*jobstart')
        call jobstart(cmd)
    elseif exists('*job_start')
        exec '!start '  . cmd
    else
        call system(cmd)
    endif
endfunction
" ]]]

"自动打开文件所在目录
"" FileExplore: 在文件浏览器中打开当前目录
" [[[
noremap <silent> <F2> <Esc>:call FileExplore()<CR>
command! FileExplore call FileExplore()
function! FileExplore()
    let l:path = expand(getcwd())
    call BrowserOpen(l:path)
endfunction
" ]]]


