return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<leader>tt", -- 2<leader>tn = 2 term
			})
		end,
	},
}
