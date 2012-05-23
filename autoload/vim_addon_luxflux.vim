fun! vim_addon_luxflux#Activate(vam_features)
  let g:netrw_silent = 0
  let g:linux=1

  let plugins = {
      \ 'always':
        \ [
          \ 'Syntastic', 'herald', 'endwise', 'trailing-whitespace', 'snipmate', 'snipmate-snippets', 'fugitive', 'gitolite',
          \ 'github:vim-ruby/vim-ruby',
          \ ],
      \ 'rails':
        \ [
        \ 'bundler', 'github:chriseppstein/vim-haml', 'github:pangloss/vim-javascript', 'Markdown', 'github:tpope/vim-rails',
        \ 'commentary', 'github:kchmck/vim-coffee-script', 'github:tpope/vim-cucumber',
        \ 'github:groenewege/vim-less'
        \ ],
      \ 'gui':
        \ [ 'ctrlp' ],
      \ 'puppet':
        \ [ 'github:netdata/vim-puppet' ],
  \ }

  let activate = []
  for [k,v] in items(plugins)
    if k == 'always'
          \ || (type(a:vam_features) == type([]) && index(a:vam_features, k) >= 0)
          \ || (type(a:vam_features) == type('') && a:vam_features == 'all')
      call extend(activate, v)
    endif
  endfor

  call vam#ActivateAddons(activate,{'auto_install':1})

  color herald
endfunction
