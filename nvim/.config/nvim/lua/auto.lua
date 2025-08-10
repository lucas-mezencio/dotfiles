print("Auto commands loaded")
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "oil",
-- 	callback = function()
-- 		-- This function tells obsidian.nvim to check the current buffer's path.
-- 		-- The `0` means the current buffer.
-- 		-- We wrap it in pcall to prevent errors if you are using oil outside of a vault.
-- 		pcall(require("obsidian").attach_and_get_client, 0)
-- 	end,
-- 	desc = "Auto-activate Obsidian plugin in Oil buffers",
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		pcall(
			vim.diagnostic.enable(false, {
				bufnr = 0,
			}),
			0
		)
	end,
	desc = "Auto-activate Obsidian plugin in Markdown buffers",
})

-- Check for a special environment variable on startup
if os.getenv("NVIM_LAUNCH_OBSIDIAN_WORKSPACES") == "1" then
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		-- The 'once' flag is crucial: it makes the autocommand run only once and then delete itself.
		once = true,
		callback = function()
			-- Check if the command exists before running to be safe
			if vim.fn.exists(":Obsidian") > 0 then
				vim.cmd("Obsidian workspace")
				-- vim.cmd("Obsidian workspaces")
			else
				print("Error: :Obsidian command not found. Is the plugin loaded?")
			end
		end,
		desc = "Launch Obsidian workspaces from a script",
	})
end
