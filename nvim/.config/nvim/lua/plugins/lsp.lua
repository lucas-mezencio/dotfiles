return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        keys = {
          { "<leader>ss", false }, -- lsp symbols
          { "<leader>sS", false }, -- lsp workspace symbols
          {
            "<leader>pss",
            function()
              Snacks.picker.lsp_symbols()
            end,
            desc = "Lsp Symbols",
          },
          {
            "<leader>psS",
            function()
              Snacks.picker.lsp_workspace_symbols()
            end,
            desc = "Lsp Workspace Symbols",
          },
          {
            "<leader>cl",
            function()
              Snacks.picker.lsp_config()
            end,
            desc = "Lsp Info",
          },
          { "gd", vim.lsp.buf.definition, desc = "[G]oto [D]efinition", has = "definition" },
          { "grr", vim.lsp.buf.references, desc = "[G]oto [R]eferences", nowait = true },
          { "gi", vim.lsp.buf.implementation, desc = "Goto [I]mplementation" },
          { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
          { "grn", vim.lsp.buf.rename, desc = "[R]e[n]ame", has = "rename" },
          {
            "K",
            function()
              return vim.lsp.buf.hover()
            end,
            desc = "Hover",
          },
          {
            "gK",
            function()
              return vim.lsp.buf.signature_help()
            end,
            desc = "Signature Help",
            has = "signatureHelp",
          },
          {
            "<c-k>",
            function()
              return vim.lsp.buf.signature_help()
            end,
            mode = "i",
            desc = "Signature Help",
            has = "signatureHelp",
          },
          { "gra", vim.lsp.buf.code_action, desc = "[G]oto Code [A]ction", mode = { "n", "x" }, has = "codeAction" },
          { "<leader>cc", vim.lsp.codelens.run, desc = "Run [C]odelens", mode = { "n", "x" }, has = "codeLens" },
          {
            "<leader>cC",
            vim.lsp.codelens.refresh,
            desc = "Refresh & Display [C]odelens",
            mode = { "n" },
            has = "codeLens",
          },
          {
            "grnf",
            function()
              Snacks.rename.rename_file()
            end,
            desc = "[R]e[n]ame [F]ile",
            mode = { "n" },
            has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
          },
          { "grA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
          {
            "]]",
            function()
              Snacks.words.jump(vim.v.count1)
            end,
            has = "documentHighlight",
            desc = "Next Reference",
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          },
          {
            "[[",
            function()
              Snacks.words.jump(-vim.v.count1)
            end,
            has = "documentHighlight",
            desc = "Prev Reference",
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          },
          {
            "<a-n>",
            function()
              Snacks.words.jump(vim.v.count1, true)
            end,
            has = "documentHighlight",
            desc = "Next Reference",
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          },
          {
            "<a-p>",
            function()
              Snacks.words.jump(-vim.v.count1, true)
            end,
            has = "documentHighlight",
            desc = "Prev Reference",
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          },
        },
      },
    },
  },
}
