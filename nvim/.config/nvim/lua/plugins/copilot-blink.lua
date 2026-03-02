-- Copilot configuration with NATIVE suggestions (not blink-copilot)
-- This uses Copilot's built-in suggestion system which supports multi-line completions
-- blink.cmp is kept for LSP/snippets, Copilot runs independently

return {
  -- Configure Copilot with native suggestions enabled
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true, -- Hide when blink.cmp menu is open
        debounce = 75,
        keymap = {
          accept = "<C-l>", -- Ctrl+; to accept
          accept_word = false,
          accept_line = false,
          next = "<M-]>", -- Alt+]
          prev = "<M-[>", -- Alt+[
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>", -- Alt+Enter to open panel
        },
        layout = {
          position = "bottom",
          ratio = 0.4,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        go = true,
        lua = true,
        python = true,
        javascript = true,
        typescript = true,
        rust = true,
        ["*"] = true,
      },
    },
  },

  -- Configure blink.cmp to work alongside Copilot
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        -- Disable Tab in blink.cmp so Copilot can use it
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
      },

      completion = {
        menu = {
          auto_show = true,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },

      -- Remove copilot from blink sources - use native instead
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
