local M = require("lualine.component"):extend()

-- Function to check if current buffer is a CodeCompanion buffer
local function is_codecompanion_buffer()
  return vim.bo.filetype == "codecompanion"
end

-- Function to get adapter and model info
local function get_adapter_info()
  if not is_codecompanion_buffer() then
    return nil
  end

  -- Try to get metadata from the global variable
  local bufnr = vim.api.nvim_get_current_buf()
  local metadata = rawget(_G, "codecompanion_chat_metadata") and _G.codecompanion_chat_metadata[bufnr]

  if not metadata or not metadata.adapter then
    return nil
  end

  local adapter_name = metadata.adapter.name
  local model_name = metadata.adapter.model

  if adapter_name and model_name then
    return string.format("[%s] (%s)", adapter_name, model_name)
  elseif adapter_name then
    return "[" .. adapter_name .. "]"
  else
    return nil
  end
end

-- Initializer
-- function M:init(options)
--   M.super.init(self, options)
--
--   -- Set up autocommand to update statusline when metadata changes
--   local group = vim.api.nvim_create_augroup("CodeCompanionAdapterInfo", { clear = true })
--
--   vim.api.nvim_create_autocmd({ "User" }, {
--     pattern = { "CodeCompanionChatOpened", "CodeCompanionRequestFinished", "CodeCompanionAdapterChanged" },
--     group = group,
--     callback = function()
--       -- vim.cmd("redrawstatus")
--     end,
--   })
-- end

-- Function that runs every time statusline is updated
function M:update_status()
  return get_adapter_info()
end

return M
