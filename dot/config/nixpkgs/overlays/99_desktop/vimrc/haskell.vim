" {{{ LanguageClient
" let g:LanguageClient_serverCommands = {
"     \ 'haskell': ['hie-wrapper', '--lsp'],
"     \ }

" let g:LanguageClient_rootMarkers = {
"     \ 'haskell': ['*.cabal']
"     \ }

" disable syntastic for haskell
let g:syntastic_haskell_checkers = ['']
" }}}

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
