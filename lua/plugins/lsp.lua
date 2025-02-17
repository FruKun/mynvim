return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities() -- for CMP
			local lsp = require("lspconfig")
			lsp.pylsp.setup({
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							flake8 = {
								enabled = true,
								maxLineLength = 120,
								ignore = { "W391", "W503" },
								-- config = "",
							},
							isort = {
								enabled = true,
								maxLineLength = 120,
							},
							black = {
								enabled = true,
							},
							pycodestyle = {
								enabled = false,
							},
							mccabe = {
								enabled = false,
							},
							pyflakes = {
								enabled = false,
							},
						},
					},
				},
			})

			lsp.lua_ls.setup({
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {},
				},
				capabilities = capabilities, -- for CMP
				-- for barbecue
				on_attach = function(client, bufnr)
					-- ...

					if client.server_capabilities["documentSymbolProvider"] then
						require("nvim-navic").attach(client, bufnr)
					end

					-- ...
				end,
			})

			lsp.html.setup({
				capabilities = capabilities,
			})
		end,
	},
}
