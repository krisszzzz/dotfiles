set noswapfile
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set cindent
set relativenumber


lua require('plugins')
lua require('lualine_cfg')

set completeopt=menu,menuone,noselect
set backspace=indent,eol,start
colorscheme lightning 

" coc mapping
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction



" NerdCommenter config
let g:NERDCreateDefaultMappings = 1
let g:NERDCustomDelimiters = { 'c' : { 'left': '/*', 'right': '*/' } } 
let mapleader = ","

nnoremap <C-h> <Cmd>bprevious<CR>
nnoremap <C-l> <Cmd>bnext<CR>
nnoremap <C-k> <Cmd>bdelete<CR>

" Telescope mapping

nnoremap ff <cmd>Telescope find_files<CR>
nnoremap fg <cmd>Telescope live_grep<CR>

nnoremap fb <cmd>Telescope buffers<CR>

