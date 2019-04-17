behave mswin
noremap <f11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
noremap <f12> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleTransparency', "247,180")<cr>
"全屏和透明窗体,需要gvim_fullscreen.dll支持
