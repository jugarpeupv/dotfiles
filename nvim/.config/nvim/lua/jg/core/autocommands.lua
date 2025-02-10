local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

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

-- vim.cmd([[autocmd BufRead */node_modules/* lua vim.diagnostic.disable(0)]])
-- vim.cmd([[autocmd BufRead,BufNewFile */dist/* lua vim.diagnostic.disable(0)]])
-- vim.cmd([[autocmd BufRead,BufNewFile */assets/* lua vim.diagnostic.disable(0)]])

vim.cmd([[
  augroup filetypedetect
  autocmd BufRead,BufNewFile *Jenkinsfile set filetype=groovy
  augroup END
]])

-- vim.cmd([[
--   augroup WrapMarkdownAu
--   autocmd! FileType markdown set nowrap
--   augroup END
-- ]])

-- vim.cmd([[
--   augroup WrapTelescopePreview
--   autocmd! FileType TelescopePreview set wrap
--   augroup END
-- ]])

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


vim.cmd([[ augroup JsonToJsonc
    autocmd! FileType json set filetype=jsonc
augroup END ]])

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "json",
--   callback = function()
--     vim.cmd([[set commentstring=//\ %s]])
--   end,
-- })


-- vim.cmd([[autocmd BufReadPost * if &filetype == 'json' | execute 'set filetype jsonc' | endif]])

-- vim.cmd([[autocmd BufReadPre * if &buftype == 'terminal' | execute 'setlocal wrap' | endif]])


-- vim.cmd([[autocmd OptionSet * if &diff | execute 'set nowrap' | endif]])


-- vim.api.nvim_create_autocmd({ "OptionSet" }, {
--   pattern = "diff",
--   callback = function()
--     if vim.wo.diff then
--       require("barbecue.ui").toggle(false)
--     else
--       require("barbecue.ui").toggle(true)
--     end
--   end,
-- })

-- vim.cmd("hi! NvimTreeStatusLineNC guifg=none guibg=none")

-- vim.cmd([[autocmd VimLeave * :!echo Hello; sleep 1]])

-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = vim.api.nvim_create_augroup("term-open-buflisted", { clear = true }),
--   callback = function()
--     vim.cmd("setlocal wrap")
--     -- vim.bo.buflisted = false
--   end,
-- })

vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))

    vim.keymap.set({ "n", "v" }, "cc", "<Plug>(git-conflict-ours)")
    vim.keymap.set({ "n", "v" }, "ci", "<Plug>(git-conflict-theirs)")
    vim.keymap.set({ "n", "v" }, "cb", "<Plug>(git-conflict-both)")
    vim.keymap.set({ "n", "v" }, "cn", "<Plug>(git-conflict-none)")
    vim.keymap.set({ "n", "v" }, "ck", "<Plug>(git-conflict-prev-conflict)")
    vim.keymap.set({ "n", "v" }, "cj", "<Plug>(git-conflict-next-conflict)")
  end,
})

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "TelescopePreviewerLoaded",
--   callback = function(args)
--     -- if args.data.filetype ~= "help" then
--     --   vim.wo.number = true
--     --   return
--     -- end
--     -- -- elseif args.data.bufname:match("*.csv") then
--     -- --   vim.wo.wrap = false
--     -- -- end
--     vim.wo.wrap = true
--   end,
-- })
--
--
-- local group = vim.api.nvim_create_augroup("__env", {clear=true})
-- vim.api.nvim_create_autocmd({"BufEnter"}, {
--   pattern = ".env",
--   group = group,
--   callback = function()
--     print("env file")
--     vim.o.wrap = false
--   end,
-- })
--
--
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("wrap-markdown", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.cmd([[set nowrap]])
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup("copilot-conceal", { clear = true }),
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.conceallevel = 0
  end
})
