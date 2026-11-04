return {
	{
		"jugarpeupv/barbecue.nvim",
		enabled = true,
		name = "barbecue",
		branch = "main",
    -- dev = true,
    -- dir = "~/projects/barbecue.nvim/",
		-- event = "VeryLazy",
		-- event = "LspAttach",
		lazy = true,
		event = { "BufReadPost", "BufNewFile" },
		-- event = { "BufWinEnter" },
		dependencies = {
			{ "SmiteshP/nvim-navic" },
		},
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
					"bloocky",
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
					separator = ">",
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
}
