-- return {}
return {
	{
		"cbochs/grapple.nvim",
		-- opts = {
		-- 	scope = "git", -- also try out "git_branch"
		-- },
		enabled = true,
		-- event = { "BufReadPost", "BufNewFile" },
		-- cmd = { "Grapple", "Telescope" },
		keys = {
			{
				"<leader>hg",
				function()
					local actions = require("telescope.actions")

					local wt_utils = require("jg.custom.worktree-utils")
					local wt_info = wt_utils.get_wt_info(vim.loop.cwd())

					if not wt_info or next(wt_info) == nil then
						return
					end

					local function create_finder()
						local Grapple = require("grapple")
						local tags, err = Grapple.tags()
						if not tags then
							---@diagnostic disable-next-line: param-type-mismatch
							return vim.notify(err, vim.log.levels.ERROR)
						end

						local results = {}
						for i, tag in ipairs(tags) do
							---@class grapple.telescope.result
							local result = {
								i,
								tag.path,
								(tag.cursor or { 1, 0 })[1],
								(tag.cursor or { 1, 0 })[2],
							}

							table.insert(results, result)
						end

						return require("telescope.finders").new_table({
							results = results,

							---@param result grapple.telescope.result
							entry_maker = function(result)
								local utils = require("telescope.utils")
								local filename = result[2]
								local lnum = result[3]

								local entry = {
									value = result,
									ordinal = filename,
									display = utils.transform_path({ path_display = { "tail" } }, filename),
									filename = filename,
									lnum = lnum,
								}

								return entry
							end,
						})
					end

					local open_in_split = function(prompt_bufnr)
						local worktree_path = wt_info.wt_dir
						actions.close(prompt_bufnr)

						local action_state = require("telescope.actions.state")
						local selection = action_state.get_selected_entry()
						-- print("Current buffer: ", current_buf_name)
						local relpath = selection.filename:match("wt%-[^/]+/(.+)")
						if not relpath then
							print("Current file is not inside a worktree")
							return
						end
						local command = "sp | e " .. worktree_path .. "/" .. relpath
						print("Executing command: ", command)

						vim.cmd(command)
					end

					local open_in_vsplit = function(prompt_bufnr)
						local worktree_path = wt_info.wt_dir
						actions.close(prompt_bufnr)

						local action_state = require("telescope.actions.state")
						local selection = action_state.get_selected_entry()
						-- print("Current buffer: ", current_buf_name)
						local relpath = selection.filename:match("wt%-[^/]+/(.+)")
						if not relpath then
							print("Current file is not inside a worktree")
							return
						end

						local command = "vsp | e " .. worktree_path .. "/" .. relpath
						print("Executing command: ", command)

						vim.cmd(command)
					end

					local select_file = function(prompt_bufnr)
						local worktree_path = wt_info.wt_dir
						actions.close(prompt_bufnr)

						local action_state = require("telescope.actions.state")
						local selection = action_state.get_selected_entry()
						-- print("Current buffer: ", current_buf_name)
						local relpath = selection.filename:match("wt%-[^/]+/(.+)")
						if not relpath then
							print("Current file is not inside a worktree")
							return
						end

						local command = "e " .. worktree_path .. "/" .. relpath

						vim.cmd(command)
					end

					require("telescope").extensions.grapple.tags({
						layout_strategy = 'bottom_pane',
						layout_config = {
							bottom_pane = { width = 1, height = 0.47, preview_width = 0.40 },
						},
						finder = create_finder(),
						attach_mappings = function(_, map)
							local action_set = require("telescope.actions.set")
							action_set.select:replace(select_file)
							map("i", "<C-v>", open_in_vsplit)
							map("n", "<C-v>", open_in_vsplit)
							map("i", "<C-s>", open_in_split)
							map("n", "<C-s>", open_in_split)
							return true
						end,
					})
				end,
			},
			{ "<leader>hh", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
			{ "<leader>aa", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
			{ "<leader>S", "<cmd>Grapple toggle_scopes<cr>", desc = "Grappel toggle scopes" },
			{ "<leader>N", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			{ "<leader>P", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },

			{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
			{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
			{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
			{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },
			{ "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Select fifth tag" },
      { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Select fifth tag" },
      { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Select fifth tag" },
		},
		config = function()
			require("grapple").setup({
				scope = "worktree",
        style = "basename",
				---Default command to use when selecting a tag
				---@type fun(path: string)
				command = function(path)
					local wt_utils = require("jg.custom.worktree-utils")
					local wt_info = wt_utils.get_wt_info(vim.loop.cwd())

					if not wt_info or next(wt_info) == nil then
						vim.cmd("edit " .. path)
						return
					end

					local actual_worktree_dir = wt_info.wt_dir
					local last_part = path:match("wt%-[^/]+/(.+)")
					local actual_path = actual_worktree_dir .. "/" .. last_part
					vim.cmd("edit " .. actual_path)
				end,
				scopes = {
					{
						name = "worktree",
						desc = "worktree scope",
						fallback = "git_branch",
						-- cache = {
						--   event = { "DirChanged" },
						-- },
						resolver = function()
							local wt_utils = require("jg.custom.worktree-utils")
							local wt_info = wt_utils.get_wt_info(vim.loop.cwd())

							if not wt_info or next(wt_info) == nil then
								local cwd = vim.loop.cwd()
								return cwd, cwd
							end
							local id = wt_info.wt_root_dir
							local path = wt_info.wt_dir

							return id, path
						end,
					},
				},
			})
		end,
	},
}
