function _G.FylerWinbarCwd()
	local ok, fyler = pcall(require, "fyler")
	if not ok or type(fyler.get_current_dir) ~= "function" then
		return (vim.loop.cwd() or ""):gsub("^" .. vim.env.HOME, "~")
	end
	local dir = fyler.get_current_dir() or vim.loop.cwd() or ""
	return dir:gsub("^" .. vim.env.HOME, "~")
end

-- return {}
return {
	{
		"A7Lavinraj/fyler.nvim",
		-- dir = "~/projects/fyler.nvim/wt-feature-get_current_dir",
		-- dev = true,
		enabled = false,
		lazy = true,
		cmd = { "Fyler" },
		-- event = { "VeryLazy" },
		-- branch = "stable",
		-- branch = "main",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			-- {
			-- 	"nvim-mini/mini.icons",
			-- 	config = function()
			-- 		require("mini.icons").setup({
			-- 			file = {
			-- 				[".eslintignore"] = { glyph = "󰱺" },
			-- 				["Gemfile.lock"] = { glyph = "" },
			-- 				["Pluginfile"] = { glyph = "", hl = "MiniIconsRed" },
			-- 			},
			-- 		})
			-- 	end,
			-- },
			-- { "lambdalisue/vim-nerdfont" },
		},
		keys = {
			{
				"<leader>fe",
				function()
					local fyler = require("fyler")
					fyler.open()
				end,
				desc = "Fyler",
			},
		},
		opts = {
			hooks = {
				-- function(path) end
				on_delete = nil,
				-- function(src_path, dst_path) end
				on_rename = nil,
				-- function(hl_groups, palette) end
				on_highlight = nil,
			},
			integrations = {
				-- icon = "mini_icons",
				icon = "nvim_web_devicons",
				-- icon = "none",
				-- icon = function(item_type, path)
				--   if item_type == "directory" then
				--     return "", "FylerFSDirectoryIcon"
				--   else
				--     return "", "FylerFSDirectoryIcon"
				--   end
				-- end
			},
			views = {
				finder = {
					-- Close explorer when file is selected
					close_on_select = false,
					-- Auto-confirm simple file operations
					confirm_simple = false,
					-- Replace netrw as default explorer
					default_explorer = false,
					-- Move deleted files/directories to the system trash
					delete_to_trash = true,
					columns = {
						git = {
							enabled = true,
							symbols = {
								Untracked = "?",
								Added = "+",
								Modified = "!",
								Deleted = "✗",
								Renamed = "󰕛 ",
								Copied = "~",
								Conflict = "",
								Ignored = " ",
							},
						},
						diagnostic = {
							enabled = true,
							symbols = {
								Error = " ",
								Warn = " ",
								Info = " ",
								Hint = "󰠠 ",
							},
						},
					},
					-- Icons for directory states
					icon = {
						directory_collapsed = "",
						-- directory_empty = "󱞞",
						directory_expanded = "",
					},
					-- Indentation guides
					indentscope = {
						enabled = true,
						markers = {
							{ "│", "FylerIndentMarker" },
							{ "└", "FylerIndentMarker" },
						},
					},
					-- Key mappings
					mappings = {
						-- ["Y"] = function(view)
						--   print('hi')
						-- end,
						["q"] = "CloseView",
						["<CR>"] = "Select",
						["L"] = "Select",
						["<C-t>"] = "SelectTab",
						["<C-v>"] = "SelectVSplit",
						["<C-s>"] = "SelectSplit",
						["-"] = "GotoParent",
						["="] = "GotoCwd",
						["<BS>"] = "GotoNode",
						["#"] = "CollapseAll",
						-- ["<BS>"] = "CollapseNode",
						["H"] = "CollapseNode",
					},
					-- Current file tracking
					follow_current_file = false,
					-- File system watching(includes git status)
					watcher = {
						enabled = true,
					},
					-- Window configuration
					win = {
						border = vim.o.winborder == "" and "single" or vim.o.winborder,
						buf_opts = {
							filetype = "fyler",
							syntax = "fyler",
							buflisted = false,
							buftype = "acwrite",
							expandtab = true,
							shiftwidth = 2,
						},
						kind = "split_right_most",
						-- kind = "replace",
						-- kind = "split_left",
						kinds = {
							float = {
								height = "70%",
								width = "70%",
								top = "10%",
								left = "15%",
							},
							replace = {},
							split_above = {
								height = "70%",
							},
							split_above_all = {
								height = "70%",
							},
							split_below = {
								height = "70%",
							},
							split_below_all = {
								height = "70%",
							},
							split_left = {
								width = "30%",
							},
							split_left_most = {
								width = "30%",
							},
							split_right = {
								width = "30%",
							},
							split_right_most = {
								width = "30%",
							},
						},
						win_opts = {
							-- winbar = "%#NvimTreeRootFolder#%{substitute(v:lua.vim.fn.getcwd(), '^' . $HOME, '~', '')}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							winbar = "%#NvimTreeRootFolder#%{v:lua.FylerWinbarCwd()}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							-- winbar = "%#NvimTreeRootFolder#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							concealcursor = "nvic",
							-- conceallevel = 3,
							foldcolumn = "1",
							cursorline = true,
							number = true,
							relativenumber = true,
							winhighlight = "Normal:FylerNormal",
							wrap = false,
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("fyler").setup(opts)
		end,
	},
}
