return {
	"preservim/nerdtree",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {"nvim-lua/plenary.nvim"},
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>o", ":Telescope live_grep<CR>", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope builtin<CR>", {noremap = true, silent = true})
		end
	}
}
