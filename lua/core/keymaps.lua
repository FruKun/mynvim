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
map("i", "<Leader>.", "<ESC>")
map("v", "<Leader>.", "<ESC>")
-- Move macro
map("n", "q", "<Nop>", { desc = "Macro", noremap = true })
-- delete single character without copying into register
map("n", "x", '"_x', { desc = "delete char withotu copying" })
-- Reload configuration without restart nvim
map("n", "<leader>r", ":so %<CR>")
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
-- Tabs
map("n", "<Tab>", ":bnext<CR>")
map("n", "<s-Tab>", ":bprevious<CR>")
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
vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})
vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "gd", builtin.lsp_definitions)
