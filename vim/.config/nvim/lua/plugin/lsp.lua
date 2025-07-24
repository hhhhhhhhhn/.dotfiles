return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp"
		},
		config = function()
			require("neodev").setup()
			local lspconfig = require("lspconfig")

			local mason = require("mason")
			mason.setup()
			local masonlsp = require("mason-lspconfig")
			masonlsp.setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local mapOpts = {noremap = true, silent = true}
			local on_attach = function(client, bufn)
				client.server_capabilities.semanticTokensProvider = nil

				vim.api.nvim_buf_set_option(bufn, "omnifunc", "v:lua.vim.lsp.omnifunc")

				vim.api.nvim_buf_set_keymap(bufn, "n", "<leader>F", "<cmd>lua vim.lsp.buf.declaration()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<leader>f", "<cmd>lua vim.lsp.buf.definition()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "K",         "<cmd>lua vim.lsp.buf.hover()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<C-k>",     "<cmd>lua vim.lsp.buf.signature_help()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>t",  "<cmd>lua vim.lsp.buf.type_definition()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>r",  "<cmd>lua vim.lsp.buf.rename()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>a",  "<cmd>lua vim.lsp.buf.code_action()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>R",  "<cmd>lua vim.lsp.buf.references()<CR>", mapOpts)
				vim.api.nvim_buf_set_keymap(bufn, "n", "<space>p",  "<cmd>lua vim.lsp.buf.formatting()<CR>", mapOpts)
			end

			-- TODO: Fix
			-- masonlsp.setup_handlers{
			-- 	function(server_name)
			-- 		lspconfig[server_name].setup{
			-- 			on_attach = on_attach,
			-- 		}
			-- 	end,
			-- 	["emmet_ls"] = function()
			-- 		lspconfig.emmet_ls.setup{
			-- 			on_attach = on_attach,
			-- 			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" }
			-- 		}
			-- 	end,
			-- }

			-- Adding custom lsp
			require("lspconfig.configs").rocls = {
				default_config = {
					cmd = {"roc_lang_server"},
					filetypes = { "roc" },
					root_dir = lspconfig.util.root_pattern(".git", "main.roc"),
					settings = {}
				}
			}

			lspconfig.rocls.setup{on_attach=on_attach}
			lspconfig.dartls.setup{on_attach=on_attach}
			lspconfig.gleam.setup{on_attach=on_attach}
		end
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function ()
			local cmp = require("cmp")
			cmp.setup {
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
				experimental = {
					ghost_text = true,
				},
				preselect = cmp.PreselectMode.None,
			}
		end
	},
}
