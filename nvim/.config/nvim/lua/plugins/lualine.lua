return {
	{
		"jugarpeupv/barbecue.nvim",
		enabled = true,
		name = "barbecue",
		branch = "main",
		event = "VeryLazy",
		-- event = "LspAttach",
		-- event = { "BufReadPost", "BufNewFile" },
		-- event = { "BufWinEnter" },
		dependencies = {
			{ "SmiteshP/nvim-navic" },
		},
		dev = true,
		opts = {
			-- configurations go here
		},
		config = function()
			local status_ok, bb = pcall(require, "barbecue")
			if not status_ok then
				return
			end

			bb.setup({
				-- attach_navic = function()
				attach_navic = false,
				show_navic = false,
				show_modified = true,
				-- create_autocmd = false,
				lead_custom_section = function(bufnr, _)
					local icons = {
						Error = "",
						Warn = "",
						Info = "",
						Hint = "󰠠",
					}

					local label = {}
					for severity, icon in pairs(icons) do
						local n =
							#vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity[string.upper(severity)] })
						if n > 0 then
							table.insert(label, { icon .. " " .. n .. " ", "DiagnosticSign" .. severity })
						end
					end
					return label
				end,
				exclude_filetypes = {
					"netrw",
					"mail",
					"grug-far",
					"toggleterm",
					"copilot-chat",
					"copilot-diff",
					"copilot-overlay",
					"NvimTree",
					"Diff",
					"dirvish",
					"help",
					"dashboard",
					"fugitive",
					"diffview",
					" ",
					"",
					"DiffviewFiles",
					"startify",
					"dashboard",
					"packer",
					"neogitstatus",
					"Trouble",
					"alpha",
					"lir",
					"Outline",
					"spectre_panel",
					"toggleterm",
					"qf",
				},
				show_dirname = true,
				show_basename = true,
				symbols = {
					modified = "⏺",
				},
				theme = {
					normal = { fg = "#c0caf5" },
					ellipsis = { fg = "#737aa2" },
					separator = { fg = "#737aa2" },
					modified = { fg = "#3b4261" },
					dirname = { fg = "#737aa2" },
					basename = { bold = false },
					context = { fg = "#737aa2" },
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		-- enabled = true,
		-- event = "VeryLazy",
		event = "LspAttach",
		-- event = { "BufReadPost", "BufNewFile" },
		ft = { "DiffviewFiles" },
		lazy = true,
		-- dependencies = { "catppuccin/nvim" },
		-- priority = 10,
		-- event = { "TermOpen" ,"BufReadPre", "BufNewFile" },
		-- event = { "TermOpen", "BufReadPost" },
		config = function()
			-- local dmode_enabled = false
			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "DebugModeChanged",
			-- 	callback = function(args)
			-- 		dmode_enabled = args.data.enabled
			-- 	end,
			-- })

			local colors = {
				green = "#94E2D5",
				blue = "#9CDCFE",
				-- blue = "#bb9af7",
				-- cyan = "#4EC9B0",
				-- cyan = "#94e2d5",
				-- cyan = "#bb9af7",
				-- cyan = "#9d7cd8",
				cyan = "#CBA6F7",
				-- cyan            = '#0db9d7',
				black = "#292e42",
				-- black           = '#1f2335',
				alternate_black = "#737aa2",
				white = "#737aa2",
				red = "#C586C0",
				blue_visual = "#264F78",
				violet = "#C586C0",
				grey = "#3B4252",
				-- red = "#ff5189",
				orange = "#CE9178",
			}

			local bubbles_theme = {
				normal = {
					a = { fg = colors.alternate_black, bg = colors.black },
					b = { fg = colors.alternate_black, bg = colors.black },
					c = { fg = colors.alternate_black, bg = colors.black },
					-- a = { fg = colors.alternate_black, bg = 'none'},
					-- b = { fg = colors.white, bg = 'none' },
					-- c = { fg = colors.white, bg = 'none' },
				},
				insert = { a = { fg = colors.alternate_black, bg = colors.black } },
				command = { a = { fg = colors.alternate_black, bg = colors.black } },
				visual = { a = { fg = colors.alternate_black, bg = colors.black } },
				replace = { a = { fg = colors.alternate_black, bg = colors.black } },
				inactive = {
					a = { fg = colors.alternate_black, bg = colors.black },
					b = { fg = colors.alternate_black, bg = colors.black },
					c = { fg = colors.alternate_black, bg = colors.black },
				},
				-- inactive = {
				--   a = { fg = colors.blue, bg = 'none' },
				--   b = { fg = colors.blue, bg = 'none' },
				--   c = { fg = colors.blue, bg = 'none' },
				-- },
			}

			local dirnameFormatFn = function()
				local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				local cwd = vim.fn.getcwd()
				local wt_utils = require("jg.custom.worktree-utils")
				local wt_info = wt_utils.get_wt_info(cwd)
				-- local parent_dir = vim.fn.fnamemodify(cwd .. "/..", ":p")
				local parent_dir = vim.fn.fnamemodify(cwd, ":h:t")

				if next(wt_info) == nil then
					return "  " .. dir_name .. " "
				else
					return "  " .. parent_dir .. " "
				end
			end

			local dirname = {
				"dirname",
				-- color = { fg = "#C586C0" ,bg = "none" },
				fmt = dirnameFormatFn,
			}

			local filename = {
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				path = 1, -- 0: Just the filename
				-- path = 0, -- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path

				-- shorting_target = 100, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "[!]", -- Text to show when the file is modified.
					-- readonly = "󰔉",    -- Text to show when the file is non-modifiable or readonly.
					readonly = "󰦝",
					unnamed = "󰔉", -- Text to show for unnamed buffers.
				},
				-- color = { fg = "#4EC9B0" ,bg = "none" },
				-- color = function(section)
				--   local active_buf_full_path = vim.api.nvim_buf_get_name(0)
				--
				--   local wt_utils = require("jg.custom.worktree-utils")
				--   local wt_info = wt_utils.get_wt_info(vim.fn.getcwd())
				--
				--   if next(wt_info) == nil then
				--     return { fg = colors.alternate_black }
				--   end
				--
				--   local escaped_wt_dir = wt_info["wt_dir"]:gsub("([^%w])", "%%%1")
				--
				--   if string.find(active_buf_full_path, escaped_wt_dir) then
				--     return { fg = colors.alternate_black }
				--   else
				--     return { fg = "#F38BA8" }
				--   end
				-- end,
			}

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_lsp" },
				sections = { "error", "warn", "info", "hint" },
				diagnostics_color = {
					error = "DiagnosticVirtualTextErrorLine",
					warn = "DiagnosticVirtualTextWarnLine",
					info = "DiagnosticVirtualTextInfoLine",
					hint = "DiagnosticVirtualTextHintLine",
				},
				colored = false,
				update_in_insert = true,
				alwars_visible = false,
			}

			local diagnostics_inactive = {
				"diagnostics",
				sources = { "nvim_lsp" },
				sections = { "error", "warn", "info", "hint" },
				diagnostics_color = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
					hint = "DiagnosticHint",
				},
				colored = true,
				update_in_insert = true,
				alwars_visible = false,
				color = { bg = colors.black },
			}

			local lualine_component = require("lualine.components.branch.git_branch")

			local branch = {
				"branch",
				-- color = function(section)
				--   local active_buf_full_path = vim.api.nvim_buf_get_name(0)
				--
				--   local wt_utils = require("jg.custom.worktree-utils")
				--   local wt_info = wt_utils.get_wt_info(vim.fn.getcwd())
				--
				--   if next(wt_info) == nil then
				--     return { fg = colors.alternate_black }
				--   end
				--
				--   local escaped_wt_dir = wt_info["wt_dir"]:gsub("([^%w])", "%%%1")
				--
				--   -- if dir_name ~= branch and vim.bo.filetype ~= "TelescopePrompt" and exists_bare_dir == 1 then
				--
				--  if (vim.bo.filetype == "TelescopePrompt" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "BufTerm" or vim.bo.filetype == "") then
				--     return { fg = colors.alternate_black }
				--  end
				--
				--   if string.find(active_buf_full_path, escaped_wt_dir) then
				--     return { fg = colors.alternate_black }
				--   else
				--     return { fg = "#F38BA8" }
				--   end
				-- end,
			}

			local diff_mode = {
				function()
					if vim.wo.diff then
						return "[DIFF]"
					else
						return ""
					end
				end,
				color = { fg = colors.green }, -- Customize the colors as needed
			}

			local ahead_behind_indicator = {
				function()
					-- Cache the result to avoid executing the logic repeatedly
					if vim.g.ahead_behind_status then
						return vim.g.ahead_behind_status
					end

					-- Check if the current directory is a Git repository
					local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):gsub("%s+", "")
					if is_git_repo ~= "true" then
						vim.g.ahead_behind_status = "" -- Set empty status if not a Git repo
						return ""
					end

					-- Get the main branch name
					local main_branch = vim.fn
						.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'")
						:gsub("%s+", "")
					if main_branch == "" then
						vim.g.ahead_behind_status = "" -- Set empty status if main branch is not found
						return ""
					end

					-- Get ahead/behind counts
					local result =
						vim.fn.system("git rev-list --left-right --count HEAD..." .. main_branch .. " 2>/dev/null")
					local ahead, behind = result:match("(%d+)%s+(%d+)")
					if not ahead or not behind then
						vim.g.ahead_behind_status = "" -- Set empty status if parsing fails
						return ""
					end

					-- Format the status and cache it
					vim.g.ahead_behind_status = " " .. ahead .. "  " .. behind
					return vim.g.ahead_behind_status
				end,
				-- color = { fg = colors.green }, -- Customize the colors as needed
			}

			-- CodeCompanion adapter component
			local codecompanion_adapter = {
				require("jg.custom.codecompanion_lualine"),
				color = { fg = colors.blue },
				cond = function()
					return vim.bo.filetype == "codecompanion"
				end,
			}

			-- local diff = {
			-- 	"diff",
			-- 	colored = true, -- Displays a colored diff status if set to true
			-- 	diff_color = {
			-- 		-- Same color values as the general color option can be used here.
			-- 		added = "DiffAdd", -- Changes the diff's added color
			-- 		modified = "DiffChange", -- Changes the diff's modified color
			-- 		removed = "DiffDelete", -- Changes the diff's removed color you
			-- 	},
			-- 	symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
			-- 	source = nil, -- A function that works as a data source for diff.
			-- 	-- It must return a table as such:
			-- 	--   { added = add_count, modified = modified_count, removed = removed_count }
			-- 	-- or nil on failure. count <= 0 won't be displayed.
			-- }

			-- local function get_schema()
			-- 	local schema = require("yaml-companion").get_buf_schema(0)
			-- 	if schema.result[1].name == "none" then
			-- 		return ""
			-- 	end
			-- 	return "[󱣃 " .. schema.result[1].name .."]"
			-- end

			require("lualine").setup({
				options = {
					theme = bubbles_theme,
					-- theme = 'tokyonight',
					-- theme = 'catppuccin',
					-- theme = 'dracula',
					-- theme = 'vscode',
					-- theme = 'nord',
					-- theme = 'palenight',
					-- theme = 'seoul256',
					-- theme = 'onedark',
					-- theme = 'nightfly',
					-- theme = 'modus-vivendi',
					-- component_separators = '|',
					-- section_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					-- section_separators = { left = '', right = ''},
					-- section_separators = { left = '', right = '' },
					-- section_separators = { left = '', right = ''},
					-- component_separators = { left = '', right = ''},
					component_separators = { left = " ", right = " " },
					disabled_filetypes = {
						-- statusline = { "alpha", "dashboard", "NvimTree", "Outline", "Diffview", "diffview" },
						-- 'NvimTree',
						statusline = { "alpha", "dashboard", "Outline", "Diffview", "diffview", "intro", "NvimTree" },
						winbar = {
							"help",
							"startify",
							"dashboard",
							"packer",
							"neogitstatus",
							"NvimTree",
							"Trouble",
							"alpha",
							"lir",
							"Outline",
							"spectre_panel",
							"toggleterm",
							"qf",
						},
					},
				},
				sections = {
					lualine_a = {
						{ "mode", separator = { left = "", right = "" } },
						-- {
						-- 	"mode",
						-- 	fmt = function(str)
						-- 		return dmode_enabled and "DEBUG" or str
						-- 	end,
						-- 	color = function(tb)
						--          if dmode_enabled then
						--            return { fg = colors.black, bg = "#89ddff" }
						--          else
						--            return tb
						--          end
						--
						-- 	end,
						-- },

						filename,
						-- diagnostics
						-- { 'mode', separator = { left = '' }, right_padding = 2 },
						-- { 'mode', separator = { left = '', right = '' } },
						-- { 'mode', separator = { left = '', right = '' } },
						-- { 'mode', separator = { left = '', right = '' } },
						-- { 'mode', separator = { left = '', right = '' } },
						-- { "mode", separator = { left = "", right = "" } },
					},
					-- lualine_b = { branch, ahead_behind_indicator },
					lualine_b = {},
					lualine_c = { diff_mode },
					-- lualine_x = { dirname, "filetype", get_schema },
					lualine_x = { codecompanion_adapter, "filetype" },
					-- lualine_x = {},
					-- lualine_y = {},
					lualine_y = { "progress" },
					lualine_z = {
						-- { "location", separator = { left = "", right = "" } },
						-- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
						-- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
						-- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
						-- { 'location', left_padding = 2 },
						-- { 'progress', 'location' }
						"location",
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {
						-- { 'filename', right_padding = 2 },
						-- { filename },
						-- { "filename" },
						-- { 'filename', separator = { left = '' }, left_padding = 2 },
					},
					lualine_c = { filename },
					-- lualine_c = { dirname },
					-- lualine_x = { "filetype" },
					-- lualine_y = {
					--   "location",
					--   -- { 'location', separator = { left = '', right = '' }, left_padding = 2 },
					-- },
					-- lualine_x = { diff },
					lualine_x = { dirname },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				-- winbar = {
				--   lualine_a = { branch },
				--   lualine_b = {},
				--   lualine_c = { filename },
				--   lualine_x = {},
				--   lualine_y = {},
				--   lualine_z = {}
				-- },
				-- inactive_winbar = {
				--   lualine_a = {},
				--   lualine_b = {},
				--   lualine_c = { 'filename' },
				--   lualine_x = {},
				--   lualine_y = {},
				--   lualine_z = {}
				-- },
				extensions = {},
			})
		end,
	},
}
