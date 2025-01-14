-- vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_matchit = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- if vim.env.TERM == 'xterm-kitty' then
--   vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
--   vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
-- end

require("jg.core.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  -- rocks = { enabled = false },
  rocks = {  enabled = true, hererocks = true },
  dev = {
    path = "~/projects",
    patterns = {},
    fallback = true,
  },
  ui = {
    backdrop = 100,
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

require("jg.core.autocommands")
require("jg.core.keymaps")

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     -- require("config.autocmds")
--     -- require("config.keymaps")
--     require("jg.core.autocommands")
--     require("jg.core.keymaps")
--   end,
-- })
