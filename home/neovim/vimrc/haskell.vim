" Point Conversion {{{

function! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction

function! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction

autocmd FileType haskell vnoremap <silent> <leader>h. :call Pointfree()<CR>
autocmd FileType haskell vnoremap <silent> <leader>h> :call Pointful()<CR>

" }}}
"
