vim.api.nvim_set_keymap("n", "<leader>kp", ":lua require('kulala').jump_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>kn", ":lua require('kulala').jump_next()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>kr", ":lua require('kulala').run()<CR>", { noremap = true, silent = true })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "http",
--   callback = function()
--     vim.cmd([[set commentstring=#\ %s]])
--   end,
-- })
