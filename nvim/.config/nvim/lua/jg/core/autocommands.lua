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

if vim.fn.has("nvim-0.13") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroups.highlight,
		desc = "Hightlight selection on yank",
		pattern = "*",
		callback = function()
      vim.hl.hl_op({ higroup = "Visual", timeout = 200 })
		end,
	})
else
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroups.highlight,
		desc = "Highlight selection on yank",
		pattern = "*",
		callback = function()
      vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
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
		["swcrc"] = "jsonc",
	},
})

vim.filetype.add({
  pattern = {
    [".*/msmtp/config"] = "msmtp", -- or "ini"
  },
})

vim.treesitter.language.register("bash", "msmtp") -- or "comment"

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
	group = augroups.filetypedetect,
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
vim.keymap.set("n", "<leader>EE", function()
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
			local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
				vim.cmd("w")
			end)
			if not ok then
				local name = vim.api.nvim_buf_get_name(buf)
				if name == "" then
					name = "[buf " .. buf .. "]"
				end
				vim.notify("Autosave: Could not write " .. name .. ": " .. tostring(err), vim.log.levels.DEBUG)
			else
				require("barbecue.ui").update(id)
			end
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

-- In `:G log` / `:Git log` pager buffers: `dv` on a commit prefills the
-- command line with `DiffviewOpen <full-hash>^!` (without pressing Enter).
-- The token is resolved to a commit instead of being trusted from the line:
-- custom `git log --format` can start with graph chars, `<`/`>` (--left-right)
-- or a date.
vim.api.nvim_create_autocmd("User", {
	pattern = "FugitivePager",
	group = augroups.git,
	callback = function(args)
		local cache = {}

		-- Resolve to the full commit id (fails for non-commits/blobs).
		local function resolve(token)
			if not token or #token < 7 then return nil end
			if cache[token] ~= nil then return cache[token] or nil end

			local rev = token .. "^{commit}"
			local full

			-- Prefer fugitive's API. It may not be available if its autoload
			-- script is not loaded yet; fall back to plain git.
			local ok, res = pcall(vim.fn["fugitive#RevParse"], rev)
			if ok and type(res) == "string" and res:match("^%x%x%x%x%x%x%x%x+$") then
				full = res
			else
				local out = vim.fn.systemlist({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--verify", "--quiet", rev })
				if vim.v.shell_error == 0 and out[1] and out[1]:match("^%x%x%x%x%x%x%x%x+$") then
					full = out[1]
				end
			end

			cache[token] = full or false
			return full
		end

		-- Commit for a line: `commit <hash>`, nearest one above, or any
		-- commit-like token on the line.
		local function commit_at(lines, lnum)
			local hash = resolve((lines[lnum] or ""):match("^commit%s+(%x+)"))
			if hash then return hash end

			for i = lnum, 1, -1 do
				local c = (lines[i] or ""):match("^commit%s+(%x+)")
				if c then
					hash = resolve(c)
					if hash then return hash end
				end
			end

			for token in (lines[lnum] or ""):gmatch("%x+") do
				hash = resolve(token)
				if hash then return hash end
			end
		end

		vim.keymap.set("n", "dv", function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local hash = commit_at(lines, vim.api.nvim_win_get_cursor(0)[1])
			if not hash then
				vim.notify("No commit hash under cursor", vim.log.levels.WARN)
				return
			end
			vim.cmd("DiffviewOpen " .. hash .. "^!")
		end, { buffer = args.buf, desc = "DiffviewOpen: commit under cursor" })

		-- Visual selection: open the file history for the selected range.
		vim.keymap.set("x", "dv", function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local a, b = vim.fn.getpos("v")[2], vim.fn.getpos(".")[2]
			local first, last = math.min(a, b), math.max(a, b)

			local commits, seen = {}, {}
			for i = first, last do
				local h = commit_at(lines, i)
				if h and not seen[h] then
					seen[h] = true
					commits[#commits + 1] = h
				end
			end

			if #commits == 0 then
				vim.notify("No commits in the selected range", vim.log.levels.WARN)
				return
			end

			-- `git log` is newest-first: first selected line is the newest.
			local newest, oldest = commits[1], commits[#commits]
			-- Execute directly: doing `feedkeys(":...")` from visual mode makes
			-- Vim prefix `'<,'>`, which turns this into a line-trace history
			-- for the current (pager temp) file and yields 0 commits.
			vim.cmd("DiffviewFileHistory --range=" .. oldest .. "^.." .. newest)
		end, { buffer = args.buf, desc = "DiffviewFileHistory: range of selection" })
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

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "codecompanion",
-- 	group = augroups.codecompanion,
-- 	callback = function(args)
-- 		local bufnr = args.buf
-- 		local state = {
-- 			line_count = vim.api.nvim_buf_line_count(bufnr),
-- 		}
-- 		vim.b[bufnr].codecompanion_follow_state = state
--
-- 		local function follow_windows(prev_count, new_count)
-- 			for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
-- 				local cursor = vim.api.nvim_win_get_cursor(winid)
-- 				local near_end = cursor[1] >= math.max(prev_count - 1, 1)
-- 				if near_end then
-- 					vim.api.nvim_win_call(winid, function()
-- 						vim.api.nvim_win_set_cursor(0, { new_count, 0 })
-- 						local height = vim.api.nvim_win_get_height(0)
-- 						local view = vim.fn.winsaveview()
-- 						view.topline = math.max(new_count - height + 1, 1)
-- 						vim.fn.winrestview(view)
-- 					end)
-- 				end
-- 			end
-- 		end
--
-- 		vim.api.nvim_create_autocmd("TextChanged", {
-- 			buffer = bufnr,
-- 			callback = function()
-- 				local mode = vim.api.nvim_get_mode().mode
-- 				if vim.startswith(mode, "i") then
-- 					state.line_count = vim.api.nvim_buf_line_count(bufnr)
-- 					return
-- 				end
--
-- 				local prev_count = state.line_count or vim.api.nvim_buf_line_count(bufnr)
-- 				local new_count = vim.api.nvim_buf_line_count(bufnr)
-- 				if new_count <= prev_count then
-- 					state.line_count = new_count
-- 					return
-- 				end
--
-- 				follow_windows(prev_count, new_count)
-- 				state.line_count = new_count
-- 			end,
-- 		})
-- 	end,
-- })

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

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf

		-- Utility to move from one prompt to another
		-- vim.keymap.set({ "t" }, "<C-N>", "<C-\\><C-n>/\\|✗<CR>", { noremap = false, silent = true, buffer = bufnr })
		vim.keymap.set({ "t" }, "<C-P>", "<C-\\><C-n>?\\|✗<CR>", { noremap = false, silent = true, buffer = bufnr })

		-- vim.keymap.set({ "n" }, "<C-N>", "/\\|✗<CR>", { noremap = false, silent = true, buffer = bufnr })
		vim.keymap.set({ "n" }, "<C-P>", "?\\|✗<CR>", { noremap = false, silent = true, buffer = bufnr })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	group = augroups.general,
	desc = "Never conceal quotes in JSON",
	callback = function()
		vim.wo.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-repl",
	callback = function()
		vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "text.kulala_ui",
-- 	group = augroups.filetypedetect,
-- 	callback = function(event)
-- 		local ok, parser = pcall(vim.treesitter.get_parser, event.buf, "json")
-- 		if ok and parser then
-- 			parser:destroy() -- detaches only the JSON parser
-- 			-- vim.treesitter.get_parser_cache(event.buf, "json").tree = nil
-- 		end
-- 	end,
-- })

vim.api.nvim_create_autocmd('LspProgress', {
  group = augroups.general,
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.client_id,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})


vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroups.filetype_misc,
  pattern = "*.swiftinterface",
  callback = function(args)
    vim.bo[args.buf].readonly = true
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].swapfile = false
    vim.b.matchparen_enabled = false
    -- vim.treesitter.stop(args.buf)
    vim.b.matchup_matchparen_enabled = 0
    vim.b.matchup_matchparen_fallback = 0
    Snacks.util.wo(0, {
      foldmethod = "manual",
      statuscolumn = "",
      conceallevel = 0,
      relativenumber = false,
      number = true,
    })
    vim.b.minianimate_disable = true
    vim.b.minihipatterns_disable = true
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroups.filetype_misc,
  pattern = "*Package.resolved",
  callback = function(args)
    vim.bo[args.buf].filetype = "json"
  end,
})

-- `---` / `+++` are file headers (metadata), not added/removed code: don't
-- paint them with the diff add/delete palettes. The `@comment.diff` part is
-- for the treesitter `diff` parser (diffs.nvim appends the language to the
-- capture name); diffOldFile/diffNewFile are the Vim syntax groups used by
-- fugitive/diff syntax.
local function neutral_diff_file_headers()
  vim.api.nvim_set_hl(0, "diffOldFile", { link = "Comment" })
  vim.api.nvim_set_hl(0, "diffNewFile", { link = "Comment" })
  -- The `diff` treesitter query maps old_file/new_file to these groups, and
  -- they fall back to diffRemoved/diffAdded (with background). Neutralize the
  -- language-suffixed groups themselves so the extmarks don't paint a bg.
  vim.api.nvim_set_hl(0, "@diff.minus.diff", { link = "Comment" })
  vim.api.nvim_set_hl(0, "@diff.plus.diff", { link = "Comment" })
  vim.api.nvim_set_hl(0, "@comment.diff", { link = "Comment", default = true })
end
neutral_diff_file_headers()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroups.highlight,
  callback = neutral_diff_file_headers,
})

