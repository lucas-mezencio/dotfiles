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
        "  Add:",
        "    # ESP-IDF component + toolchain include paths",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/driver/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_driver_gpio/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_driver_gptimer/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_driver_uart/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/include/soc\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/include/soc/esp32\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/port/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_system/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_system/port/include/private\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_timer/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_common/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_rom/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_rom/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/hal/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/hal/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/hal/platform_port/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/freertos/FreeRTOS-Kernel/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/freertos/config/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/freertos/config/include/freertos\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/freertos/esp_additions/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/soc/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/soc/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/soc/esp32\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/xtensa/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/xtensa/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/xtensa/deprecated_include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_pm/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/dma/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/debug_probe/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/ldo/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/mspi_timing_tuning/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/power_supply/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/mspi_timing_tuning/tuning_scheme_impl/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_hw_support/port/esp32\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/heap/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/heap/tlsf\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/log/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/vfs/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_app_format/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_bootloader_format/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_partition/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/efuse/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/efuse/esp32/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/spi_flash/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/app_trace/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/app_trace/private_include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/app_trace/port/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/port/freertos/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/port/esp32xx/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/port/esp32xx/include/arch\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/port/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/src/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/include/apps\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/include/apps/sntp\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_timer/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/bootloader_support/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/bootloader_support/bootloader_flash/include\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_rom/esp32\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_rom/esp32/include/esp32\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/esp_system/port/soc\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/include/apps\"",
        "    - \"-I" .. vim.fn.expand("$HOME") .. "/.platformio/packages/framework-espidf/components/lwip/include\"",
        "    # xtensa toolchain sysroot",
        "    - \"--sysroot=/home/lucas/.platformio/packages/toolchain-xtensa-esp32/xtensa-esp32-elf\"",
        "    - \"-isystem=/home/lucas/.platformio/packages/toolchain-xtensa-esp32/xtensa-esp32-elf/include\"",
        "    - \"-isystem=/home/lucas/.platformio/packages/toolchain-xtensa-esp32/xtensa-esp32-elf/include/c++/11.4.0\"",
        "    - \"-isystem=/home/lucas/.platformio/packages/toolchain-xtensa-esp32/xtensa-esp32-elf/xtensa-esp32-elf/include\"",
        "    # ESP-IDF defines",
        "    - \"-DESP_PLATFORM\"",
        "    - \"-DIDF_VER=\\\"5.5.3\\\"\"",
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
        "    - -Wno-frame-address",
        "    - -Wno-error=*",
        "",
        "Diagnostics:",
        "  Suppress:",
        "    # Arduino ESP32's FreeRTOS uses ##__VA_ARGS__ comma-elision (GCC-specific).",
        "    # Clang evaluates portGET_ARGUMENT_COUNT() as 1 not 0, failing this assert.",
        "    - static_assert_requirement_failed",
        "    # ESP-IDF soc headers use macros/types host clang can't resolve",
        "    - unresolvable_include",
        "    # xtensa-specific types (gpio_num_t, ledc_channel_t, etc.)",
        "    - unknown_typename",
        "    - undeclared_var_use",
        "    # machine/endian.h lives in xtensa sysroot, not host",
        "    - pp_file_not_found",
        "    # esp_timer functions declared with __attribute__((import_module))",
        "    - implicit-function-declaration",
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

    -- Override the plugin's :PioLSP so Pioinit's post-init callback runs our
    -- full setup (fix compiler paths + write .clangd) instead of the bare one.
    vim.api.nvim_create_user_command("PioLSP", function()
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. "/platformio.ini") == 0 then
        vim.notify("[PlatformIO] No platformio.ini in current directory", vim.log.levels.ERROR)
        return
      end
      pio_clangd_setup(cwd)
    end, { force = true, desc = "Setup PlatformIO LSP" })

    -- Alias kept for muscle memory
    vim.api.nvim_create_user_command("PioClangd", function()
      vim.cmd("PioLSP")
    end, { desc = "Setup PlatformIO LSP (alias for PioLSP)" })
  end,
}
