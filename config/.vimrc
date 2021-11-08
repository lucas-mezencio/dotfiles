call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/syntastic'
call plug#end()

map <F5> :NERDTreeToggle<CR>
