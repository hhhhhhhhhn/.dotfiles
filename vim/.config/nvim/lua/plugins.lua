local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require("packer").startup(function() 
	use 'lifepillar/vim-solarized8'
	use 'preservim/nerdtree'
	use 'vim-scripts/Drawit'
	use {'evanleck/vim-svelte', branch = "main"}
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'
	use 'folke/lsp-colors.nvim'
	if packer_bootstrap then
		require('packer').sync()
	end
end)
