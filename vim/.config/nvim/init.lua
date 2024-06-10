vim.g.mapleader = " "
vim.o.compatible = false
vim.o.background = "dark"
vim.o.ignorecase = true
vim.o.swapfile = false
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.backup = false
vim.o.ffs = "unix"
vim.o.ff = "unix"
vim.o.mouse = "a"
vim.o.hlsearch = false
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.colorcolumn = "81,121"
vim.o.backspace = "indent,eol,start"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({import = "plugin", change_detection = {enabled = false}})

vim.cmd("autocmd BufRead,BufCreate,BufNewFile ~/Notes/** luafile ~/.config/nvim/ftplugin/notes.lua")

vim.api.nvim_set_keymap("n", "<leader>nn", ":edit ~/Notes/index.md<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>e", ":NERDTreeToggle<CR>", {noremap = true, silent = true})
