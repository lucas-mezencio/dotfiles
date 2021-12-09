vim.cmd([[ packadd packer.nvim ]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'scrooloose/nerdtree'
  use 'frazrepo/vim-rainbow'
  use 'scrooloose/syntastic'
  use 'tpope/vim-surround'
  use 'ObserverOfTime/coloresque.vim'
  use 'jiangmiao/auto-pairs'
  use 'preservim/tagbar'
end)

