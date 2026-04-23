
-- With `"awq"`, Vim will:
--   - Auto-format text as you type (`a`)
--   - Treat lines ending in whitespace as paragraph boundaries (`w`)
--   - Allow comment formatting (`q`)
-- vim.bo.formatoptions = "awq"

-- vim.bo.textwidth = 72
-- vim.cmd([[autocmd FileType mail setlocal wrap]])

vim.cmd([[setlocal wrap]])
vim.cmd([[setlocal signcolumn=no]])
vim.bo.textwidth = 120


