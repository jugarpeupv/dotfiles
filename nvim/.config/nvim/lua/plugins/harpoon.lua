-- return {}

-- ---@diagnostic disable: missing-parameter
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
    enabled = false,
		-- commit = "e76cb03",
		-- event = "VeryLazy",
		keys = {
			-- { "<leader>A", function() require("harpoon"):list():append() end, desc = "harpoon file", },
			{
				"<leader>aa",
				function()
					require("harpoon"):list():add()
				end,
				desc = "harpoon file",
			},
			{
				"<leader>hh",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "harpoon file list toggle",
			},
			-- { "<leader>ha", "<cmd>Telescope harpoon marks<cr>", desc = "harpoon quick menu" },
			-- { "<leader>a", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "harpoon quick menu", },
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "harpoon to file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "harpoon to file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "harpoon to file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "harpoon to file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "harpoon to file 5",
			},
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon.setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					-- key = function()
					-- 	local wt_utils = require("jg.custom.worktree-utils")
					-- 	local wt_switch_info = wt_utils.get_wt_info(vim.loop.cwd())
					--
					--         -- wt_switch_info {
					--         --   wt_dir = "/Users/jgarcia/work/arch-ram-nx-extensions/wt-feature-cli-improvements",
					--         --   wt_git_dir = "/Users/jgarcia/work/arch-ram-nx-extensions/worktrees/wt-feature-cli-improvements",
					--         --   wt_head = "feature/cli-improvements",
					--         --   wt_name = "wt-feature-cli-improvements",
					--         --   wt_root_dir = "/Users/jgarcia/work/arch-ram-nx-extensions"
					--         -- }
					-- 	if wt_switch_info == nil or next(wt_switch_info) == nil then
					-- 		return vim.loop.cwd()
					-- 	end
					-- 	return wt_switch_info.wt_root_dir
					-- end,
				},
			}, {
				-- menu = {
				-- 	width = vim.api.nvim_win_get_width(0) - 48,
				-- },
			})

			-- harpoon:extend(require("harpoon.extensions").builtins.command_on_nav('UfoEnableFold'))
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- local harpoon_extensions = require("harpoon.extensions")
			-- harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

			vim.keymap.set("n", "<leader>ha", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })

			vim.keymap.set("n", "<leader>mm", function()
        local worktree_list_name
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_switch_info = wt_utils.get_wt_info(vim.loop.cwd())

				-- if wt_switch_info == nil or next(wt_switch_info) == nil then
				-- 	worktree_list_name = vim.loop.cwd()
				--     else
				--   worktree_list_name = wt_switch_info.wt_root_dir
				--     end

				worktree_list_name = wt_switch_info.wt_root_dir
				harpoon:list(worktree_list_name):append()
			end)

			vim.keymap.set("n", "<leader>hh", function()
        local worktree_list_name
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_switch_info = wt_utils.get_wt_info(vim.loop.cwd())

				-- if wt_switch_info == nil or next(wt_switch_info) == nil then
				-- 	worktree_list_name = vim.loop.cwd()
				--     else
				--   worktree_list_name = wt_switch_info.wt_root_dir
				--     end

				worktree_list_name = wt_switch_info.wt_root_dir
				harpoon.ui:toggle_quick_menu(harpoon:list(worktree_list_name), {})
			end)

			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})
			-- Harpoon
			-- keymap("n", "<Leader>ha", "<cmd>Telescope harpoon marks<cr>", opts)
			-- keymap("n", "<Leader>aa", "<cmd>lua require('harpoon.mark').add_file()<cr>", opts)
			-- keymap("n", "<Leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
			-- keymap("n", "<Leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", opts)
			-- keymap("n", "<Leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", opts)
			-- keymap("n", "<Leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", opts)
			-- keymap("n", "<Leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", opts)
			-- keymap("n", "<Leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", opts)
			-- keymap("n", "<Leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", opts)
			-- keymap("n", "<Leader>7", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", opts)
			-- keymap("n", "<Leader>8", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", opts)
			-- keymap("n", "<Leader>9", "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", opts)

			-- vim.keymap.set("n", "<leader>aa", function()
			--   harpoon:list():add()
			-- end)

			-- vim.keymap.set("n", "<Leader>ha", "<cmd>Telescope harpoon marks<cr>")
			-- vim.keymap.set("n", "<leader>hh", function()
			--   harpoon.ui:toggle_quick_menu(harpoon:list())
			-- end)

			-- vim.keymap.set("n", "<Leader>1", function()
			--   harpoon:list():select(1)
			-- end)
			-- vim.keymap.set("n", "<Leader>2", function()
			--   harpoon:list():select(2)
			-- end)
			-- vim.keymap.set("n", "<Leader>3", function()
			--   harpoon:list():select(3)
			-- end)
			-- vim.keymap.set("n", "<Leader>4", function()
			--   harpoon:list():select(4)
			-- end)
			-- vim.keymap.set("n", "<Leader>5", function()
			--   harpoon:list():select(5)
			-- end)
			-- vim.keymap.set("n", "<Leader>6", function()
			--   harpoon:list():select(6)
			-- end)

			-- Toggle previous & next buffers stored within Harpoon list
			-- vim.keymap.set("n", "<C-k>", function() harpoon:list():prev() end)
			-- vim.keymap.set("n", "<C-j>", function() harpoon:list():next() end)
		end,
	},
}
