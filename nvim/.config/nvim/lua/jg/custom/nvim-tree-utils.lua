
local utils = require("nvim-tree.utils")

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
  local file_permissions = vim.fn.getfperm(file_name)

  local fpath = " fullpath: " .. node.absolute_path
  local created_at = " created:  " .. os.date("%x %X", stats.birthtime.sec)
  local modified_at = " modified: " .. os.date("%x %X", stats.mtime.sec)
  local accessed_at = " accessed: " .. os.date("%x %X", stats.atime.sec)
  local size = " size:     " .. utils.format_bytes(stats.size)
  local permissions = " permis:   " .. file_permissions

  return {
    fpath,
    permissions,
    size,
    accessed_at,
    modified_at,
    created_at
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
  current_popup = {
    winnr = winnr,
    file_path = node.absolute_path,
  }
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_win_set_buf(winnr, bufnr)
end


local function close_popup()
  if current_popup ~= nil then
    vim.api.nvim_win_close(current_popup.winnr, true)
    vim.cmd "augroup NvimTreeRemoveFilePopup | au! CursorMoved | augroup END"

    current_popup = nil
  end
end

local function custom_toggle_file_info(node)
  if node.name == ".." then
    return
  end
  if current_popup ~= nil then
    local is_same_node = current_popup.file_path == node.absolute_path

    close_popup()

    if is_same_node then
      return
    end
  end

  setup_window(node)

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("NvimTreeRemoveFilePopup", {}),
    callback = close_popup,
  })
end

local api = require("nvim-tree.api")

local M = {}

M.change_root_to_global_cwd = function()
  local global_cwd = vim.fn.getcwd(-1, -1)
  api.tree.change_root(global_cwd)
end

M.custom_info_popup = function()
  local node = api.tree.get_node_under_cursor()
  custom_toggle_file_info(node)
end

return M
