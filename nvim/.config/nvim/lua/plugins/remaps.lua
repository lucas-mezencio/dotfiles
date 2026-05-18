return {
  {
    "folke/noice.nvim",
    keys = {
      { "<leader>snl", false },
      { "<leader>snh", false },
      { "<leader>sna", false },
      { "<leader>snd", false },
      { "<leader>snt", false },
      {
        "<leader>vsnl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>vsnh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>vsna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>vsnd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>vsnt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>sr", false },
      {
        "<leader>psr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },

      {
        "<leader>pst",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>psT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "NOTE" } })
        end,
        desc = "Todo/Fix/Fixme/Note",
      },
    },
  },

  {
    -- Move flash.nvim from 's' to 'f' prefix
    "folke/flash.nvim",
    -- stylua: ignore
    keys = {
      { "fa", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "fF", mode = { "n", "x", "o" }, function() require("flash").treesitter() end },
      { "fr", mode = "o", function() require("flash").remote() end },
    },
  },
  {
    -- Move mini-surround from 'gs' to 's'
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- add surrounding
        delete = "sd", -- delete surrounding
        find = "sf", -- find right surrounding
        find_left = "sF", -- find left surrounding
        highlight = "sh", -- highlight surrounding
        replace = "sr", -- replace surrounding
        update_n_lines = "sn", -- update n lines
      },
    },
  },
}
