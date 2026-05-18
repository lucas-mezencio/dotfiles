return {
  { "folke/edgy.nvim", optional = true },
  {
    "saghen/blink.compat",
    optional = true, -- make optional so it's only enabled if any extras need it
    opts = {},
    version = not vim.g.lazyvim_blink_main and "*",
  },
  {
    "saghen/blink.cmp",
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      keys = {
        ["<CR>"] = false,
      },
      sources = {
        providers = {
          path = {},
        },
      },
    },
  },
  { "b0o/schemastore.nvim" },
}
