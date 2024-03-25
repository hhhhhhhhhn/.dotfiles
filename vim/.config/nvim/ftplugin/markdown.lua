vim.wo.spell = true
vim.bo.spelllang="es,en,de"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true
vim.wo.colorcolumn=-1
vim.wo.conceallevel=3
vim.wo.linebreak=true
vim.bo.textwidth=80

local md_link_start = "%]%(<?"
local md_link_end = ">?%)"

local notes_link_start = "%[%["
local notes_link_end = "%]%]"

function Follow()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, row-1, row, false)[1]

	local start, finish = string.find(line, md_link_start .. ".-" .. md_link_end)
	if start == nil then
		start, finish = string.find(line, notes_link_start .. ".-" .. notes_link_end)
		if start == nil then
			vim.fn.feedkeys("gx")
			return
		end
		local link = string.sub(line, start, finish)
		link = string.gsub(link, notes_link_start, "")
		link = string.gsub(link, notes_link_end, "")
		vim.cmd("e ~/Notes/" .. link .. ".md")
		return
	end

	local link = string.sub(line, start, finish)
	link = string.gsub(link, md_link_start, "")
	link = string.gsub(link, md_link_end, "")

	vim.cmd("e " .. link)
end

local md_list = "^%s*- "

function Newline()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, row-1, row, false)[1]

	local start, finish = string.find(line, md_list)

	local keys
	-- Not in a list
	if start == nil then
		keys = "a\n"
	elseif finish == #line then
		keys = "hr A"
	else
		keys = "a\n- "
	end
	vim.fn.feedkeys(keys)
end

function ShiftNewline()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, row-1, row, false)[1]
	print(line)

	local start, _ = string.find(line, md_list)
	if start == nil then
		vim.fn.feedkeys("a\n")
		return
	end
	vim.fn.feedkeys("a\n- ")
end

local maps = {
	["and"] = "∧",
	["or"] = "∨",
	["xor"] = "⊻",
	["el"] = "∈",
	["nel"] = "∉",
	["not"] = "¬",
	["all"] = "∀",
	["ex"] = "∃",
	["nex"] = "∄",
	["imp"] = "→",
	["iff"] = "↔",
	["un"] = "∪",
	["int"] = "∩",
	["sub"] = "⊂",
	["sup"] = "⊃",
	["del"] = "Δ",
	["nat"] = "ℕ",
	["rat"] = "ℚ",
	["real"] = "ℝ",
	["whole"] = "ℤ",
}

for source, dest in pairs(maps) do
	vim.api.nvim_buf_set_keymap(0, "i", "<C-c>" .. source, dest, {noremap=true, silent=true})
end

vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<cmd>lua Follow()<CR>", {noremap=true, silent=true})
vim.api.nvim_buf_set_keymap(0, "v", "<CR>", "da[<C-r>\"](<<C-r>\".md>)<esc>", {noremap=true, silent=true})
vim.api.nvim_buf_set_keymap(0, "i", "<CR>", "<esc><cmd>lua Newline()<CR>", {noremap=true, silent=true})
vim.api.nvim_buf_set_keymap(0, "n", "o", "$<cmd>lua Newline()<CR>", {noremap=true, silent=true})
vim.api.nvim_buf_set_keymap(0, "n", "O", "k$<cmd>lua Newline()<CR>", {noremap=true, silent=true})

vim.api.nvim_buf_set_keymap(0, "v", "?", 'c_<C-r>"_<esc>', {noremap=true, silent=true})

vim.api.nvim_set_hl(0, "@punctuation.special", { link = "markdownH1" })
