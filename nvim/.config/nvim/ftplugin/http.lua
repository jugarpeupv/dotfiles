vim.api.nvim_set_keymap("n", "<leader>kp", ":lua require('kulala').jump_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>kn", ":lua require('kulala').jump_next()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>kr", ":lua require('kulala').run()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>kt", ":lua require('kulala').toggle_view()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>ks", ":lua require('kulala').show_stats() <CR>", { noremap = true, silent = true })

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>ki",
  "<cmd>lua require('kulala').inspect()<cr>",
  { noremap = true, silent = true, desc = "Inspect the current request" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>kc",
  "<cmd>lua require('kulala').copy()<cr>",
  { noremap = true, silent = true, desc = "Copy the current request as a curl command" }
)

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "http",
--   callback = function()
--     vim.cmd([[set commentstring=#\ %s]])
--   end,
-- })
