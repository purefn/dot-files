" {{{ LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie-8.0', '--lsp'],
    \ }

let g:LanguageClient_rootMarkers = {
    \ 'haskell': ['*.cabal']
    \ }

autocmd FileType haskell nnoremap <buffer> <silent> <F5> :call LanguageClient_contextMenu()<CR>
autocmd FileType haskell nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
autocmd FileType haskell nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
autocmd FileType haskell nnoremap <silent> <leader>gs :call LanguageClient#textDocument_references()<CR>
autocmd FileType haskell nnoremap <silent> <leader>r :call LanguageClient#textDocument_rename()<CR>
autocmd FileType haskell nnoremap <silent> <leader>qf :call LanguageClient#textDocument_codeAction()<CR>

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
