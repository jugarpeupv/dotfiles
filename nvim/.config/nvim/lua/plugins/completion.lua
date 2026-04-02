return {
	{
		"saghen/blink.cmp",
		enabled = true,
		event = { "InsertEnter", "CmdlineEnter" },
		keys = {
			"?",
			"/",
		},
		-- optional: provides snippets for the snippet source
		dependencies = {
			{ "onsails/lspkind.nvim", commit = "3ddd1b4edefa425fda5a9f95a4f25578727c0bb3" },
			"Kaiser-Yang/blink-cmp-git",
			"Kaiser-Yang/blink-cmp-avante",
			"rafamadriz/friendly-snippets",
			-- "moyiz/blink-emoji.nvim",
			-- "MahanRahmati/blink-nerdfont.nvim",
			"disrupted/blink-cmp-conventional-commits",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- version = "1.7.0",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		-- Switch to Lua fuzzy in cmdline so that an empty keyword (e.g. after typing
		-- a trailing '/') still returns all path items.  Frizbee (Rust) returns zero
		-- matches for an empty needle; the Lua implementation returns every item with
		-- score 0 when the needle is empty, which is exactly what we need here.
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,

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
							cmp.hide()
						else
							cmp.show()
						end
					end,
				},
				["<Tab>"] = {},
				-- ["<Tab>"] = {
				--   function(cmp)
				--     if vim.b[vim.api.nvim_get_current_buf()].nes_state then
				--       cmp.hide()
				--       return (
				--         require("copilot-lsp.nes").apply_pending_nes()
				--         and require("copilot-lsp.nes").walk_cursor_end_edit()
				--       )
				--     end
				--     if cmp.snippet_active() then
				--       return cmp.accept()
				--     else
				--       return cmp.select_and_accept()
				--     end
				--   end,
				--   "snippet_forward",
				--   "fallback",
				-- },
				-- ["<Tab>"] = {
				--   "snippet_forward",
				--   function() -- sidekick next edit suggestion
				--     return require("sidekick").nes_jump_or_apply()
				--   end,
				--   -- function() -- if you are using Neovim's native inline completions
				--   --   return vim.lsp.inline_completion.get()
				--   -- end,
				--   "fallback",
				-- },
				["<S-Tab>"] = {},
				-- ["<C-k>"] = { "select_prev", "fallback" },
				["<C-k>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						else
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<c-k>", true, false, true),
								"n",
								false
							)
							return
						end
					end,
					"fallback",
					-- function(cmp)
					--        print('fallback')
					-- 	return cmp.fallback()
					-- end,
				},

				["<C-j>"] = { "select_next", "fallback" },
				["<C-l>"] = { "accept", "fallback" },
				["<Right>"] = {
					function()
						local copilot_available, copilot = pcall(require, "copilot.suggestion")
            if not copilot_available then
              return
            end
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
							local t = function(str)
								return vim.api.nvim_replace_termcodes(str, true, true, true)
							end
							vim.api.nvim_feedkeys(t("<CR>"), "n", false)
							return
						elseif cmp.is_menu_visible() and cmp.get_selected_item() then
							return cmp.select_and_accept()
							-- return cmp.select()
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
				-- Tab: if menu open → select next; if closed → open blink menu
				["<Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_next()
						end
						-- Menu not open: show it (same open pattern as <C-l>)
						local trigger = require("blink.cmp.completion.trigger")
						local menu = require("blink.cmp.completion.windows.menu")
						local before = vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
						local expanded = vim.fn.getcompletion(before, "cmdline")
						if #expanded == 0 then
							return false -- nothing to show, let native handle it
						end
						menu.force_auto_show()
						trigger.show({ force = true, trigger_kind = "manual", initial_selected_item_idx = 1 })
						vim.schedule(function()
							if trigger.context == nil then return end
							menu.force_auto_show()
							menu.open()
							menu.update_position()
						end)
						return true
					end,
					"fallback",
				},
				-- S-Tab: if menu open → select prev; otherwise fallback
				["<S-Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						end
					end,
					"fallback",
				},
					["<Right>"] = {},
					["<Left>"] = {},
					-- ["<CR>"] = { "accept_and_enter", "fallback" },
					-- ["<CR>"] = { "accept", "fallback" },
					["<c-y>"] = { "accept", "fallback" },
					["<CR>"] = {
						-- function(cmp)
						-- 	local filetype = vim.bo.filetype
						-- 	if filetype == "grug-far" then
						--           print('ft grugfar')
						--           vim.api.nvim_feedkeys(t("<localleader>s"), "n", false)
						--           -- return cmp.fallback()
						-- 	end
						-- end,
						"accept_and_enter",
						"fallback",
					},
					-- ["<CR>"] = {},
					["<C-k>"] = {
						function(cmp)
							if cmp.is_menu_visible() then
								return cmp.select_prev()
							else
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<c-k>", true, false, true),
									"n",
									false
								)
								return
							end
						end,
						"fallback",
						-- function(cmp)
						--        print('fallback')
						-- 	return cmp.fallback()
						-- end,
					},
					["<C-j>"] = { "select_next", "fallback" },
					-- ["<C-l>"] = { "accept", "fallback" },
					-- ["<C-v>"] = false,
					-- ["<C-l>"] = false,
					["<C-l>"] = {
						function(cmp)
							local trigger = require("blink.cmp.completion.trigger")
							local menu = require("blink.cmp.completion.windows.menu")

							if not cmp.is_menu_visible() then
								local cmdline = vim.fn.getcmdline()
								local pos = vim.fn.getcmdpos()
								local before = cmdline:sub(1, pos - 1)
								local expanded = vim.fn.getcompletion(before, "cmdline")
								if #expanded == 0 then
									local with_dot = before .. "."
									local expanded_dot = vim.fn.getcompletion(with_dot, "cmdline")
									if #expanded_dot > 0 then
										vim.api.nvim_feedkeys(".", "t", false)
										return true
									end
									-- No completions available at all — do nothing
									return false
								end
								menu.force_auto_show()
								trigger.show({ force = true, trigger_kind = "manual", initial_selected_item_idx = 1 })
								vim.schedule(function()
									if trigger.context == nil then
										return
									end
									menu.force_auto_show()
									menu.open()
									menu.update_position()
								end)
								return true
							end

							local selected = cmp.get_selected_item() or (cmp.get_items() or {})[1]
							if not selected then
								return cmp.select_next()
							end

							-- Accept the item
							cmp.accept({ index = selected.idx })

							-- If item is a directory (label ends in '/'), reopen the menu for its contents
							if vim.endswith(selected.label, "/") then
								menu.force_auto_show()
								trigger.show({
									force = true,
									trigger_kind = "trigger_character",
									trigger_character = "/",
								})
								vim.schedule(function()
									if trigger.context == nil then
										return
									end
									menu.force_auto_show()
									menu.open()
									menu.update_position()
								end)
							end
						end,
					},
				},
				sources = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward: use blink with buffer source
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					-- Commands: return nothing so Neovim's built-in wildmenu handles completion

				-- Commands
				if type == ":" or type == "@" then
					return { "cmdline", "path" }
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
					-- menu = {
					-- 	auto_show = function()
					-- 		return vim.fn.getcmdtype() == "?" or vim.fn.getcmdtype() == "/"
					-- 	end,
					-- },
					-- Displays a preview of the selected item on the current line
					ghost_text = { enabled = false },
				},
			},
			completion = {
				trigger = {
					show_on_keyword = true,
					show_on_insert_on_trigger_character = true,
				},
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				documentation = { window = { border = "rounded" }, auto_show = true },
				menu = {
					-- auto_show = true,
					-- Delay before showing the completion menu while typing
					-- auto_show_delay_ms = 100,
					auto_show = function()
						return vim.bo.filetype ~= "codecompanion" and vim.bo.filetype ~= "opencode"
					end,
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
									-- Path source: kind is set correctly as Folder/File
								if ctx.kind == "Folder" then
                    icon = ""
								else
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									end
								elseif ctx.source_name == "Cmdline" then
								-- Cmdline source: detect folder by trailing slash
								if ctx.label:sub(-1) == "/" then
                    icon = ""
								else
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										else
											icon = lspkind.symbolic("File", { mode = "symbol" })
										end
									end
								else
									icon = lspkind.symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									if ctx.kind ~= "Folder" then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
								elseif ctx.source_name == "Cmdline" then
									if ctx.label:sub(-1) ~= "/" then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									else
										hl = "BlinkCmpKindFolder"
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
					-- "git",
					-- "avante",
					"lsp",
					"path",
					"buffer",
					-- "omni",
					"snippets",
					-- "lazydev",
					-- "emoji",
					-- "nerdfont",
					-- "conventional_commits",
				},
				per_filetype = {
					["opencode"] = { "buffer", "path", "lsp" },
					["codecompanion"] = { "buffer", "path" },
					["octo"] = {
						"git",
						-- "lsp",
						"path",
						"buffer",
						-- "emoji",
						-- "nerdfont",
						-- "conventional_commits",
					},
					["gitcommit"] = {
						"git",
						"path",
						"conventional_commits",
						"buffer",
					},
					-- ["md"] = {},
					["markdown"] = { "lsp", "buffer", "path" },
					["copilot-chat"] = { "buffer" },
					["AvanteInput"] = { "avante", "lsp", "buffer" },
				},
				providers = {
					git = {
						module = "blink-cmp-git",
						name = "Git",
						-- only enable this source when filetype is gitcommit, markdown, or 'octo'
						enabled = function()
							return vim.tbl_contains({ "gitcommit", "octo" }, vim.bo.filetype)
						end,
						opts = {
							-- options for the blink-cmp-git

							git_centers = {
								github = {
									mention = {
										-- Use gh CLI with GraphQL query for assignable users
										get_command = function()
											return "echo"
										end,
										get_command_args = function(command, token)
											-- Your custom user list
											local custom_users = {
												"GPJULI6_mapfre",
												"RFERRA3_mapfre",
												"GDMARI2_mapfre",
												"ABENAV1_mapfre",
												"VVILAS1_mapfre",
												"LUQUER1_mapfre",
												"AHEVIAV_mapfre",
												"RPANAD1_mapfre",
												"RCDAVI3_mapfre",
											}

											-- Get issue number from Octo buffer URL

											-- local function get_octo_issue_number()
											-- 	if vim.bo.filetype ~= "octo" then
											-- 		return nil
											-- 	end
											--
											-- 	local bufname = vim.fn.expand("%:p")
											--
											-- 	-- Try to match issue pattern: octo://owner/repo/issues/123
											-- 	local issue_num = bufname:match("octo://[^/]+/[^/]+/issue/(%d+)")
											-- 	if issue_num then
											-- 		return issue_num
											-- 	end
											--
											-- 	-- Try to match PR pattern: octo://owner/repo/pull/123
											-- 	issue_num = bufname:match("octo://[^/]+/[^/]+/pull/(%d+)")
											-- 	if issue_num then
											-- 		return issue_num
											-- 	end

											-- 	-- Try buffer variable as fallback
											-- 	local bufnr = vim.api.nvim_get_current_buf()
											-- 	local issue_obj = vim.b[bufnr].octo_issue
											-- 	if issue_obj and issue_obj.number then
											-- 		return tostring(issue_obj.number)
											-- 	end
											--
											-- 	return nil
											-- end
											--
											--            local issue_number = get_octo_issue_number()
											--            vim.print(issue_number)
											-- if issue_number then
											-- 	-- Fetch issue author using gh CLI
											-- 	local handle = io.popen(
											-- 		string.format(
											-- 			'gh issue view %s --json author --jq ".author.login" 2>/dev/null',
											-- 			issue_number
											-- 		)
											-- 	)
											-- 	if handle then
											-- 		local author = handle:read("*a"):gsub("%s+$", "")
											-- 		handle:close()
											--
											-- 		-- Add author to custom list if not already present
											-- 		if author and author ~= "" then
											-- 			local found = false
											-- 			for _, username in ipairs(custom_users) do
											-- 				if username == author then
											-- 					found = true
											-- 					break
											-- 				end
											-- 			end
											-- 			if not found then
											-- 				table.insert(custom_users, 1, author) -- Add at the beginning
											-- 			end
											-- 		end
											-- 	end
											-- end
											--
											-- Convert to the format that separate_output expects
											local json_users = {}
											for _, username in ipairs(custom_users) do
												table.insert(json_users, string.format('{"login":"%s"}', username))
											end

											return { "[" .. table.concat(json_users, ",") .. "]" }
										end,

										-- get_command = function()
										--     return 'gh'
										-- end,
										-- get_command_args = function(command, token)
										--     local utils = require('blink-cmp-git.utils')
										--     local owner_repo = utils.get_repo_owner_and_repo()
										--     local owner, repo = owner_repo:match('([^/]+)/([^/]+)')
										--
										--     return {
										--         'api',
										--         'graphql',
										--         '-f',
										--         'query=query($owner: String!, $name: String!) { repository(owner: $owner, name: $name) { assignableUsers(first: 5) { nodes { login name } } } }',
										--         '-F',
										--         'owner=' .. owner,
										--         '-F',
										--         'name=' .. repo,
										--         '--jq',
										--         '.data.repository.assignableUsers.nodes',
										--     }
										-- end,
										-- Parse the GraphQL response
										separate_output = function(output)
											local utils = require("blink-cmp-git.utils")
											return utils.remove_empty_string_value(utils.json_decode(output))
										end,
									},
								},
							},
						},
					},
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
					-- nerdfont = {
					-- 	module = "blink-nerdfont",
					-- 	name = "Nerd Fonts",
					-- 	score_offset = 10, -- Tune by preference
					-- 	min_keyword_length = 3,
					-- 	opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
					-- },
					-- emoji = {
					-- 	module = "blink-emoji",
					-- 	name = "Emoji",
					-- 	score_offset = 15, -- Tune by preference
					-- 	opts = { insert = true }, -- Insert emoji (default) or complete its name
					-- 	should_show_items = function()
					-- 		return vim.tbl_contains(
					-- 			-- Enable emoji completion only for git commits and markdown.
					-- 			-- By default, enabled for all file-types.
					-- 			{ "gitcommit" },
					-- 			vim.o.filetype
					-- 		)
					-- 	end,
					-- },
				path = {
						-- In cmdline mode, only surface dotfiles (items starting with '.').
						-- Regular files/dirs are already covered by the cmdline source.
						-- In normal insert mode, pass everything through unchanged.
						transform_items = function(_, items)
							if vim.api.nvim_get_mode().mode ~= "c" then
								return items
							end
							return vim.tbl_filter(function(item)
								return item.label:sub(1, 1) == "."
							end, items)
						end,
						-- Only activate for path-type completions in cmdline mode,
						-- and only when the last path component doesn't already start with '.'
						-- (in that case cmdline source already returns the dotfiles).
						should_show_items = function()
							if vim.api.nvim_get_mode().mode ~= "c" then
								return true
							end
							local compltype = vim.fn.getcmdcompltype()
							local path_types =
								{ "file", "dir", "file_in_path", "dir_in_path", "runtime", "shellcmd" }
							if not vim.tbl_contains(path_types, compltype) then
								return false
							end
							-- If the user has already typed a '.' prefix after the last slash,
							-- cmdline source will surface those dotfiles — don't duplicate them.
							local cmdline = vim.fn.getcmdline()
							local pos = vim.fn.getcmdpos()
							local before = cmdline:sub(1, pos - 1)
							local last_component = before:match("[^/]*$") or ""
							return last_component:sub(1, 1) ~= "."
						end,
						opts = {
							show_hidden_files_by_default = true,
						},
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
							-- Only require a keyword when completing a bare command name (no space yet).
							-- For arguments (paths etc.) always allow empty keyword so dotfiles show up.
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
}
