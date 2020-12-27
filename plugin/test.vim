fun! Testhelloworld()
python3 << EOF
a = vim.eval("getline('.')")
print(a)
EOF
   echo 'helloworld' 
endf

command! Testhello :call Testhelloworld()
