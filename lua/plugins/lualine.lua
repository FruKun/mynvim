local function get_venv(variable)
	local venv = os.getenv(variable)
	if venv ~= nil and string.find(venv, "/") then
		local orig_venv = venv
		for w in orig_venv:gmatch("([^/]+)") do
			venv = w
		end
		venv = string.format("%s", venv)
	end
	return venv
end
require("lualine").setup({
	options = { "auto" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "buffers" },
		lualine_x = {
			function()
				if vim.bo.filetype == "python" then
					local venv = get_venv("CONDA_DEFAULT_ENV") or get_venv("VIRTUAL_ENV") or "NO ENV"
					return " " .. venv
				else
					return ""
				end
			end,
			"filetype",
		},
		lualine_y = { "" },
		lualine_z = { "location" },
	},
})
