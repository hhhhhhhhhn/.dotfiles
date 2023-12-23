local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
	use "wbthomason/packer.nvim"
	use "lifepillar/vim-solarized8"
	use "preservim/nerdtree"
	use "neovim/nvim-lspconfig"
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-nvim-lsp"
	use "saadparwaiz1/cmp_luasnip"
	use "L3MON4D3/LuaSnip"
	use "ChrisWellsWood/roc.vim"
	use "folke/lsp-colors.nvim"
	use "evanleck/vim-svelte"
	use {"nvim-telescope/telescope.nvim", requires = {{"nvim-lua/plenary.nvim"}} }
	use "folke/neodev.nvim"
	use "ledger/vim-ledger"
	use {
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	}
	use {
		"Exafunction/codeium.vim",
		config = function()
			vim.keymap.set('i', '<C-a>', function ()
				return vim.fn['codeium#Accept']()
			end, { expr = true })
		end
	}

	if packer_bootstrap then
		require("packer").sync()
	end
end)
