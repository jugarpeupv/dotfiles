return {
	{
		-- "atiladefreitas/bloocky",
		"jugarpeupv/bloocky",
		-- dev = true,
		-- dir = "~/projects/bloocky/wt-bloocky-upstream-main/",
		keys = {
			{ "<leader>ec", "<cmd>Bloocky week work<cr>" },
			{ "<leader>ed", "<cmd>Bloocky day work<cr>" },
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
			local work_username = vim.fn.system("pass work_login | awk -F: '/^username:/{print $2}'"):gsub("%s+", "")
			local personal_username = vim.fn.system("pass gmail_personal_account"):gsub("%s+", "")
			require("bloocky").setup({
				granularity = 30,
				week_start = "monday", -- "sunday" (default) | "monday"
				keymaps = {
					toggle = false, -- Disables default <leader>tb
					toggle_sidebar = false, -- Disables default <leader>tB
				},
				window = {
					mode = "buffer", -- "float" | "sidebar" | "buffer" ("replace" alias)
					width = "auto",
					height = "auto",
				},
				sync = {
					enabled = true,
					sync_on_open = false, -- pull when the calendar opens
          debug = true, -- <-- enable
					accounts = {
						{
							id = "work",
							provider = "caldav",
						        auth_cmd = "davmail-token",
						        url = "http://localhost:1080",
							username = work_username,
						        password="",
							-- password_cmd = "pass work_login | head -1"
						},
						-- {
						-- 	id = "icloud",
						-- 	provider = "caldav",
						-- 	url = "https://caldav.icloud.com/",
						-- 	username = personal_username, -- your Apple ID email
						-- 	password_cmd = { "pass", "personal_apple_password" },
						-- },
					},
					-- optional: calendars = { { name="Calendar", mode="rw", default=true } } -- omit to sync all
				},
			})
		end,
	},
}
