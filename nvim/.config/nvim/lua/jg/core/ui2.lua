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
			progress = "cmd",
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
			height = 0.10,
		},
		dialog = {
			height = 0.1,
		},
		msg = {
			height = 0.10,
			timeout = 500,
		},
		pager = {
			height = 0.40,
		},
	},
})

-- vim.keymap.set("n", "gh", function() -- cmdOutput open (or close) (requires vim._core.ui2 nvim0.12)
--   local ui2 = require("vim._core.ui2")
--   vim.cmd("split")
--   vim.api.nvim_win_set_height(0, 15)
--   vim.api.nvim_set_current_buf(ui2.bufs.cmd)
-- end)

local buf = nil
local ns = vim.api.nvim_create_namespace("jg_cmdhistory")

local function setup_hl()
  vim.api.nvim_set_hl(0, "MsghistoryTitle", { link = "Title", default = true })
end
setup_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_hl })

local function log_buf()
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].filetype = "cmdhistory"
  end
  return buf
end

vim.api.nvim_create_autocmd("Progress", {
  pattern = "*",
  callback = function(ev)
    local d = ev.data or {}
    -- ev.data.text arrives as a list of strings, not a string.
    local text = d.text
    if type(text) == "table" then
      text = table.concat(text, "")
    end
    text = (text or ""):gsub("\n", " ")
    local title = d.title or ""
    -- Render only what was in the cmd: title + text, never a
    -- synthesized percentage (percent may be 0, which is truthy in Lua).
    local line = (title ~= "" and (title .. ": ") or "") .. text
    -- Buffer writes are forbidden in fast-event/textlock contexts
    -- (e.g. LspProgress fired from inside request_sync/completion).
    -- Defer to main loop.
    vim.schedule(function()
      local ok, b = pcall(log_buf)
      if not ok or not vim.api.nvim_buf_is_valid(b) then
        return
      end
      -- Keep every update: always append a new line.
      local wok = pcall(vim.api.nvim_buf_set_lines, b, -1, -1, false, { line })
      if not wok then
        return
      end
      if title ~= "" then
        local row = vim.api.nvim_buf_line_count(b) - 1
        pcall(vim.api.nvim_buf_set_extmark, b, ns, row, 0, { end_col = #title + 1, hl_group = "@tag" })
      end
    end)
  end,
})

vim.keymap.set("n", "gh", function()
  vim.cmd("split")
  vim.api.nvim_win_set_height(0, 15)
  vim.api.nvim_set_current_buf(log_buf())
  vim.cmd("normal! G")
end)




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
