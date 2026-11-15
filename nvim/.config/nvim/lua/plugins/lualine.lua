return {
	{
		"nvim-lualine/lualine.nvim",
		event = { "VeryLazy" },
		ft = { "DiffviewFiles" },
		lazy = true,
		config = function()
			local colors = {
				green = "#94E2D5",
				blue = "#9CDCFE",
				cyan = "#CBA6F7",
				black = "#292e42",
				alternate_black = "#737aa2",
				white = "#737aa2",
				red = "#C586C0",
				blue_visual = "#264F78",
				violet = "#C586C0",
				grey = "#3B4252",
				orange = "#CE9178",
			}

			local bubbles_theme = {
				normal = {
					a = { fg = colors.alternate_black, bg = colors.black },
					b = { fg = colors.alternate_black, bg = colors.black },
					c = { fg = colors.alternate_black, bg = colors.black },
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
					-- modified = "[!]", -- Text to show when the file is modified.
					modified = "⏺",
					-- readonly = "󰔉",    -- Text to show when the file is non-modifiable or readonly.
					-- readonly = "󰦝",
          readonly = "󱀰",
					-- unnamed = "󰔉", -- Text to show for unnamed buffers.
          -- unnamed = " "
          unnamed = "[No Name]"
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

			-- Async tag shown when HEAD is detached (e.g. after
			-- `git checkout v1.2.3`), mirroring the tmux status-left snippet.
			local git_tag = {
				function()
					return require("jg.custom.git-tag").get()
				end,
				color = { fg = colors.cyan },
			}

			-- Async git status rendered by gitmux with the same symbols, layout
			-- and colours as the tmux status bar (see ~/.config/tmux/gitmux.conf).
			local git_status = {
				function()
					return require("jg.custom.gitmux").get()
				end,
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

			require("jg.custom.gitmux").setup({
        ttl = 650,
				-- Keep gitmux's named colours in line with the lualine palette.
				-- Hex colours from gitmux.conf (e.g. #8ee2cf) are used as-is.
				-- colors = {
				-- 	red = "#F38BA8",
				-- 	green = colors.green,
				-- 	yellow = "#E0AF68",
				-- 	blue = "#b4beff",
				-- 	magenta = colors.violet,
				-- 	cyan = colors.cyan,
				-- 	white = colors.alternate_black,
				-- },
			})

			require("jg.custom.git-tag").setup({ ttl = 650 })

			require("lualine").setup({
				options = {
					theme = bubbles_theme,
          refresh = { statusline = 700 },
					section_separators = { left = "", right = "" },
					component_separators = { left = " ", right = " " },
					disabled_filetypes = {
						statusline = { "Diffview", "diffview" },
						winbar = {
							"oil",
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
					},
					lualine_b = {},
					lualine_c = {
            filename,
						diff_mode,
					},
					lualine_x = {
            git_tag,
            git_status,
            -- function()
            --   return require("direnv").statusline()
            -- end,
            -- dirname,
						-- "encoding",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = {
						"location",
					},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},
}
