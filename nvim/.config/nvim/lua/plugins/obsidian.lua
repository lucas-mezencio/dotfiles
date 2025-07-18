return {
	{

		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- opts = {
		-- 	completions = {
		-- 		blink = { enabled = true },
		-- 	},
		-- },
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		---@module 'obsidian'
		---@type obsidian.config.ClientOpts
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Vaults/MainVault/",
				},
			},
			completion = {
				nvim_cmp = false,
				blink = true,
				match_case = false,
				min_chars = 2,
			},
			ui = {
				enable = false,
			},

			---@param title string|?
			---@return string
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%Y-%m-%d-%H-%M")) .. "-" .. suffix
			end,
			mappings = {
				["<leader>on"] = {
					action = function()
						vim.cmd.ObsidianNew()
					end,
					opts = { buffer = true, desc = "[0]bsidian [N]ew Note" },
				},
				["<leader>os"] = {
					action = function()
						vim.cmd.ObsidianSearch()
					end,
					opts = { buffer = true, desc = "[O]bsidian [S]earch" },
				},
				["<leader>of"] = {
					action = function()
						vim.cmd.ObsidianQuickSwitch()
					end,
					opts = { buffer = true, desc = "[O]bsidian [F]ind" },
				},
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				-- ["<leader>oo"] = {
				-- 	action = function()
				-- 		vim.cmd.ObsidianWorkspace()
				-- 	end,
				-- 	opts = { buffer = true, desc = "[O]bsidian [O]pen Workspace" },
				-- },
			},
		},
	},
}
