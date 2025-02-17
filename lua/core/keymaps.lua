local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
-- ==== Base ==== --
-- ESC to
map("i", "<Leader>.", "<ESC>", { desc = "ESC" })
map("v", "<Leader>.", "<ESC>", { desc = "ESC" })
-- Terminal
map("t", "<Leader>.", "<C-\\><C-n>")
map("t", "<ESC>", "<C-\\><C-n>")
-- Move macro
map("n", "q", "<Nop>", { desc = "Macro", noremap = true })
-- Jump
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
-- Delete single character without copying into register
map("n", "x", '"_x', { desc = "delete char without copying" })
-- Reload configuration without restart nvim
map("n", "<leader>r", ":so %<CR>", { desc = "reload current open config file" })
-- Move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
-- Window resize (respecting `v:count`)
map(
	"n",
	"<C-Left>",
	'"<Cmd>vertical resize -" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Decrease window width" }
)
map(
	"n",
	"<C-Down>",
	'"<Cmd>resize -" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Decrease window height" }
)
map(
	"n",
	"<C-Up>",
	'"<Cmd>resize +" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Increase window height" }
)
map(
	"n",
	"<C-Right>",
	'"<Cmd>vertical resize +" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Increase window width" }
)
-- Buffers
map("n", "<Tab>", ":bnext<CR>")
map("n", "<s-Tab>", ":bprevious<CR>")
map("n", "<leader>d", ":bdelete<CR>")
-- remove highlight
map("n", "<leader>/", ":nohl<CR>", { desc = "clear search highlights" })
-- ==== Plugins ==== --
-- NeoTree
map("n", "<Leader>e", ":Neotree toggle <CR>")
-- Conform.format
vim.keymap.set("n", "<leader>ll", function()
	require("conform").format({
		lsp_format = "fallback",
		async = true,
		timeout_ms = 500,
	})
end, { desc = "Format file", noremap = true, silent = true })
-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Telescope git branches" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Telescope git commits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope git status" })
vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Telescope lsp document symbols" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "lsp references" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "lsp definitions" })
-- DAP (Debug Adapter Protocol)
vim.keymap.set("n", "<F10>", function()
	require("dap").continue()
end)
-- vim.keymap.set("n", "<F6>", function()
-- 	require("dap").step_over()
-- end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
-- vim.keymap.set("n", "<F8>", function()
-- 	require("dap").step_out()
-- end)
vim.keymap.set("n", "<Leader>xb", function()
	require("dap").toggle_breakpoint()
end, { desc = "breakpoint" })
-- vim.keymap.set("n", "<Leader>xb", function()
-- 	require("dap").set_breakpoint()
-- end)
-- vim.keymap.set("n", "<Leader>dL", function()
-- 	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
-- end)
-- vim.keymap.set("n", "<Leader>dr", function()
-- 	require("dap").repl.open()
-- end)
-- vim.keymap.set("n", "<Leader>dl", function()
-- 	require("dap").run_last()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
-- 	require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
-- 	require("dap.ui.widgets").preview()
-- end)
-- vim.keymap.set("n", "<Leader>df", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set("n", "<Leader>ds", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.scopes)
-- end)
map("n", "<leader>xm", "<cmd>lua require('dap-python').test_method()<CR>", { desc = "test method" })
map("n", "<leader>xc", "<cmd>lua require('dap-python').test_class()<CR>", { desc = "test class" })
map("v", "<leader>xs", "<ESC><cmd>lua require('dap-python').debug_selection()<CR>", { desc = "debug selection" })
map("n", "<leader>xt", "<cmd>lua require('dapui').toggle()<CR>", { desc = "dap ui toggle" })
-- F9, execute code!
local execute_code = function()
	if vim.bo.filetype == "python" then
		local run_cmd = "python " .. vim.fn.expand("%:p")
		vim.cmd("split | resize 10 | term " .. run_cmd)
		vim.cmd("startinsert")
	end
end

vim.keymap.set("n", "<F9>", execute_code, { desc = "execute python code" })
--
-- -- This function will close a terminal automatically if it gets the exit 0
-- vim.api.nvim_create_autocmd('TextChangedT', {
--   callback = function()
--     local buffer_name = vim.api.nvim_buf_get_name(0)
--     local buffer_table = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--     local buffer_text = table.concat(buffer_table, '\n')
--     if string.find(buffer_text, "Process exited 0") then
--       vim.api.nvim_input('<ESC>')
--       local timer = vim.loop.new_timer()
--       timer:start(100, 0, function()
--         vim.schedule(function()
--           vim.cmd("silent! bdelete" .. ' ' .. buffer_name .. '!')
--         end)
--       end)
--     end
--   end,
--   pattern = '*',
-- })
