return {
	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following lua:
	--    require('gitsigns').setup({ ... })
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
		-- keys = {
		-- 	{ "<leader>gc", "<cmd>Gitsigns preview_hunk<CR>", desc = "[G]it show [C]hanges." },
		-- },

		config = function(_, opts)
			require("gitsigns").setup(opts)
			vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns preview_hunk<CR>", { desc = "[G]it show [C]hanges." })
		end,
	},
	-- TODO: consider check lazy git after, but for right now vim-fugitive will do the job.
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]how" })
		end,
	},
}
