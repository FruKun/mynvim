local opt = vim.opt
-----------------------------------------------------------
-- ОБЩИЕ ОПЦИИ
-----------------------------------------------------------
-- vim.cmd.colorscheme("catppuccin")

-- Use English as main language
vim.cmd([[language en_US.UTF-8]])

opt.clipboard = "unnamedplus"
opt.mouse = "a" --Включит мышь
opt.encoding = "utf-8" --Кодировка
opt.showcmd = true --Отображение команд
vim.cmd([[
filetype indent plugin on
syntax enable
]])
opt.swapfile = true
opt.undofile = true
opt.undolevels = 1000
-----------------------------------------------------------
-- ВИЗУАЛЬНЫЕ ОПЦИИ
-----------------------------------------------------------
opt.number = true --Номер строк сбоку
opt.relativenumber = true
opt.expandtab = true
opt.tabstop = 4 --1 tab = 4 пробела
opt.smartindent = true
opt.autoindent = true
opt.softtabstop = 4
opt.shiftwidth = 4 --Смещаем на 4 пробела
opt.smarttab = true
opt.wrap = false
opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.laststatus = 3
opt.splitbelow = true
opt.splitright = true

vim.wo.signcolumn = "yes"

opt.cursorline = true -- Подсветка строки с курсором
opt.cursorlineopt = "number"
opt.termguicolors = true

vim.cmd([[highlight clear LineNr]])
vim.cmd([[highlight clear SignColumn]])

-----------------------------------------------------------
-- НАСТРОЙКИ ПОИСКА
-----------------------------------------------------------
-- Будет игнорировать размер букв при поиске
opt.ignorecase = true --Игнорировать размер букв
opt.smartcase = true --Игнор прописных букв
opt.showmatch = true
