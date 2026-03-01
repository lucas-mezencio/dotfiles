-- Enhanced Copilot + blink.cmp configuration for multiline completions
-- This overrides LazyVim's default copilot extra to enable proper multiline ghost text

return {
  -- Configure blink.cmp for enhanced ghost text with multiline support
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        -- Enable ghost text for multiline previews
        ghost_text = {
          enabled = true,
          -- Show ghost text when an item is selected
          show_with_selection = true,
          -- Show ghost text when no item is selected (shows first item)
          show_without_selection = true,
          -- Show ghost text when the menu is open
          show_with_menu = true,
          -- Show ghost text when the menu is closed
          show_without_menu = true,
        },

        -- Optional: Configure menu behavior
        menu = {
          -- Auto-show the menu (you can set to false if you prefer ghost text only)
          auto_show = true,
          -- Draw the menu above or below based on available space
          draw = {
            -- Show more context in completion items
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
      },

      -- Keymap configuration
      keymap = {
        preset = "enter",
        -- <C-y> accepts the ghost text or selected completion
        ["<C-y>"] = { "select_and_accept" },
        -- <CR> only accepts when an item is explicitly selected
        ["<CR>"] = { "accept", "fallback" },
        -- <Tab> for snippet navigation only
        ["<C-n>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },
      },

      -- Configure sources
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100, -- Prioritize Copilot suggestions
            async = true,
            opts = {
              -- Request more completions from Copilot
              max_completions = 5,
              max_attempts = 6,
              -- Debounce to avoid too many requests
              debounce = 150,
              -- Auto-refresh when cursor moves
              auto_refresh = {
                backward = true,
                forward = true,
              },
            },
          },
        },
      },
    },
  },

  -- Ensure copilot.lua is configured correctly
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      suggestion = {
        -- Disable native suggestions since we're using blink-copilot
        enabled = false,
        auto_trigger = false,
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true,
        yaml = true,
        json = true,
        lua = true,
        python = true,
        javascript = true,
        typescript = true,
        rust = true,
        go = true,
        ["*"] = true, -- Enable for all filetypes
      },
    },
  },

  -- Ensure blink-copilot dependency is loaded
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "fang2hou/blink-copilot",
    },
  },
}
