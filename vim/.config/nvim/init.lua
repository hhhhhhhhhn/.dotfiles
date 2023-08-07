require("plugins")

local settings = {
	compatible = false,
	background = "dark",
	termguicolors = true,
	ignorecase = true,
	swapfile = false,
	autoindent = true,
	smartindent = true,
	backup = false,
	ffs = "unix",
	ff = "unix",
	mouse = "a",
	hlsearch = false,
	wrap = false,
	tabstop = 4,
	shiftwidth = 4,
	colorcolumn = "81,121",
	backspace = "indent,eol,start",
}

vim.cmd("autocmd BufRead,BufCreate,BufNewFile ~/Notes/** luafile ~/.config/nvim/ftplugin/notes.lua")
vim.cmd("au BufRead,BufNewFile *.njk set filetype=html")
vim.g.svelte_preprocessors = {"ts"}
vim.g.mapleader = " "

for setting, value in pairs(settings) do
	vim.o[setting] = value end
local mapOpts = {noremap = true, silent = true}
local maps = {
	n = {
		{"<leader><leader>", "/++<CR>:noh<CR>c2l"},
		{"<leader>nn", ":edit ~/Notes/index.md<CR>"},
		{"<leader>e", ":NERDTreeToggle<CR>"},
		{"<leader>o", ":Telescope live_grep<CR>"},
		{"<C-p>", ":Telescope builtin<CR>"},
		{"<leader>be", ":lua require('dapui').toggle()<CR>"},
		{"<leader>bc", ":lua require('dap').continue()<CR>"},
		{"<leader>bn", ":lua require('dap').step_over()<CR>"},
		{"<leader>bs", ":lua require('dap').step_into()<CR>"},
		{"<leader>bo", ":lua require('dap').step_out()<CR>"},
		{"<leader>bb", ":lua require('dap').toggle_breakpoint()<CR>"},
		{"<leader>bl", ":lua require('dap').run_last()<CR>"},
	},
	i = {
		{";lt", "<"},
		{";gt", "<"},
	},
}

vim.cmd("xmap ga <Plug>(EasyAlign)")
for mode, mapList in pairs(maps) do
	for _, map in ipairs(mapList) do
		vim.api.nvim_set_keymap(mode, map[1], map[2], mapOpts)
	end
end

-------------------------------- LSP section -----------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- luasnip setup
local luasnip = require "luasnip"

-- nvim-cmp setup
local cmp = require "cmp"
cmp.setup {
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
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
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				vim.fn['codeium#Accept']()
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
	experimental = {
		ghost_text = true,
	},
	preselect = cmp.PreselectMode.None,
}

require("neodev").setup()

local mason = require("mason")
mason.setup{}
local masonlsp = require("mason-lspconfig")
masonlsp.setup{}

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

local lspconfig = require("lspconfig")
lspconfig.ccls.setup{on_attach=on_attach}

masonlsp.setup_handlers{
	function(server_name)
		lspconfig[server_name].setup{
			on_attach = on_attach,
		}
	end,
	["emmet_ls"] = function()
		lspconfig.emmet_ls.setup{
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" }
		}
	end
}
--- Codeium
vim.g.codeium_no_map_tab = true

require("deno-nvim")

------------------------------- Debuger ----------------------------------------
local dapui = require "dapui"
local dap = require "dap"

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "c" },
	controls = {
		icons = {
			pause = "■",
			play = "▶",
			step_into = "↓",
			step_over = "↷",
			step_out = "↑",
			step_back = "←",
			run_last = "↻",
			terminate = "☠",
		}
	}
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("dap-go").setup()

----------------------------- Colors section -----------------------------------
vim.cmd("colorscheme solarized8")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

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

require("lsp-colors").setup({
	Error = "#dc322f",
	Warning = "#b58900",
	Information = "#0b5163",
	Hint = "#073642"
})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
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
