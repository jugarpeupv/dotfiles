-- Find project root using root markers
function _G.RunVimTest(cmd_name)
  return function()
    -- local root_markers = { "Gemfile", "package.json", ".git/", "nx.json" }
    -- for _, marker in ipairs(root_markers) do
    --   local marker_file = vim.fn.findfile(marker, vim.fn.expand('%:p:h') .. ';')
    --   if #marker_file > 0 then
    --     vim.g['test#project_root'] = vim.fn.fnamemodify(marker_file, ":p:h")
    --     break
    --   end
    --   local marker_dir = vim.fn.finddir(marker, vim.fn.expand('%:p:h') .. ';')
    --   if #marker_dir > 0 then
    --     vim.g['test#project_root'] = vim.fn.fnamemodify(marker_dir, ":p:h")
    --     break
    --   end
    --
    --   vim.g['test#javascript#runner'] = "jest"
    -- end

    local marker_file = vim.fn.findfile("nx.json", vim.fn.expand("%:p:h") .. ";")
    print("marker_file: " .. marker_file)
    if #marker_file > 0 then
      vim.g["test#javascript#runner"] = "nx"
    else
      vim.g["test#javascript#runner"] = "jest"
    end

    vim.cmd(":" .. cmd_name)
  end
end

return {
  "vim-test/vim-test",
  --   event = {
  --     "BufEnter *.test.[tj]s",
  --     "BufEnter *.spec.[tj]s",
  config = function()
    vim.g["test#strategy"] = "neovim_sticky"
    vim.g["test#neovim_sticky#reopen_window"] = 1
    vim.g["test#preserve_screen"] = 1
    vim.g["test#neovim_sticky#kill_previous"] = 1
    vim.g["VimuxHeight"] = "15"
  end,
  keys = {
    -- { "<leader>te", RunVimTest("TestNearest"), desc = "Run nearest test" },
    { "<leader>tf", RunVimTest("TestFile"),    desc = "Run all tests in the current file" },
    -- { '<leader>', RunVimTest('TestSuite'), desc = "Run the nearest test suite" },
    -- { '<leader>rr', RunVimTest('TestLast'), desc = "Run last test again" }
  },
  -- {
  --   "David-Kunz/jester",
  --   config = function()
  --     require("jester").setup({
  --       cmd = "jest -t '$result' -- $file", -- run command
  --       path_to_jest_run = '/opt/homebrew/bin/jest', -- used to run tests
  --       path_to_jest_debug = './node_modules/.bin/jest', -- used for debugging
  --       dap = { -- debug adapter configuration
  --         type = "node2",
  --         request = "launch",
  --         cwd = vim.fn.getcwd(),
  --         runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
  --         args = { "--no-cache" },
  --         sourceMaps = false,
  --         protocol = "inspector",
  --         skipFiles = { "<node_internals>/**/*.js" },
  --         console = "integratedTerminal",
  --         port = 9229,
  --         disableOptimisticBPs = true,
  --       },
  --     })
  --
  --     vim.keymap.set({ "n" }, "<leader>Td", function()
  --       require("jester").debug_file()
  --     end, {})
  --   end,
  -- },

  -- {
  --   "nvim-neotest/neotest",
  --   event = {
  --     "BufEnter *.test.[tj]s",
  --     "BufEnter *.spec.[tj]s",
  --   },
  --   dependencies = {
  --     "mortepau/codicons.nvim",
  --     "nvim-neotest/neotest-jest",
  --     "nvim-neotest/nvim-nio",
  --     "nvim-lua/plenary.nvim",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       adapters = {
  --         require("neotest-jest")({
  --           -- jestCommand = "npm test --",
  --           -- env = { CI = true },
  --           -- cwd = function(path)
  --           --   return vim.fn.getcwd()
  --           -- end,
  --         }),
  --       },
  --     })
  --
  --     vim.keymap.set({ "n" }, "<leader>Tr", function()
  --       require("neotest").run.run()
  --     end, {})
  --
  --     vim.keymap.set({ "n" }, "<leader>Td", function()
  --       require("neotest").run.run({ strategy = "dap" })
  --     end, {})
  --
  --     vim.keymap.set({ "n" }, "<leader>Tf", function()
  --       require("neotest").run.run(vim.fn.expand("%"))
  --     end, {})
  --   end,
  -- },
}

--
-- -- return {
-- --   -- {
-- --   --   "nhurlock/clownshow.nvim",
-- --   --   -- ft = { "typescript", "javascript" },
-- --   --   -- cmd = "JestWatch",
-- --   --   event = {
-- --   --     "BufEnter *.test.[tj]s",
-- --   --     "BufEnter *.spec.[tj]s",
-- --   --   },
-- --   --   config = true,
-- --   -- },
-- --   -- {
-- --   --   event = {
-- --   --     "BufEnter *.test.[tj]s",
-- --   --     "BufEnter *.spec.[tj]s",
-- --   --   },
-- --   --   "preservim/vimux",
-- --   -- },
-- --
-- --   {
-- --     "vim-test/vim-test",
-- --     event = {
-- --       "BufEnter *.test.[tj]s",
-- --       "BufEnter *.spec.[tj]s",
-- --     },
-- --     -- event = "BufReadPre",
-- --     -- cmd = { "TestNearest", "TestFile" },
-- --     -- dependencies = { 'preservim/vimux' },
-- --     config = function()
-- --       vim.keymap.set("n", "<leader>te", ":TestNearest<CR>")
-- --       vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
-- --       -- vim.cmd("let test#strategy = 'vimux'")
-- --       vim.cmd("let test#strategy = 'neovim_sticky'")
-- --       vim.cmd("let g:test#neovim_sticky#kill_previous = 1")
-- --       vim.cmd("let g:test#preserve_screen = 1")
-- --       vim.cmd("let test#neovim_sticky#reopen_window = 1")
-- --       -- vim.cmd("let g:test#javascript#runner = 'jest'")
-- --
-- --       -- local function file_exists(name)
-- --       --   print("Checking file: " .. name)
-- --       --   local f = io.open(name, "r")
-- --       --   if f ~= nil then
-- --       --     io.close(f)
-- --       --     print("File exists")
-- --       --     return true
-- --       --   else
-- --       --     return false
-- --       --   end
-- --       -- end
-- --       --
-- --       --
-- --       -- if file_exists("nx.json") then
-- --       --   vim.cmd("let g:test#javascript#runner = 'nx'")
-- --       -- end
-- --
-- --         vim.cmd("let g:test#javascript#runner = 'nx'")
-- --       -- vim.cmd("let g:test#javascript#runner = 'npm'")
-- --       -- vim.cmd("let g:test#javascript#runner = 'jest'")
-- --       vim.cmd("let g:VimuxHeight = '15'")
-- --     end,
-- --   },
-- -- }
-- --
-- -- -- return {
-- -- --   { "jugarpeupv/neotest-jest", dev = true },
-- -- --   { "nvim-neotest/neotest",
-- -- --   config = function()
-- -- --     vim.api.nvim_create_autocmd("FileType", {
-- -- --       pattern = "neotest-output-panel",
-- -- --       callback = function()
-- -- --         vim.cmd("norm G")
-- -- --       end,
-- -- --     })
-- -- --     require("neotest").setup({
-- -- --       adapters = {
-- -- --         require("neotest-jest")({
-- -- --           -- jestCommand = "npm test --",
-- -- --           jestCommand = function()
-- -- --             local file = vim.fn.expand("%:p")
-- -- --             local fullProjectPath = string.match(file, "(.-/[^/]+/)src")
-- -- --             local projectName = fullProjectPath:match(".*/([^/]+)/$")
-- -- --             return "nx test " .. projectName .. " --"
-- -- --           end,
-- -- --           jestConfigFile = function()
-- -- --             local file = vim.fn.expand("%:p")
-- -- --             if string.find(file, "/libs/") then
-- -- --               return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
-- -- --             end
-- --
-- -- --             return vim.fn.getcwd() .. "/jest.config.ts"
-- -- --           end,
-- -- --           -- env = { CI = true },
-- -- --           cwd = function()
-- -- --             -- local file = vim.fn.expand("%:p")
-- -- --             -- if string.find(file, "/libs/") then
-- -- --             --   local match_string = string.match(file, "(.-/[^/]+/)src")
-- -- --             --   return match_string
-- -- --             -- end
-- -- --             return vim.fn.getcwd()
-- -- --           end,
-- -- --         }),
-- -- --       },
-- -- --     })
-- -- --   end,
-- -- --   }
-- -- -- }
