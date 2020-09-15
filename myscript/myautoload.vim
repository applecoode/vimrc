"0:up, 1:down, 2:up, 3:pgdown, 4:top, 5:bottom
"侧屏自动滚屏代码
function! Tools_PreviousCursor(mode)
        if winnr('$') <= 1
                return
        endif
        noautocmd silent! wincmd p
        if a:mode == 0
                exec "normal! \<c-y>"
        elseif a:mode == 1
                exec "normal! \<c-e>"
        elseif a:mode == 2
                exec "normal! ".winheight('.')."\<c-y>"
        elseif a:mode == 3
                exec "normal! ".winheight('.')."\<c-e>"
        elseif a:mode == 4
                normal! gg
        elseif a:mode == 5
                normal! G
        elseif a:mode == 6
                exec "normal! \<c-u>"
        elseif a:mode == 7
                exec "normal! \<c-d>"
        elseif a:mode == 8
                exec "normal! k"
        elseif a:mode == 9
                exec "normal! j"
        endif
        noautocmd silent! wincmd p
endfunc

"切换preview窗口
fun! TagglePreview()
    try 
      :wincmd P
      :pclose 
    catch 
      :YcmCompleter GetDoc 
    endtry
endf

"搜索笔记
function! Vimgrepsm()
                exec "vimgrep ".input("search what?")."/j ~/vimwiki/diary/*.md" 
endfunction
function! Vimgrepsw()
                exec "vimgrep ".input("search what?")."/j ~/vimwiki/diary/*.wiki" 
endfunction
function! Vimgrepsa()
                exec "vimgrep ".input("search what?")."/j ~/vimwiki/diary/**/*" 
endfunction

"自动打开文件所在目录
function! FileExplore()
    let l:path = expand(getcwd())
    call BrowserOpen(l:path)
endfunction

"异步执行md,python,go,html
func! RunProgramInPrefix()
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
          if &filetype == 'html'
                  exec  "!start chrome %"
          endif
          if &filetype == 'go'
                  exec "AsyncRun go run %"
                  exec "copen"
                  exec "wincmd p"
          endif
endfunc

"命令框执行python go
func! RunProgram()
        exec "w"
        if &filetype == 'python'
                exec "!python %"
        elseif &filetype == 'go'
                exec "!go run %"
        endif
endfunc

"切换quickfix窗口
func! TaggleQuickWin()
        if getqflist({'winid':1}).winid
                exec "cclose"
        else
                exec "copen"
        endif
endfunction

"切换补全时是否出现preview窗口
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

"新建ignore文件自动填充内容
function! InitGitignore()
    if &filetype ==# 'gitignore'
        let s:ignore = [
                    \'test.*', 'tmp.*',
                    \'*~','*.swp','*.un',
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

"自动打开文件网址
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
