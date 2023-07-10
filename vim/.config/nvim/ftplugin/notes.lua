local function relative_to(to, path)
	local process = io.popen("realpath '" .. path .. "' --relative-to '" .. to .. "'")
	local line = process:read("l")
	process:close()
	return line
end
vim.opt_local.spellfile = os.getenv("HOME") .. "/Notes/vimspell.utf-8.add"

function Notes_Search()
	local note_dir = vim.fn.expand("%:h")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local original_bufn = vim.api.nvim_win_get_buf(0)
	local original_win = vim.fn.win_getid()

	require("telescope.builtin").live_grep({
		cwd = "~/Notes/",
		attach_mappings = function (bufn, map)
			local function insertLink()
				local selected = require("telescope.actions.state").get_selected_entry()
				local relative_path = relative_to(note_dir, selected.cwd .. "/" .. string.gsub(selected.filename, "%.md", ""))
				vim.api.nvim_buf_set_text(original_bufn, row-1, col, row-1, col, {"[[" .. relative_path .. "]]"})
				vim.api.nvim_win_set_cursor(original_win, {row, col+2})
				require("telescope.actions").close(bufn)
			end

			map("i", "<C-l>", insertLink)

			return true
		end
	})
end

local links = {}
local registered = false

local function remove_prefix(input, prefix)
	return string.sub(input, #prefix + 1)
end

links.setup = function()
	if registered then
		return
	end
	registered = true
	local cmp = require("cmp")
	local source = {}
	source.new = function()
		return setmetatable({}, {__index = source})
	end
	source.get_trigger_characters = function()
		return { "[" }
	end
	source.complete = function(self, request, callback)
		local input = string.sub(request.context.cursor_before_line, request.offset - 1)
		local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)
		local items = {}
		if vim.endswith(prefix, "[[") then
			local root = vim.fn.expand("~/Notes/")
			local files = vim.split(vim.fn.expand("~/Notes/**/*.md"), "\n")
			for _, file in ipairs(files) do
				local name = remove_prefix(file, root)
				name = string.gsub(name, "%.md", "")
				table.insert(items, {
					label = name,
					-- filterText = "FILTERTEXT",
					textEdit = {
						newText = "[[" .. name .. "]]",
						range = {
							start = {
								line = request.context.cursor.row - 1,
								character = request.context.cursor.col - 2 - #input,
							},
							["end"] = {
								line = request.context.cursor.row - 1,
								character = request.context.cursor.col - 1,
							}
						}
					}
				})
			end
		end

		callback({items = items, isIncomplete = true})
	end
	cmp.register_source("notelinks", source.new())
	cmp.setup.filetype("markdown", {
		sources = {
			{name = "notelinks"}
		}
	})
end

links.setup()

vim.api.nvim_buf_set_keymap(0, "n", "<leader>o", "<cmd>lua Notes_Search()<CR>", {noremap=true, silent=true})
