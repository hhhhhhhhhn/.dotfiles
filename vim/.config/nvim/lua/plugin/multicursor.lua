return {
	"mg979/vim-visual-multi",
	branch = "master",
	init = function()
		vim.g.VM_maps = {
			["Find Under"] = "<C-n>",
			["Start Regex Search"] = "<C-f>",
		}
	    vim.api.nvim_create_autocmd('User', {
			pattern = 'visual_multi_start',
			callback = function()
				-- For some reason :LspStop crashes
				vim.lsp.stop_client(vim.lsp.get_clients())
			end})
		vim.api.nvim_create_autocmd('User', {
			pattern = 'visual_multi_exit',
			callback = function()
				pcall(function () vim.cmd("LspStart") end)
			end})
	end
}
