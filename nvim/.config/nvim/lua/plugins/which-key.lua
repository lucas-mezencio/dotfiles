return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>p", name = "+project" },
      { "<leader>ps", name = "+search" },
      { "<leader>v", name = "+vim" },
      { "<leader>vs", name = "+search" },
      { "<leader>vsn", name = "+noice" },
      { "<leader>h", name = "+harpoon" },

      -- Disable
      { "<leader>s", hidden = true },
      { "<leader>sn", hidden = true },
    },
  },
}
