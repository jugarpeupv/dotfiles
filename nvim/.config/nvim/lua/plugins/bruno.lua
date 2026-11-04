-- lazy.nvim
return {
	{
		"SugarHashira/bruno.nvim",
		name = "bruno-api",
		enabled = true,
		init = function()
			vim.filetype.add({
				extension = {
					bru = "bruno",
				},
			})
		end,
    ft = { "bruno" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>hr", "<cmd>BrunoRun<cr>", desc = "Bruno: Run request" },
			{ "<leader>hR", "<cmd>BrunoReplay<cr>", desc = "Bruno: Replay last request" },
			{ "<leader>he", "<cmd>BrunoEnv<cr>", desc = "Bruno: Switch environment" },
			{ "<leader>hs", "<cmd>BrunoSearch<cr>", desc = "Bruno: Search requests" },
			{ "<leader>hv", "<cmd>BrunoToggleView<cr>", desc = "Bruno: Toggle view" },
			{ "<leader>hc", "<cmd>BrunoCopy<cr>", desc = "Bruno: Copy as cURL" },
			{ "<leader>hi", "<cmd>BrunoInspect<cr>", desc = "Bruno: Inspect last request" },
		},
		config = function()
			require("bruno").setup({
				collection_paths = {
					{ name = "nomo-api", path = "/Users/jgp/projects/nomo/wt-feature-rebrand/server/bruno" },
				},
				picker = "telescope", -- "telescope" | "fzf-lua" | "snacks"
				default_view = "body", -- "body" | "headers" | "headers_body" | "raw"
			})

			-- Bruno CLI >= 4 writes `[ { results: [...] } ]`, but the plugin
			-- expects `{ results: [...] }`, so every view silently falls back to
			-- raw. Unwrap the first iteration before rendering; the normalized
			-- value is reused by BrunoInspect / BrunoStats / BrunoCopy.
			local db = require("bruno.db")
			local ui = require("bruno.ui")
			local render = ui.render
			ui.render = function(bufnr, view)
				local raw = db.last_raw_output
				if raw then
					local ok, data = pcall(vim.json.decode, raw)
					if ok and type(data) == "table" and data.results == nil and data[1] and data[1].results then
						db.last_raw_output = vim.json.encode(data[1])
					end
				end
				return render(bufnr, view)
			end
		end,
	},
}
