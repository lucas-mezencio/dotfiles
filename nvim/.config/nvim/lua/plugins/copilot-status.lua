-- Visual status indicator for GitHub Copilot
return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add Copilot status to lualine with visual feedback
      local copilot_status = function()
        local ok, copilot = pcall(require, "copilot.client")
        if not ok then
          return ""
        end

        local buf = vim.api.nvim_get_current_buf()
        local client = vim.lsp.get_clients({ name = "copilot", bufnr = buf })[1]
        
        if not client then
          return ""
        end

        -- Check if suggestion is visible
        local suggestion_ok, suggestion = pcall(require, "copilot.suggestion")
        if suggestion_ok and suggestion.is_visible() then
          return " " -- Bright icon when suggestion is visible
        end

        -- Check if Copilot is attached
        if client.attached_buffers[buf] then
          return " " -- Dimmer icon when ready but no suggestion
        end

        return ""
      end

      -- Add to the right section of lualine
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, copilot_status)
    end,
  },
}
