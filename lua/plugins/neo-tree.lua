return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignore = true,
					},
				},
				window = {
					mappings = {
						["e"] = function()
							vim.api.nvim_exec("Neotree focus filesystem left", true)
						end,
						["b"] = function()
							vim.api.nvim_exec("Neotree focus buffers left", true)
						end,
						["g"] = function()
							vim.api.nvim_exec("Neotree focus git_status left", true)
						end,
						["<tab>"] = function(state)
							state.commands["open"](state)
							vim.cmd("Neotree reveal")
						end,
						["d"] = function(state)
							local inputs = require("neo-tree.ui.inputs")
							local path = state.tree:get_node().path
							local msg = "Are you sure you want to trash " .. path
							inputs.confirm(msg, function(confirmed)
								if not confirmed then
									return
								end

								vim.fn.system({ "trash", vim.fn.fnameescape(path) })
								require("neo-tree.sources.manager").refresh(state.name)
							end)
						end,
					},
				},
				event_handlers = {

					{
						event = "file_open_requested",
						handler = function()
							-- auto close
							-- vim.cmd("Neotree close")
							-- OR
							require("neo-tree.command").execute({ action = "close" })
						end,
					},
				},
			})
		end,
	},
}
