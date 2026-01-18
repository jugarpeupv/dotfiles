return {
	{
		"rebelot/terminal.nvim",
		enabled = true,
		keys = {
			{
				"<M-ñ>",
				mode = { "n", "t" },
				function()
					-- vim.cmd("TermToggle enew")
					-- local term_map = require("terminal.mappings")
					-- term_map.toggle({ layout = {} })
					local get_terminal_bufs = function()
						return vim.tbl_filter(function(bufnr)
							return vim.fn.getbufvar(bufnr, "&buftype") == "terminal"
								and vim.fn.getbufvar(bufnr, "&ft") == ""
						end, vim.api.nvim_list_bufs())
					end

					local terminals = get_terminal_bufs()
					local there_are_no_terminal_buffers = next(terminals) == nil

					if there_are_no_terminal_buffers then
						vim.cmd("term")
						return
					else -- there are terminal buffers
						local function get_opened_buffers_count()
							local buffers = vim.api.nvim_list_bufs()
							local opened_buffers = vim.tbl_filter(function(bufnr)
								return vim.api.nvim_buf_is_loaded(bufnr)
							end, buffers)
							return #opened_buffers
						end

						local opened_buffers_count = get_opened_buffers_count()

						local current_buf = vim.api.nvim_get_current_buf()
						local buftype = vim.fn.getbufvar(current_buf, "&buftype")
						if buftype == "terminal" and opened_buffers_count > 2 then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true),
								"n",
								true
							)
							vim.schedule(function()
								require("bufjump").backward()
							end)
						else
							vim.cmd("TermToggle enew")
						end

						-- local current_buf2 = vim.api.nvim_get_current_buf()
						--
						-- if current_buf == current_buf2 then
						--   vim.cmd("TermToggle enew")
						-- end
					end
				end,
				{ silent = true, noremap = true },
			},
			{
				"<M-l>",
				mode = { "n", "t" },
				function()
					vim.cmd("wa")
					local win_ids = vim.api.nvim_list_wins()
					for _, win_id in ipairs(win_ids) do
						require("barbecue.ui").update(win_id)
					end
					local get_terminal_bufs = function()
						return vim.tbl_filter(function(bufnr)
							local filetype = vim.fn.getbufvar(bufnr, "&ft")
							-- print("filetype: ", filetype)
							local buftype = vim.fn.getbufvar(bufnr, "&buftype")
							-- print("buftype: ", buftype)
							return buftype == "terminal" and filetype == ""
						end, vim.api.nvim_list_bufs())
					end

					local terminals = get_terminal_bufs()
					-- print(vim.inspect(terminals))

					local there_are_no_terminal_buffers = next(terminals) == nil

					if there_are_no_terminal_buffers then
						vim.cmd("15sp|term")
						return
					else -- there are terminal buffers
						local term_map = require("terminal.mappings")
						term_map.toggle()
					end
				end,
			},
			{
				"<leader>ii",
				function()
					local term = require("terminal")
					local index = term.current_term_index()
					term.set_target(index)
				end,
			},
			{
				"<leader>tl",
				mode = { "n" },
				"<cmd>vsp|term<cr>",
			},
			{
				"<leader>th",
				mode = { "n" },
				"<cmd>15sp|term<cr>",
			},
			{
				"<leader>tT",
				mode = { "n" },
				"<cmd>tabnew|term<cr>",
			},
			{
				"<leader>tj",
				mode = { "n" },
				function()
					local term_map = require("terminal.mappings")
					term_map.cycle_next()
				end,
			},
			{
				"<leader>tk",
				mode = { "n" },
				function()
					local term_map = require("terminal.mappings")
					term_map.cycle_prev()
				end,
			},
			{
				"<leader>tF",
				mode = { "n" },
				function()
					local term_map = require("terminal.mappings")
					term_map.move({ open_cmd = "float" })
				end,
			},
		},
		config = function()
			require("terminal").setup({
				layout = {
					open_cmd = "botright 15 new",
					border = "rounded",
				},
			})

			local term_map = require("terminal.mappings")
			vim.keymap.set("n", "<leader>tx", term_map.kill)
			-- vim.keymap.set("n", "<leader>tj", term_map.cycle_next)
			-- vim.keymap.set("n", "<leader>tk", term_map.cycle_prev)

			vim.keymap.set("n", "<leader>t0", term_map.toggle({ open_cmd = "enew" }))

			vim.keymap.set("n", "<leader>t1", term_map.toggle({ open_cmd = "tabnew" }))

			-- local opts = { noremap = true, silent = true }
			-- vim.keymap.set({ "n", "t" }, "<M-ñ>", term_map.toggle({ open_cmd = "enew" }), opts)

			-- vim.keymap.set("n", "<M-ñ>", function()
			--   term_map.toggle({ open_cmd = "tabnew" })
			--   -- local get_terminal_bufs = function()
			--   --   return vim.tbl_filter(function(bufnr)
			--   --     return vim.fn.getbufvar(bufnr, "&buftype") == "terminal" and vim.fn.getbufvar(bufnr, "&ft") == ""
			--   --   end, vim.api.nvim_list_bufs())
			--   -- end
			--   --
			--   -- local terminals = get_terminal_bufs()
			--   --
			--   -- local there_are_no_terminal_buffers = next(terminals) == nil
			--   --
			--   -- if there_are_no_terminal_buffers then
			--   --   vim.cmd("tabnew|term")
			--   --   return
			--   -- else -- there are terminal buffers
			--   --   term_map.toggle({ open_cmd = "tabnew" })
			--   -- end
			-- end , { silent = true })

			vim.keymap.set("n", "<leader>tL", term_map.move({ open_cmd = "botright vnew" }))
			vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }))
		end,
	},
}
