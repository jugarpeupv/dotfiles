vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
  pattern = "Cargo.toml",
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "crates" } } })
  end,
})

vim.cmd([[
  augroup _general_settings
  autocmd!
  " autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
  autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
  autocmd BufWinEnter * :set formatoptions-=cro
  " autocmd FileType qf set nobuflisted
  augroup end

  " augroup _auto_resize
  " autocmd!
  " autocmd VimResized * tabdo wincmd =
  " augroup end
]])

vim.cmd([[autocmd BufRead,BufNewFile */node_modules/* lua vim.diagnostic.disable(0)]])
vim.cmd([[autocmd BufRead,BufNewFile */assets/* lua vim.diagnostic.disable(0)]])

vim.cmd([[
  augroup filetypedetect
  autocmd BufRead,BufNewFile *Jenkinsfile set filetype=groovy
  augroup END
]])

vim.cmd([[
  augroup WrapMarkdownAu
  autocmd! FileType markdown set wrap
  augroup END
]])

vim.cmd([[
  augroup WrapTelescopePreview
  autocmd! FileType TelescopePreview set wrap
  augroup END
]])

vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("set-png-ft", { clear = true }),
  pattern = "*.png",
  callback = function()
    vim.cmd([[set filetype=png]])
  end,
})

-- vim.api.nvim_create_autocmd("CursorMoved", {
--   group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
--   callback = function()
--     if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
--       vim.schedule(function()
--         vim.cmd.nohlsearch()
--       end)
--     end
--   end,
-- })

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
      or get_option(filetype, option)
end

vim.cmd([[ augroup JsonToJsonc
    autocmd! FileType json set filetype=jsonc
augroup END ]])

vim.cmd([[autocmd OptionSet * if &diff | execute 'set nowrap' | endif]])

-- vim.cmd([[autocmd VimLeave * :!echo Hello; sleep 4]])

