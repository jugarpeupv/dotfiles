local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)
-- opt.jumpoptions = 'clean'


-- opt.guicursor="n-v-c-sm:block-Cursor,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"

-- tabs & indentation
opt.tabstop = 2      -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2   -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces

-- opt.expandtab = false -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
-- opt.shortmess:append("I") -- remove :intro

-- line wrapping
-- opt.wrap = true -- disable line wrapping
opt.wrap = true -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line
opt.scrolloff = 2
opt.scrollback = 100000
opt.sidescrolloff = 4
opt.hlsearch = true
opt.incsearch = true
opt.showcmd = true
-- opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })
-- opt.expandtab = true
-- opt.showbreak = string.rep(" ", 0) -- Make it so that long lines wrap smartly
opt.linebreak = true
opt.modelines = 1
opt.belloff = "all" -- Just turn the dang bell off
opt.inccommand = "split"
opt.mouse = "n"
opt.swapfile = false
opt.backup = false
opt.hidden = true

opt.formatoptions = opt.formatoptions - "c" - "r" - "o"

-- opt.diffopt = { "iwhiteall", "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal", "followwrap" }
-- opt.diffopt="iwhiteall,internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"
opt.diffopt="iwhiteall,internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:patience"

opt.pumblend = 0
opt.pumheight = 10
opt.winborder = "rounded"

opt.fillchars = opt.fillchars + "diff:╱"
opt.breakindent = true
opt.showbreak = "↪\\"

-- vim.cmd([[set fillchars+=diff:╱]])
-- vim.cmd([[set breakindent]])
-- vim.cmd([[set showbreak=↪\]])

-- vim.o.ls = 0
-- vim.o.ch = 0

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position


-- clipboard
if os.getenv("SSH_TTY") == nil then
  opt.clipboard:append("unnamedplus")
else
  -- On ssh, use cmd+v to paste, copy should work just fine
  opt.clipboard:append("unnamedplus")

  local function my_paste(_reg)
    return function(_lines)
      local content = vim.fn.getreg('"')
      return vim.split(content, "\n")
    end
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = my_paste("+"),
      ["*"] = my_paste("*"),
    },
  }
end

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.ea = true         -- equal always, windows same size
-- opt.ea = false         -- equal always, windows same size

opt.iskeyword:append("-") -- consider string-string as whole word

-- global statusline
opt.laststatus = 3

opt.conceallevel = 0

-- opt.laststatus = 0

-- opt.winbar ="%=%m %f"

-- vim.cmd[[set diffopt+=linematch:60]]

opt.winblend = 0

-- vim.cmd([[let &t_Cs = "\e[4:3m]"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m]"]])

opt.showmode = false
vim.g.markdown_folding = 1
-- vim.cmd([[set noshowmode]])
-- vim.cmd([[let g:markdown_folding=1]])
-- vim.cmd[[set shada+=r/mnt/exdisk]]

opt.list = true

local space = "·"
opt.listchars:append({
  -- tab = "» ",
  tab = "  ",
  -- multispace = "␣",
  -- multispace = space,
  -- lead = space,
  -- trail = "󱁐",
  -- trail = "␣",
  trail = space,
  -- trail = "»",
  nbsp = "&",
})
-- opt.listchars:append("trail:.")
-- opt.listchars:append("eol:↴")

-- vim.cmd[[set statusline+=%#Container#%{g:currentContainer}]]
-- vim.cmd([[hi Container guifg=#BADA55 guibg=Black]])

-- vim.cmd([[let g:TerminusInsertCursorShape=1]])
-- vim.g.TerminusInsertCursorShape = 1

vim.o.foldcolumn = "0"
vim.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = false
vim.opt.foldmethod = "expr"
vim.o.foldtext = ""
vim.o.foldopen = "search,tag,undo"
-- vim.o.completeopt = "menu,popup,noselect,noinsert"

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

-- opt.updatetime = 1000

vim.g.suda_smart_edit = 1

-- vim.opt.foldnestmax = 3
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 99
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = ""

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     vim.defer_fn(function()
--       vim.opt.foldmethod = "expr"
--       vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--       vim.opt.foldtext = ""
--     end, 100)
--   end,
-- })

vim.g.zoomwintab_remap = false
vim.g.zoomwintab_remap = 0
