-- set leader key to space
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- vim.cmd([[nnoremap q <Nop>]])
-- q/ -- search history
-- q: -- command history

vim.keymap.set({ "n" }, "<S-D-Up>", ":resize +3<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Down>", ":resize -3<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Left>", ":vertical resize -5<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Right>", ":vertical resize +5<CR>", opts)

vim.keymap.set({ "t" }, "<S-D-Up>", "<C-\\><C-n><CMD>resize +3<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Down>", "<C-\\><C-n><CMD>resize -3<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Left>", "<C-\\><C-n><CMD>vertical resize -5<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Right>", "<C-\\><C-n><CMD>vertical resize +5<CR>", opts)

-- vim.keymap.set({ "t" }, "gT", "<C-\\><C-n>gT", opts)
-- vim.keymap.set({ "t" }, "gt", "<C-\\><C-n>gt", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Folding
-- keymap("n", "<C-p>", "za", opts)
keymap("n", ";", "za", opts)
-- Paste
keymap("n", "p", "p=`]", opts)
-- keymap("n", "p", "p]", opts)
-- keymap("v", "p", '"_dP', opts)
-- keymap("n", "d", '"*d', opts)
-- keymap("v", "d", '"*d', opts)
-- keymap("n", "D", '"*D', opts)
-- keymap("n", "dd", '"*dd', opts)

-- keymap("n", "y", '"0y', opts)
-- keymap("v", "y", '"0y', opts)
-- keymap("n", "Y", '"0y', opts)
-- keymap("n", "yy", '"0yy', opts)

keymap("n", "d", '"9d', opts)
keymap("v", "d", '"9d', opts)
keymap("n", "D", '"9D', opts)
keymap("n", "dd", '"9dd', opts)

-- keymap("n", "x", '"9x', opts)
-- keymap("v", "x", '"9x', opts)
-- keymap("n", "X", '"9x', opts)

keymap("n", "<leader>pu", "<cmd>pu<cr>", opts)

-- Cmd modifiers cooresponds to cmd+shift+7
vim.cmd([[map <M-g> gcc]])

vim.keymap.set({ "n", "t" }, "<M-p>", function()
  require("telescope.builtin").find_files({
    hidden = true,
    find_command = { "rg", "--files", "--color", "never", "--glob=!.git", "--glob=!*__template__" },
  })
end, opts)

-- cd into dir of the current buffer
vim.keymap.set({ "n" }, "<leader>cd", function()
  vim.cmd("lcd " .. vim.fn.expand("%:p:h"))
end, opts)

keymap(
  "n",
  "<Leader>.",
  "<cmd> lua require('telescope.builtin').find_files({ prompt_title = '< VimRC >', cwd = '~/dotfiles/nvim/.config/nvim',hidden = false })<cr>",
  opts
)
keymap("n", "<Leader>ce", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", opts)
keymap("n", "<Leader>ht", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<Leader>mp", "<cmd>lua require('telescope.builtin').man_pages()<cr>", opts)
keymap("n", "<Leader>of", "<cmd>lua require('telescope.builtin').oldfiles({ only_cwd = true })<cr>", opts)
keymap("n", "<Leader>rg", "<cmd>lua require('telescope.builtin').registers()<cr>", opts)
keymap("n", "<Leader>ke", "<cmd>lua require('telescope.builtin').keymaps()<cr>", opts)
keymap("n", "<Leader>cm", "<cmd>lua require('telescope.builtin').commands()<cr>", opts)
keymap("n", "<Leader>td", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", opts)
keymap("n", "<Leader>bo", "<cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>", opts)
keymap("n", "<Leader>sy", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
keymap("n", "<Leader>lr", "<cmd>LspRestart<cr>", opts)

keymap("n", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("i", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("t", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)

keymap("n", "<Leader>d", "<Nop>", opts)
-- keymap("n", "<Leader>d", ":NvimTreeFindFile<cr>", opts)
keymap("n", "<M-k>", "<cmd>NvimTreeFindFile<cr>", opts)
keymap("t", "<M-k>", "<C-\\><C-n><cmd>NvimTreeFindFile<cr>", opts)
keymap("n", "<M-u>", "<cmd> lua require('trouble').next({skip_groups = true, jump = true})<cr>", opts)
keymap("n", "<M-y>", "<cmd> lua require('trouble').prev({skip_groups = true, jump = true})<cr>", opts)

keymap("n", "<M-8>", "<cmd>cnext<cr>", opts)
keymap("n", "<M-6>", "<cmd>cprev<cr>", opts)
-- Utilities
keymap("n", "<BS>", "<C-^>", opts)
keymap("o", "<BS>", "^", opts)
keymap("n", "<Leader><BS>", "<cmd>qa!<CR>", opts)
keymap("n", "<Leader>q", "<cmd>q!<CR>", opts)
-- keymap("t", "<Leader>q", "<cmd>q!<CR>", opts)
keymap("n", "<Leader>nn", "<cmd>nohlsearch<CR>", opts)
keymap(
  "n",
  "<Leader>fi",
  "<cmd>lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true })<cr>",
  opts
)
vim.keymap.set({ "n" }, "<Leader>bu", function()
  require("telescope.builtin").buffers({
    ignore_current_buffer = true,
    show_all_buffers = false,
    sort_mru = true,
    sort_lastused = true,
    initial_mode = "normal",
    theme = "ivy",
  })
end, opts)
keymap("n", "<leader>tr", "<cmd>lua require('telescope.builtin').resume()<cr>", opts)
keymap("n", "<leader>tm", "<cmd>lua require('telescope.builtin').node_modules list<cr>", opts)
keymap(
  "n",
  "<Leader>fs",
  "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>",
  opts
)

vim.keymap.set({ "n", "v" }, "<Leader>fr", "<cmd>lua require('telescope.builtin').egrepify<cr>", opts)

vim.keymap.set({ "n", "v" }, "<Leader>ff", function()
  require("telescope").extensions.live_grep_args.live_grep_raw({
    disable_coordinates = true,
    -- group_by = "filename",
    -- disable_devicons = true,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case",
      "--glob=!icarSDK.js",
      "--glob=!package-lock.json",
      "--glob=!**/.git/**",
      -- "--ignore-case",
      -- "--smart-case",
      -- "--word-regexp"
    },
  })
end)

vim.keymap.set({ "n", "v" }, "<Leader>f.", function()
  require("telescope").extensions.live_grep_args.live_grep_raw({
    disable_coordinates = true,
    cwd = "~/dotfiles/nvim/.config/nvim",
    -- group_by = "filename",
    -- disable_devicons = true,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case",
      "--glob=!icarSDK.js",
      "--glob=!package-lock.json",
      "--glob=!**/.git/**",
      -- "--ignore-case",
      -- "--smart-case",
      -- "--word-regexp"
    },
  })
end)

-- keymap(
--   "n",
--   "<Leader>ss",
--   "<cmd>lua require('telescope.builtin').live_grep({ search_dirs={'%:p'}, vimgrep_arguments='rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings'})<cr>",
--   opts
-- )

keymap(
  "n",
  "<Leader>ss",
  "<cmd>lua require('telescope.builtin').live_grep({ search_dirs={'%:p'}, vimgrep_arguments={ 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }})<cr>",
  opts
)

keymap("n", "<Leader>sl", "<cmd>BLines<cr>", opts)
keymap("n", "gv", "<cmd>vsp | lua vim.lsp.buf.definition()<cr>", opts)
keymap("n", "<Leader>pp", "<cmd>lua require('telescope.builtin').projects()<CR>", opts)

-- Telescope
keymap("n", "<Leader>gs", "<cmd>lua require('telescope.builtin').git_stash()<cr>", opts)
keymap("n", "<Leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", opts)

keymap("n", "<Leader>gB", "<cmd>G branch -vv<cr>", opts)

-- Sniprun
keymap("n", "<Leader>sr", "<cmd>%SnipRun<cr>", opts)

-- Git blame
keymap("n", "<Leader>bl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", opts)
keymap("n", "<Leader>bh", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", opts)
keymap("n", "<Leader>bt", "<cmd>Gitsigns toggle_current_line_blame<cr>", opts)
keymap("n", "<Leader>bf", "<cmd>GitBlameOpenCommitURL<cr>", opts)

-- Replace
vim.cmd([[nnoremap <Leader>rr :%s///gc<Left><Left><Left>]])
vim.cmd([[xnoremap <Leader>rr :s///gc<Left><Left><Left>]])
vim.cmd([[nnoremap <Leader>sw /\<\><Left><Left>]])

vim.cmd(
  [[nnoremap <Leader>rq :cfdo %s///gc \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

vim.cmd(
  [[xnoremap <Leader>rq :cfdo %s///gc \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

-- Vim Fugitive
-- keymap("n", "<Leader>gu", ":diffget<cr>", opts)
-- keymap("n", "<Leader>gs", ":diffput<cr>", opts)
keymap("n", "<Leader>sU", ":G branch --set-upstream-to=origin/", opts)
keymap("n", "<Leader>go", "<cmd>:!git-open<cr>", opts)
keymap("n", "<Leader>np", "<cmd>:e ~/.npmrc<cr>", opts)
keymap("n", "<Leader>aw", "<cmd>:e ~/.aws/config<cr>", opts)
keymap("n", "<Leader>zh", "<cmd>:e ~/.zshrc<cr>", opts)
keymap("n", "<Leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<cr>", opts)

-- Hop
vim.api.nvim_set_keymap("n", "<leader>ww", "<cmd>lua require'hop'.hint_words()<cr>", opts)

-- JsonPath
keymap("n", "<leader>cp", "<cmd>JsonPath<CR>", opts)

-- Reformat file
keymap("n", "<leader>cw", ":e ++ff=dos<CR> | :set ff=unix<CR>", opts)

-- The Primeagean
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set('n', "n", "nzzzv")
-- vim.keymap.set('n', "N", "Nzzzv")

vim.keymap.set("n", "<leader>rs", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Trouble
-- vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
--   { silent = true, noremap = true }
-- )

-- vim.cmd([[tnoremap <C-n> <C-\><C-n>]])
vim.cmd([[tnoremap <C-Space> <C-\><C-n>]])

vim.cmd([[:tnoremap <C-Up> <C-\><C-N>:resize +5<cr>]])
vim.cmd([[:tnoremap <C-Down> <C-\><C-N>:resize -5<cr>]])
vim.cmd([[:tnoremap <C-Left> <C-\><C-N>:vertical resize -5<cr>]])
vim.cmd([[:tnoremap <C-Right> <C-\><C-N>:vertical resize +5<cr>]])

vim.cmd([[:tnoremap <C-o> <C-\><C-N><C-o>]])

vim.keymap.set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Ctrlsf.nvim
vim.keymap.set("n", "<leader>sf", "<Plug>CtrlSFCwordPath")
vim.keymap.set("n", "<leader>st", "<CMD>CtrlSFToggle<CR>")

vim.cmd([[nmap <leader>tN :tabnew %<CR>]])
vim.cmd([[nmap <leader>tC :tabclose<CR>]])

vim.keymap.set("n", "<leader>ta", require("jg.custom.telescope").curr_buf, {})

vim.keymap.set("n", "<leader>te", function()
  require("jg.custom.telescope").term_buffers({
    show_all_buffers = true,
    ignore_current_buffer = false,
    only_cwd = false,
    cwd_only = false,
  })
end, { silent = true })

-- vim.api.nvim_set_keymap("n", "gn", "<cmd> lua require('illuminate').goto_next_reference()<cr>", opts)
--
-- vim.api.nvim_set_keymap("n", "gN", "<cmd> lua require('illuminate').goto_prev_reference()<cr>", opts)

vim.cmd([[nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>]])
vim.cmd([[nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>]])

-- vim.keymap.set("i", "<Tab>", function()
--   if require("copilot.suggestion").is_visible() then
--     require("copilot.suggestion").accept()
--   else
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
--   end
-- end, { desc = "Super Tab" })

vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>us", vim.cmd.UndotreeShow)
vim.keymap.set("n", "<leader>ns", vim.cmd.Neogen)

vim.cmd([[nnoremap <F6> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>]])

-- vim.keymap.set("n", "<M-i>", "<cmd>split term://%:p:h//zsh<cr>", opts)
vim.keymap.set("n", "<M-b>", function()
  require("terminal").run("", {
    cwd = vim.fn.expand("%:p:h"),
  })
end)

-- vim.keymap.set({ "i", "s" }, "<C-e>", function()
--   local ls = require("luasnip")
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<C-f>", function()
--   local ls = require("luasnip")
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })

vim.keymap.set("n", "<leader>cl", function()
  require("telescope").extensions.neoclip.default()
end, { silent = true })

vim.keymap.set("n", "<leader>ti", function()
  local image = require("image")
  if image.is_enabled() then
    image.disable()
  else
    image.enable()
  end
end, opts)

-- using 0 register
-- vim.keymap.set({ "n" }, "<leader><leader>y", [["0yy]])                              -- copy to 0 register
-- vim.keymap.set({ "x" }, "<leader><leader>y", [["0y]])                               -- copy to 0 register

vim.keymap.set({ "n" }, "<leader>bm", ":Bufferize messages<cr>", { silent = true }) -- paste from 0 register

local function show_documentation()
  local filetype = vim.bo.filetype
  if filetype == "vim" or filetype == "help" then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif filetype == "man" then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end

vim.keymap.set("n", "K", show_documentation, { silent = true })

vim.keymap.set({ "n" }, "<leader>wd", "<cmd>windo diffthis<cr>", opts) -- copy to 0 register
vim.keymap.set({ "n" }, "<leader>wo", "<cmd>windo diffoff<cr>", opts)  -- copy to 0 register

vim.api.nvim_set_keymap("n", "<F5>", [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>vf", "<cmd>Vifm .<cr>", { noremap = true, silent = true })
