-- Shared "<M-y> async command on a path" flow.
--
-- Used by normal file buffers, oil and fyler. Replaces the old
-- vim.g._fyler_async_path / vim.g._fyler_async_cmdline_active globals.
--
-- Lifecycle:
--   async.begin(path)   -> arms the path, opens ":" and shows the hint
--   <CR> handler        -> async.consume() + async.run(cmd, path)
--   <Esc>/<C-c>         -> async.cancel() (CmdlineLeave autocmd)
--
-- The command-line <CR> intercept itself lives in jg.core.keymaps, because it
-- also has to keep the <M-b> Compile flow working.

local M = {}

local state = { path = nil, label = nil }
local hint = { win = nil, buf = nil }
local run_seq = 0

local function is_restricted(err)
	return err and (tostring(err):match("E11") or tostring(err):match("E565"))
end

local function close_hint()
	local win, buf = hint.win, hint.buf
	hint.win, hint.buf = nil, nil

	if win and vim.api.nvim_win_is_valid(win) then
		local ok, err = pcall(vim.api.nvim_win_close, win, true)
		if not ok and is_restricted(err) then
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(win) then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end)
		end
	end

	if buf and vim.api.nvim_buf_is_valid(buf) then
		local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = true })
		if not ok and is_restricted(err) then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end)
		end
	end
end

function M.show_hint()
	local path = state.path
	if not path then
		return
	end
	close_hint()
	hint.buf = vim.api.nvim_create_buf(false, true)

	local rel = vim.fn.fnamemodify(path, ":~:.")
	if rel == "" then
		rel = path
	end
	local line1 = " Async command "
	local line2 = " ! on " .. rel .. " "
	local width = math.max(#line1, #line2) + 2
	vim.api.nvim_buf_set_lines(hint.buf, 0, -1, false, { line1, line2 })
	hint.win = vim.api.nvim_open_win(hint.buf, false, {
		relative = "editor",
		width = width,
		height = 2,
		row = vim.o.lines - 5,
		col = 0,
		style = "minimal",
		border = "rounded",
		title = " " .. (state.label or "Async") .. " ",
		title_pos = "left",
		focusable = false,
		zindex = 40,
	})
	vim.api.nvim_buf_add_highlight(hint.buf, -1, "Title", 0, 0, -1)
end

---Show the hint now. Only defer when window ops are restricted (inside a
---cmdline mapping, where Neovim raises E565/E11); the original code also
---created the float before entering the cmdline, otherwise it is not drawn
---until the next keypress.
local function show_hint_safe()
	if not state.path then
		return
	end
	local ok, err = pcall(M.show_hint)
	if not ok and is_restricted(err) then
		vim.schedule(function()
			if state.path then
				pcall(M.show_hint)
				pcall(vim.cmd, "redraw")
			end
		end)
	end
end

---Arm the flow for `path` and show the hint (without opening the cmdline).
---@param path string
---@param opts? { label?: string }
---@return string|nil path
function M.arm(path, opts)
	if not path or path == "" then
		return
	end
	state.path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
	state.label = (opts and opts.label) or "Async"
	close_hint()
	show_hint_safe()
	return state.path
end

---Feed a `:` command line. Used to re-enter after history/register picks.
---@param text? string
function M.feed(text)
	local feed = ":" .. (text or "")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feed, true, false, true), "n", true)
end

---Arm the flow and open the cmdline.
---@param path string
---@param opts? { label?: string }
function M.begin(path, opts)
	if not M.arm(path, opts) then
		return
	end
	M.feed("")
end

function M.is_active()
	return state.path ~= nil
end

function M.get_path()
	return state.path
end

---Take the path out of the flow and clear the hint.
---@return string|nil
function M.consume()
	local path = state.path
	state.path, state.label = nil, nil
	close_hint()
	return path
end

function M.cancel()
	state.path, state.label = nil, nil
	close_hint()
end

---Run `cmd` with the path appended, streaming the result into a scratch split.
---@param user_cmd string
---@param path string
function M.run(user_cmd, path)
	if not user_cmd or user_cmd:match("^%s*$") or not path then
		return
	end

	local full_cmd = user_cmd .. " " .. vim.fn.shellescape(path)

	-- Create the result buffer instantly with a placeholder; the async
	-- completion below replaces its contents in place.
	vim.cmd("botright split")
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
		"```bash",
		full_cmd,
		"```",
		"",
		"calculating...",
	})
	vim.bo[buf].buflisted = true
	vim.bo[buf].bufhidden = ""
	vim.bo[buf].buftype = ""
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].modifiable = false
	vim.bo[buf].modified = false

	-- Unique name: re-running the same command must not E95.
	run_seq = run_seq + 1
	local name = "async:" .. full_cmd
	while vim.fn.bufexists(name) == 1 do
		run_seq = run_seq + 1
		name = "async:" .. full_cmd .. " #" .. run_seq
	end
	pcall(vim.api.nvim_buf_set_name, buf, name)

	vim.system({ "sh", "-c", full_cmd }, { text = true }, function(obj)
		vim.schedule(function()
			-- User may have wiped the buffer while it ran.
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			local stdout = obj.stdout or ""
			local stderr = obj.stderr or ""
			local code = obj.code or 0
			local lines = {}
			table.insert(lines, "```bash")
			table.insert(lines, full_cmd)
			table.insert(lines, "```")
			table.insert(lines, "")
			if code == 0 then
				table.insert(lines, "  exit 0")
			else
				table.insert(lines, "  exit " .. code)
			end
			table.insert(lines, "")

			if stdout ~= "" then
				for _, line in ipairs(vim.split(stdout:gsub("\n$", ""), "\n")) do
					table.insert(lines, line)
				end
			end
			if stderr ~= "" then
				if stdout ~= "" then
					table.insert(lines, "")
				end
				for _, line in ipairs(vim.split(stderr:gsub("\n$", ""), "\n")) do
					table.insert(lines, line)
				end
			end
			if stdout == "" and stderr == "" then
				table.insert(lines, "(no output)")
			end

			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modifiable = false
			vim.bo[buf].modified = false
		end)
	end)
end

---Clear the flow when the cmdline is left without executing (<Esc>, <C-c>).
function M.setup()
	local group = vim.api.nvim_create_augroup("JgAsyncCmdline", { clear = true })
	local function cancel_if_active()
		if M.is_active() then
			M.cancel()
		end
	end
	vim.api.nvim_create_autocmd("CmdlineLeave", { group = group, pattern = ":", callback = cancel_if_active })
	vim.api.nvim_create_autocmd("CmdwinEnter", { group = group, pattern = ":", callback = cancel_if_active })
end

return M
