-- return {}

return {
  -- {
  --   "nhurlock/clownshow.nvim",
  --   -- ft = { "typescript", "javascript" },
  --   -- cmd = "JestWatch",
  --   event = {
  --     "BufEnter *.test.[tj]s",
  --     "BufEnter *.spec.[tj]s",
  --   },
  --   config = true,
  -- },
  -- {
  --   event = {
  --     "BufEnter *.test.[tj]s",
  --     "BufEnter *.spec.[tj]s",
  --   },
  --   "preservim/vimux",
  -- },
  {
    "vim-test/vim-test",
    event = {
      "BufEnter *.test.[tj]s",
      "BufEnter *.spec.[tj]s",
    },
    -- event = "BufReadPre",
    -- cmd = { "TestNearest", "TestFile" },
    -- dependencies = { 'preservim/vimux' },
    config = function()
      vim.keymap.set("n", "<leader>te", ":TestNearest<CR>")
      vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
      -- vim.cmd("let test#strategy = 'vimux'")
      vim.cmd("let test#strategy = 'neovim_sticky'")
      vim.cmd("let g:test#neovim_sticky#kill_previous = 1")
      vim.cmd("let g:test#preserve_screen = 1")
      vim.cmd("let test#neovim_sticky#reopen_window = 1")
      -- vim.cmd("let g:test#javascript#runner = 'jest'")

      local function file_exists(name)
        local f = io.open(name, "r")
        if f ~= nil then
          io.close(f)
          return true
        else
          return false
        end
      end


      if file_exists("nx.json") then
        vim.cmd("let g:test#javascript#runner = 'nx'")
      end

      -- vim.cmd("let g:test#javascript#runner = 'npm'")
      -- vim.cmd("let g:test#javascript#runner = 'jest'")
      vim.cmd("let g:VimuxHeight = '15'")
    end,
  },
}

-- return {
--   { "jugarpeupv/neotest-jest", dev = true },
--   { "nvim-neotest/neotest",
--   config = function()
--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = "neotest-output-panel",
--       callback = function()
--         vim.cmd("norm G")
--       end,
--     })
--     require("neotest").setup({
--       adapters = {
--         require("neotest-jest")({
--           -- jestCommand = "npm test --",
--           jestCommand = function()
--             local file = vim.fn.expand("%:p")
--             local fullProjectPath = string.match(file, "(.-/[^/]+/)src")
--             local projectName = fullProjectPath:match(".*/([^/]+)/$")
--             return "nx test " .. projectName .. " --"
--           end,
--           jestConfigFile = function()
--             local file = vim.fn.expand("%:p")
--             if string.find(file, "/libs/") then
--               return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
--             end

--             return vim.fn.getcwd() .. "/jest.config.ts"
--           end,
--           -- env = { CI = true },
--           cwd = function()
--             -- local file = vim.fn.expand("%:p")
--             -- if string.find(file, "/libs/") then
--             --   local match_string = string.match(file, "(.-/[^/]+/)src")
--             --   return match_string
--             -- end
--             return vim.fn.getcwd()
--           end,
--         }),
--       },
--     })
--   end,
--   }
-- }
