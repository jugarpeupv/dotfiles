-- return {}
return {
	--Create local branch to track remote branch
	-- git branch --track feature/mytest origin/feature/mytest

	-- "ThePrimeagen/git-worktree.nvim",
	-- "polarmutex/git-worktree.nvim",
	-- "jugarpeupv/git-worktree.nvim",
	-- version = "^2",
	"jugarpeupv/git-worktree.nvim",
	dir = "~/projects/git-worktree.nvim",
	dev = true,
	-- branch = "main",
	-- dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>wt",
			function()
				require("telescope").extensions.git_worktree.git_worktree()
			end,
			{
				noremap = true,
				silent = true,
			},
		},
		{
			mode = { "n" },
			"<leader>wc",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			{ noremap = true, silent = true },
		},
	},
	config = function()
		vim.g.git_worktree_log_level = 1

		vim.g.git_worktree = {
			change_directory_command = "cd",
			update_on_change = true,
			update_on_change_command = "e .",
			clearjumps_on_change = true,
			confirm_telescope_deletions = false,
			autopush = false,
		}

		-- vim.keymap.set(
		-- 	{ "n" },
		-- 	"<leader>wt",
		-- 	":lua require('telescope').extensions.git_worktree.git_worktree()<cr>",
		-- 	{ noremap = true, silent = true, expr = false }
		-- )
		-- vim.keymap.set(
		-- 	{ "n" },
		-- 	"<leader>wc",
		-- 	":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
		-- 	{ noremap = true, silent = true, expr = false }
		-- )

		local Hooks = require("git-worktree.hooks")
		local update_on_switch = Hooks.builtins.update_current_buffer_on_switch
		-- local config = require("git-worktree.config")

		local send_cmd_to_all_terms = function(cmd_text)
			local function get_all_terminals()
				local terminal_chans = {}
				for _, chan in pairs(vim.api.nvim_list_chans()) do
					if chan["mode"] == "terminal" and chan["pty"] ~= "" then
						table.insert(terminal_chans, chan)
					end
				end
				table.sort(terminal_chans, function(left, right)
					return left["buffer"] < right["buffer"]
				end)
				if #terminal_chans == 0 then
					return nil
				end
				return terminal_chans
			end

			local send_to_terminal = function(terminal_chan, term_cmd_text)
				vim.api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
			end

			local terminals = get_all_terminals()
			if terminals and next(terminals) == nil then
				return nil
			end

			if terminals == nil then
				return nil
			end

			for _, terminal in pairs(terminals) do
				send_to_terminal(terminal["id"], cmd_text)
			end

			return true
		end

		Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
			local wt_utils = require("jg.custom.worktree-utils")
			local api_nvimtree = require("nvim-tree.api")
			local prev_node_modules_path = prev_path .. "/node_modules"
			local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)

			-- Copy over node_modules folder if it exists
			if prev_node_modules_exists ~= 0 then
				os.rename(prev_node_modules_path, path .. "/node_modules")
			end

			local ignored_root_files = wt_utils.get_ignored_root_files(prev_path, prev_path .. "/.git")

			for _, file in ipairs(ignored_root_files) do
				local prev_file_path = prev_path .. "/" .. file
				local prev_file_exists = vim.fn.filereadable(prev_file_path)
				if prev_file_exists ~= 0 then
					os.rename(prev_file_path, path .. "/" .. file)
				end
			end

			api_nvimtree.tree.reload()

			-- update .git/HEAD to the new branch so when you open a new terminal on root parent it shows the corrent branch

			local wt_switch_info = wt_utils.get_wt_info(path)
			if next(wt_switch_info) == nil then
				return
			end
			wt_utils.update_git_head(wt_switch_info.wt_root_dir, wt_switch_info.wt_head)

			-- Send command to the terminal to change the directory
			send_cmd_to_all_terms("cd " .. path)

			-- Write to disk new pointing branch
			local file_utils = require("jg.custom.file-utils")
			local wt_root_dir_with_ending = wt_switch_info.wt_root_dir .. "/"
			local my_table = {
				penultimate_wt = prev_path,
				last_active_wt = wt_switch_info.wt_dir,
			}
			file_utils.write_bps(file_utils.get_bps_path(wt_root_dir_with_ending), my_table)

			-- Update current file opened
			local current_buffer_filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
			if current_buffer_filetype == "NvimTree" then
				return
			else
				update_on_switch(path, prev_path)
			end
		end)

		Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
			local relative_path = path
			local Path = require("plenary.path")
			local original_path = ""
			if not Path:new(path):is_absolute() then
				original_path = Path:new():absolute():gsub("/wt%-[^/]+/?$", "/")
			end
			local prev_node_modules_path = original_path .. "/node_modules"
			local worktree_path = original_path .. "/" .. relative_path
			local destination_path = worktree_path .. "/node_modules"

			local prev_node_modules_exists = vim.fn.isdirectory(prev_node_modules_path)
			if prev_node_modules_exists ~= 0 then
				os.rename(prev_node_modules_path, destination_path)
				local api_nvimtree = require("nvim-tree.api")
				api_nvimtree.tree.reload()
			end

			local file_utils = require("jg.custom.file-utils")
			local my_table = {
				penultimate_wt = "",
				last_active_wt = worktree_path,
			}
			file_utils.write_bps(file_utils.get_bps_path(original_path), my_table)
		end)

		Hooks.register(Hooks.type.DELETE, function(path)
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) then
					local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
					if ft ~= "NvimTree" then
						vim.api.nvim_buf_delete(bufnr, { force = true })
					end
				end
			end
			local api_nvimtree = require("nvim-tree.api")
			api_nvimtree.git.reload()
			api_nvimtree.tree.reload()
		end)
	end,
}
