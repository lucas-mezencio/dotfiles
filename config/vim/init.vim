call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'
Plug 'ObserverOfTime/coloresque.vim'
Plug 'jiangmiao/auto-pairs'

call plug#end()

map <F5> :NERDTreeToggle<CR>
set statusline+=%#warningmsg#


"syntastic commands
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
