return {
	{
		"lifepillar/vim-solarized8",
		priority = 10000,
		lazy = false,
		config = function ()
			vim.cmd("colorscheme solarized8")
			vim.o.termguicolors = true

			-- Trailing whitespace
			vim.api.nvim_set_hl(0, "Trailing", { link = "Error" })

			vim.api.nvim_create_autocmd({"BufRead","BufNewFile"}, {
				callback = function()
					vim.cmd("match Trailing /\\s\\+$/")
				end
			})

			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					vim.api.nvim_set_hl(0, "Trailing", { link = "Normal" })
				end
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					vim.api.nvim_set_hl(0, "Trailing", { link = "Error" })
				end
			})
		end
	},
	{
		"folke/lsp-colors.nvim",
		config = function()
			require("lsp-colors").setup({
				Error = "#dc322f",
				Warning = "#b58900",
				Information = "#0b5163",
				Hint = "#073642"
			})
			local signs = { Error = ">>", Warn = ">", Hint = "?", Info = "!" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●"
				}
			})
		end
	},
}
