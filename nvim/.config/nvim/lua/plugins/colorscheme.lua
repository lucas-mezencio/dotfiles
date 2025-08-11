return {
	"folke/tokyonight.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			style = "moon",
			transparent = true,
			-- styles = {
			-- 	comments = { italic = false }, -- Disable italics in comments
			-- },
		})
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
