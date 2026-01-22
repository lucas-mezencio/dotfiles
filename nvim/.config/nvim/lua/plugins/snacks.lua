-- lazy.nvim
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    explorer = { layout = "default" }, -- enabled false to oil
    picker = {
      sources = {
        explorer = {
          layout = { preset = "default" },
          auto_close = true,
        },
      },
    },
  },
  keys = {
    {
      "<leader>pv",
      function()
        Snacks.explorer.reveal()
      end,
      desc = "[P]roject [V]iew",
    },
    {
      "<leader>vsh",
      function()
        Snacks.picker.help()
      end,
      desc = "[V]im [S]earch [H]elp",
    },
    {
      "<leader>vsf",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[V]im [S]earch [F]iles",
    },
    {
      "<leader>vsk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "[V]im [S]earch [K]eymaps",
    },
    {
      "<leader>pf",
      function()
        Snacks.picker.files()
      end,
      desc = "Search [P]roject [F]iles",
    },
    {
      "<leader>pg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Search [P]roject [G]it [F]iles",
    },
    {
      "<leader><leader>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "[ ] Find existing buffers",
    },
    {
      "<leader>ps.",
      function()
        Snacks.picker.recent()
      end,
      desc = '[P]roject [S]earch Recent Files ("." for repeat)',
    },
    {
      "<leader>psb",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "[P]roject Grep Open [B]uffers",
    },
    {
      "<leader>psg",
      function()
        Snacks.picker.grep()
      end,
      desc = "[P]roject [S]earch by [G]rep",
    },
    {
      "<leader>psw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "[P]roject [S]earch current [W]ord",
      mode = { "n", "x" },
    },
    -- search
    {
      "<leader>ps/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "[P]roject [S]earch History [/]",
    },
    {
      "<leader>vsa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "[V]im [S]earch [A]utocmds",
    },
    {
      "<leader>psc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "[P]roject [S]earch [C]ommand History",
    },
    {
      "<leader>vsc",
      function()
        Snacks.picker.commands()
      end,
      desc = "[V]im [S]earch [C]ommands",
    },
    {
      "<leader>psd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "[P]roject [S]earch [D]iagnostics",
    },
    {
      "<leader>psD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "[P]roject [S]earch [D]iagnostics Buffer",
    },
    {
      "<leader>vsH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "[V]im [S]earch [H]ighlights",
    },
    {
      "<leader>vsi",
      function()
        Snacks.picker.icons()
      end,
      desc = "[V]im [S]earch [I]cons",
    },
    {
      "<leader>psj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "[P]roject [S]earch [J]umps",
    },
    {
      "<leader>psl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "[P]roject [S]earch [L]ocation List",
    },
    {
      "<leader>psm",
      function()
        Snacks.picker.marks()
      end,
      desc = "[P]roject [S]earch [M]arks",
    },
    {
      "<leader>vsm",
      function()
        Snacks.picker.man()
      end,
      desc = "[V]im [S]earch [M]an Pages",
    },
    {
      "<leader>psq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "[P]roject [S]earch [Q]uickfix List",
    },
    {
      "<leader>psr",
      function()
        Snacks.picker.resume()
      end,
      desc = "[P]roject [S]earch [R]esume",
    },
    {
      "<leader>psu",
      function()
        Snacks.picker.undo()
      end,
      desc = "[P]roject [S]earch [U]ndo History",
    },

    { "<leader>psB", false },
    { "<leader>psp", false },
    { '<leader>ps"', false },
    { '<leader>s"', false },
    -- find
    { "<leader>fb", false },
    { "<leader>fc", false },
    { "<leader>ff", false },
    { "<leader>fg", false },
    { "<leader>fp", false },
    -- Grep
    { "<leader>sb", false },
    { "<leader>sB", false },
    { "<leader>sg", false },
    { "<leader>sw", false },
    -- search
    { '<leader>s"', false },
    { "<leader>s/", false },
    { "<leader>sa", false },
    { "<leader>sb", false },
    { "<leader>sc", false },
    { "<leader>sC", false },
    { "<leader>sd", false },
    { "<leader>sD", false },
    { "<leader>sh", false },
    { "<leader>sH", false },
    { "<leader>si", false },
    { "<leader>sj", false },
    { "<leader>sk", false },
    { "<leader>sl", false },
    { "<leader>sm", false },
    { "<leader>sM", false },
    { "<leader>sp", false },
    { "<leader>sq", false },
    { "<leader>sR", false },
    { "<leader>su", false },
  },
}
