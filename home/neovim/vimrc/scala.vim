let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd BufWritePost *.scala silent :EnTypeCheck

autocmd FileType scala nnoremap <buffer> <silent> <leader>t :EnType<CR>
autocmd FileType scala nnoremap <buffer> <silent> <leader>t :EnType<CR>
autocmd FileType scala nnoremap <buffer> <silent> gd :EnDeclaration<CR>
autocmd FileType scala nnoremap <buffer> <silent> <C-]> :EnDeclaration<CR>
autocmd FileType scala noremap <buffer> <silent> <C-w>] :EnDeclarationSplit<CR>
autocmd FileType scala noremap <buffer> <silent> <C-w><C-]> :EnDeclarationSplit<CR>
autocmd FileType scala noremap <buffer> <silent> <C-v>] :EnDeclarationSplit v<CR>
autocmd FileType scala noremap <buffer> <silent> <leader>i :EnInspectType<CR>
autocmd FileType scala noremap <buffer> <silent> <leader>I :EnSuggestImport<CR>
autocmd FileType scala noremap <buffer> <silent> <leader>rn :EnRename<CR>

