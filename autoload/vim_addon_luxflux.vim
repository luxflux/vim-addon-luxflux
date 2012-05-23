fun! vim_addon_luxflux#Activate(vam_features)
  let g:netrw_silent = 0
  let g:linux=1

  let plugins = {
      \ 'always':
        \ [
          \ 'Syntastic', 'herald', 'endwise', 'trailing-whitespace', 'snipmate-snippets', 'fugitive', 'gitolite',
          \ 'github:vim-ruby/vim-ruby',
          \ ],
      \ 'rails':
        \ [
        \ 'bundler', 'github:chriseppstein/vim-haml', 'github:pangloss/vim-javascript', 'Markdown', 'github:tpope/vim-rails',
        \ 'commentary', 'github:kchmck/vim-coffee-script', 'github:tpope/vim-cucumber',
        \ 'github:groenewege/vim-less'
        \ ],
      \ 'gui':
        \ [ 'github:kien/ctrlp.vim' ],
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

  syntax enable
  set encoding=utf-8
  filetype plugin indent on

  set number
  set ruler       " show the cursor position all the time
  set cursorline
  set showcmd     " display incomplete commands
  set shell=bash  " avoids munging PATH under zsh

  " Allow backgrounding buffers without writing them, and remember marks/undo
  " for backgrounded buffers
  set hidden

  "" Whitespace
  set nowrap                        " don't wrap lines
  set tabstop=2                     " a tab is two spaces
  set shiftwidth=2                  " an autoindent (with <<) is two spaces
  set expandtab                     " use spaces, not tabs
  set list                          " Show invisible characters
  set backspace=indent,eol,start    " backspace through everything in insert mode
  " List chars
  set listchars=""                  " Reset the listchars
  set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
  set listchars+=trail:.            " show trailing spaces as dots
  set listchars+=extends:>          " The character to show in the last column when wrap is
                                    " off and the line continues beyond the right of the screen
  set listchars+=precedes:<         " The character to show in the first column when wrap is
                                    " off and the line continues beyond the left of the screen
  "" Searching
  set hlsearch                      " highlight matches
  set incsearch                     " incremental searching
  set ignorecase                    " searches are case insensitive...
  set smartcase                     " ... unless they contain at least one capital letter

  " provide some context when editing
  set scrolloff=3

  " don't use Ex mode, use Q for formatting
  map Q gq

  " clear the search buffer when hitting return
  :nnoremap <CR> :nohlsearch<cr>

  nnoremap <leader><leader> <c-^>

  " find merge conflict markers
  nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

  " easier navigation between split windows
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

  " disable cursor keys in normal mode
  map <Left>  :echo "no!"<cr>
  map <Right> :echo "no!"<cr>
  map <Up>    :echo "no!"<cr>
  map <Down>  :echo "no!"<cr>

  set backupdir=~/.vim/_backup    " where to put backup files.
  set directory=~/.vim/_temp      " where to put swap files.

  " paste mode toggle
  set pastetoggle=<f4>

  " toggle number
  nmap <F5> :set number! number?<CR>

  " set indenting for puppet files
  autocmd FileType puppet setlocal shiftwidth=4 tabstop=4

  if has("statusline") && !&cp
    set laststatus=2  " always show the status bar

    " Start the status line
    set statusline=%f\ %m\ %r

    " Add fugitive
    set statusline+=%{fugitive#statusline()}

    " Finish the statusline
    set statusline+=Line:%l/%L[%p%%]
    set statusline+=Col:%v
    set statusline+=Buf:#%n
    set statusline+=[%b][0x%B]
  endif

  if has("autocmd")

    function s:setupWrapping()
      set wrap
      set wrapmargin=2
      set textwidth=80
    endfunction

    " In Makefiles, use real tabs, not tabs expanded to spaces
    au FileType make set noexpandtab

    " Make sure all markdown files have the correct filetype set and setup wrapping
    au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

    " Treat JSON files like JavaScript
    au BufNewFile,BufRead *.json set ft=javascript

    " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
    au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

    " Remember last location in file, but not for commit messages.
    " see :help last-position-jump
    au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g`\"" | endif
  endif

  " get reference for the current commit from git flow
  function GitRedmineIssue(fixes)
    let current_branch = system("git rev-parse --abbrev-ref HEAD")
    let ref = substitute(current_branch, '^.\+\/\(\d\+\).\+$', '\1', '')
    if a:fixes == 'true'
      let prefix = 'fixes'
    else
      let prefix = 'refs'
    endif
    return prefix . ' #' . ref
  endfunction
  iab REFS <C-R>=GitRedmineIssue('false')<CR>
  iab FIXES <C-R>=GitRedmineIssue('true')<CR>

  autocmd BufWritePre * :FixWhitespace

endfunction
