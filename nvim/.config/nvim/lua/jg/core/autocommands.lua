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

vim.api.nvim_create_autocmd("filetype", {
  pattern = "NvimTree",
  desc = "Mappings for NvimTree",
  group = vim.api.nvim_create_augroup("NvimTreeBulkCommands", { clear = true }),
  callback = function()
    -- Yank marked files
    vim.keymap.set("n", "bgy", function()
      local api = require("nvim-tree.api")
      local marks = api.marks.list()
      if #marks == 0 then
        print("No items marked")
        return
      end
      local absolute_file_paths = ""
      for _, mark in ipairs(marks) do
        absolute_file_paths = absolute_file_paths .. mark.absolute_path .. "\n"
      end
      -- Using system registers for multi-instance support.
      vim.fn.setreg("+", absolute_file_paths)
      print("Yanked " .. #marks .. " items")
    end, { remap = true, buffer = true })

    -- Paste files
    vim.keymap.set("n", "bgp", function()
      local api = require("nvim-tree.api")
      local source_paths = {}
      for path in vim.fn.getreg("+"):gmatch("[^\n%s]+") do
        source_paths[#source_paths + 1] = path
      end
      local node = api.tree.get_node_under_cursor()
      local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
      local target_path = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
      for _, source_path in ipairs(source_paths) do
        vim.fn.system({ "cp", "-R", source_path, target_path })
      end
      api.tree.reload()
      print("Pasted " .. #source_paths .. " items")
    end, { remap = true, buffer = true })
  end,
})

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

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("worktree-strate-enter", { clear = true }),
  callback = function()
    local wt_utils = require("jg.custom.worktree-utils")
    local cwd = vim.loop.cwd()

    local has_worktrees = wt_utils.has_worktrees(cwd)
    if has_worktrees then
      local file_utils = require("jg.custom.file-utils")
      local key = vim.fn.fnamemodify(cwd or "", ":p")
      local bps_path = file_utils.get_bps_path(key)
      local data = file_utils.load_bps(bps_path)
      if next(data) == nil or data.last_active_wt == nil then
        return
      end
      local last_active_wt = data.last_active_wt
      local api = require("nvim-tree.api")
      api.tree.change_root(last_active_wt)
    end
  end,
})

-- vim.cmd([[autocmd VimLeave * :!echo Hello; sleep 4]])
