return {
	{
		"yousefakbar/notmuch.nvim",
		-- dir = "~/projects/notmuch.nvim/wt-feature-sync_mail_async/",
		-- dev = true,
		enabled = true,
		opts = {
			notmuch_db_path = os.getenv("HOME") .. "/Mail",
			open_cmd = "open",
			maildir_sync_cmd = "mbsync -a",
			keymaps = {
				sendmail = "S",
				compose = "C",
				reply = "R",
			},
		},
		keys = {
			-- { mode = { "n" }, "<leader>nn", "<cmd>Notmuch<cr>", { silent = true } },
			{ mode = { "n" }, "<leader><space>", "<cmd>Notmuch<cr>", { silent = true } },

			{
				mode = { "n" },
				"<leader>nn",
				"<cmd>NmSearch tag:inbox and tag:unread and not tag:github<cr>",
				{ silent = true },
			},

			{
				mode = { "n" },
				"<leader>na",
				function()
					require("jg.custom.telescope").notmuch_picker()
				end,
				{ silent = true },
			},
		},
	},
	-- {
	-- 	"pimalaya/himalaya-vim",
	-- 	config = function()
	-- 		local pick_and_paste_filepath_at = function(root_dir)
	-- 			if root_dir == nil then
	-- 				root_dir = "~"
	-- 			end
	--
	-- 			if type(root_dir) ~= "string" then
	-- 				vim.notify("pick_and_paste_filepath_at root_dir needs to be string", vim.log.levels.ERROR)
	-- 				return
	-- 			end
	--
	-- 			root_dir = vim.fs.normalize(root_dir)
	--
	-- 			-- disable BufLeave autocmd temporarily
	-- 			local au_opts = {
	-- 				group = "himalaya_write",
	-- 				event = { "BufLeave" },
	-- 			}
	-- 			local au = vim.api.nvim_get_autocmds(au_opts)
	-- 			if au == nil or #au ~= 1 then
	-- 				vim.notify(
	-- 					"pick_and_paste_filepath_at: expected exactly one autocmd but got: \n" .. vim.inspect(au),
	-- 					vim.log.levels.ERROR
	-- 				)
	-- 				return
	-- 			end
	-- 			au = au[1]
	-- 			vim.api.nvim_clear_autocmds(au_opts)
	--
	-- 			local actions = require("telescope.actions")
	-- 			local action_state = require("telescope.actions.state")
	--
	-- 			-- save working directory to restore later
	-- 			local prev_wd = vim.fn.getcwd()
	--
	-- 			-- cd to root_dir only for window
	-- 			vim.cmd(string.format("silent lcd %s", vim.fn.expand(root_dir)))
	--
	-- 			local function run_selection(prompt_bufnr, map)
	-- 				-- replace default action on <cr> in telescope picker
	-- 				actions.select_default:replace(function()
	-- 					-- close telescope buffer
	-- 					actions.close(prompt_bufnr)
	-- 					-- insert selected filepath
	-- 					local selection = action_state.get_selected_entry()
	-- 					vim.paste({ vim.fs.joinpath(root_dir, selection[1]) }, -1)
	-- 					-- restore wd for window
	-- 					vim.cmd(string.format("silent lcd %s", vim.fn.expand(prev_wd)))
	-- 					-- restore BufLeave autocmd
	-- 					vim.api.nvim_create_autocmd(au.event, {
	-- 						group = au.group,
	-- 						buffer = au.buffer,
	-- 						command = au.command,
	-- 						once = au.once,
	-- 					})
	-- 					-- restore cursor position
	-- 					vim.cmd([[normal! 'z]])
	-- 				end)
	-- 				-- has to return true
	-- 				return true
	-- 			end
	--
	-- 			-- run telescope file picker with our custom function
	-- 			local opts = { attach_mappings = run_selection }
	-- 			require("telescope.builtin").find_files(opts)
	-- 		end
	--
	-- 		-- add attachment at the end of file, pick file with telescope at `root_dir`
	-- 		local add_attachment = function(root_dir)
	-- 			local k = vim.keycode
	-- 			return function()
	-- 				-- set mark to restore cursor postion later
	-- 				vim.cmd([[normal! mz]])
	-- 				-- set goto end and add 2 newlines
	-- 				vim.cmd([[normal! Go]] .. k("<cr>") .. k("<esc>"))
	-- 				-- insert attachment boilerplate
	-- 				vim.paste({ "<#part filename=><#/part>" }, -1)
	-- 				-- move cursor to =
	-- 				vim.cmd([[normal! 0f=]])
	-- 				pick_and_paste_filepath_at(root_dir)
	-- 			end
	-- 		end
	--
	-- 		vim.api.nvim_create_autocmd({ "FileType" }, {
	-- 			group = vim.api.nvim_create_augroup("mail_himalaya_augroup", { clear = true }),
	-- 			pattern = { "mail" },
	-- 			callback = function(ev)
	-- 				vim.keymap.set("n", "gtt", add_attachment("/Users/jgarcia/Documents"), {
	-- 					desc = "add email attachment",
	-- 					buffer = true,
	-- 					silent = true,
	-- 				})
	-- 			end,
	-- 			desc = "add email attachment",
	-- 		})
	-- 	end,
	-- },
	-- { 'felipec/notmuch-vim' }

	-- {
	-- 	"aliyss/vim-himalaya-ui",
	-- 	-- cmd = {
	-- 	-- 	"HimalayaUI",
	-- 	-- },
	-- 	-- init = function()
	-- 	-- 	-- Your HimalayaUI configuration
	-- 	-- end,
	-- },
}
