require("vim._core.ui2").enable({
	enable = true,
	msg = {
		-- targets = 'cmd',
		targets = {
			-- [''] = 'cmd',
			empty = "cmd",
			bufwrite = "cmd",
			confirm = "cmd",
			emsg = "cmd",
			echo = "cmd",
			echomsg = "cmd",
			echoerr = "cmd",
			completion = "cmd",
			list_cmd = "cmd",
			lua_error = "cmd",
			lua_print = "cmd",
			progress = "msg",
			rpc_error = "cmd",
			quickfix = "cmd",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "msg",
      shell_out = "msg",
			shell_err = "msg",
			shell_ret = "msg",
			undo = "cmd",
			verbose = "cmd",
			wildlist = "cmd",
			wmsg = "cmd",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.90,
		},
		dialog = {
			height = 0.25,
		},
		msg = {
			height = 0.90,
			timeout = 5000,
		},
		pager = {
			height = 0.85,
		},
	},
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "pager",
-- 	callback = function()
-- 		-- vim.bo.buflisted = true
-- 		vim.bo.bufhidden = "hide" -- keep it, ui2 already sets this; just don't wipe
-- 	end,
-- })
--
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cmd",
--   callback = function()
--     -- vim.bo.buflisted = true
--     vim.bo.bufhidden = "hide" -- keep it, ui2 already sets this; just don't wipe
--   end,
-- })
