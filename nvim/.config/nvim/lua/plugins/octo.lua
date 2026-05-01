-- Open a GitHub issue/PR URL under the cursor in an Octo buffer
-- Supports: github.com/{owner}/{repo}/issues/{n}
--           github.com/{owner}/{repo}/pull/{n}
local function open_github_url()
	local line = vim.api.nvim_get_current_line()
	-- Strip common URL-terminating markdown/punctuation chars before matching
	line = line:gsub("[%)%]>\"']", " ")
	local owner, repo, number = line:match("github%.com/([^/]+)/([^/]+)/issues/(%d+)")
	local cmd = "issue"
	if not owner then
		owner, repo, number = line:match("github%.com/([^/]+)/([^/]+)/pull/(%d+)")
		cmd = "pr"
	end
	if not owner or not number then
		vim.notify(
			string.format(
				"No GitHub issue/PR URL found on current line (got: %s %s %s)",
				tostring(owner),
				tostring(repo),
				tostring(number)
			),
			vim.log.levels.WARN
		)
		return
	end
	local final_cmd = string.format("Octo %s edit %s %s/%s", cmd, number, owner, repo)
	vim.cmd(final_cmd)
end

return {
	{
		-- "pwntester/octo.nvim",
		"jugarpeupv/octo.nvim",
		-- dev = true,
		-- dir = "~/projects/octo.nvim/wt-master",
		-- dependencies = {
		-- -- 	"nvim-lua/plenary.nvim",
		-- -- 	"nvim-telescope/telescope.nvim",
		-- 	"ibhagwan/fzf-lua",
		-- -- 	"nvim-tree/nvim-web-devicons",
		-- },
		cmd = { "Octo" },
		-- "<cmd>Octo search review-requested:GPJULI6_mapfre is:pr involves:GPJULI6_mapfre state:open -team-review-requested:arch-gva-dev -team-review-requested:arch-gva-mnt -team-review-requested:arch-gva-own<cr>",
		keys = {
			{
				mode = { "n" },
				"<leader>og",
				function()
					open_github_url()
				end,
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>oc",
				"<cmd>Octo issue create mapfre-tech/arch-mar2-mgmt<cr>",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>or",
				":Octo search is:pr involves:GPJULI6_mapfre state:open",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>oP",
				":Octo search author:GPJULI6_mapfre is:pr is:open owner:mapfre-tech",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>op",
				":Octo pr create",
				{ noremap = true, silent = true },
			},
			{
				mode = { "n" },
				"<leader>os",
				-- "<cmd>Octo search assignee:GPJULI6_mapfre is:issue is:open label:task type:issue repo:mapfre-tech/arch-mar2-mgmt<cr>",
				":Octo search is:issue assignee:GPJULI6_mapfre repo:mapfre-tech/arch-mar2-mgmt is:open",
				-- ":Octo search assignee:GPJULI6_mapfre is:issue is:open",
				-- ":Octo search assignee:GPJULI6_mapfre is:issue is:open repo:mapfre-tech/arch-mar2-mgmt",
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
			-- picker = "snacks", -- 'telescope' or 'fzf-lua'
			-- picker = "fzf-lua", -- 'telescope' or 'fzf-lua'
			picker = "snacks", -- 'telescope' or 'fzf-lua'
			-- picker = "fzf-lua",
			default_to_projects_v2 = true,
			picker_config = {
				use_emojis = false, -- only used by "fzf-lua" picker for now
				search_static = true,
				mappings = { -- mappings for the pickers
					open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
					copy_url = { lhs = "<C-p>", desc = "copy url to system clipboard" },
					copy_sha = { lhs = "<C-n>", desc = "copy commit SHA to system clipboard" },
					checkout_pr = { lhs = "<C-l>", desc = "checkout pull request" },
					merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
				},
			},
			mappings = {
				issue = {
					set_project_field_type = { lhs = "<localleader>ts", desc = "set project Type field" },
					set_project_field_status = { lhs = "<localleader>cs", desc = "set project Status field" },
					close_issue = { lhs = "<localleader>ic", desc = "close issue" },
					reopen_issue = { lhs = "<localleader>io", desc = "reopen issue" },
					list_issues = { lhs = "<localleader>il", desc = "list open issues on same repo" },
					reload = { lhs = "<C-r>", desc = "reload issue" },
					open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
					copy_url = { lhs = "<C-p>", desc = "copy url to system clipboard" },
					add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
					remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
					create_label = { lhs = "<localleader>lc", desc = "create label" },
					add_label = { lhs = "<localleader>la", desc = "add label" },
					remove_label = { lhs = "<localleader>ld", desc = "remove label" },
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
				},
				pull_request = {
					checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
					merge_pr = { lhs = "<localleader>pm", desc = "merge PR" },
          merge_pr_admin = { lhs = "<localleader>pM", desc = "merge PR bypassing branch protections (admin)" },
					squash_and_merge_pr = { lhs = "<localleader>psm", desc = "squash and merge PR" },
					rebase_and_merge_pr = { lhs = "<localleader>prm", desc = "rebase and merge PR" },
					merge_pr_queue = {
						lhs = "<localleader>pq",
						desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo)",
					},
					squash_and_merge_queue = {
						lhs = "<localleader>psq",
						desc = "squash and add to merge queue (Merge queue must be enabled in the repo)",
					},
					rebase_and_merge_queue = {
						lhs = "<localleader>prq",
						desc = "rebase and add to merge queue (Merge queue must be enabled in the repo)",
					},
					list_commits = { lhs = "<localleader>pc", desc = "list PR commits" },
					list_changed_files = { lhs = "<localleader>pf", desc = "list PR changed files" },
					show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
					add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
					remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer request" },
					close_issue = { lhs = "<localleader>ic", desc = "close PR" },
					reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
					list_issues = { lhs = "<localleader>il", desc = "list open issues on same repo" },
					reload = { lhs = "<C-r>", desc = "reload PR" },
					open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
					copy_url = { lhs = "<C-p>", desc = "copy url to system clipboard" },
					copy_sha = { lhs = "<C-n>", desc = "copy commit SHA to system clipboard" },
					goto_file = { lhs = "gf", desc = "go to file" },
					add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
					remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
					create_label = { lhs = "<localleader>lc", desc = "create label" },
					add_label = { lhs = "<localleader>la", desc = "add label" },
					remove_label = { lhs = "<localleader>ld", desc = "remove label" },
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
					review_start = { lhs = "<localleader>vs", desc = "start a review for the current PR" },
					review_resume = { lhs = "<localleader>vr", desc = "resume a pending review for the current PR" },
					resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
					unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
				},
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
					copy_sha = { lhs = "<C-n>", desc = "copy commit SHA to system clipboard" },
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

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "octo",
				group = vim.api.nvim_create_augroup("octo_filetypedetect", { clear = true }),
				callback = function()
					vim.schedule(function()

            function _G.MarkdownFold()
              local line = vim.fn.getline(vim.v.lnum)
              local level = line:match("^(#+)%s")
              if level then
                return ">" .. #level -- ">" means "start a fold of this level"
              end
              return "=" -- "=" means "same fold level as previous line"
            end

            function _G.MarkdownFoldText()
              local first_line = vim.fn.getline(vim.v.foldstart)
              local line_count = vim.v.foldend - vim.v.foldstart
              return first_line .. " - " .. line_count .. " lines folded"
            end

						vim.wo.conceallevel = 0
						vim.wo.cursorline = true
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.MarkdownFold()"
            vim.opt_local.foldlevel = 99 -- open all folds by default
            vim.opt_local.foldtext = "v:lua.MarkdownFoldText()"
						vim.cmd("hi htmlItalic gui=none")
					end)
				end,
			})
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
