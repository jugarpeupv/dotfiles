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
-- keymap("n", ";", "za", opts)
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

vim.keymap.set({ "n" }, "<leader>gt", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local options = {
		git_command = { "git", "tag", "-l" },
	}
	local opts2 = {}

	pickers
		.new(options, {
			prompt_title = "Git Tags",
			finder = finders.new_oneshot_job(options.git_command, opts2),
			sorter = conf.file_sorter(options),
			-- sorter = require("telescope.config").values.generic_sorter,
			-- sorter = require("telescope.sorters").Sorter:new({
			-- 	scoring_function = function(_, prompt, line)
			-- 		-- Custom sorting logic: Sort by descending order
			-- 		if line:match("%d+%.%d+%.%d+") then
			-- 			local major, minor, patch = line:match("(%d+)%.(%d+)%.(%d+)")
			-- 			return -tonumber(major) * 10000 - tonumber(minor) * 100 - tonumber(patch)
			-- 		end
			-- 		return 0
			-- 	end,
			-- }),
			attach_mappings = function(_, map)
				actions.select_default:replace(actions.git_checkout)
				return true
			end,
		})
		:find()
end, opts)

vim.keymap.set({ "n", "t" }, "<D-p>", function()
	require("telescope.builtin").find_files({
		hidden = true,
		find_command = {
			"rg",
			"--files",
			"--color",
			"never",
			"--glob=!.git",
			"--glob=!*__template__",
			"--glob=!*DS_Store",
		},
	})
	-- local builtin = require("telescope.builtin")
	--
	-- local themes = require("telescope.themes")
	-- local opts_ivy = {
	--   layout_config = { height = 0.5 },
	--   hidden = true,
	--   find_command = { "rg", "--files", "--color", "never", "--glob=!.git", "--glob=!*__template__" },
	-- }
	-- builtin.find_files(themes.get_ivy(opts_ivy))
end, opts)

vim.keymap.set({ "n", "t" }, "<M-p>", function()
	require("telescope.builtin").find_files({
		hidden = true,
		find_command = {
			"rg",
			"--files",
			"--color",
			"never",
			"--glob=!.git",
			"--glob=!*__template__",
			"--glob=!*DS_Store",
		},
	})
	-- local builtin = require("telescope.builtin")
	--
	-- local themes = require("telescope.themes")
	-- local opts_ivy = {
	--   layout_config = { height = 0.4 },
	--   hidden = true,
	--   find_command = { "rg", "--files", "--color", "never", "--glob=!.git", "--glob=!*__template__" },
	-- }
	-- builtin.find_files(themes.get_ivy(opts_ivy))
end, opts)

-- cd into dir of the current buffer
vim.keymap.set({ "n" }, "<leader>cd", function()
	local cwd = vim.fn.expand("%:p:h")
	-- vim.cmd("lcd " .. cwd)
	require("nvim-tree.api").tree.change_root(cwd)
end, opts)

vim.keymap.set({ "n" }, "<leader>.", function()
  require("telescope.builtin").find_files({
    prompt_title = '< NvimRC >',
    cwd = '~/dotfiles/nvim/.config/nvim',
    no_ignore = true,
    hidden = false,
    preview = {
      hide_on_startup = true,
    },
  })
end, opts)

-- keymap("n", "su", "<cmd>Telescope file_browser path=/Users/jgarcia<cr>", opts)
-- keymap("n", "sf", "<cmd>Telescope file_browser<cr>", opts)
-- keymap("n", "sb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

vim.keymap.set({ "n" }, "so", function()
	require("jg.custom.telescope").oil_fzf_dir(vim.fn.expand("~"))
end, opts)

vim.keymap.set({ "n" }, "<leader>fw", function()
	require("jg.custom.telescope").telescope_file_picker_in_workspace(vim.fn.expand("~"))
end, opts)

vim.keymap.set({ "n" }, "su", function()
	local find_command = {
		"fd",
		".",
		vim.fn.expand("~/"),
		"--type",
		"d",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		-- "--one-file-system",
		"--max-depth",
		"4",
		"--hidden",
	}
	-- local f_browser_finder = require "telescope".extensions.file_browser.finder

	require("telescope").extensions.file_browser.file_browser({
		grouped = true,
		-- path = vim.fn.expand("~/"),
		cwd = vim.fn.expand("~/"),
		-- picker = f_browser_finder.browse_folders,
		depth = 1,
		-- use_ui_input = false,
		find_command,
		git_status = false,
		respect_gitignore = true,
		prompt_path = true,
	})
end, opts)

vim.keymap.set({ "n" }, "sf", function()
	local function pick_dir_and_explore_files(cb)
		local path = vim.fn.expand("~/")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local find_command = {
			"fd",
			".",
			path,
			"--type",
			"d",
			"--exclude",
			".git",
			"--exclude",
			"node_modules",
			-- "--one-file-system",
			"--max-depth",
			"4",
			"--hidden",
		}

		-- Function to escape special characters in a string for use in a pattern
		local function escape_pattern(text)
			return text:gsub("([^%w])", "%%%1")
		end

		local escaped_path = escape_pattern(path)

		pickers
			.new(opts, {
				prompt_title = "Select a directory",
				finder = finders.new_oneshot_job(find_command, {
					entry_maker = function(entry)
						local entry_substituted = entry:gsub(escaped_path, ""):gsub("^/", "")
						return {
							value = entry,
							-- display = "  ~/" .. entry_substituted,
							display = function()
								local display_string = "  ~/" .. entry_substituted
								return display_string, { { { 0, 1 }, "Directory" } }
							end,
							-- { { {1, 3}, hl_group } }
							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						cb(selection.value)
					end)

					-- actions.select_vertical:replace(function()
					--   local selection = action_state.get_selected_entry()
					--   require("telescope.actions").close(prompt_bufnr)
					--   vim.cmd("vsplit")
					--   print('hi')
					--   print(selection.value)
					--   require("oil").open(selection.value)
					-- end)

					return true
				end,
			})
			:find()
	end

	local function my_cb(path)
		require("telescope").extensions.file_browser.file_browser({
			grouped = true,
			depth = false,
			use_ui_input = false,
			follow_links = true,
			respect_gitignore = true,
			git_status = false,
			prompt_path = true,
			path = vim.fn.expand(path),
			select_buffer = true,
		})
	end

	pick_dir_and_explore_files(my_cb)

	-- require("telescope").extensions.file_browser.file_browser({
	--   grouped = true,
	--   depth = false,
	--   use_ui_input = false,
	--   follow_links = true,
	--   respect_gitignore = true,
	--   git_status = false,
	--   prompt_path = true,
	--   path = vim.fn.expand("%:p:h"),
	--   select_buffer = true,
	-- })
end, opts)

vim.keymap.set({ "n" }, "sd", function()
	require("jg.custom.telescope").oil_fzf_dir(vim.fn.expand("%:p:h"), true)
end, opts)

vim.keymap.set({ "n" }, "se", function()
	require("telescope").extensions.file_browser.file_browser({
		grouped = true,
		depth = 1,
		use_ui_input = false,
		path = vim.fn.expand("%:p:h"),
		git_status = false,
		select_buffer = true,
		respect_gitignore = true,
		prompt_path = true,
	})
end, opts)

keymap("n", "<leader>ce", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", opts)
keymap("n", "<leader>ht", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<leader>mp", "<cmd>lua require('telescope.builtin').man_pages()<cr>", opts)
keymap("n", "<leader>of", "<cmd>lua require('telescope.builtin').oldfiles({ only_cwd = true })<cr>", opts)
keymap("n", "<leader>oo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", opts)
keymap("n", "<leader>rg", "<cmd>lua require('telescope.builtin').registers()<cr>", opts)
keymap("n", "<leader>ke", "<cmd>lua require('telescope.builtin').keymaps()<cr>", opts)
keymap("n", "<leader>cm", "<cmd>lua require('telescope.builtin').commands()<cr>", opts)
keymap("n", "<leader>mm", "<cmd>lua require('telescope.builtin').marks()<cr>", opts)
keymap("n", "<leader>td", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", opts)

keymap("n", "<leader>Th", "<cmd>lua require('telescope').extensions.git_file_history.git_file_history()<cr>", opts)

keymap("n", "<leader>Cd", "<cmd>lua vim.diagnostic.reset()<cr>", opts)

keymap("n", "<leader>bo", "<cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>", opts)
keymap("n", "<leader>sy", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
keymap("n", "<leader>lr", "<cmd>LspRestart<cr>", opts)

keymap("n", "<D-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)
keymap("i", "<D-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)
keymap("t", "<D-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)
keymap("n", "<M-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)
keymap("i", "<M-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)
keymap("t", "<M-j>", "<cmd>keepjumps NvimTreeToggle<cr>", opts)

-- vim.keymap.set("n", "<D-j>", function()
--   local api = require("nvim-tree.api")
--   if api.tree.is_visible() then
--     api.tree.close()
--   else
--     -- api.node.open.replace_tree_buffer()
--     api.tree.find_file({ winid = vim.api.nvim_get_current_win(), focus = true, open = true })
--   end
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "<M-j>", function()
--   local api = require("nvim-tree.api")
--   if api.tree.is_visible() then
--     api.tree.close()
--   else
--     -- api.node.open.replace_tree_buffer()
--     api.tree.find_file({ winid = vim.api.nvim_get_current_win(), focus = true, open = true })
--   end
-- end, { noremap = true, silent = true })

keymap("n", "<leader>d", "<Nop>", opts)
-- keymap("n", "<leader>d", ":NvimTreeFindFile<cr>", opts)
keymap("n", "<D-k>", "<cmd>keepjumps NvimTreeFindFile<cr>", opts)
keymap("t", "<D-k>", "<C-\\><C-n><cmd>keepjumps NvimTreeFindFile<cr>", opts)

keymap("n", "<M-k>", "<cmd>keepjumps NvimTreeFindFile<cr>", opts)
keymap("t", "<M-k>", "<C-\\><C-n><cmd>keepjumps NvimTreeFindFile<cr>", opts)

-- vim.keymap.set("n", "<D-k>", function()
--   local api = require("nvim-tree.api")
--   -- api.node.open.replace_tree_buffer()
--   api.tree.find_file({ winid = vim.api.nvim_get_current_win(), focus = true })
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "<M-k>", function()
--   local api = require("nvim-tree.api")
--   -- api.node.open.replace_tree_buffer()
--   api.tree.find_file({ winid = vim.api.nvim_get_current_win(), focus = true })
-- end, { noremap = true, silent = true })

keymap("n", "<M-u>", "<cmd> lua require('trouble').next({skip_groups = true, jump = true})<cr>", opts)
keymap("n", "<M-y>", "<cmd> lua require('trouble').prev({skip_groups = true, jump = true})<cr>", opts)

-- vim.keymap.set({ "n" }, "<M-o>", "<cmd>bp<cr>", opts)
-- vim.keymap.set({ "n" }, "<M-i>", "<cmd>bn<cr>", opts)

keymap("n", "<M-8>", "<cmd>cnext<cr>", opts)
keymap("n", "<M-6>", "<cmd>cprev<cr>", opts)
-- Utilities
keymap("n", "<BS>", "<C-^>", opts)
keymap("o", "<BS>", "^", opts)
keymap("n", "<leader><BS>", "<cmd>qa!<CR>", opts)
-- keymap("n", "<leader>q", "<cmd>q!<CR>", opts)
-- keymap("n", "<leader>q", "<C-w>c", opts)
vim.keymap.set({ "n" }, "<leader>q", function()
	-- vim.cmd("q!")
	local function is_last_window()
		return vim.fn.winnr("$") == 1
	end

	-- Example usage
	if is_last_window() then
		vim.cmd("q!")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>c", true, false, true), "n", true)
	end
end, opts)

-- keymap("t", "<leader>q", "<cmd>q!<CR>", opts)
keymap("n", "<leader>nn", "<cmd>nohlsearch<CR>", opts)

vim.keymap.set({ "n" }, "<leader>fi", function()
	require("telescope.builtin").find_files({
		hidden = true,
		no_ignore = true,
		find_command = { "fd", ".", "--type", "f", "--exclude", ".git/*", "--exclude", "node_modules/*" },
		preview = {
			hide_on_startup = true,
		},
	})
end, opts)

vim.keymap.set({ "n" }, "<leader>bu", function()
	require("jg.custom.telescope").normal_buffers({
		ignore_current_buffer = true,
		show_all_buffers = false,
		sort_mru = true,
		-- sort_lastused = true,
		-- initial_mode = "normal",
	})

	-- require("telescope.builtin").buffers({
	--   -- ignore_current_buffer = true,
	--   show_all_buffers = false,
	--   sort_mru = true,
	--   sort_lastused = true,
	--   -- initial_mode = "normal",
	-- })
end, opts)
keymap("n", "<leader>tr", "<cmd>lua require('telescope.builtin').resume()<cr>", opts)
-- keymap("n", "<leader>tm", "<cmd>lua require('telescope.builtin').node_modules list<cr>", opts)
keymap(
	"n",
	"<leader>fs",
	"<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>",
	opts
)

vim.keymap.set({ "n", "v" }, "<leader>fR", "<cmd>lua require('telescope.builtin').egrepify<cr>", opts)

vim.keymap.set({ "n", "v" }, "<leader>ff", function()
	require("telescope").extensions.live_grep_args.live_grep_raw({
		disable_coordinates = true,
		path_display = { "absolute" },
		theme = "ivy",
		layout_config = { height = 0.47 },
		preview = {
			hide_on_startup = true,
		},
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

vim.keymap.set({ "n", "v" }, "<leader>f.", function()
	local cwd = "~/dotfiles/nvim/.config/nvim"
	require("telescope").extensions.live_grep_args.live_grep_raw({
		disable_coordinates = true,
		cwd = cwd,
		prompt_title = "Find files in " .. cwd,
		theme = "ivy",
		layout_config = { height = 0.53 },
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
--   "<leader>ss",
--   "<cmd>lua require('telescope.builtin').live_grep({ search_dirs={'%:p'}, vimgrep_arguments='rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings'})<cr>",
--   opts
-- )

vim.keymap.set("n", "<leader>ss", function()
	require("jg.custom.telescope").curr_buf({
		preview = {
			hide_on_startup = true,
		},
	})
	-- require("telescope.builtin").live_grep({
	-- 	search_dirs = { "%:p" },
	-- 	vimgrep_arguments = {
	-- 		"rg",
	-- 		"--color=never",
	-- 		"--no-heading",
	-- 		"--with-filename",
	-- 		"--line-number",
	-- 		"--column",
	-- 		"--smart-case",
	-- 	},
	-- })
end, opts)
-- keymap(
-- 	"n",
-- 	"<leader>ss",
-- 	"<cmd>lua require('telescope.builtin').live_grep({ search_dirs={'%:p'}, vimgrep_arguments={ 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }})<cr>",
-- 	opts
-- )

keymap("n", "<leader>sl", "<cmd>BLines<cr>", opts)
keymap("n", "<leader>pp", "<cmd>lua require('telescope.builtin').projects()<CR>", opts)

-- Telescope
-- keymap("n", "<leader>gs", "<cmd>lua require('telescope.builtin').git_stash()<cr>", opts)


-- Keymap for git stash with extended functionality
vim.keymap.set("n", "<leader>gs", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")
  builtin.git_stash({
    attach_mappings = function(prompt_bufnr, map)
      -- Custom action to discard a git stash
      local function discard_stash()
        local selection = action_state.get_selected_entry()
        if not selection then
          print("No stash selected!")
          return
        end

        local stash_index = selection.value:match("^stash@{(%d+)}")
        if stash_index then
          vim.fn.system("git stash drop stash@{" .. stash_index .. "}")
          print("Discarded stash: stash@{" .. stash_index .. "}")
        else
          print("Failed to parse stash index!")
        end

        actions.close(prompt_bufnr)
      end

      -- Map a key to discard the selected stash
      map("i", "<C-d>", discard_stash)
      map("n", "<C-d>", discard_stash)

      return true
    end,
  })
end, { desc = "Telescope Git Stash with Discard Option" })


-- keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", opts)
vim.keymap.set("n", "<leader>gb", function()
	local actions = require("telescope.actions")
	require("telescope.builtin").git_branches({
		mappings = {
			i = {
				["<C-a>"] = actions.git_create_branch,
			},
		},
	})
end, opts)

-- keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches({layout_config={height=0.8}})<cr>", opts)

keymap("n", "<leader>gB", "<cmd>Git branch -vv<cr>", opts)

-- vim.keymap.set({ "n" }, "<leader>gB", function()
--   local handle = io.popen("git rev-parse --abbrev-ref HEAD")
--   if not handle then
--     local cmd = "!git branch -vv"
--     vim.cmd(cmd)
--     return
--   end
--   local current_branch = handle:read("*a"):gsub("%s+", "")
--   handle:close()
--   -- Run the Git branch -vv command and filter the output
--   local cmd = "!git branch -vv | grep ' " .. current_branch .. " '"
--   vim.cmd(cmd)
-- end, opts)

-- Sniprun
keymap("n", "<leader>sr", "<cmd>%SnipRun<cr>", opts)

-- Git blame
keymap("n", "<leader>bl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", opts)
-- keymap("n", "<leader>bh", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", opts)
keymap("n", "<leader>bt", "<cmd>Gitsigns toggle_current_line_blame<cr>", opts)
keymap("n", "<leader>bf", "<cmd>GitBlameOpenCommitURL<cr>", opts)

-- Replace
vim.cmd([[nnoremap <leader>rr :%s///g<Left><Left><Left>]])
vim.cmd([[xnoremap <leader>rr :s///g<Left><Left><Left>]])
vim.cmd([[nnoremap <leader>sw /\<\><Left><Left>]])

vim.cmd(
	[[nnoremap <leader>rq :cfdo %s///gc \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

vim.cmd(
	[[xnoremap <leader>rq :cfdo %s///gc \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

-- Vim Fugitive
-- keymap("n", "<leader>gu", ":diffget<cr>", opts)
-- keymap("n", "<leader>gs", ":diffput<cr>", opts)
keymap("n", "<leader>sU", ":Git branch --set-upstream-to=origin/", opts)
keymap("n", "<leader>go", "<cmd>:!git-open<cr>", opts)
keymap("n", "<leader>np", "<cmd>:e ~/.npmrc<cr>", opts)
keymap("n", "<leader>aw", "<cmd>:e ~/.aws/config<cr>", opts)
keymap("n", "<leader>zh", "<cmd>:e ~/.zshrc<cr>", opts)
keymap("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<cr>", opts)

-- Hop
vim.api.nvim_set_keymap("n", "S", "<cmd>lua require'hop'.hint_words()<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>ww", "<cmd>lua require'hop'.hint_words()<cr>", opts)

-- JsonPath
keymap("n", "<leader>cp", "<cmd>JsonPath<CR>", opts)

-- Reformat file
keymap("n", "<leader>cw", ":e ++ff=dos<CR> | :set ff=unix<CR>", opts)

-- The Primeagean
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set('n', "n", "nzzzv")
-- vim.keymap.set('n', "N", "Nzzzv")

vim.keymap.set("n", "<leader>rc", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Trouble
-- vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>xo", "<cmd>Trouble symbols toggle<cr>", { silent = true, noremap = true })
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

vim.cmd([[nnoremap <F6> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>]])

-- vim.keymap.set("n", "<M-i>", "<cmd>split term://%:p:h//zsh<cr>", opts)
vim.keymap.set("n", "<leader>ct", function()
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

-- using 0 register
-- vim.keymap.set({ "n" }, "<leader><leader>y", [["0yy]])                              -- copy to 0 register
-- vim.keymap.set({ "x" }, "<leader><leader>y", [["0y]])                               -- copy to 0 register

vim.keymap.set({ "n" }, "<leader>bh", ":Bufferize hi<cr>", { silent = true }) -- paste from 0 register

vim.keymap.set({ "n" }, "<leader>bm", ":Bufferize messages<cr>", { silent = true }) -- paste from 0 register

vim.keymap.set({ "n" }, "<leader>bi", ":Bufferize Inspect<cr>", { silent = true }) -- paste from 0 register

-- local function show_documentation()
--   local filetype = vim.bo.filetype
--   if filetype == "vim" or filetype == "help" then
--     local status, _ = pcall(vim.cmd, "h " .. vim.fn.expand("<cword>"))
--     if not status then
--       print("No help for " .. vim.fn.expand("<cword>"))
--     end
--   elseif filetype == "man" then
--     vim.cmd("Man " .. vim.fn.expand("<cword>"))
--   elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
--     require("crates").show_popup()
--   else
--     vim.lsp.buf.hover()
--   end
-- end

local function show_documentation()
	local filetype = vim.bo.filetype
	local cword = vim.fn.expand("<cword>")

	if filetype == "vim" or filetype == "help" then
		local status, _ = pcall(vim.cmd, "h " .. cword)
		if not status then
			print("No help for " .. cword)
		end
	elseif filetype == "man" then
		vim.cmd("Man " .. cword)
	elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
		require("crates").show_popup()
	else
		local params = vim.lsp.util.make_position_params(0, "utf-8")

		local response = vim.lsp.buf_request_sync(0, "textDocument/hover", params)
		local has_lsp_info = false

		if response then
			for _, value in pairs(response) do
				if value and value.result and value.result.contents then
					has_lsp_info = true
				end
			end
		end

		if has_lsp_info then
			vim.lsp.buf.hover()
		else
			local _, err = pcall(vim.cmd, "h " .. cword)
			if err then
				return
			end
		end
	end
end

vim.keymap.set("n", "K", show_documentation, { silent = true })

-- vim.keymap.set({ "n" }, "<leader>wd", "<cmd>windo diffthis<cr>", opts) -- copy to 0 register
vim.keymap.set({ "n" }, "<leader>wd", function()
	vim.cmd([[highlight DiffDelete guifg=#011528]])
	vim.cmd("NvimTreeClose")
	vim.cmd("windo diffthis")
	require("barbecue.ui").toggle(false)
end, opts) -- copy to 0 register

-- vim.keymap.set({ "n" }, "<leader>wo", "<cmd>windo diffoff<cr>", opts)  -- copy to 0 register
vim.keymap.set({ "n" }, "<leader>wo", function()
	vim.cmd([[highlight DiffDelete guifg=none]])
	vim.cmd("windo diffoff")
	require("barbecue.ui").toggle(true)
end, opts) -- copy to 0 register

vim.api.nvim_set_keymap("n", "<F5>", [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>vf", "<cmd>Vifm .<cr>", { noremap = true, silent = true })

-- clear scrollback buffer in terminal buffer
-- vim.keymap.set({ "t", "n" }, "<leader>CL", "<C-\\><C-n><cmd>lua vim.bo.scrollback=1<cr>", opts)

vim.keymap.set("n", "<leader>xx", "<cmd>source %<CR>")
vim.keymap.set({ "n", "v" }, "<leader>xs", ":.lua<CR>")

vim.keymap.set({ "n" }, "<leader>sn", function()
	-- run this command on modifiable windows
	--   -- vim.wo.wrap = not vim.wo.wrap
	vim.cmd([[windo if &ma | set wrap! | endif]])
end, opts)

vim.keymap.set({ "n" }, "<leader>se", function()
	local status, _ = pcall(vim.cmd, "vert h " .. vim.fn.expand("<cword>"))
	if not status then
		print("No help for " .. vim.fn.expand("<cword>"))
	end
end, opts)

local function find_directory_and_focus()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local function open_nvim_tree(prompt_bufnr, _)
		actions.select_default:replace(function()
			local api = require("nvim-tree.api")

			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			api.tree.open()
			-- api.tree.find_file(selection.cwd .. "/" .. selection.value)
			api.tree.find_file(selection.value)
		end)
		return true
	end

	require("telescope.builtin").find_files({
		prompt_title = "Open directory in nvim tree",
		find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
		attach_mappings = open_nvim_tree,
		entry_maker = function(entry)
			return {
				value = entry,
				display = function()
					local display_string = " " .. entry
					return display_string, { { { 0, 1 }, "Directory" } }
				end,
				ordinal = entry,
			}
		end,
	})
end

vim.keymap.set("n", "<leader>fd", find_directory_and_focus, opts)

local function find_in_node_modules()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local cwd = vim.loop.cwd()
	local node_modules_path = cwd .. "/node_modules"

	local function open_nvim_tree(prompt_bufnr, _)
		actions.select_default:replace(function()
			local api = require("nvim-tree.api")

			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			api.tree.open()

			local uv = vim.loop

			if uv.fs_stat(selection.value .. "/package.json") then
				api.tree.find_file(selection.value .. "/package.json")
			else
				api.tree.find_file(selection.value)
			end
		end)
		return true
	end

	require("telescope.builtin").find_files({
		prompt_title = 'Find dependency in "node_modules"',
		find_command = {
			"fd",
			".",
			node_modules_path,
			"--no-ignore",
			"--type",
			"dir",
			"--max-depth",
			"2",
			"--exclude",
			"node_modules/*/node_modules",
			-- "--prune",
		},
		attach_mappings = open_nvim_tree,
		entry_maker = function(entry)
			return {
				value = entry,
				display = function()
					local cwd_dos = vim.loop.cwd():gsub("%-", "%%%-")
					local modified_entry = entry:gsub(cwd_dos .. "/", "")
					local display_string = "  " .. modified_entry
					return display_string, { { { 0, 1 }, "Directory" } }
				end,
				ordinal = entry,
			}
		end,
	})
end

vim.keymap.set("n", "<leader>fn", find_in_node_modules, opts)

-- fd . "node_modules" --no-ignore --exclude .git/* --exclude **/node_modules/**

vim.keymap.set({ "n" }, "<leader>rs", function()
	require("jg.custom.telescope").run_npm_scripts_improved()
end, opts)

vim.keymap.set({ "n" }, "<leader>rt", function()
	require("jg.custom.telescope").run_nx_scripts()
end, opts)

vim.keymap.set({ "n" }, "<leader>bn", "<cmd>bn<cr>", opts)
vim.keymap.set({ "n" }, "<leader>bp", "<cmd>bp<cr>", opts)

vim.keymap.set({ "n" }, "<leader>fr", "<cmd>Telescope frecency workspace=CWD<cr>", opts)

vim.keymap.set({ "n" }, "<leader>bd", "<cmd>bdelete<cr>", opts)

vim.keymap.set({ "n" }, "<M-b>", function()
	local current_buf_name = vim.fn.expand("%")

  local function get_filetype_alias()
    local filetype = vim.bo.filetype

    if filetype == "sh" or filetype == "bash" then
      return "sh"
    elseif filetype == "typescript" or filetype == "javascript" then
      return "bun"
    else
      return filetype
    end
  end

  local executable = get_filetype_alias()

	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(":Compile " .. executable .. " " .. current_buf_name, true, false, true),
		"n",
		true
	)

	-- vim.api.nvim_feedkeys(
	--   vim.api.nvim_replace_termcodes("<ESC>" .. current_buf_name, true, false, true),
	--   "n",
	--   true
	-- )
end, opts)

vim.api.nvim_set_keymap("i", "<C-e>", "<C-o>$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-a>", "<C-o>^", { noremap = true, silent = true })
vim.cmd([[cnoremap <C-a> <C-b>]])
-- vim.api.nvim_set_keymap("c", "<c-k>", [[ wildmenumode() ? "c-k>" : "<up>" ]], { noremap = true, expr = true }) -- expr mapping
-- vim.api.nvim_set_keymap("c", "<c-j>", [[ wildmenumode() ? "c-j>" : "<down>" ]], { noremap = true, expr = true }) -- expr mapping
-- vim.cmd("cnoremap <expr> <C-K> wildmenumode() ? '<C-P>' : '<Up>'")
-- vim.cmd("cnoremap <expr> <C-J> wildmenumode() ? '<C-N>' : '<Down>'")

-- vim.keymap.set('c', '<C-j>', '<Tab>', { noremap = true, silent = true })
-- vim.keymap.set('c', '<C-k>', '<S-Tab>', { noremap = true, silent = true })

-- -- vim.cmd([[nnoremap <nowait> gr gr]])
-- --
-- -- vim.api.nvim_del_keymap('n', 'gr')
if vim.fn.has("nvim-0.11") == 1 then
	local keymaps = {
		{ mode = "n", lhs = "gri" },
		{ mode = "n", lhs = "grn" },
		{ mode = "n", lhs = "grr" },
		{ mode = "n", lhs = "gra" },
		{ mode = "x", lhs = "gra" },
	}

	for _, keymapping in ipairs(keymaps) do
		if vim.fn.maparg(keymapping.lhs, keymapping.mode) ~= "" then
			vim.api.nvim_del_keymap(keymapping.mode, keymapping.lhs)
		end
	end
end

vim.api.nvim_create_user_command("NpmReadme", function(opts)
	local package_name = opts.args
	local package_url = "https://registry.npmjs.org/" .. package_name .. "/latest"

	-- Fetch the package metadata
	local handle = io.popen("curl -s " .. package_url)
	if not handle then
		return
	end
	local package_metadata = handle:read("*a")
	handle:close()

	-- Parse the repository URL from the package metadata
	local repo_url = package_metadata:match('"repository":{[^}]*"url":"(.-)"')
	if not repo_url then
		print("Repository URL not found for package: " .. package_name)
		return
	end

	-- Convert the repository URL to the raw README URL
	local readme_url = repo_url:gsub("github%.com", "raw.githubusercontent.com"):gsub("%.git$", ""):gsub("git%+", "")
		.. "/master/README.md"

	-- Fetch the README content
	handle = io.popen("curl -s " .. readme_url)
	if not handle then
		return
	end
	local readme_content = handle:read("*a")
	handle:close()

	-- Create a new scratch buffer and set its content
	vim.cmd("enew")
	vim.api.nvim_buf_set_name(0, "npm_info_" .. package_name .. ".md")
	-- vim.api.nvim_buf_set_option(0, "buftype", "nofile")
	-- vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(0, "filetype", "markdown")
	vim.api.nvim_buf_set_option(0, "swapfile", false)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(readme_content, "\n"))
end, { nargs = 1 })

vim.keymap.set({ "n" }, "<leader>nR", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":NpmReadme ", true, false, true), "n", true)
end, opts)

local function clear_lsp_signs()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.diagnostic.reset(nil, bufnr)
end

-- Create a command to clear only LSP diagnostic signs
vim.api.nvim_create_user_command("ClearLspSigns", clear_lsp_signs, {})

vim.keymap.set("t", "<M-o>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
	vim.schedule(function()
		require("bufjump").backward()
	end)
end, opts)

vim.keymap.set("t", "<M-i>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
	vim.schedule(function()
		require("bufjump").forward()
	end)
end, opts)

vim.keymap.set("t", "<D-o>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
	vim.schedule(function()
		require("bufjump").backward()
	end)
end, opts)

vim.keymap.set("t", "<D-i>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
	vim.schedule(function()
		require("bufjump").forward()
	end)
end, opts)

keymap("n", "<leader>tm", "<cmd>:e ~/.config/tmux/tmux.conf<cr>", opts)

-- https://vim.fandom.com/wiki/Searching_for_expressions_which_include_slashes
vim.cmd([[command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '\')|set hlsearch]])

vim.keymap.set("n", "<leader>ch", "<cmd>Changes<cr>", opts)

-- Map a shortcut to open the picker.
vim.keymap.set("n", "<leader>ri", function()
	require("telescope").extensions.recent_files.pick()
end, { noremap = true, silent = true })

vim.api.nvim_set_keymap("o", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "L", "$h", { noremap = true, silent = true })

vim.api.nvim_set_keymap("o", "H", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "H", "^", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bk", "<cmd>bwipeout!<cr>", opts)

vim.keymap.set("n", "<leader>nx", function()
	require("telescope").extensions.nx.actions()
end, opts)

vim.cmd([[set wildcharm=<C-v>]])
-- vim.cmd([[cnoremap <C-l> <Space><BS><C-v>]])
vim.cmd([[cnoremap <C-l> <C-y><C-v>]])
-- vim.cmd([[cnoremap <C-l> <Space><BS><Right><C-z>]])
vim.cmd([[cnoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<Up>"]])
vim.cmd([[cnoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Down>"]])
vim.cmd([[cnoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"]])
vim.cmd([[cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"]])

vim.keymap.set("n", "<leader>nr", function()
	-- Get the current buffer content
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- Parse the project name from the "name" property
	local project_name
	for _, line in ipairs(lines) do
		project_name = line:match('"name"%s*:%s*"([^"]+)"')
		if project_name then
			break
		end
	end

	if not project_name then
		print("Could not find project name in project.json.")
		return
	end

	-- Get the current line under the cursor
	local current_line = vim.api.nvim_get_current_line()

	-- Parse the target name from the current line
	local target_name = current_line:match('"([^"]+)"%s*:%s*{')
	if not target_name then
		print("Could not find target name under the cursor.")
		return
	end

	local command = string.format("npx nx %s %s", target_name, project_name)

	local function get_all_terminals()
		local terminal_chans = {}
		for _, chan in pairs(vim.api.nvim_list_chans()) do
			if chan["mode"] == "terminal" and chan["pty"] ~= "" then
				table.insert(terminal_chans, chan)
			end
		end
		table.sort(terminal_chans, function(left, right)
			return left["buffer"] < right["buffer"]
		end)
		if #terminal_chans == 0 then
			return nil
		end
		return terminal_chans
	end
	local terminals = get_all_terminals()

	if terminals and next(terminals) ~= nil and #terminals > 0 then
		-- Send the command to the first terminal
		vim.fn.chansend(terminals[1]["id"], command)
	else
		-- Open a new terminal and send the command
		vim.cmd("split | terminal")
		vim.fn.chansend(vim.b.terminal_job_id, command)
	end

	-- -- Open a terminal and send the command
	-- vim.cmd("split | terminal")
	-- vim.fn.chansend(vim.b.terminal_job_id, command)
end, opts)

vim.cmd(
	[[inoremap <C-G>  <C-O>:!whisper.nvim<CR><C-O>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^[[:space:\]\]*//'")<CR><C-R>an]]
)
vim.cmd(
	[[nnoremap <C-G>       :!whisper.nvim<CR>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^\[\[:space:\]\]*//'")<CR>"ap]]
)
vim.cmd(
	[[vnoremap <C-G> c<C-O>:!whisper.nvim<CR><C-O>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^[[:space:\]\]*//'")<CR><C-R>a]]
)

local function tables_equal(t1, t2)
	if #t1 ~= #t2 then
		return false
	end
	for i, v in ipairs(t1) do
		if v ~= t2[i] then
			return false
		end
	end
	return true
end

local toggle_diffopt = function()
	local current = vim.opt.diffopt:get()
	local option1 =
		{ "iwhiteall", "internal", "filler", "closeoff", "indent-heuristic", "linematch:60", "algorithm:histogram" }
	local option2 = { "internal", "filler", "closeoff", "indent-heuristic", "linematch:60", "algorithm:histogram" }

	if tables_equal(current, option1) then
		vim.opt.diffopt = option2
	else
		vim.opt.diffopt = option1
	end
end

vim.keymap.set("n", "<leader>DD", toggle_diffopt, { desc = "Toggle diffopt settings" })

vim.keymap.set({ "n" }, "<leader>sc", function()
	require("telescope").extensions.yaml_schema.yaml_schema({})
end, opts)

vim.keymap.set("n", "<leader>gm", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	-- Helper to escape Lua patterns
	local function pesc(str)
		return str:gsub("([^%w])", "%%%1")
	end

	local function get_git_modified_files()
		local cwd = vim.loop.cwd()
		local handle = io.popen("git status --porcelain")
		if not handle then
			return {}
		end
		local result = handle:read("*a")
		handle:close()
		local files = {}
		for line in result:gmatch("[^\r\n]+") do
			local file = line:match("^..%s+(.+)$")
			if file then
				-- Remove cwd prefix for display if present
				local display = file:gsub("^" .. pesc(cwd) .. "/", "")
				table.insert(files, { value = file, display = display })
			end
		end
		return files
	end

	local function git_modified_files_picker()
		pickers
			.new({}, {
				prompt_title = "Git Modified Files",
				finder = finders.new_table({
					results = get_git_modified_files(),
					entry_maker = function(entry)
						return {
							value = entry.value,
							display = entry.display,
							ordinal = entry.display,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						vim.cmd("edit " .. selection.value)
					end)
					return true
				end,
			})
			:find()
	end

	git_modified_files_picker()
end, opts)

vim.keymap.set("n", "<leader>dv", function()
	-- Get the current branch (faster method)
	local current_branch = vim.fn.system("git symbolic-ref --short HEAD"):gsub("%s+", "")

	-- Get the default branch (faster method)
	local default_branch =
		vim.fn.system("git symbolic-ref --short refs/remotes/origin/HEAD"):gsub("origin/", ""):gsub("%s+", "")

	-- Construct the DiffviewOpen command
	local diffview_command = string.format(":DiffviewOpen %s..%s", default_branch, current_branch)
	-- Populate the command line using vim.api.nvim_feedkeys
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(diffview_command, true, false, true), "n", true)
end, { noremap = true, silent = true, desc = "Fill cmdline with DiffviewOpen command" })
