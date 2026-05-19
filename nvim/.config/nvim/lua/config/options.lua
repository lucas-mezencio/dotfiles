-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.have_nerd_font = true
vim.g.maplocalleader = " "
vim.o.scrolloff = 15
vim.o.confirm = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.colorcolumn = "80,120"
-- Disable inlay hints by default (toggle with <leader>uh)
vim.lsp.inlay_hint.enable(false)

-- Allow prettier to run without a local .prettierrc file
vim.g.lazyvim_prettier_needs_config = false

vim.filetype.add({
  pattern = {
    [".*%.env%.[%w_.-]+"] = "sh",
    [".*/%.envs/.*"] = "sh",
    [".*nginx.*%.conf%.template"] = "nginx",
  },
})
