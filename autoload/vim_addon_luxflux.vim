fun! vim_addon_luxflux#Activate(vam_features)
  let g:netrw_silent = 0
  let g:linux=1

  let plugins = {
      \ 'always':
        \ [
          \ 'Syntastic', 'molokai', 'endwise', 'trailing-whitespace', 'snipmate'
          \ ],
      \ 'rails':
        \ [
        \ 'cucumber', 'bundler', 'Haml', 'javascript', 'markdown', 'rails', 'ruby',
        \ 'coffee-script', 'commentary'
        \ ],
      \ 'gui':
        \ [ 'ctrlp' ],
      \ 'puppet':
        \ [ 'puppet' ],
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

  color molokai
endfunction
