return {
  "anurag3301/nvim-platformio.lua",
  dependencies = {
    { "akinsho/toggleterm.nvim", config = true },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  -- lazy = false,
  config = function()
    require("platformio").setup({
      lsp = "clangd",
      clangd_source = "compiledb",
      -- A gente passa a bola pro próprio plugin criar o atalho do menu
      menu_key = "<leader>pp",
    })
  end,
}
