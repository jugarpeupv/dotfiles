-- return {}

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    config = function()
      -- This module contains a number of default definitions
      -- local rainbow_delimiters = require("rainbow-delimiters")
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          -- Use global strategy by default
          -- [""] = rainbow.strategy["global"],
          [""] = function(bufnr)
            local line_number = 1
            local line = vim.fn.getline(line_number)
            local char_count = #line

            if char_count > 1000 then
              return nil
            end

            local line_count = vim.api.nvim_buf_line_count(bufnr)
            if line_count > 10000 then
              return nil
            elseif line_count > 2000 then
              return rainbow.strategy['local']
            end

            return rainbow.strategy['global']
          end,

          -- Use local for HTML
          -- Pick the strategy for LaTeX dynamically based on the buffer size
          ["json"] = function(bufnr)
            -- Disabled for very large files, global strategy for large files,
            -- local strategy otherwise
            -- local line_count = vim.api.nvim_buf_line_count(bufnr)
            -- if line_count > 10000 then
            --   return nil
            -- elseif line_count > 1000 then
            --   return rainbow.strategy['local']
            -- end
            -- return rainbow.strategy['global']
            return nil
          end,
          ["jsonc"] = function(bufnr)
            -- -- Disabled for very large files, global strategy for large files,
            -- -- local strategy otherwise
            -- local line_count = vim.api.nvim_buf_line_count(bufnr)
            -- if line_count > 10000 then
            --   return nil
            -- elseif line_count > 1000 then
            --   return rainbow.strategy['local']
            -- end
            -- return rainbow.strategy['global']
            return nil
          end,
        },
        -- query = {

        --   [""] = "rainbow-delimiters",
        --   lua = "rainbow-blocks",
        -- },
        -- priority = {
        --   [""] = 110,
        --   lua = 210,
        -- },
        highlight = {
          "TSRainbowRed",
          "TSRainbowYellow",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
          "TSRainbowViolet",
          "TSRainbowCyan",
        },
      }
    end,
  },
}
