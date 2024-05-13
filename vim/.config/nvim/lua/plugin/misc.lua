return {
	{"Exafunction/codeium.vim",
		config = function()
			vim.g.codeium_no_map_tab = true
			vim.keymap.set('i', '<C-a>', function ()
				return vim.fn['codeium#Accept']()
			end, { expr = true })
		end
	},
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
