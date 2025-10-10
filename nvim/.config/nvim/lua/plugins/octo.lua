return {
	{
		"pwntester/octo.nvim",
		-- commit = "c96a03d2aa4688f45fb8d58e832fdd37d104f12d",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR 'ibhagwan/fzf-lua',
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "Octo" },
    -- "<cmd>Octo search review-requested:GPJULI6_mapfre is:pr involves:GPJULI6_mapfre state:open -team-review-requested:arch-gva-dev -team-review-requested:arch-gva-mnt -team-review-requested:arch-gva-own<cr>",
		keys = {
			{
				mode = { "n" },
				"<leader>or",
				"<cmd>Octo search review-requested:GPJULI6_mapfre is:pr involves:GPJULI6_mapfre state:open<cr>",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>op",
				"<cmd>Octo search author:GPJULI6_mapfre is:pr is:open owner:mapfre-tech<cr>",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>os",
				-- "<cmd>Octo search assignee:GPJULI6_mapfre is:issue is:open label:task type:issue repo:mapfre-tech/arch-mar2-mgmt<cr>",
        "<cmd>Octo search assignee:GPJULI6_mapfre is:issue is:open repo:mapfre-tech/arch-mar2-mgmt<cr>",
				{ noremap = true, silent = true },
			},
		},
		opts = {
			-- github_hostname = "github.com", -- Change to your own ghe host
			ssh_aliases = {
				["github.com-mar"] = "github.com",
				["github.com-work"] = "github.com",
				["github.com-izertis"] = "github.com",
				["github.com-personal"] = "github.com",
			}, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
			-- picker = "fzf-lua", -- 'telescope' or 'fzf-lua'
			-- picker = "snacks", -- 'telescope' or 'fzf-lua'
			picker = "snacks", -- 'telescope' or 'fzf-lua'
			picker_config = {
				use_emojis = false, -- only used by "fzf-lua" picker for now
				mappings = { -- mappings for the pickers
					open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
					copy_sha = { lhs = "<C-h>", desc = "copy commit SHA to system clipboard" },
					checkout_pr = { lhs = "<C-e>", desc = "checkout pull request" },
					merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
				},
			},
			mappings = {
				review_diff = {
					submit_review = { lhs = "<localleader>vs", desc = "submit review" },
					discard_review = { lhs = "<localleader>vd", desc = "discard review" },
					add_review_comment = {
						lhs = "<localleader>ca",
						desc = "add a new review comment",
						mode = { "n", "x" },
					},
					add_review_suggestion = {
						lhs = "<localleader>sa",
						desc = "add a new review suggestion",
						mode = { "n", "x" },
					},
					focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
					toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
					next_thread = { lhs = "]t", desc = "move to next thread" },
					prev_thread = { lhs = "[t", desc = "move to previous thread" },
					select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
					goto_file = { lhs = "gf", desc = "go to file" },
				},
				file_panel = {
					submit_review = { lhs = "<localleader>vs", desc = "submit review" },
					discard_review = { lhs = "<localleader>vd", desc = "discard review" },
					next_entry = { lhs = "j", desc = "move to next changed file" },
					prev_entry = { lhs = "k", desc = "move to previous changed file" },
					select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
					refresh_files = { lhs = "R", desc = "refresh changed files panel" },
					focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
					toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
					select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
				},
				review_thread = {
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
					resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
					unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
				},
			},
		},
		config = function(_, opts)
			require("octo").setup(opts)
			vim.treesitter.language.register("markdown", "octo")
		end,
		-- config = function()
		--   require("octo").setup({
		--     -- github_hostname = "github.com", -- Change to your own ghe host
		--     ssh_aliases = {
		--       ["github.com-mar"] = "github.com",
		--       ["github.com-work"] = "github.com",
		--       ["github.com-izertis"] = "github.com",
		--       ["github.com-personal"] = "github.com",
		--     }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
		--   })
		-- end,
	},
}
