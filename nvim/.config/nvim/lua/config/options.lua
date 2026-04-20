-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.have_nerd_font = true
vim.g.maplocalleader = " "
vim.o.scrolloff = 15
vim.o.confirm = true
vim.opt.tabstop = 4
vim.opt.colorcolumn = "80,120"
-- Disable inlay hints by default (toggle with <leader>uh)
vim.lsp.inlay_hint.enable(false)

vim.filetype.add({
  pattern = {
    [".*%.env%.[%w_.-]+"] = "sh",
    [".*/%.envs/.*"] = "sh",
    [".*nginx.*%.conf%.template"] = "nginx",
  },
})
