-- return {}

return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    after = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter" },
    opts = { enable = true, enable_autocmd = false, config = { http = "# %s" } },
    -- config = function()
    --   require("ts_context_commentstring").setup({
    --     enable_autocmd = true,
    --   })
    -- end,
  },
}

-- return {
--   {
--     "lucastavaresa/SingleComment.nvim",
--     dependencies = {
--       {
--         "JoosepAlviste/nvim-ts-context-commentstring",
--         event = { "BufReadPost", "BufNewFile" },
--         config = function()
--           require("ts_context_commentstring").setup({
--             enable_autocmd = false,
--           })
--         end,
--       },
--     },
--     -- event = "VeryLazy",
--     -- keybindings = { { { "n", "v" }, "gcc" }, { "n", "gca" } },
--     -- keys = { { { "n", "v" }, "gcc" }, { "n", "gca" } },
--     -- dependencies = {
--     --   "nvim-treesitter/nvim-treesitter",
--     --   "JoosepAlviste/nvim-ts-context-commentstring",
--     -- },
--     keys = {
--       { "gcc", mode = "n",          desc = "Comment toggle current line" },
--       { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
--       { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
--       { "gbc", mode = "n",          desc = "Comment toggle current block" },
--       { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
--       { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
--     },
--     config = function()
--       -- vim.keymap.set("n", "gcc", require("SingleComment").SingleComment, { expr = true })
--       -- vim.keymap.set("v", "gcc", require("SingleComment").Comment, {})
--       -- vim.keymap.set("n", "gca", require("SingleComment").ToggleCommentAhead, {})
--       -- vim.keymap.set("n", "gcA", require("SingleComment").CommentAhead, {})
--       -- vim.keymap.set({ "n", "v" }, "gcb", require("SingleComment").BlockComment)

--       vim.keymap.set("n", "gcc", require("SingleComment").SingleComment, { expr = true })
--       -- comments the selected lines
--       vim.keymap.set("v", "gcc", require("SingleComment").Comment, {})
--       -- toggle a comment top/ahead of the current line
--       vim.keymap.set("n", "gca", require("SingleComment").ToggleCommentAhead, {})
--       -- comments ahead of the current line
--       vim.keymap.set("n", "gcA", require("SingleComment").CommentAhead, {})
--       -- comment a block, and removes the innermost block comment in normal mode
--       vim.keymap.set({ "n", "v" }, "gcb", require("SingleComment").BlockComment)
--     end,
--   },
-- }
