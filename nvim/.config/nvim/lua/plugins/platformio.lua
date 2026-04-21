return {
  "anurag3301/nvim-platformio.lua",
  dependencies = {
    { "akinsho/toggleterm.nvim", config = true },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("platformio").setup({
      lsp = "clangd",
      clangd_source = "compiledb",
      menu_key = "<leader>pp",
    })

    -- compile_commands.json uses bare compiler names (e.g. xtensa-esp32-elf-gcc).
    -- clangd resolves these via PATH to check against --query-driver. Since PIO
    -- toolchains are not in PATH outside of PIO's own shell, clangd can't find
    -- them → no system headers. Fix: replace bare names with absolute paths.
    local function fix_compiler_paths(cwd)
      local cc_file = cwd .. "/compile_commands.json"
      if vim.fn.filereadable(cc_file) == 0 then return end

      local text = table.concat(vim.fn.readfile(cc_file), "\n")

      -- collect unique bare compiler names (no leading /)
      local compilers = {}
      for name in text:gmatch('"command": "([^/ ][^ ]*)') do
        compilers[name] = true
      end

      local changed = false
      for name in pairs(compilers) do
        local full = vim.fn.system(
          "find " .. vim.fn.expand("$HOME") ..
          "/.platformio/packages -name '" .. name .. "' -type f 2>/dev/null | head -1"
        ):gsub("%s+$", "")
        if full ~= "" then
          text = text:gsub('"command": "' .. vim.pesc(name) .. " ", '"command": "' .. full .. " ")
          changed = true
        end
      end

      if changed then
        vim.fn.writefile(vim.split(text, "\n"), cc_file)
      end
    end

    -- Strip GCC/xtensa-specific flags clangd's built-in x86 clang doesn't know.
    -- Without this, clangd emits spurious errors for every file.
    local function write_clangd_config(cwd)
      local lines = {
        "CompileFlags:",
        "  Remove:",
        "    # GCC/xtensa-specific flags unknown to clangd's x86 clang driver",
        "    - -mlongcalls",
        "    - -fno-shrink-wrap",
        "    - -fno-tree-switch-conversion",
        "    - -fstrict-volatile-bitfields",
        "    - -fno-jump-tables",
        "    - -fno-old-style-declaration",
        "    - -Wno-old-style-declaration",
        "    # ~/.config/clangd/config.yaml adds -std=c11 and -xc globally.",
        "    # PlatformIO projects set their own standard via compile_commands.json.",
        "    - -std=c11",
        "    - -xc",
      }
      vim.fn.writefile(lines, cwd .. "/.clangd")
    end

    local function pio_clangd_setup(cwd)
      if vim.fn.isdirectory(cwd .. "/.git") == 0 then
        vim.fn.system(
          "git -C " .. cwd .. " init && git -C " .. cwd .. " add . && git -C " .. cwd .. " commit -m 'init'"
        )
      end

      vim.notify("[PlatformIO] Building and generating LSP index…", vim.log.levels.INFO)

      vim.fn.jobstart("pio run -t compiledb", {
        cwd = cwd,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              fix_compiler_paths(cwd)
              write_clangd_config(cwd)
              vim.notify("[PlatformIO] LSP ready", vim.log.levels.INFO)
              if vim.fn.has("nvim-0.12") == 1 then
                vim.cmd("lsp restart")
              else
                vim.cmd("LspRestart")
              end
            else
              vim.notify("[PlatformIO] Build failed — fix errors then run :PioClangd", vim.log.levels.WARN)
            end
          end)
        end,
      })
    end

    -- Run automatically on first open of a C/C++ file in a new PIO project.
    -- Skips if compile_commands.json already has real entries.
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
      callback = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/platformio.ini") == 0 then return end

        if vim.fn.filereadable(cwd .. "/compile_commands.json") == 1 then
          local content = table.concat(vim.fn.readfile(cwd .. "/compile_commands.json"), "")
          if not content:find('"command": ""') then return end
        end

        pio_clangd_setup(cwd)
      end,
    })

    -- Manual trigger: use after adding new libraries to platformio.ini
    vim.api.nvim_create_user_command("PioClangd", function()
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. "/platformio.ini") == 0 then
        vim.notify("[PlatformIO] No platformio.ini in current directory", vim.log.levels.ERROR)
        return
      end
      pio_clangd_setup(cwd)
    end, { desc = "Rebuild PlatformIO LSP index" })
  end,
}
