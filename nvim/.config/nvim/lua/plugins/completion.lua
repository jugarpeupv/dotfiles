local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
-- return {}
return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		enabled = true,
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			-- local cmp = require("cmp")
			-- cmp.setup({
			-- 	enabled = function()
			-- 		return (vim.api.nvim_get_option_value("filetype", { buf = 0 }) ~= "gitcommit" or
			--          vim.api.nvim_get_option_value("filetype", { buf = 0 }) ~= "copilot-chat") or
			--          vim.api.nvim_get_option_value("filetype", { buf = 0 }) ~= "AvanteInput"
			-- 	end,
			-- 	sources = {},
			-- 	window = {
			-- 		completion = {
			-- 			-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			-- 			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			-- 			winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
			-- 		},
			-- 		documentation = {
			-- 			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			-- 			-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			-- 			winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
			-- 		},
			-- 	},
			-- })
			--
			-- -- cmp.setup.filetype({ "gitcommit" }, {
			-- -- 	sources = {},
			-- -- })
			--
			-- -- `/` cmdline setup.
			-- cmp.setup.cmdline({ "/", "?" }, {
			-- 	mapping = cmp.mapping.preset.cmdline({
			-- 		["<C-j>"] = { c = cmp.mapping.select_next_item() },
			-- 		["<C-k>"] = { c = cmp.mapping.select_prev_item() },
			-- 		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			-- 		["<C-l>"] = cmp.config.disable,
			-- 		["<Tab>"] = cmp.config.disable,
			-- 		["<CR>"] = cmp.mapping(function(fallback)
			-- 			local selected_entry = cmp.get_selected_entry()
			-- 			local filetype = vim.bo.filetype
			-- 			if filetype == "" then
			-- 				vim.api.nvim_feedkeys(t("<CR>"), "n", true)
			-- 				return
			-- 			elseif cmp.visible() and selected_entry ~= nil then
			-- 				cmp.confirm({ select = true })
			-- 				return
			-- 			else
			-- 				-- fallback()
			-- 				vim.api.nvim_feedkeys(t("<CR>"), "n", true)
			--            fallback()
			-- 			end
			-- 		end, { "i", "s" }),
			-- 		-- ["<Tab>"] = cmp.config.disable,
			-- 		-- ["<Tab>"] = cmp.mapping(function(fallback)
			-- 		-- 	-- local copilot = require("copilot.suggestion")
			-- 		-- 	-- if copilot.is_visible() then
			-- 		-- 	--   copilot.accept()
			-- 		-- 	-- elseif cmp.visible() then
			-- 		-- 	fallback()
			-- 		-- end),
			-- 	}),
			-- 	-- mapping = {
			-- 	--   ["<C-j>"] = { c = cmp.mapping.select_next_item() },
			-- 	--   ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
			-- 	-- },
			-- 	sources = {
			-- 		{ name = "buffer" },
			-- 	},
			-- })
		end,
	},
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		keys = {
			"?",
			"/",
		},
		-- optional: provides snippets for the snippet source
		dependencies = {
			"onsails/lspkind.nvim",
			"Kaiser-Yang/blink-cmp-avante",
			"rafamadriz/friendly-snippets",
			"moyiz/blink-emoji.nvim",
			"MahanRahmati/blink-nerdfont.nvim",
			"disrupted/blink-cmp-conventional-commits",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
				["<C-w>"] = { "show_signature", "hide_signature", "fallback" },
				["<C-space>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							cmp.close()
						else
							cmp.show()
						end
					end,
				},
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<Right>"] = {
					function()
						local copilot = require("copilot.suggestion")
						if copilot.is_visible() then
							copilot.accept()
							return
						end
					end,
					"fallback",
				},
				-- ['<CR>'] = { 'select_and_accept', 'fallback' }
				-- ["<CR>"] = { "accept", "fallback" },
				["<CR>"] = {
					function(cmp)
						local filetype = vim.bo.filetype
						if filetype == "" then
							-- vim.api.nvim_feedkeys(t("<CR>"), "n", true)
							vim.api.nvim_feedkeys(t("<CR>"), "n", true)
							return
						elseif cmp.is_menu_visible() and cmp.get_selected_item() then
							return cmp.select_and_accept()
						end
					end,
					"fallback",
					-- function(cmp)
					--        print('fallback')
					-- 	return cmp.fallback()
					-- end,
				},
			},
			cmdline = {
				enabled = true,
				-- use 'inherit' to inherit mappings from top level `keymap` config
				keymap = {
					preset = "cmdline",
					["<Right>"] = {},
					["<Left>"] = {},
					["<CR>"] = { "accept_and_enter", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-j>"] = { "select_next", "fallback" },
					["<C-l>"] = { "accept", "fallback" },
				},
				sources = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					-- Commands
					if type == ":" or type == "@" then
						return { "cmdline" }
					end
					return {}
				end,
				completion = {
					trigger = {
						show_on_blocked_trigger_characters = {},
						show_on_x_blocked_trigger_characters = {},
					},
					list = {
						selection = {
							-- When `true`, will automatically select the first item in the completion list
							preselect = false,
							-- When `true`, inserts the completion item automatically when selecting it
							auto_insert = false,
						},
					},
					-- Whether to automatically show the window when new completion items are available
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == "?" or vim.fn.getcmdtype() == "/"
						end,
					},
					-- Displays a preview of the selected item on the current line
					ghost_text = { enabled = false },
				},
			},
			completion = {
				trigger = {
					show_on_keyword = true,
					show_on_insert_on_trigger_character = false,
				},
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				documentation = { window = { border = "rounded" }, auto_show = true },
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "kind_icon", "label", gap = 1 },
							{ "kind", gap = 1 },
							{ "source_name", "label_description", gap = 1 },
						},
						components = {
							label = {
								width = { fill = true, max = 60 },
							},
							label_description = {
								width = { max = 100 },
							},
							kind_icon = {
								text = function(ctx)
									local lspkind = require("lspkind")
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = lspkind.symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
				},
			},
			signature = { enabled = false, window = { border = "rounded" } },
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = {
					"avante",
					"lsp",
					"path",
					"buffer",
					"omni",
					"snippets",
					"lazydev",
					"emoji",
					"nerdfont",
					"conventional_commits",
				},
				per_filetype = { ["copilot-chat"] = { "path", "lsp", "buffer" } },
				providers = {
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {
							-- options for blink-cmp-avante
						},
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					-- ecolog = { name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
					buffer = {
						min_keyword_length = 2,
						max_items = 4,
						-- should_show_items = function()
						--   local col = vim.api.nvim_win_get_cursor(0)[2]
						--   local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
						--   -- NOTE: remember that `trigger_text` is modified at the top of the file
						--   return before_cursor:match("!" .. "%w*$") ~= nil
						-- end,
						-- transform_items = function(_, items)
						--   local line = vim.api.nvim_get_current_line()
						--   local col = vim.api.nvim_win_get_cursor(0)[2]
						--   local before_cursor = line:sub(1, col)
						--   local start_pos, end_pos = before_cursor:find("!" .. "[^" .. "!" .. "]*$")
						--   if start_pos then
						--     for _, item in ipairs(items) do
						--       if not item.trigger_text_modified then
						--         ---@diagnostic disable-next-line: inject-field
						--         item.trigger_text_modified = true
						--         item.textEdit = {
						--           newText = item.insertText or item.label,
						--           range = {
						--             start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
						--             ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
						--           },
						--         }
						--       end
						--     end
						--   end
						--   return items
						-- end,
					},
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
						enabled = function()
							return vim.bo.filetype == "gitcommit"
						end,
						---@module 'blink-cmp-conventional-commits'
						---@type blink-cmp-conventional-commits.Options
						opts = {}, -- none so far
					},
					nerdfont = {
						module = "blink-nerdfont",
						name = "Nerd Fonts",
						score_offset = 10, -- Tune by preference
						min_keyword_length = 3,
						opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
					cmdline = {
						-- ignores cmdline completions when executing shell commands
						enabled = function()
							-- return vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!") and not vim.fn.getcmdline():match("^:w")
							if vim.fn.getcmdline():match("^w") then
								return false
							end
							return true
							-- return true
							--        print(vim.fn.getcmdline())
							-- -- if (vim.fn.getcmdtype() == ":") then
							-- --   return false
							-- -- end
							-- return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
						end,
						min_keyword_length = function(ctx)
							-- when typing a command, only show when the keyword is 3 characters or longer
							if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
								return 1
							end
							return 0
						end,
					},
					snippets = {
						enabled = true,
						module = "blink.cmp.sources.snippets",
						-- max_items = 5,
						-- min_keyword_length = 2,
						-- should_show_items = function()
						-- 	local col = vim.api.nvim_win_get_cursor(0)[2]
						-- 	local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
						-- 	-- NOTE: remember that `trigger_text` is modified at the top of the file
						-- 	return before_cursor:match(";" .. "%w*$") ~= nil
						-- end,
						-- transform_items = function(_, items)
						-- 	local line = vim.api.nvim_get_current_line()
						-- 	local col = vim.api.nvim_win_get_cursor(0)[2]
						-- 	local before_cursor = line:sub(1, col)
						-- 	local start_pos, end_pos = before_cursor:find(";" .. "[^" .. ";" .. "]*$")
						-- 	if start_pos then
						-- 		for _, item in ipairs(items) do
						-- 			if not item.trigger_text_modified then
						-- 				---@diagnostic disable-next-line: inject-field
						-- 				item.trigger_text_modified = true
						-- 				item.textEdit = {
						-- 					newText = item.insertText or item.label,
						-- 					range = {
						-- 						start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
						-- 						["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
						-- 					},
						-- 				}
						-- 			end
						-- 		end
						-- 	end
						-- 	return items
						-- end,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = {
				implementation = "rust",
				max_typos = function()
					return 0
				end,
				use_proximity = true,
			},
		},
		opts_extend = { "sources.default" },
	},

	-- INIT_CMP_MODULE
	-- {
	--   event = "InsertEnter",
	--   "hrsh7th/nvim-cmp",
	--   dependencies = {
	--     {
	--       "petertriho/cmp-git",
	--       dependencies = { "hrsh7th/nvim-cmp" },
	--       opts = {},
	--     },
	--     { "neovim/nvim-lspconfig" },
	--     { "davidsierradz/cmp-conventionalcommits" },
	--     {
	--       -- snippet plugin
	--       "L3MON4D3/LuaSnip",
	--       build = "make install_jsregexp",
	--       dependencies = "rafamadriz/friendly-snippets",
	--       opts = { history = true, updateevents = "TextChanged,TextChangedI" },
	--     },
	--     { "windwp/nvim-autopairs" },
	--     -- cmp sources plugins
	--     -- "hrsh7th/cmp-nvim-lsp-signature-help",
	--     -- "hrsh7th/cmp-cmdline",
	--     "saadparwaiz1/cmp_luasnip",
	--     "hrsh7th/cmp-nvim-lua",
	--     "hrsh7th/cmp-nvim-lsp",
	--     "hrsh7th/cmp-buffer",
	--     "hrsh7th/cmp-path",
	--   },
	--   config = function()
	--     local lspkind_comparator = function(conf)
	--       local lsp_types = require("cmp.types").lsp
	--       return function(entry1, entry2)
	--         if entry1.source.name ~= "nvim_lsp" then
	--           if entry2.source.name == "nvim_lsp" then
	--             return false
	--           else
	--             return nil
	--           end
	--         end
	--         local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
	--         local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
	--         if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
	--           kind1 = "Parameter"
	--         end
	--         if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
	--           kind2 = "Parameter"
	--         end
	--
	--         local priority1 = conf.kind_priority[kind1] or 0
	--         local priority2 = conf.kind_priority[kind2] or 0
	--         if priority1 == priority2 then
	--           return nil
	--         end
	--         return priority2 < priority1
	--       end
	--     end
	--
	--     local label_comparator = function(entry1, entry2)
	--       return entry1.completion_item.label < entry2.completion_item.label
	--     end
	--
	--     local types = require("cmp.types")
	--     -- import nvim-cmp plugin safely
	--     local cmp_status, cmp = pcall(require, "cmp")
	--     if not cmp_status then
	--       return
	--     end
	--
	--     -- import luasnip plugin safely
	--     local luasnip_status, luasnip = pcall(require, "luasnip")
	--     if not luasnip_status then
	--       return
	--     end
	--
	--     -- import lspkind plugin safely
	--     local lspkind_status, lspkind = pcall(require, "lspkind")
	--     if not lspkind_status then
	--       return
	--     end
	--
	--     luasnip.add_snippets("html", {
	--       luasnip.parser.parse_snippet("testtest", "worksworks"),
	--     })
	--     -- luasnip.filetype_extend("myangular", { "html" })
	--     luasnip.filetype_extend("htmlangular", { "html" })
	--     -- load vs-code like snippets from plugins (e.g. friendly-snippets)
	--     require("luasnip.loaders.from_vscode").lazy_load()
	--
	--     vim.opt.completeopt = "menu,menuone,noselect"
	--
	--     cmp.setup.filetype({ "sagarename" }, {
	--       sources = {},
	--     })
	--
	--     cmp.setup.filetype({ "copilot-chat" }, {
	--       sources = {},
	--     })
	--
	--     local t = function(str)
	--       return vim.api.nvim_replace_termcodes(str, true, true, true)
	--     end
	--
	--     cmp.setup({
	--       performance = { fetching_timeout = 10000 },
	--       snippet = {
	--         expand = function(args)
	--           luasnip.lsp_expand(args.body)
	--         end,
	--       },
	--       -- preslect = cmp.PreselectMode.Item,
	--       mapping = cmp.mapping.preset.insert({
	--         ["<C-j>"] = cmp.mapping({
	--           c = function()
	--             vim.api.nvim_feedkeys(t("<Down>"), "m", true)
	--           end,
	--           i = function()
	--             vim.api.nvim_feedkeys(t("<Down>"), "m", true)
	--           end,
	--         }),
	--         ["<C-k>"] = cmp.mapping({
	--           c = function()
	--             vim.api.nvim_feedkeys(t("<Up>"), "m", true)
	--           end,
	--           i = function()
	--             vim.api.nvim_feedkeys(t("<Up>"), "m", true)
	--           end,
	--         }),
	--         -- ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
	--         -- ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
	--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
	--         ["<C-y>"] = cmp.mapping(function()
	--           local copilot = require("copilot.suggestion")
	--           if copilot.is_visible() then
	--             copilot.accept()
	--           elseif cmp.visible() then
	--             cmp.confirm({ select = true })
	--             return
	--           elseif luasnip.expand_or_locally_jumpable() then
	--             luasnip.expand_or_jump()
	--           end
	--           -- if luasnip.jumpable(-1) then
	--           --   luasnip.jump(-1)
	--           -- end
	--           -- if luasnip.expand_or_locally_jumpable() then
	--           --   luasnip.expand_or_jump()
	--           -- end
	--         end, { "i", "s" }),
	--         ["<C-x>"] = cmp.mapping(function()
	--           -- if luasnip.expand_or_jumpable() then
	--           --   luasnip.expand_or_jump()
	--           -- end
	--           if luasnip.jumpable(-1) then
	--             luasnip.jump(-1)
	--           end
	--         end, { "i", "s" }),
	--         ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
	--         ["<C-e>"] = cmp.mapping.abort(),   -- close completion window
	--         -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
	--         -- ["<CR>"] = cmp.mapping(function(fallback)
	--         --   -- local copilot = require("copilot.suggestion")
	--         --   -- if copilot.is_visible() then
	--         --   --   copilot.accept()
	--         --   -- elseif cmp.visible() then
	--         --   local filetype = vim.bo.filetype
	--         --   if filetype == "" then
	--         --     vim.api.nvim_feedkeys(t("<CR>"), "n", true)
	--         --     return
	--         --   elseif cmp.visible() then
	--         --     cmp.confirm({ select = true })
	--         --     return
	--         --   else
	--         --     fallback()
	--         --     return
	--         --   end
	--         -- end, { "i", "s" }),
	--
	--         ["<CR>"] = cmp.mapping(function(fallback)
	--           local selected_entry = cmp.get_selected_entry()
	--           local filetype = vim.bo.filetype
	--           if filetype == "" then
	--             vim.api.nvim_feedkeys(t("<CR>"), "n", true)
	--             return
	--           elseif cmp.visible() and selected_entry ~= nil then
	--             cmp.confirm({ select = true })
	--             return
	--           else
	--             fallback()
	--             -- vim.api.nvim_feedkeys(t("<CR>"), "n", true)
	--             return
	--           end
	--         end, { "i", "s" }),
	--         ["<Right>"] = cmp.mapping(function(fallback)
	--           local copilot = require("copilot.suggestion")
	--           if copilot.is_visible() then
	--             copilot.accept()
	--           else
	--             fallback()
	--           end
	--         end, { "i", "s" }),
	--         ["<Tab>"] = cmp.mapping.confirm({ select = true }),
	--         -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
	--         -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
	--         -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
	--         -- Overload tab to accept Copilot suggestions.
	--         -- ["<Tab>"] = cmp.mapping(function(fallback)
	--         --   -- local copilot = require("copilot.suggestion")
	--         --   -- if copilot.is_visible() then
	--         --   --   copilot.accept()
	--         --   -- elseif cmp.visible() then
	--         --
	--         --   if luasnip.expand_or_jumpable() then
	--         --     luasnip.expand_or_jump()
	--         --   else
	--         --     fallback()
	--         --   end
	--         --
	--         --   -- if cmp.visible() then
	--         --   --   cmp.confirm({ select = true })
	--         --   --   -- elseif luasnip.expand_or_locally_jumpable() then
	--         --   --   --   luasnip.expand_or_jump()
	--         --   -- else
	--         --   --   fallback()
	--         --   -- end
	--         -- end, { "i", "s" }),
	--         -- ["<S-Tab>"] = cmp.mapping(function(fallback)
	--         --   -- local copilot = require("copilot.suggestion")
	--         --   -- if copilot.is_visible() then
	--         --   --   copilot.accept()
	--         --   -- else
	--         --   --   fallback()
	--         --   -- end
	--         --   -- if cmp.visible() then
	--         --   --   cmp.select_prev_item()
	--         --   -- elseif luasnip.expand_or_locally_jumpable(-1) then
	--         --   --   luasnip.jump(-1)
	--         --   -- else
	--         --   --   fallback()
	--         --   -- end
	--         --   if luasnip.expand_or_locally_jumpable(-1) then
	--         --     luasnip.jump(-1)
	--         --   else
	--         --     fallback()
	--         --   end
	--         -- end, { "i", "s"}),
	--       }),
	--       -- window = {
	--       --   completion = cmp.config.window.bordered(),
	--       --   documentation = cmp.config.window.bordered(),
	--       -- },
	--       window = {
	--         completion = {
	--           -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
	--           border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	--           winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
	--         },
	--         documentation = {
	--           border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	--           -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
	--           winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
	--         },
	--       },
	--       -- sources for autocompletion
	--       sources = cmp.config.sources({
	--         { name = "lazydev",  group_index = 0 },
	--         { name = "nvim_lua", priority = 1100 },
	--         {
	--           name = "nvim_lsp",
	--           priority = 1000,
	--           -- entry_filter = function(entry, ctx)
	--           --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
	--           -- end,
	--           -- entry_filter = function(entry, _)
	--           --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
	--           -- end,
	--         },
	--         { name = "nvim_lsp:yamlls", priority = 999 },
	--         -- { name = 'nvim_lsp_signature_help', priority = 998 },
	--         { name = "ecolog",          priority = 901 },
	--         { name = "path",            priority = 900 }, -- file system paths
	--         { name = "git",             priority = 890 },
	--         -- { name = "nvim_lsp_signature_help" },
	--         { name = "render-markdown", priority = 850 },
	--         { name = "obsidian",        priority = 800 },
	--         { name = "obsidian_new",    priority = 800 },
	--         { name = "obsidian_tags",   priority = 800 },
	--         { name = "luasnip",         priority = 700 }, -- snippets
	--         -- { name = "nvim_lsp:marksman", priority = 600 },
	--         { name = "crates",          priority = 300 },
	--         { name = "buffer",          priority = 5,  keyword_length = 3 },
	--       }),
	--       sorting = {
	--         -- comparators = {
	--         --   -- cmp.config.compare.offset,
	--         --   cmp.config.compare.order,
	--         --   cmp.config.compare.exact,
	--         --   cmp.config.compare.score,
	--         --   function(entry1, entry2)
	--         --     local kind1 = entry1:get_kind()
	--         --     kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
	--         --     local kind2 = entry2:get_kind()
	--         --     kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
	--         --     if kind1 ~= kind2 then
	--         --       if kind1 == types.lsp.CompletionItemKind.Snippet then
	--         --         return false
	--         --       end
	--         --       if kind2 == types.lsp.CompletionItemKind.Snippet then
	--         --         return true
	--         --       end
	--         --       local diff = kind1 - kind2
	--         --       if diff < 0 then
	--         --         return true
	--         --       elseif diff > 0 then
	--         --         return false
	--         --       end
	--         --     end
	--         --   end,
	--         --   cmp.config.compare.sort_text,
	--         --   cmp.config.compare.length,
	--         -- },
	--
	--         comparators = {
	--           -- label_comparator,
	--           cmp.config.compare.score,
	--           lspkind_comparator({
	--             kind_priority = {
	--               Parameter = 14,
	--               Variable = 12,
	--               Field = 11,
	--               Property = 11,
	--               Constant = 10,
	--               Enum = 10,
	--               EnumMember = 10,
	--               Event = 10,
	--               Function = 10,
	--               Method = 10,
	--               Operator = 10,
	--               Reference = 10,
	--               Struct = 10,
	--               File = 8,
	--               Folder = 8,
	--               Class = 5,
	--               Color = 5,
	--               Module = 5,
	--               Interface = 3,
	--               Keyword = 2,
	--               Constructor = 1,
	--               Snippet = 0,
	--               Text = 0,
	--               TypeParameter = 1,
	--               Unit = 1,
	--               Value = 1,
	--             },
	--           }),
	--           -- cmp.config.compare.kind,
	--           cmp.config.compare.order,
	--           cmp.config.compare.offset,
	--           cmp.config.compare.exact,
	--           function(entry1, entry2)
	--             local kind1 = entry1:get_kind()
	--             kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
	--             local kind2 = entry2:get_kind()
	--             kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
	--             if kind1 ~= kind2 then
	--               if kind1 == types.lsp.CompletionItemKind.Snippet then
	--                 return false
	--               end
	--               if kind2 == types.lsp.CompletionItemKind.Snippet then
	--                 return true
	--               end
	--               local diff = kind1 - kind2
	--               if diff < 0 then
	--                 return true
	--               elseif diff > 0 then
	--                 return false
	--               end
	--             end
	--           end,
	--           cmp.config.compare.sort_text,
	--           cmp.config.compare.length,
	--         },
	--       },
	--       -- configure lspkind for vs-code like icons
	--       formatting = {
	--         -- format = require("tailwindcss-colorizer-cmp").formatter
	--
	--         format = lspkind.cmp_format({
	--           before = require("tailwind-tools.cmp").lspkind_format,
	--           maxwidth = 80,
	--           mode = "symbol_text",
	--           menu = {
	--             nvim_lsp = "[LSP]",
	--             ["nvim_lsp:yamlls"] = "[LSP-yamlls]",
	--             ["nvim_lsp:null-ls"] = "[LSP-nulls]",
	--             ["nvim_lsp:lua_ls"] = "[LSP-luals]",
	--             buffer = "[Buffer]",
	--             luasnip = "[LuaSnip]",
	--             obsidian = "[Obsidian]",
	--             obsidian_new = "[Obsidian]",
	--             obsidian_tags = "[Obsidian]",
	--             nvim_lua = "[Lua]",
	--             latex_symbols = "[Latex]",
	--             ["vim-dadbod-completion"] = "[DB]",
	--             crates = "[Crates]",
	--           },
	--           -- before = function(entry, vim_item)
	--           --   vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
	--           --   return vim_item
	--           -- end,
	--         }),
	--         -- format = function (entry, vim_item)
	--         --   vim_item.kind = lspkind.presets.default[vim_item.kind]
	--         --   vim_item.menu = ({
	--         --     nvim_lsp = "[LSP]",
	--         --     look = "[Dict]",
	--         --     buffer = "[Buffer]"
	--         --   })[entry.source.name]
	--         --
	--         --   vim_item.kind, vim_item.menu = vim_item.menu, vim_item.kind
	--         --   return vim_item
	--         -- end
	--         -- format = lspkind.cmp_format({
	--         --     -- mode = 'symbol',
	--         -- 	maxwidth = 50,
	--         -- 	ellipsis_char = "...",
	--         -- }),
	--       },
	--     })
	--
	--     cmp.setup.cmdline("?", {
	--       -- mapping = cmp.mapping.preset.cmdline({
	--       --   ["<C-j>"] = { c = cmp.mapping.select_next_item() },
	--       --   ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
	--       --   -- ["<Tab>"] = cmp.config.disable,
	--       --   ["<Tab>"] = cmp.mapping(function(fallback)
	--       --     -- local copilot = require("copilot.suggestion")
	--       --     -- if copilot.is_visible() then
	--       --     --   copilot.accept()
	--       --     -- elseif cmp.visible() then
	--       --     fallback()
	--       --   end),
	--       -- }),
	--       mapping = {
	--         ["<C-j>"] = { c = cmp.mapping.select_next_item() },
	--         ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
	--       },
	--       sources = {
	--         { name = "buffer" },
	--       },
	--     })
	--
	--     -- `/` cmdline setup.
	--     cmp.setup.cmdline("/", {
	--       -- mapping = cmp.mapping.preset.cmdline({
	--       --   ["<C-j>"] = { c = cmp.mapping.select_next_item() },
	--       --   ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
	--       --   -- ["<Tab>"] = cmp.config.disable,
	--       --   ["<Tab>"] = cmp.mapping(function(fallback)
	--       --     -- local copilot = require("copilot.suggestion")
	--       --     -- if copilot.is_visible() then
	--       --     --   copilot.accept()
	--       --     -- elseif cmp.visible() then
	--       --     fallback()
	--       --   end),
	--       -- }),
	--       mapping = {
	--         ["<C-j>"] = { c = cmp.mapping.select_next_item() },
	--         ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
	--       },
	--       sources = {
	--         { name = "buffer" },
	--       },
	--     })
	--     -- -- `:` cmdline setup.
	--     -- cmp.setup.cmdline(":", {
	--     --   mapping = cmp.mapping.preset.cmdline({
	--     --     ["<C-j>"] = { c = cmp.mapping.select_next_item() },
	--     --     ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
	--     --     -- ["<Tab>"] = cmp.mapping(function(fallback)
	--     --     --   -- local copilot = require("copilot.suggestion")
	--     --     --   -- if copilot.is_visible() then
	--     --     --   --   copilot.accept()
	--     --     --   -- elseif cmp.visible() then
	--     --     --   -- fallback()
	--     --     --   cmp.mapping.complete()
	--     --     -- end),
	--     --   }),
	--     --   -- matching = { disallow_symbol_nonprefix_matching = false },
	--     --   sources = cmp.config.sources({
	--     --     { name = "path" },
	--     --   }, {
	--     --     {
	--     --       name = "cmdline",
	--     --       option = {
	--     --         ignore_cmds = { "Man", "!", "read", "write" },
	--     --       },
	--     --     },
	--     --   }),
	--     -- })
	--     -- If you want insert `(` after select function or method item
	--
	--     local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
	--     vim.api.nvim_create_autocmd("FileType", {
	--       pattern = { "sql", "mysql", "plsql" },
	--       callback = function()
	--         cmp.setup.buffer({
	--           sources = {
	--             { name = "nvim_lsp" },
	--             { name = "vim-dadbod-completion" },
	--             { name = "buffer" },
	--           },
	--         })
	--       end,
	--       group = autocomplete_group,
	--     })
	--   end,
	-- },
}
