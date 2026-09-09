return {
	{
		-- "atiladefreitas/bloocky",
    "jugarpeupv/bloocky",
		-- dev = true,
		-- dir = "~/projects/bloocky/wt-bloocky-upstream-main/",
		keys = {
			{ "<leader>tb", "<cmd>Bloocky week<cr>" },
			{ "<leader>tB", "<cmd>Bloocky day<cr>" },
		},
		cmd = {
			"Bloocky",
			"BloockyToggle",
			"BloockyAdd",
			"BloockySidebar",
			"BloockySync",
			"BloockySyncStatus",
			"BloockySyncReport",
			"BloockySyncRestore",
			"BloockySyncAuth",
			"BloockySyncRevoke",
			"BloockySyncReset",
		},
		config = function()
			local username = vim.fn.system("pass izertis_login | awk -F: '/^username:/{print $2}'"):gsub("%s+", "")
			require("bloocky").setup({
				granularity = 30,
				week_start = "monday", -- "sunday" (default) | "monday"
        keymaps = {
          toggle = false,          -- Disables default <leader>tb
          toggle_sidebar = false,  -- Disables default <leader>tB
        },
				window = {
					mode = "buffer", -- "float" | "sidebar" | "buffer" ("replace" alias)
          width = "auto",
          height = "auto",
				},
				sync = {
					enabled = true,
					sync_on_open = false, -- pull when the calendar opens
					accounts = {
						{
							id = "izertis",
							provider = "caldav",
              auth_cmd = "davmail-token",
              url = "http://localhost:1080",
							username = username,
              password="",
							-- password_cmd = "pass izertis_login | head -1"
						},
					},
					-- optional: calendars = { { name="Calendar", mode="rw", default=true } } -- omit to sync all
				},
			})
		end,
	},
}
