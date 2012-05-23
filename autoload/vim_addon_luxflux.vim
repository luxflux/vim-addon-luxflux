fun! vim_addon_luxflux#Activate(vam_features)
  let g:netrw_silent = 0
  let g:linux=1
  
  let plugins = {
      \ 'always':
        \ [
          \ 'syntastic2', 'molokai', 'endwise', 'trailing-whitespace'
          \ ],
      \ 'rails':
        \ [ 'cucumber', 'bundler' ],
      \ 'gui':
        \ [ 'ctrlp' ],
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
endfunction
