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
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
			})

			vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })
			vim.api.nvim_set_hl(0, "@punctuation", { link = "Normal" })
			vim.api.nvim_set_hl(0, "@text.literal", { link = "Normal" }) -- Markdown code
			vim.api.nvim_set_hl(0, "@exception", { link = "Macro" })
			vim.api.nvim_set_hl(0, "@function.macro", { link = "Macro" })
			vim.api.nvim_set_hl(0, "@text.literal.markdown", { ctermfg = 242, fg = "#586e75" })
			vim.api.nvim_set_hl(0, "@text.literal.markdown_inline", { ctermfg = 242, fg = "#586e75" })
			vim.api.nvim_set_hl(0, "@conceal.markdown", { ctermfg = 242, fg = "#586e75" })
			vim.api.nvim_set_hl(0, "@conceal.markdown_inline", { ctermfg = 242, fg = "#586e75" })
			vim.api.nvim_set_hl(0, "@text.emphasis.markdown_inline", { italic = true })
			vim.api.nvim_set_hl(0, "@text.strong.markdown_inline", { bold = true })

			vim.api.nvim_set_hl(0, "@markup.heading", { link = "@text.title" })
			vim.api.nvim_set_hl(0, "@markup.link", { link = "@text.reference" })
			vim.api.nvim_set_hl(0, "@markup.list", { link = "@text.reference" })
			vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "@text.literal.markdown" })
			vim.api.nvim_set_hl(0, "@markup.raw.block", { link = "@text.literal.markdown" })
			vim.api.nvim_set_hl(0, "@label.markdown", { link = "@text.literal.markdown" })

			vim.api.nvim_set_hl(0, 'NormalFloat', { bg = "#063643" })
			vim.api.nvim_set_hl(0, 'Normal', { bg = "None" })

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
