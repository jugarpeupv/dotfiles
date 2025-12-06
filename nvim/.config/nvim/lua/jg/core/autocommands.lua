local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
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
			-- vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
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

vim.cmd([[
  augroup filetypedetect
  autocmd BufRead,BufNewFile *Jenkinsfile set filetype=groovy
  augroup END
]])

vim.cmd([[
  augroup filetypedetect
  autocmd BufRead,BufNewFile Gemfile.lock set filetype=gemfilelock
  augroup END
]])

vim.cmd([[
	augroup filetypedetect
	autocmd BufRead,BufNewFile *Pluginfile set filetype=ruby
	augroup END
]])

vim.cmd([[
	augroup filetypedetect
	autocmd BufRead,BufNewFile *proguard-rules.pro set filetype=proguard
	augroup END
]])

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

vim.filetype.add({
	extension = {
		["swcrc"] = "jsonc",
	},
})

local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.env",
	group = group,
	callback = function()
		vim.o.wrap = false
		vim.bo.filetype = "sh"
	end,
})

local env_group = vim.api.nvim_create_augroup("__env_default", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = ".env.*",
	group = env_group,
	callback = function()
		vim.o.wrap = false
		vim.bo.filetype = "sh"
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("copilot-conceal", { clear = true }),
	pattern = "copilot-chat",
	callback = function(args)
		vim.o.conceallevel = 0
		vim.o.signcolumn = "no"
		vim.o.foldcolumn = "0"
		vim.o.relativenumber = false
		vim.o.number = false
		vim.o.completeopt = "menuone,noinsert,noselect"

		if vim.b[args.buf].view ~= nil then
			vim.fn.winrestview(vim.b[args.buf].view)
			return
		end
		vim.cmd("norm zz")
	end,
})

-- Save and restore window view when switching buffers
vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = vim.api.nvim_create_augroup("savecopilotchatvinsaveview", { clear = true }),
	pattern = "copilot-chat",
	callback = function(args)
		vim.b[args.buf].view = vim.fn.winsaveview()
		-- vim.o.conceallevel = 0
		-- vim.o.signcolumn = "yes"
		-- vim.o.foldcolumn = "auto"
		-- -- vim.o.relativenumber = true
		-- -- vim.o.number = true
		-- vim.o.completeopt = "menu,popup"
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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "applescript",
	group = vim.api.nvim_create_augroup("applescript2", { clear = true }),
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
		zsh = "bash",
	},
})

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
vim.api.nvim_create_autocmd("DirChanged", {
	group = vim.api.nvim_create_augroup("DirChanged_custom_jg", { clear = true }),
	desc = "Track directory changes and update dir_history",
	-- pattern = "*",
	callback = function(args)
		local new_dir = args.file
		local home = os.getenv("HOME")
		if new_dir:sub(1, #home) == home then
			new_dir = "~" .. new_dir:sub(#home + 1)
		end
		if vim.tbl_contains(dir_history, new_dir) then
			-- Remove the existing entry if it exists
			for i, dir in ipairs(dir_history) do
				if dir == new_dir then
					table.remove(dir_history, i)
					break
				end
			end
		end

		table.insert(dir_history, 1, new_dir)
	end,
})

-- Telescope picker for directory history with default selection on the penultimate entry
local function open_dir_history()
	local pickers = require("telescope.pickers")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Directory History",
			-- finder = finders.new_table(entries),
			finder = require("telescope.finders").new_table({
				results = dir_history,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						-- vim.cmd("e " .. selection[1])
						local api_nvimtree = require("nvim-tree.api")
						api_nvimtree.tree.change_root(selection[1])
						api_nvimtree.tree.reload()
						vim.cmd("cd " .. selection[1])
					end
				end)
				return true
			end,
		})
		:find()
end

-- Map the function to a key
vim.keymap.set("n", "<leader>ee", function()
	open_dir_history()
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("ModeChanged", {
	desc = "Highlighting matched words when searching",
	group = vim.api.nvim_create_augroup("modechangedcustom", { clear = true }),
	pattern = { "t:nt" },
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	desc = "Autosave",
	group = vim.api.nvim_create_augroup("autosavegroup", { clear = true }),
	callback = function(ev)
		if vim.bo[ev.buf].buftype ~= "terminal" then
			return
		end

		local win_ids = vim.api.nvim_list_wins()

		local writable_win_ids = {}
		for _, win in ipairs(win_ids) do
			local buf = vim.api.nvim_win_get_buf(win)

			local buftype = vim.bo[buf].buftype
			local modified = vim.bo[buf].modified
			local readonly = vim.bo[buf].readonly

			if buftype == "" and modified and not readonly then
				table.insert(writable_win_ids, win)
			end
		end

		if next(writable_win_ids) == nil then
			return
		end

		for _, id in ipairs(writable_win_ids) do
			local buf = vim.api.nvim_win_get_buf(id)
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("w")
			end)
			require("barbecue.ui").update(id)
		end
	end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('my-grug-far-custom-keybinds', { clear = true }),
--   pattern = { 'grug-far' },
--   callback = function(ev)
--     vim.keymap.set('ca', 'w', function()
--       local inst = require('grug-far').get_instance(0)
--       inst:sync_all()
--     end, { buffer = ev.buf })
--   end,
-- })


-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- 	desc = "splitbelowtermi",
-- 	group = vim.api.nvim_create_augroup("splitbelowtermi", { clear = true }),
-- 	callback = function(ev)
-- 		if vim.bo[ev.buf].buftype ~= "terminal" then
-- 			return
-- 		end
-- 		vim.opt.splitbelow = true
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("BufLeave", {
-- 	pattern = "term://*",
-- 	callback = function()
-- 		vim.opt.splitbelow = true
-- 	end,
-- })

-- vim.api.nvim_create_autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('my-grug-far-custom-keybinds', { clear = true }),
--   pattern = { 'grug-far' },
--   callback = function()
--     vim.keymap.set('ca', 'w', function()
--       local inst = require('grug-far').get_instance(0)
--       inst:sync_all()
--     end, { buffer = true })
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "git",
	callback = function()
		vim.opt_local.foldmethod = "syntax"
	end,
})

-- This overrides DiffAdd in fugitive buffers, turning them into something that
-- looks like DiffDelete (while allowing it to be highlighted differently).
--
-- This hack ensures that deletions in the previous version of a diff show up
-- as actual deletions, not additions (relative to the current version).
local function fix_highlight_in_a_buffer()
	local winhl = vim.wo.winhl

	if not vim.wo.diff then
		return
	end

	if winhl == "" then
		vim.wo.winhl = "DiffChange:DiffAddAsDelete,DiffText:DiffDeleteText,DiffAdd:DiffAddAsDelete"
	else
		-- vim.wo.winhl = winhl .. ',DiffAdd:' .. override
		-- vim.wo.winhl = winhl .. ",DiffChange:DiffAddAsDelete,DiffText:DiffDeleteText"
		vim.wo.winhl = "DiffChange:DiffAddAsDelete,DiffText:DiffDeleteText,DiffAdd:DiffAddAsDelete"
		-- vim.wo.winhl = {
		-- 	"DiffChange:DiffAddAsDelete",
		-- 	"DiffText:DiffDeleteText",
		-- }
	end
end

vim.api.nvim_create_autocmd("BufNew", {
	pattern = "fugitive://*",
	group = vim.api.nvim_create_augroup("highlight_fugitive", { clear = true }),
	callback = function()
		fix_highlight_in_a_buffer()
		-- for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- 	local buf = vim.api.nvim_win_get_buf(win)
		-- 	local buf_name = vim.api.nvim_buf_get_name(buf)
		-- 	if buf_name:match("^fugitive://") then
		-- 		fix_highlight_in_a_buffer() -- or your custom logic
		-- 	else
		-- 		fix_highlight_in_b_buffer() -- or your custom logic
		-- 	end
		-- end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fugitive",
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "S", ":G add .<CR>", opts)

		-- vim.keymap.set("n", "<Tab>", function()
		--   vim.cmd("call fugitive#PreviousFile(v:count1)")
		-- end, opts)
		--
		-- vim.keymap.set("n", "<S-Tab>", function()
		--   vim.cmd("call fugitive#NextFile(v:count1)")
		-- end, opts)

		-- vim.keymap.set("n", "<Tab>", function()
		--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("[m", true, false, true), "n", false)
		-- 	-- for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- 	-- 	local buf = vim.api.nvim_win_get_buf(win)
		-- 	-- 	local name = vim.api.nvim_buf_get_name(buf)
		-- 	-- 	if name:sub(-2) == "//" then
		-- 	-- 		vim.api.nvim_set_current_win(win)
		-- 	-- 		-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("]m", true, false, true), "n", false)
		-- 	-- 		-- vim.api.nvim_feedkeys("dv", "n", false)
		-- 	-- 		vim.cmd("stopinsert") -- ensures normal mode
		-- 	-- 		vim.api.nvim_feedkeys("dv", "n", false)
		-- 	-- 		-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("dv", true, false, true), "n", false)
		-- 	-- 		break
		-- 	-- 	end
		-- 	-- end
		-- end, { buffer = true, silent = true })
		--
		-- vim.keymap.set("n", "<S-Tab>", function()
		--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("[m", true, false, true), "n", false)
		--     vim.api.nvim_feedkeys("dv", "n", false)
		--   -- for _, win in ipairs(vim.api.nvim_list_wins()) do
		--   --   local buf = vim.api.nvim_win_get_buf(win)
		--   --   local name = vim.api.nvim_buf_get_name(buf)
		--   --     local sub = name:sub(-2)
		--   --     vim.print(sub)
		--   --   if name:sub(-2) == "//" then
		--   --     vim.api.nvim_set_current_win(win)
		--   --     -- vim.api.nvim_feedkeys("[m", "n", false)
		--   --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("[m", true, false, true), "n", false)
		--   --     vim.api.nvim_feedkeys("dv", "n", false)
		--   --     break
		--   --   end
		--   -- end
		-- end, { buffer = true, silent = true })
	end,
})

-- vim.cmd([[au User FugitiveIndex nmap <buffer> dt :Gtabedit <Plug><cfile><Bar>Gvdiffsplit<CR>]])

vim.api.nvim_create_autocmd("User", {
	pattern = "FugitiveIndex",
	callback = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"dt",
			":Gtabedit <Plug><cfile>|Gvdiffsplit<CR>",
			{ noremap = true, silent = true }
		)
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "diffview://*",
	group = vim.api.nvim_create_augroup("diffview-package-lock", { clear = true }),
	callback = function(args)
		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if bufname:match("package%-lock%.json") then
			vim.b.matchup_matchparen_enabled = 0
			vim.b.matchup_matchparen_fallback = 0
			vim.treesitter.stop(args.buf)
			vim.bo.filetype = "bigfile"
			vim.wo.number = false
			vim.wo.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sidekick_terminal",
	group = vim.api.nvim_create_augroup("sidekick_terminal_au", { clear = true }),
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "<c-s>", "<cr>", opts)
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "codecompanion",
--   group = vim.api.nvim_create_augroup("CodeCompanionAppendDetect", { clear = true }),
--   callback = function(args)
--     local bufnr = args.buf
--     vim.b[bufnr].last_line_count = vim.api.nvim_buf_line_count(bufnr)
--     vim.b[bufnr].last_cursor_line = vim.api.nvim_win_get_cursor(0)[1]
--
--     vim.api.nvim_create_autocmd("TextChanged", {
--       buffer = bufnr,
--       callback = function()
--         if vim.fn.mode() == "i" then
--           return
--         end
--
--         local prev_line_count = vim.b[bufnr].last_line_count or vim.api.nvim_buf_line_count(bufnr)
--         local new_line_count = vim.api.nvim_buf_line_count(bufnr)
--         local cursor = vim.api.nvim_win_get_cursor(0)
--
--         -- Only move if new lines were appended and cursor was at previous end
--         if new_line_count > prev_line_count and cursor[1] == prev_line_count then
--           vim.api.nvim_win_set_cursor(0, {new_line_count, 0})
--         end
--
--         -- Update last known line count
--         vim.b[bufnr].last_line_count = new_line_count
--         vim.cmd("norm! zz")
--       end,
--     })
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "ps" },
	callback = function()
		vim.wo.wrap = false
	end,
})
