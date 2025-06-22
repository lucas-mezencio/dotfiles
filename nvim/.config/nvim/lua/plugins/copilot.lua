return {
	"Exafunction/windsurf.nvim",
	event = "BufEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	opts = {},
	config = function()
		require("codeium").setup({
			virtual_text = {
				enabled = true,
				virtual_text_priority = 65535,
			},
		})
	end,
	keys = {
		{ "<leader>at", "<cmd>lua require('codeium').toggle()<cr>", desc = "Toggle Codeium" },
	},
}
