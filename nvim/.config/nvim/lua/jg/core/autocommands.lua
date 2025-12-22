local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
	return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
		or get_option(filetype, option)
end

local augroups = {
	general = vim.api.nvim_create_augroup("cc_general", { clear = true }),
	highlight = vim.api.nvim_create_augroup("cc_highlight", { clear = true }),
	env = vim.api.nvim_create_augroup("cc_env", { clear = true }),
	copilot = vim.api.nvim_create_augroup("cc_copilot", { clear = true }),
	dir = vim.api.nvim_create_augroup("cc_dir_history", { clear = true }),
	mode = vim.api.nvim_create_augroup("cc_mode_changed", { clear = true }),
	autosave = vim.api.nvim_create_augroup("cc_autosave", { clear = true }),
	git = vim.api.nvim_create_augroup("cc_git", { clear = true }),
	diff = vim.api.nvim_create_augroup("cc_diff_ui", { clear = true }),
	terminal = vim.api.nvim_create_augroup("cc_terminal", { clear = true }),
	codecompanion = vim.api.nvim_create_augroup("cc_codecompanion", { clear = true }),
	filetype_misc = vim.api.nvim_create_augroup("cc_filetype_misc", { clear = true }),
	filetypedetect = vim.api.nvim_create_augroup("cc_filetypedetect", { clear = true }),
}

if vim.fn.has("nvim-0.11") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroups.highlight,
		desc = "Hightlight selection on yank",
		pattern = "*",
		callback = function()
			vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
			-- vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	})
else
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroups.highlight,
		desc = "Highlight selection on yank",
		pattern = "*",
		callback = function()
			if vim.fn.has("nvim-0.11") == 0 then
				require("vim.highlight").on_yank({ higroup = "Visual", timeout = 200 })
			end
		end,
	})
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroups.general,
	desc = "Disable formatoptions kro",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroups.filetypedetect,
	pattern = "*Jenkinsfile",
	callback = function()
		vim.bo.filetype = "groovy"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroups.filetypedetect,
	pattern = "Gemfile.lock",
	callback = function()
		vim.bo.filetype = "gemfilelock"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroups.filetypedetect,
	pattern = "*Pluginfile",
	callback = function()
		vim.bo.filetype = "ruby"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroups.filetypedetect,
	pattern = "*proguard-rules.pro",
	callback = function()
		vim.bo.filetype = "proguard"
	end,
})

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

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.env", ".env.*" },
	group = augroups.env,
	callback = function()
		vim.o.wrap = false
		vim.bo.filetype = "sh"
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroups.copilot,
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

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = augroups.copilot,
	pattern = "copilot-chat",
	callback = function(args)
		vim.b[args.buf].view = vim.fn.winsaveview()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroups.copilot,
	pattern = "copilot-overlay",
	callback = function()
		require("barbecue.ui").toggle(false)
		vim.cmd([[highlight DiffDelete guifg=#011528]])
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = augroups.copilot,
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
	group = augroups.filetypedetect,
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
	group = augroups.dir,
	desc = "Track directory changes and update dir_history",
	callback = function(args)
		local new_dir = args.file
		local home = os.getenv("HOME")
		if new_dir:sub(1, #home) == home then
			new_dir = "~" .. new_dir:sub(#home + 1)
		end
		if vim.tbl_contains(dir_history, new_dir) then
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
	group = augroups.mode,
	pattern = { "t:nt" },
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	desc = "Autosave",
	group = augroups.autosave,
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
	group = augroups.git,
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
		vim.wo.winhl = "DiffChange:DiffAddAsDelete,DiffText:DiffDeleteText,DiffAdd:DiffAddAsDelete"
	end
end

vim.api.nvim_create_autocmd("BufNew", {
	pattern = "fugitive://*",
	group = augroups.diff,
	callback = function()
		fix_highlight_in_a_buffer()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fugitive",
	group = augroups.git,
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "S", ":G add .<CR>", opts)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "FugitiveIndex",
	group = augroups.git,
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
	group = augroups.diff,
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
	group = augroups.terminal,
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "<c-s>", "<cr>", opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	group = augroups.codecompanion,
	callback = function(args)
		local bufnr = args.buf
		local state = {
			line_count = vim.api.nvim_buf_line_count(bufnr),
		}
		vim.b[bufnr].codecompanion_follow_state = state

		local function follow_windows(prev_count, new_count)
			for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
				local cursor = vim.api.nvim_win_get_cursor(winid)
				local near_end = cursor[1] >= math.max(prev_count - 1, 1)
				if near_end then
					vim.api.nvim_win_call(winid, function()
						vim.api.nvim_win_set_cursor(0, { new_count, 0 })
						local height = vim.api.nvim_win_get_height(0)
						local view = vim.fn.winsaveview()
						view.topline = math.max(new_count - height + 1, 1)
						vim.fn.winrestview(view)
					end)
				end
			end
		end

		vim.api.nvim_create_autocmd("TextChanged", {
			buffer = bufnr,
			callback = function()
				local mode = vim.api.nvim_get_mode().mode
				if vim.startswith(mode, "i") then
					state.line_count = vim.api.nvim_buf_line_count(bufnr)
					return
				end

				local prev_count = state.line_count or vim.api.nvim_buf_line_count(bufnr)
				local new_count = vim.api.nvim_buf_line_count(bufnr)
				if new_count <= prev_count then
					state.line_count = new_count
					return
				end

				follow_windows(prev_count, new_count)
				state.line_count = new_count
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "ps" },
	group = augroups.filetype_misc,
	callback = function()
		vim.wo.wrap = false
	end,
})



vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  group = vim.api.nvim_create_augroup("GitConflictDetected", { clear = true }),
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

-- vim.api.nvim_create_autocmd("TermOpen", {
--   pattern = "*",
--   callback = function(args)
--     local bufnr = args.buf
--
--     -- Utility to move from one prompt to another
--     vim.keymap.set({ "t" }, "<C-N>", "<C-\\><C-n>/\\|✗<CR>", { noremap = true, silent = true, buffer = bufnr })
--     vim.keymap.set({ "t" }, "<C-P>", "<C-\\><C-n>?\\|✗<CR>", { noremap = true, silent = true, buffer = bufnr })
--
--     vim.keymap.set({ "n" }, "<C-N>", "/\\|✗<CR>", { noremap = true, silent = true, buffer = bufnr })
--     vim.keymap.set({ "n" }, "<C-P>", "?\\|✗<CR>", { noremap = true, silent = true, buffer = bufnr })
--   end,
-- })
