-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	cmd = "Neotree",
	keys = {
		{ "<leader>pv", ":Neotree toggle position=float<CR>", { desc = "[P]roject [V]iew" } },
	},
	opts = {
		filesystem = {
			window = {
				mappings = {
					["<leader>pv"] = "close_window",
				},
			},
			hijack_netrw_behaviour = "open_current",
		},
		window = {
			position = "float",
		},
	},
}
