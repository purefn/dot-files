let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie-8.0', '--lsp'],
    \ }

let g:LanguageClient_loggingFile = '~/langclient.log'
let g:LanguageClient_rootMarkers = {
        \ 'haskell': ['*.cabal']
        \ }
