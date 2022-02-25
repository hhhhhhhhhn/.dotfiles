vim.o.autochdir = true
vim.o.spell = true
vim.o.spelllang="es,en"

local function relative_to(to, path)
	local process = io.popen("realpath '" .. path .. "' --relative-to '" .. to .. "'")
	local line = process:read("l")
	process:close()
	return line
end

function Notes_Search()
	local note_dir = vim.fn.expand("%:h")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local original_bufn = vim.api.nvim_win_get_buf(0)
	local original_win = vim.fn.win_getid()

	require("telescope.builtin").live_grep({
		cwd = "~/Notes/",
		attach_mappings = function (bufn, map)
			local function insertLink()
				local selected = require("telescope.actions.state").get_selected_entry(bufn)
				local relative_path = relative_to(note_dir, selected.cwd .. "/" .. selected.filename)
				vim.api.nvim_buf_set_text(original_bufn, row-1, col+1, row-1, col+1, {"[](<" .. relative_path .. ">)"})
				vim.api.nvim_win_set_cursor(original_win, {row, col+3})
				require("telescope.actions").close(bufn)
			end

			map("i", "<C-l>", insertLink)

			return true
		end
	})
end

local md_link_start = "%]%(<?"
local md_link_end = ">?%)"
function Follow()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, row-1, row, false)[1]

	local start, finish = string.find(line, md_link_start .. ".-" .. md_link_end)
	if start == nil then
		vim.fn.feedkeys("gx")
		return
	end

	local link = string.sub(line, start, finish)
	link = string.gsub(link, md_link_start, "")
	link = string.gsub(link, md_link_end, "")

	vim.cmd("e " .. link)
end

vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>lua Notes_Search()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "<CR>", "<cmd>lua Follow()<CR>", {noremap=true, silent=true})
