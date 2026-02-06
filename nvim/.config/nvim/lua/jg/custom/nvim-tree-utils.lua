-- local utils = require("nvim-tree.utils")

local current_popup = nil

local function get_formatted_lines(node)
	local stats = node.fs_stat
	if stats == nil then
		return {
			"",
			"  Can't retrieve file information",
			"",
		}
	end

	local file_name = vim.fn.expand(node.absolute_path)
	if file_name == "" or file_name == nil then
		file_name = node.absolute_path
	end
	local file_permissions = vim.fn.getfperm(file_name)

	local improved_size = vim.system({ "du", "-sh", file_name }):wait().stdout:match("^[^\t]+")

	local fpath = " fullpath: " .. node.absolute_path
	local created_at = " created:  " .. os.date("%x %X", stats.birthtime.sec)
	local modified_at = " modified: " .. os.date("%x %X", stats.mtime.sec)
	local accessed_at = " accessed: " .. os.date("%x %X", stats.atime.sec)
	-- local size = " size:     " .. utils.format_bytes(stats.size)
	local size = " size:     " .. improved_size
	local permissions = " permis:   " .. file_permissions

	return {
		fpath,
		permissions,
		size,
		accessed_at,
		modified_at,
		created_at,
	}
end

local function setup_window(node)
	local lines = get_formatted_lines(node)

	local max_width = vim.fn.max(vim.tbl_map(function(n)
		return #n
	end, lines))
	local open_win_config = vim.tbl_extend(
		"force",
		{ col = 1, row = 1, relative = "cursor", border = "rounded", style = "minimal" },
		{
			width = max_width + 1,
			height = #lines,
			noautocmd = true,
			zindex = 60,
		}
	)
	local winnr = vim.api.nvim_open_win(0, false, open_win_config)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_win_set_buf(winnr, bufnr)
	
	current_popup = {
		winnr = winnr,
		bufnr = bufnr,
		file_path = node.absolute_path,
	}

	-- Highlight "permis" and "size" keys
	for i, line in ipairs(lines) do
		local s, e = line:find(".-:")
		if s and e then
			vim.api.nvim_buf_add_highlight(bufnr, -1, "Type", i - 1, s - 1, e)
		end
	end
	
	-- Set buffer-local keymap to close popup with 'q'
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
		noremap = true,
		silent = true,
		callback = close_popup,
	})
end

local function close_popup()
	if current_popup ~= nil then
		-- Clean up autocmd first
		vim.cmd("augroup NvimTreeRemoveFilePopup | au! CursorMoved | augroup END")
		
		-- Close window if it's still valid
		if vim.api.nvim_win_is_valid(current_popup.winnr) then
			vim.api.nvim_win_close(current_popup.winnr, true)
		end
		
		-- Delete buffer if it's still valid
		if vim.api.nvim_buf_is_valid(current_popup.bufnr) then
			vim.api.nvim_buf_delete(current_popup.bufnr, { force = true })
		end

		current_popup = nil
	end
end

local function custom_toggle_file_info(node)
	if node.name == ".." then
		return
	end
	if current_popup ~= nil then
		-- If popup exists, focus it instead of toggling
		vim.api.nvim_set_current_win(current_popup.winnr)
		return
	end

	setup_window(node)

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("NvimTreeRemoveFilePopup", {}),
		callback = function()
			-- Only close if cursor moved and we're NOT in the popup window
			if current_popup and vim.api.nvim_get_current_win() ~= current_popup.winnr then
				close_popup()
			end
		end,
	})
end


local M = {}

M.change_root_to_global_cwd = function()
	local global_cwd = vim.fn.getcwd(-1, -1)
	require("nvim-tree.api").tree.change_root(global_cwd)
end

M.custom_info_popup = function()
	local node = require("nvim-tree.api").tree.get_node_under_cursor()
	custom_toggle_file_info(node)
end

return M
