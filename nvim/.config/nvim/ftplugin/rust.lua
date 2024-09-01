-- local bufnr = vim.api.nvim_get_current_buf()
-- vim.keymap.set(
--   "n",
--   "<M-.>",
--   function()
--     vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
--     -- or vim.lsp.buf.codeAction() if you don't want grouping.
--   end,
--   { silent = true, buffer = bufnr }
-- )


-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "rs",
--   callback = function()
--     vim.cmd([[set commentstring=//\ %s]])
--   end,
-- })
