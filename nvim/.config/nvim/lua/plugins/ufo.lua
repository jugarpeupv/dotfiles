return {}
-- return {
--   {
--     "kevinhwang91/nvim-ufo",
--     dependencies = { "kevinhwang91/promise-async" },
--     after = { "nvim-treesitter/nvim-treesitter" },
--     event = { "BufReadPost", "BufNewFile" },
--     -- keys = { "<C-p>" },
--     config = function()
--       -- Folding
--       -- vim.cmd([[set foldmethod=syntax]])
--       -- vim.cmd([[set foldmethod=indent]])
--       -- vim.cmd([[set nofoldenable]])
--       -- vim.cmd([[set foldlevelstart=20]])
--       -- vim.cmd([[set foldnestmax=10]])

--       -- vim.cmd([[set foldnestmax=10]])
--       -- vim.cmd([[set foldlevelstart=20]])
--       -- vim.cmd([[set foldmethod=expr]])
--       -- vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
--       -- vim.cmd([[set nofoldenable]])

--       -- vim.o.foldcolumn = '1' -- '0' is not bad
--       vim.o.foldcolumn = '0' -- '0' is not bad
--       vim.foldlevel = 99
--       vim.o.foldlevelstart = 99
--       vim.o.foldenable = false

--       vim.keymap.set("n", "zR", require("ufo").openAllFolds)
--       vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
--       require("ufo").setup({
--         open_fold_hl_timeout = 0,
--         provider_selector = function(bufnr, filetype, buftype)
--           return { "treesitter", "indent" }
--         end,
--       })
--     end,
--   },
-- }
