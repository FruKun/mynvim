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
-- Notify when file changed
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
-- Check file type
autocmd({ "BufRead" }, {
	pattern = "*",
	group = augroup("non_utf8_file", { clear = true }),
	callback = function()
		if vim.bo.fileencoding ~= "utf-8" then
			vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
		end
	end,
})

-- Resize all windows when we resize the terminal
autocmd("VimResized", {
	group = augroup("win_autoresize", { clear = true }),
	desc = "autoresize windows on resizing operation",
	command = "wincmd =",
})
-- open neo tree when start nvim in dir
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

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = augroup("kickstart-lsp-highlight", { clear = false })
			autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})
