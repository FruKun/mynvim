-----------------------------------------------------------
-- AUTOCOMMAND
-----------------------------------------------------------
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
-- Не автокомментировать новые линии при переходе на новую строку
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])
-- 2 spaces for selected filetypes
vim.cmd([[
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2
]])

augroup("auto_read", { clear = true })
autocmd({ "FileChangedShellPost" }, {
	pattern = "*",
	group = "auto_read",
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
	end,
})

autocmd({ "FocusGained", "CursorHold" }, {
	pattern = "*",
	group = "auto_read",
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

autocmd({ "BufRead" }, {
	pattern = "*",
	group = augroup("non_utf8_file", { clear = true }),
	callback = function()
		if vim.bo.fileencoding ~= "utf-8" then
			vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
		end
	end,
})
autocmd("TermOpen", {
	group = augroup("term_start", { clear = true }),
	pattern = "*",
	callback = function()
		-- Do not use number and relative number for terminal inside nvim
		vim.wo.relativenumber = false
		vim.wo.number = false

		-- Go to insert mode by default to start typing command
		vim.cmd("startinsert")
	end,
})
-- Resize all windows when we resize the terminal
autocmd("VimResized", {
	group = augroup("win_autoresize", { clear = true }),
	desc = "autoresize windows on resizing operation",
	command = "wincmd =",
})
local function open_nvim_tree(data)
	-- check if buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1
	if not directory then
		return
	end
	-- create a new, empty buffer
	vim.cmd.enew()
	-- wipe the directory buffer
	vim.cmd.bw(data.buf)
	-- open the tree
	require("neo-tree.command").execute({ action = "focus" })
end

autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local number_toggle_group = augroup("numbertoggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	pattern = "*",
	group = number_toggle_group,
	desc = "togger line number",
	callback = function()
		if vim.wo.number then
			vim.wo.relativenumber = true
		end
	end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = number_toggle_group,
	desc = "togger line number",
	callback = function()
		if vim.wo.number then
			vim.wo.relativenumber = false
		end
	end,
})

-- save colorscheme
autocmd({ "VimEnter" }, {
	nested = true,
	callback = function()
		vim.cmd.colorscheme(vim.g.SCHEME)
	end,
})
autocmd({ "Colorscheme" }, {
	callback = function(params)
		vim.g.SCHEME = params.match
	end,
})
