-- set leader key to space
vim.g.mapleader = " "
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

vim.cmd([[nnoremap q <Nop>]])

vim.keymap.set({ "n" }, "<S-D-Up>", ":resize +3<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Down>", ":resize -3<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Left>", ":vertical resize -5<CR>", opts)
vim.keymap.set({ "n" }, "<S-D-Right>", ":vertical resize +5<CR>", opts)

vim.keymap.set({ "t" }, "<S-D-Up>", "<C-\\><C-n><CMD>resize +3<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Down>", "<C-\\><C-n><CMD>resize -3<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Left>", "<C-\\><C-n><CMD>vertical resize -5<CR>", opts)
vim.keymap.set({ "t" }, "<S-D-Right>", "<C-\\><C-n><CMD>vertical resize +5<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Folding
keymap("n", "<C-p>", "za", opts)

-- Paste
-- keymap("n", "p", "p=`]", opts)
keymap("v", "p", '"_dP', opts)
keymap("n", "d", '"_d', opts)
keymap("v", "d", '"_d', opts)
keymap("n", "D", '"_D', opts)
keymap("n", "dd", '"_dd', opts)
keymap("n", "<leader>pu", "<cmd>pu<cr>", opts)

-- Cmd modifiers
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
keymap("n", "<Leader>po", "<cmd>PeekOpen<cr>", opts)
keymap("n", "<Leader>pc", "<cmd>PeekClose<cr>", opts)
keymap("n", "<Leader>ht", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<Leader>mp", "<cmd>lua require('telescope.builtin').man_pages()<cr>", opts)
keymap("n", "<Leader>of", "<cmd>lua require('telescope.builtin').oldfiles({ only_cwd = true })<cr>", opts)
keymap("n", "<Leader>rg", "<cmd>lua require('telescope.builtin').registers()<cr>", opts)
keymap("n", "<Leader>ke", "<cmd>lua require('telescope.builtin').keymaps()<cr>", opts)
keymap("n", "<Leader>cm", "<cmd>lua require('telescope.builtin').commands()<cr>", opts)
keymap("n", "<Leader>td", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", opts)
keymap("n", "<Leader>bo", "<cmd>lua require('telescope.builtin').bookmarks()<cr>", opts)
keymap("n", "<Leader>sy", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
keymap("n", "<Leader>lr", "<cmd>LspRestart<cr>", opts)

keymap("n", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("i", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("t", "<M-j>", "<cmd>NvimTreeToggle<cr>", opts)

keymap("n", "<Leader>d", "<Nop>", opts)
-- keymap("n", "<Leader>d", ":NvimTreeFindFile<cr>", opts)
keymap("n", "<M-k>", ":NvimTreeFindFile<cr>", opts)
keymap("n", "<M-u>", "<cmd> lua require('trouble').next({skip_groups = true, jump = true})<cr>", opts)
keymap("n", "<M-y>", "<cmd> lua require('trouble').prev({skip_groups = true, jump = true})<cr>", opts)

keymap("n", "<M-e>", "<cmd>cnext<cr>", opts)
keymap("n", "<M-l>", "<cmd>cprev<cr>", opts)

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
keymap(
  "n",
  "<Leader>bu",
  "<cmd>lua require('telescope.builtin').buffers({ ignore_current_buffer = true, show_all_buffers = false, sort_mru = true })<cr>",
  opts
)
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
keymap("n", "<Leader>ga", "<cmd>G add .<cr>", opts)
keymap("n", "<Leader>gS", "<cmd>G stash<cr>", opts)
keymap("n", "<Leader>gO", "<cmd>G stash pop<cr>", opts)
keymap("n", "<Leader>gs", "<cmd>lua require('telescope.builtin').git_stash()<cr>", opts)
keymap("n", "<Leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", opts)
keymap("n", "<leader>gt", "<cmd>GTags<CR>", opts)

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
keymap("n", "<Leader>gP", "<cmd>Git! push<cr>", opts)
keymap("n", "<Leader>gf", "<cmd>Git! fetch --all -v<cr>", opts)
keymap("n", "<Leader>gp", "<cmd>Git! pull<cr>", opts)
keymap("n", "<Leader>go", "<cmd>:!git-open<cr>", opts)
keymap("n", "<Leader>np", "<cmd>:e ~/.npmrc<cr>", opts)
keymap("n", "<Leader>aw", "<cmd>:e ~/.aws/config<cr>", opts)
keymap("n", "<Leader>zh", "<cmd>:e ~/.zshrc<cr>", opts)
keymap("n", "<Leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<cr>", opts)
keymap("n", "<Leader>gC", "<cmd>G checkout . | G clean -fd<cr>", opts)
keymap("n", "<Leader>gl", "<cmd>G log -20<cr>", opts)

-- Hop
vim.api.nvim_set_keymap("n", "<leader>ww", "<cmd>lua require'hop'.hint_words()<cr>", opts)

-- JsonPath
keymap("n", "<leader>cp", "<cmd>JsonPath<CR>", opts)

-- Reformat file
keymap("n", "<leader>cw", ":e ++ff=dos<CR> | :set ff=unix<CR>", opts)

-- Vifm
keymap("n", "<leader>vi", "<cmd>Vifm .<cr>", opts)

-- DAP
-- vim.keymap.set('n', '<leader>ee', function() require "dap".toggle_breakpoint() end)
keymap("n", "<leader>eo", "<cmd>lua require('dapui').toggle()<cr>", opts)
keymap("n", "<leader>ee", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>ca", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
vim.keymap.set("n", "<leader>en", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set('n', '<Leader>hh', function() require"dap".step_out() end)
-- vim.keymap.set("n", "<Leader>kk", function()
-- 	require("dap").step_into()
-- end)
-- vim.keymap.set("n", "<Leader>jj", function()
-- 	require("dap").step_over()
-- end)
vim.keymap.set("n", "<leader>G", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<leader>ec", function()
  require("dap").run_to_cursor()
end)
vim.keymap.set("n", "<leader>et", function()
  require("dap").terminate()
end)
vim.keymap.set("n", "<leader>ea", function()
  require("debughelper-config").attach()
end)
vim.keymap.set("n", "<leader>eE", function()
  require("debughelper-config").attachToRemote()
end)
vim.keymap.set("n", "<leader>eJ", function()
  require("debughelper-config").attachToPort8080()
end)
vim.keymap.set("n", "<leader>eh", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set("n", "<leader>es", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set("n", "<leader>ek", ':lua require"dap".up()<CR>zz')
vim.keymap.set("n", "<leader>ej", ':lua require"dap".down()<CR>zz')
vim.keymap.set("n", "<leader>er", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
-- vim.keymap.set('n', '<leader>ee', function() require"dap".set_exception_breakpoints({"all"}) end)
vim.keymap.set(
  "n",
  "<leader>lo",
  "<cmd> lua require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { ['pwa-node'] = { 'typescript' }, ['node2'] = { 'typescript' }, ['node'] = { 'typescript' } })<cr>",
  opts
)

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
vim.keymap.set("n", "<leader>tw", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
--   { silent = true, noremap = true }
-- )

-- Peek markdown
vim.keymap.set("n", "<leader>md", "<CMD>PeekOpen<CR>")
vim.keymap.set("n", "<leader>mc", "<CMD>PeekClose<CR>")

vim.cmd([[tnoremap <C-n> <C-\><C-n>]])

vim.keymap.set("n", "<leader>th", "<cmd>sp|term<cr>i", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>tv", "<cmd>vsp|term<cr>i", { silent = true, noremap = true })

vim.cmd([[:tnoremap <C-Up> <C-\><C-N>:resize +5<cr>]])
vim.cmd([[:tnoremap <C-Down> <C-\><C-N>:resize -5<cr>]])
vim.cmd([[:tnoremap <C-Left> <C-\><C-N>:vertical resize -5<cr>]])
vim.cmd([[:tnoremap <C-Right> <C-\><C-N>:vertical resize +5<cr>]])

vim.cmd([[:tnoremap <C-o> <C-\><C-N><C-o>]])

vim.keymap.set("n", "cc", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "ci", "<Plug>(git-conflict-theirs)")
vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
vim.keymap.set("n", "cn", "<Plug>(git-conflict-none)")
vim.keymap.set("n", "ck", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("n", "cj", "<Plug>(git-conflict-next-conflict)")

vim.keymap.set("v", "cc", "<Plug>(git-conflict-ours)")
vim.keymap.set("v", "ci", "<Plug>(git-conflict-theirs)")
vim.keymap.set("v", "cb", "<Plug>(git-conflict-both)")
vim.keymap.set("v", "cn", "<Plug>(git-conflict-none)")
vim.keymap.set("v", "ck", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("v", "cj", "<Plug>(git-conflict-next-conflict)")

vim.keymap.set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- lab
vim.keymap.set("n", "<leader>la", "<CMD>Lab code run<CR>")
vim.keymap.set("n", "<leader>ls", "<CMD>Lab code stop<CR>")

-- Ctrlsf.nvim
vim.keymap.set("n", "<leader>sf", "<Plug>CtrlSFCwordPath")
vim.keymap.set("n", "<leader>so", "<CMD>CtrlSFToggle<CR>")

vim.cmd([[nmap <Leader>tn :tabnew %<CR>]])
vim.cmd([[nmap <Leader>tc :tabclose<CR>]])

vim.keymap.set("n", "<leader>ta", require("jg.custom.telescope").curr_buf, {})

vim.api.nvim_set_keymap("n", "gn", "<cmd> lua require('illuminate').goto_next_reference()<cr>", opts)

vim.api.nvim_set_keymap("n", "gN", "<cmd> lua require('illuminate').goto_prev_reference()<cr>", opts)

vim.cmd([[nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>]])
vim.cmd([[nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>]])

vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })

vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>us", vim.cmd.UndotreeShow)
vim.keymap.set("n", "<leader>js", vim.cmd.Neogen)

vim.cmd([[nnoremap <F6> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>]])

vim.keymap.set("n", "<M-i>", ":split term://%:p:h//zsh<cr>", opts)

vim.keymap.set({ "i", "s" }, "<C-e>", function()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-f>", function()
  local ls = require("luasnip")
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

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
vim.keymap.set({ "n" }, "<leader><leader>", [["0yy]])                               -- copy to 0 register
vim.keymap.set({ "x" }, "<leader><leader>", [["0y]])                                -- copy to 0 register

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


vim.keymap.set({ "n" }, "<leader>wd","<cmd>windo diffthis<cr>", opts)                               -- copy to 0 register
vim.keymap.set({ "n" }, "<leader>wo","<cmd>windo diffoff<cr>", opts)                               -- copy to 0 register

vim.api.nvim_set_keymap('n', '<F5>', [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })
