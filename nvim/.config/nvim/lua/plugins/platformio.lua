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

    -- Detect framework type from platformio.ini (espidf or arduino)
    local function detect_framework(cwd)
      local ini_path = cwd .. "/platformio.ini"
      if vim.fn.filereadable(ini_path) == 0 then return nil end
      local content = table.concat(vim.fn.readfile(ini_path), "\n")
      for line in content:gmatch("[^\n]+") do
        local framework = line:match("^%s*framework%s*=%s*(%S+)")
        if framework then return framework end
      end
      return nil
    end

    -- ESP-IDF include paths ordered: public API first, toolchain sysroot LAST
    local function espidf_include_paths(pio_packages)
      local base = pio_packages .. "/framework-espidf/components"
      return {
        -- PUBLIC API HEADERS FIRST (most important for auto-import)
        base .. "/esp_wifi/include",
        base .. "/driver/include",
        base .. "/esp_netif/include",
        base .. "/esp_event/include",
        base .. "/esp_system/include",
        base .. "/esp_timer/include",
        base .. "/esp_common/include",
        -- LOG, VFS, PARTITION, APP_TRACE (utility components)
        base .. "/log/include",
        base .. "/vfs/include",
        base .. "/esp_partition/include",
        base .. "/app_trace/include",
        base .. "/app_trace/private_include",
        base .. "/app_trace/port/include",
        -- BOOTLOADER SUPPORT
        base .. "/bootloader_support/include",
        base .. "/bootloader_support/bootloader_flash/include",
        -- ESP APP FORMAT, BOOTLOADER FORMAT
        base .. "/esp_app_format/include",
        base .. "/esp_bootloader_format/include",
        -- HARDWARE SUPPORT (hal, soc, hw_support)
        base .. "/hal/include",
        base .. "/hal/esp32/include",
        base .. "/hal/platform_port/include",
        base .. "/soc/include",
        base .. "/soc/esp32/include",
        base .. "/soc/esp32",
        base .. "/esp_hw_support/include",
        base .. "/esp_hw_support/include/soc",
        base .. "/esp_hw_support/include/soc/esp32",
        base .. "/esp_hw_support/port/esp32/include",
        base .. "/esp_hw_support/port/esp32",
        base .. "/esp_hw_support/dma/include",
        base .. "/esp_hw_support/debug_probe/include",
        base .. "/esp_hw_support/ldo/include",
        base .. "/esp_hw_support/mspi_timing_tuning/include",
        base .. "/esp_hw_support/power_supply/include",
        -- ESP PM
        base .. "/esp_pm/include",
        -- XTENSA
        base .. "/xtensa/esp32/include",
        base .. "/xtensa/include",
        base .. "/xtensa/deprecated_include",
        -- ESP ROM
        base .. "/esp_rom/include",
        base .. "/esp_rom/esp32/include",
        base .. "/esp_rom/esp32",
        base .. "/esp_rom/esp32/include/esp32",
        -- ESP SYSTEM
        base .. "/esp_system/port/include/private",
        base .. "/esp_system/port/soc",
        -- FREERTOS
        base .. "/freertos/FreeRTOS-Kernel/include",
        base .. "/freertos/config/include",
        base .. "/freertos/config/include/freertos",
        base .. "/freertos/esp_additions/include",
        -- LWIP
        base .. "/lwip/include",
        base .. "/lwip/include/apps",
        base .. "/lwip/include/apps/sntp",
        base .. "/lwip/port/include",
        base .. "/lwip/port/freertos/include",
        base .. "/lwip/port/esp32xx/include",
        base .. "/lwip/port/esp32xx/include/arch",
        base .. "/lwip/src/include",
        -- MEMORY / HEAP
        base .. "/heap/include",
        base .. "/heap/tlsf",
        -- EFUSE
        base .. "/efuse/include",
        base .. "/efuse/esp32/include",
        -- SPI FLASH
        base .. "/spi_flash/include",
        -- ESP DRIVER PATHS (newer split drivers)
        base .. "/esp_driver_gpio/include",
        base .. "/esp_driver_gptimer/include",
        base .. "/esp_driver_uart/include",
        -- mbedTLS
        base .. "/mbedtls/mbedtls/include",
        base .. "/mbedtls/port/include",
        base .. "/mbedtls/esp_crt_bundle/include",
        base .. "/mbedtls/port/psa_driver/include",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/include",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/core",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/drivers/builtin/src",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/drivers/builtin/include",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/drivers/everest/include",
        base .. "/mbedtls/mbedtls/tf-psa-crypto/drivers/p256-m",
        -- ESP-LIB-C and stdio
        base .. "/esp_libc/platform_include",
        base .. "/esp_stdio/include",
        -- ESP BLOCKDEV
        base .. "/esp_blockdev/include",
        -- ESP SECURITY
        base .. "/esp_security/include",
        -- ESP HARDWARE GPIOs, USB, PMU, ANA_CONV, DMA, I2S, MSPI, GPSPI, CLOCK, SECURITY, WDT, TIMG, UART, RTC_TIMER (hal)
        base .. "/esp_hal_gpio/include",
        base .. "/esp_hal_gpio/esp32/include",
        base .. "/esp_hal_usb/include",
        base .. "/esp_hal_pmu/include",
        base .. "/esp_hal_pmu/esp32/include",
        base .. "/esp_hal_ana_conv/include",
        base .. "/esp_hal_ana_conv/esp32/include",
        base .. "/esp_hal_dma/include",
        base .. "/esp_hal_i2s/include",
        base .. "/esp_hal_i2s/esp32/include",
        base .. "/esp_hal_mspi/include",
        base .. "/esp_hal_mspi/esp32/include",
        base .. "/esp_hal_gpspi/include",
        base .. "/esp_hal_gpspi/esp32/include",
        base .. "/esp_hal_clock/include",
        base .. "/esp_hal_clock/esp32/include",
        base .. "/esp_hal_security/include",
        base .. "/esp_hal_security/esp32/include",
        base .. "/esp_hal_wdt/include",
        base .. "/esp_hal_wdt/esp32/include",
        base .. "/esp_hal_timg/include",
        base .. "/esp_hal_timg/esp32/include",
        base .. "/esp_hal_uart/include",
        base .. "/esp_hal_uart/esp32/include",
        base .. "/esp_hal_rtc_timer/include",
        base .. "/esp_hal_rtc_timer/esp32/include",
        base .. "/esp_hal/include",
        base .. "/esp_hal/esp32/include",
        base .. "/esp_lwip/include",
      }
    end

    -- Arduino ESP32 include paths ordered: Arduino core first, toolchain sysroot LAST
    local function arduino_include_paths(pio_packages)
      local base = pio_packages .. "/framework-arduinoespressif32"
      local sdk = base .. "/tools/sdk/esp32"
      return {
        -- Arduino core -- HIGHEST priority for Arduino API
        base .. "/cores/esp32",
        base .. "/variants/esp32",
        -- ESP32 SDK public API headers -- before toolchain
        sdk .. "/include/esp_wifi/include",
        sdk .. "/include/esp_netif/include",
        sdk .. "/include/esp_event/include",
        sdk .. "/include/esp_system/include",
        sdk .. "/include/driver/include",
        sdk .. "/include/esp_timer/include",
        sdk .. "/include/esp_rom/include",
        sdk .. "/include/esp_common/include",
        sdk .. "/include/freertos/include",
        sdk .. "/include/lwip/include",
        sdk .. "/include/log/include",
        sdk .. "/include/soc/include",
        sdk .. "/include/soc/esp32/include",
        sdk .. "/include/hal/include",
        sdk .. "/include/heap/include",
        sdk .. "/include/spi_flash/include",
        sdk .. "/include/vfs/include",
        sdk .. "/include/esp_partition/include",
        sdk .. "/include/bootloader_support/include",
        sdk .. "/include/app_update/include",
        sdk .. "/include/esp_app_format/include",
        sdk .. "/include/efuse/include",
        sdk .. "/include/esp_pm/include",
        sdk .. "/include/esp_hal/include",
        sdk .. "/include/esp_hal/esp32/include",
        sdk .. "/include/esp_lwip/include",
        sdk .. "/include/newlib/include",
        sdk .. "/include/xtensa/include",
        sdk .. "/include/xtensa/esp32/include",
      }
    end

    -- Write .clangd with framework-specific include paths
    local function write_clangd_config(cwd, framework)
      local pio_packages = vim.fn.expand("$HOME") .. "/.platformio/packages"
      local toolchain = pio_packages .. "/toolchain-xtensa-esp32/xtensa-esp32-elf"
      local lines = { "CompileFlags:", "  Add:" }

      local include_paths
      local defines
      if framework == "espidf" then
        include_paths = espidf_include_paths(pio_packages)
        defines = { "-DESP_PLATFORM", "-DIDF_VER=\\\"6.0.0\\\"" }
      elseif framework == "arduino" then
        include_paths = arduino_include_paths(pio_packages)
        defines = { "-DESP_PLATFORM", "-DARDUINO_ESP32_DEV", "-DARDUINO=100" }
      else
        vim.notify("[PlatformIO] Unknown framework: " .. tostring(framework), vim.log.levels.ERROR)
        return
      end

      -- Add framework include paths (already ordered high-to-low priority)
      for _, path in ipairs(include_paths) do
        table.insert(lines, '    - "-I' .. path .. '"')
      end

      -- Toolchain sysroot -- ALWAYS LAST
      table.insert(lines, '    - "--sysroot=' .. toolchain .. '"')
      table.insert(lines, '    - "-isystem=' .. toolchain .. '/include"')
      table.insert(lines, '    - "-isystem=' .. toolchain .. '/include/c++/11.4.0"')
      table.insert(lines, '    - "-isystem=' .. toolchain .. '/xtensa-esp32-elf/include"')

      -- Add defines
      for _, def in ipairs(defines) do
        table.insert(lines, '    - "' .. def .. '"')
      end

      -- Remove block
      table.insert(lines, "  Remove:")
      table.insert(lines, "    - -mlongcalls")
      table.insert(lines, "    - -fno-shrink-wrap")
      table.insert(lines, "    - -fno-tree-switch-conversion")
      table.insert(lines, "    - -fstrict-volatile-bitfields")
      table.insert(lines, "    - -fno-jump-tables")
      table.insert(lines, "    - -fno-old-style-declaration")
      table.insert(lines, "    - -Wno-old-style-declaration")
      table.insert(lines, "    - -std=c11")
      table.insert(lines, "    - -xc")
      table.insert(lines, "    - -Wno-frame-address")
      table.insert(lines, "    - -Wno-error=*")
      table.insert(lines, "    - -fno-malloc-dce")
      table.insert(lines, "    - -fzero-init-padding-bits=all")
      table.insert(lines, "")
      table.insert(lines, "Diagnostics:")
      table.insert(lines, "  Suppress:")
      table.insert(lines, "    - static_assert_requirement_failed")
      table.insert(lines, "    - unresolvable_include")
      table.insert(lines, "    - unknown_typename")
      table.insert(lines, "    - undeclared_var_use")
      table.insert(lines, "    - pp_file_not_found")
      table.insert(lines, "    - implicit-function-declaration")

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
              local framework = detect_framework(cwd)
              write_clangd_config(cwd, framework)
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

  end,
}
