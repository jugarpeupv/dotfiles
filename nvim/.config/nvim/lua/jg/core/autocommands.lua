local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
	return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
		or get_option(filetype, option)
end

if vim.fn.has("nvim-0.11") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
		desc = "Hightlight selection on yank",
		pattern = "*",
		callback = function()
			vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
		end,
	})
else
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
		desc = "Highlight selection on yank",
		pattern = "*",
		callback = function()
			if vim.fn.has("nvim-0.11") == 0 then
				require("vim.highlight").on_yank({ higroup = "Visual", timeout = 200 })
			end
		end,
	})
end

vim.cmd([[
  augroup _general_settings
  autocmd!
  " autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
  " autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
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

-- vim.cmd([[ augroup JsonToJsonc
--     autocmd! FileType json set filetype=jsonc
-- augroup END ]])

-- vim.api.nvim_create_augroup("JsonToJsonc", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "json",
--   group = "JsonToJsonc",
--   callback = function ()
--     vim.cmd("set filetype=jsonc")
--     vim.cmd("set conceallevel=0")
--   end
-- })

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

-- vim.api.nvim_create_autocmd("TermEnter", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.wo.cursorline = true
-- 	end,
-- 	desc = "Enable cursorline in terminal buffers",
-- })
--
-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	group = vim.api.nvim_create_augroup("term-open-buflisted", { clear = true }),
-- 	callback = function()
-- 		vim.cmd("setlocal relativenumber")
-- 		vim.cmd("setlocal wrap")
-- 		-- vim.bo.buflisted = false
-- 	end,
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
local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.env*",
	group = group,
	callback = function()
		vim.o.wrap = false
		vim.bo.filetype = "sh"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap-markdown", { clear = true }),
	pattern = "markdown",
	callback = function()
		-- vim.cmd([[set nowrap]])
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then
      return
    else
      -- Disable wrapping for regular markdown buffers
      vim.cmd([[set nowrap]])
    end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("copilot-conceal", { clear = true }),
	pattern = "copilot-chat",
	callback = function()
		vim.o.conceallevel = 0
		vim.o.signcolumn = "no"
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = vim.api.nvim_create_augroup("copilot-chat", { clear = true }),
	pattern = "copilot-chat",
	callback = function()
		local chat = require("CopilotChat")
		if vim.g.chat_title then
			chat.save(vim.g.chat_title)
			return
		end

		local cwd = vim.fn.getcwd()
		local wt_utils = require("jg.custom.worktree-utils")
		local wt_info = wt_utils.get_wt_info(cwd)
		-- print("wt_info", vim.inspect(wt_info))

		if next(wt_info) == nil then
			vim.g.chat_title = vim.trim(cwd:gsub("/", "_"))
		else
			-- print("wt_root_dir", wt_info["wt_root_dir"])
			vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub("/", "_"))
		end
		-- print("vim.g.chat_title", vim.g.chat_title)
		chat.save(vim.g.chat_title)
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("copilot-barbecue-ui-enter", { clear = true }),
	pattern = "copilot-overlay",
	callback = function()
		require("barbecue.ui").toggle(false)
		vim.cmd([[highlight DiffDelete guifg=#011528]])
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = vim.api.nvim_create_augroup("copilot-barbecue-ui-leave", { clear = true }),
	pattern = "copilot-overlay",
	callback = function()
		if vim.opt.diff:get() then
			require("barbecue.ui").toggle(false)
		else
			require("barbecue.ui").toggle(true)
		end
		vim.cmd([[highlight DiffDelete guifg=none]])
	end,
})

-- vim.api.nvim_create_autocmd({"OptionSet"}, {
--   pattern = "diff",
--   callback = function()
--     if vim.opt.diff:get() then
--       require("barbecue.ui").toggle(false)
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--   pattern = "windo diffthis",
--   callback = function()
--     print("windo diffthis executed")
--     require("barbecue.ui").toggle(false)
--   end,
-- })
--
--
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--   pattern = "windo diffoff",
--   callback = function()
--     print("windo diffoff executed")
--     require("barbecue.ui").toggle(true)
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markbar",
--   callback = function()
--     vim.schedule(function()
--       pcall(vim.api.nvim_buf_del_keymap, 0, "n", "j")
--       pcall(vim.api.nvim_buf_del_keymap, 0, "n", "k")
--       pcall(vim.api.nvim_buf_del_keymap, 0, "n", "g")
--       pcall(vim.api.nvim_buf_del_keymap, 0, "n", "<leader>q")
--     end)
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "applescript",
	callback = function()
		vim.cmd([[setlocal commentstring=--\ %s]])
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("filetypedetect2", { clear = true }),
	pattern = { "Gymfile", "Fastfile", "Podfile" },
	callback = function()
		vim.bo.filetype = "ruby"
	end,
})

vim.filetype.add({
	extension = {
		json = "jsonc", -- Treat .json files as jsonc
	},
})

vim.filetype.add({
	extension = {
		zsh = "bash", -- Treat .json files as jsonc
	},
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpShow',
--   callback = function(ev)
--     local all_buffer = true
--     for _, item in ipairs(ev.data.items) do
--       if item.source_name ~= "Buffer" then
--         all_buffer = false
--         break
--       end
--     end
--     if #ev.data.items == 1 or all_buffer then
--       require('blink.cmp.completion.windows.menu').close()
--     end
--   end
-- })

local history_file = vim.fn.stdpath("data") .. "/dir_history.txt"

-- Normalize directory paths by removing "./" and trailing slashes
local function normalize_path(path)
	return path:gsub("%./", ""):gsub("/$", "")
end

-- -- Save directory changes to a file
-- vim.api.nvim_create_autocmd({ "DirChangedPre" }, {
-- 	group = vim.api.nvim_create_augroup("DirChangedPreGroup", { clear = true }),
-- 	callback = function(event)
-- 		local dir = normalize_path(event.file)
-- 		local lines = {}
-- 		local file = io.open(history_file, "r")
-- 		if file then
-- 			for line in file:lines() do
-- 				lines[normalize_path(line)] = true
-- 			end
-- 			file:close()
-- 		end
-- 		if not lines[dir] then
-- 			file = io.open(history_file, "a")
-- 			if file then
-- 				file:write(dir .. "\n")
-- 				file:close()
-- 			end
-- 		end
-- 	end,
-- })


local dir_history = {}

-- Add the current working directory to dir_history at startup
local function add_current_dir_to_history()
  local current_dir = vim.fn.getcwd()
  local worktree_dir = current_dir .. "/worktrees"
  local home = os.getenv("HOME")
  if current_dir:sub(1, #home) == home then
    current_dir = "~" .. current_dir:sub(#home + 1)
  end
  -- Check if current directory is a git repo with worktrees
  if vim.fn.isdirectory(worktree_dir) == 1 then
    return
  end
  if not vim.tbl_contains(dir_history, current_dir) then
    table.insert(dir_history, current_dir)
  end
end

-- Call the function to populate dir_history at startup
add_current_dir_to_history()

-- Autocommand to track directory changes
-- vim.api.nvim_create_autocmd("DirChanged", {
--   callback = function(args)
--     local new_dir = args.file
--     local home = os.getenv("HOME")
--     if new_dir:sub(1, #home) == home then
--       new_dir = "~" .. new_dir:sub(#home + 1)
--     end
--     if not vim.tbl_contains(dir_history, new_dir) then
--       -- table.insert(dir_history, new_dir)
--       table.insert(dir_history, 1, new_dir)
--     end
--   end,
-- })

-- Telescope picker for directory history
-- Telescope picker for directory history with default selection on the penultimate entry
local function open_dir_history()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_manager = require("telescope.entry_manager")

  -- local entries = {}
  -- local file = io.open(history_file, "r")
  -- if file then
  --   for line in file:lines() do
  --     table.insert(entries, 1, line) -- Insert each line at the beginning to reverse the order
  --   end
  --   file:close()
  -- end

  pickers.new({}, {
    prompt_title = "Directory History",
    -- finder = finders.new_table(entries),
    finder = require("telescope.finders").new_table {
      results = dir_history,
    },
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function()
        actions.close(_)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("e " .. selection[1])
        end
      end)
      return true
    end,
  }):find()
end

-- Map the function to a key
vim.keymap.set("n", "<leader>ee", function()
	open_dir_history()
end, { noremap = true, silent = true })







