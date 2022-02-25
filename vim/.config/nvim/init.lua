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

vim.cmd("autocmd BufRead,BufCreate ~/Notes/* luafile ~/.config/nvim/ftplugin/notes.lua")
vim.g.svelte_preprocessors = {"ts"}
vim.g.mapleader = " "

for setting, value in pairs(settings) do
	vim.o[setting] = value
end

local mapOpts = {noremap = true, silent = true}
local maps = {
	n = {
		{"<leader><leader>", "/++<CR>:noh<CR>c2l"},
		{"<leader>nn", ":edit ~/Notes/index.md<CR>"},
		{"<leader>e", ":NERDTreeToggle<CR>"},
		{"<leader>o", ":Telescope live_grep<CR>"},
		{"<leader>t", ":Telescope builtin<CR>"},
	},
	i = {
		{";lt", "<"},
		{";gt", "<"},
	},
}

for mode, maps in pairs(maps) do
	for _, map in ipairs(maps) do
		vim.api.nvim_set_keymap(mode, map[1], map[2], mapOpts)
	end
end

-------------------------------- LSP section -----------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")

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

local lsp_installer = require("nvim-lsp-installer")


lsp_installer.on_server_ready(function(server)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.declaration()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.definition()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K",         "<cmd>lua vim.lsp.buf.hover()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>",     "<cmd>lua vim.lsp.buf.signature_help()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>t",  "<cmd>lua vim.lsp.buf.type_definition()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>r",  "<cmd>lua vim.lsp.buf.rename()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>a",  "<cmd>lua vim.lsp.buf.code_action()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>R",  "<cmd>lua vim.lsp.buf.references()<CR>", mapOpts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>p",  "<cmd>lua vim.lsp.buf.formatting()<CR>", mapOpts)

	server:setup({})
end)

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
