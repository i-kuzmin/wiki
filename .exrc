nnoremap <leader>wv :!make -sj .www/%:r.html<CR>:!chromium .www/%:r.html<CR>
nnoremap <leader>wc :!make -sj .www/%:r.html<CR>

" --- execute {
"nnoremap <leader>e :set operatorfunc=ExecuteOperator<cr>g@
"vnoremap <leader>e :<c-u>call Exec()
"
"let g:execFileName='/tmp/vim.exec'
"
"function! Exec(...)
"    let l:qargs = []
"	for item in a:000
"        call add(l:qargs, "'".item."'")
"	endfor
"
"    call ExecuteOperator(visualmode(), join( l:qargs, ' '))
"    execute "vnoremap <leader>e :<c-u>call Exec(".join(l:qargs, ', ').")"
"
"endfunction
"
"function! ExecuteOperator( type, args)
"
"    execute "'<,'>B w! ".g:execFileName
"    execute "!bash -f ".g:execFileName." ".a:args." |tee /dev/stderr |xsel -ib"
"    if a:type ==? 'v'
"    elseif a:type ==# 'char'
"        execute "normal! '[']echom"
"    else
"        return
"   endif
"endfunction
" } execute ---

" vim : fdm=marker
