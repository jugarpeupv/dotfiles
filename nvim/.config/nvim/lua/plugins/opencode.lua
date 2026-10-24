return {
	{
		"sudo-tee/opencode.nvim",
		-- enabled = true,
		-- commit = "92ad9bf550f10ac24c0076dd564fa5b424ce4fab",
		-- "jugarpeupv/opencode.nvim",
		-- dev = true,
		-- dir = "~/projects/opencode.nvim/wt-main/",
		-- lazy = true,
		keys = {
			-- {
			-- 	mode = { "n", "v" },
			-- 	"<C-.>",
			-- 	function()
			-- 		require("opencode.api").toggle()
			-- 	end,
			-- },
			{
				"<leader>oF",
				require("jg.core.utils").opencode_snapshot_picker,
				desc = "pick and diff against a snapshot",
			},
			{
				mode = { "n" },
				"<leader>ci",
				function()
					-- local diff = vim.fn.system("git diff --cached")
					-- if diff == "" then
					-- 	vim.notify("No staged changes found", vim.log.levels.WARN)
					-- 	return
					-- end
					-- local prompt = "Write a commit message for the following staged changes following Conventional Commits convention. Keep the title under 50 characters and wrap body at 72 characters.\n\n```diff\n"
					-- 	.. diff
					-- 	.. "\n```\n\nFormat as a gitcommit code block like so ```gitcommit <the-git-commit-message> ```"
					-- require("opencode.api").run(prompt)

					local prompt = "Write a Conventional Commits message for the current staged "
						.. "changes: title under 50 chars, body wrapped at 72. Reply with ONLY a "
						.. "gitcommit block, opening fence alone on its line, message starting "
						.. "on the next line:\n"
						.. "```gitcommit\n"
						.. "feat(scope): short title\n\n"
						.. "Body wrapped at 72 characters.\n"
						.. "```"
					-- ensure opencode is visible before running; open it if hidden/closed
					local window_state = require("opencode.api").get_window_state()
					if window_state.status ~= "visible" then
						require("opencode.api").toggle()
					end
					-- git_diff only: clear stale mentions and disable every other
					-- context key (files/selection leak via chat_context.lua:544 otherwise)
					require("opencode.context").clear_files()
					require("opencode.context").clear_selections()
					require("opencode.api").run(prompt, {
						context = {
							-- current_file = { enabled = false },
							-- selection = { enabled = false },
							-- diagnostics = { enabled = false },
							-- cursor_data = { enabled = false },
							-- buffer = { enabled = false },
							-- git_diff = { enabled = true },
						},
					})
				end,
				desc = "Opencode - Generate commit message from staged changes",
			},
			-- {
			-- 	mode = { "v" },
			-- 	"<leader>oa",
			-- 	function()
			-- 		-- local start_pos = vim.fn.getpos("'<")
			-- 		-- local end_pos = vim.fn.getpos("'>")
			-- 		-- require("opencode.api").add_visual_selection_inline({ open_input = true }, {
			-- 		-- 	start = start_pos[2],
			-- 		-- 	stop = end_pos[2],
			-- 		-- })
			--        require("opencode.api").add_visual_selection_inline({ open_input = true })
			--
			--        -- -- Ensure marks are updated by forcing a momentary exit or using visual mode endpoints
			--        -- local start_line = vim.fn.line("v")
			--        -- local end_line = vim.fn.line(".")
			--        -- if start_line > end_line then
			--        --   start_line, end_line = end_line, start_line
			--        -- end
			--        --
			--        -- require("opencode.api").add_visual_selection_inline({ open_input = true }, {
			--        --   start = start_line,
			--        --   stop = end_line,
			--        -- })
			-- 	end,
			-- },
			{
				mode = { "n", "v", "t" },
				"<M-m>",
				function()
					require("opencode.api").toggle()
				end,
			},
			{
				mode = { "n", "v" },
				"<D-m>",
				function()
					require("opencode.api").toggle()
				end,
			},
		},
		config = function()
			local nvim_icon = vim.fn.expand("~/.config/nvim/assets/nvim.png")
			-- Default configuration with all available options
			require("opencode").setup({
				preferred_picker = "telescope",
				-- program_status = { enabled = true, tmux = true },
				preferred_completion = "blink",
				default_global_keymaps = false,
				default_mode = "build",
				debug = {
					enabled = true,
					capture_streamed_events = false,
					show_ids = true,
					highlight_changed_lines = false,
					highlight_changed_lines_timeout_ms = 120,
					quick_chat = {
						keep_session = false,
						set_active_session = false,
					},
				},
				-- server = false,
				hooks = {
					on_question_asked = function(session)
						local cwd = session and session.workspace or vim.fn.getcwd()
						local parts = vim.split(cwd, "/")
						local repo = table.concat({ parts[#parts - 1], parts[#parts] }, "/")
						local time = os.date("%H:%M")
						local msg = time .. " Opencode needs input "
						if repo ~= "" then
							msg = msg .. " in:\n" .. repo
						end
						-- opcional: detalle del permiso
						vim.fn.jobstart({
							"terminal-notifier",
							"-title",
							"Neovim",
							"-message",
							msg,
							"-contentImage",
							nvim_icon,
							-- "-sound",
							-- "Ping",
						}, { detach = true })
					end,
					on_permission_requested = function(session)
						local cwd = session and session.workspace or vim.fn.getcwd()
						local parts = vim.split(cwd, "/")
						local repo = table.concat({ parts[#parts - 1], parts[#parts] }, "/")
						local time = os.date("%H:%M")
						local msg = time .. " Opencode needs permission "
						if repo ~= "" then
							msg = msg .. " in:\n" .. repo
						end
						-- opcional: detalle del permiso
						vim.fn.jobstart({
							"terminal-notifier",
							"-title",
							"Neovim",
							"-message",
							msg,
							"-contentImage",
							nvim_icon,
							-- "-sound",
							-- "Ping",
						}, { detach = true })
					end,
					on_done_thinking = function(session)
						local cwd = session and session.workspace or vim.fn.getcwd()
						local parts = vim.split(cwd, "/")
						local repo = table.concat({ parts[#parts - 1], parts[#parts] }, "/")
						local time = os.date("%H:%M")
						local msg = time .. " Opencode finished "
						if repo ~= "" then
							msg = msg .. " in:\n" .. repo
						end
						vim.fn.jobstart({
							"terminal-notifier",
							"-title",
							"Neovim",
							"-message",
							msg,
							"-contentImage",
							nvim_icon,
							-- vim.fn.expand("~/nvim.png"),
						}, { detach = true })
					end,
				},
				keymap = {
          editor = {
            ['<M-m>']  = { 'toggle',                                            desc = 'Toggle Opencode window' },
            ['<D-m>']  = { 'toggle',                                            desc = 'Toggle Opencode window' },
            ['<leader>oI']  = { 'open_input_new_session',                            desc = 'Open input (new session)' },
            ['<leader>oN']  = { 'open_session_tab',                                  desc = 'Open new Opencode session tab' },
            ['<leader>o<']  = { 'prev_session_tab',                                  desc = 'Previous Opencode session tab' },
            ['<leader>o>']  = { 'next_session_tab',                                  desc = 'Next Opencode session tab' },
            ['<leader>o?']  = { 'select_session_tab',                                desc = 'Select Opencode session tab' },
            ['<leader>o1']  = { 'select_session_tab', { 1 },                          desc = 'Select Opencode session tab 1' },
            ['<leader>o2']  = { 'select_session_tab', { 2 },                          desc = 'Select Opencode session tab 2' },
            ['<leader>o3']  = { 'select_session_tab', { 3 },                          desc = 'Select Opencode session tab 3' },
            ['<leader>o4']  = { 'select_session_tab', { 4 },                          desc = 'Select Opencode session tab 4' },
            ['<leader>o5']  = { 'select_session_tab', { 5 },                          desc = 'Select Opencode session tab 5' },
            ['<leader>o6']  = { 'select_session_tab', { 6 },                          desc = 'Select Opencode session tab 6' },
            ['<leader>o7']  = { 'select_session_tab', { 7 },                          desc = 'Select Opencode session tab 7' },
            ['<leader>o8']  = { 'select_session_tab', { 8 },                          desc = 'Select Opencode session tab 8' },
            ['<leader>o9']  = { 'select_session_tab', { 9 },                          desc = 'Select Opencode session tab 9' },
            ['<leader>oP']  = { 'configure_provider',                                desc = 'Configure provider' },
            ['<leader>oS']  = { 'select_session',                                    desc = 'Select session' },
            ['<leader>oH']  = { 'select_history',                                    desc = 'Select from history' },
            ['<leader>oT']  = { 'timeline',                                          desc = 'Session timeline' },
            ['<leader>oQ']  = { 'close_session_tab',                                 desc = 'Close current Opencode session tab' },
            ['<leader>oa']  = { 'add_visual_selection',         mode = { 'v' },      desc = 'Add visual selection to context' },
            ['<leader>o/']  = { 'quick_chat',                   mode = { 'n', 'x' }, desc = 'Quick chat with current context' },
            ["<leader>oC"] = {
              function()
                require("opencode.state").jobs.clear_server()
              end,
            },

            -- ['<leader>og']  = { 'toggle',                                            desc = 'Toggle Opencode window' },
            -- ['<leader>oi']  = { 'open_input',                                        desc = 'Open input window' },
            -- ['<leader>oI']  = { 'open_input_new_session',                            desc = 'Open input (new session)' },
            -- ['<leader>oN']  = { 'open_session_tab',                                  desc = 'Open new Opencode session tab' },
            -- ['<leader>o<']  = { 'prev_session_tab',                                  desc = 'Previous Opencode session tab' },
            -- ['<leader>o>']  = { 'next_session_tab',                                  desc = 'Next Opencode session tab' },
            -- ['<leader>o?']  = { 'select_session_tab',                                desc = 'Select Opencode session tab' },
            -- ['<leader>o1']  = { 'select_session_tab', { 1 },                          desc = 'Select Opencode session tab 1' },
            -- ['<leader>o2']  = { 'select_session_tab', { 2 },                          desc = 'Select Opencode session tab 2' },
            -- ['<leader>o3']  = { 'select_session_tab', { 3 },                          desc = 'Select Opencode session tab 3' },
            -- ['<leader>o4']  = { 'select_session_tab', { 4 },                          desc = 'Select Opencode session tab 4' },
            -- ['<leader>o5']  = { 'select_session_tab', { 5 },                          desc = 'Select Opencode session tab 5' },
            -- ['<leader>o6']  = { 'select_session_tab', { 6 },                          desc = 'Select Opencode session tab 6' },
            -- ['<leader>o7']  = { 'select_session_tab', { 7 },                          desc = 'Select Opencode session tab 7' },
            -- ['<leader>o8']  = { 'select_session_tab', { 8 },                          desc = 'Select Opencode session tab 8' },
            -- ['<leader>o9']  = { 'select_session_tab', { 9 },                          desc = 'Select Opencode session tab 9' },
            -- ['<leader>oh']  = { 'select_history',                                    desc = 'Select from history' },
            -- ['<leader>oo']  = { 'open_output',                                       desc = 'Open output window' },
            -- ['<leader>ot']  = { 'toggle_focus',                                      desc = 'Toggle focus' },
            -- ['<leader>oT']  = { 'timeline',                                          desc = 'Session timeline' },
            -- ['<leader>oq']  = { 'close',                                             desc = 'Close Opencode window' },
            -- ['<leader>oQ']  = { 'close_session_tab',                                 desc = 'Close current Opencode session tab' },
            -- ['<leader>os']  = { 'select_session',                                    desc = 'Select session' },
            -- ['<leader>oS']  = { 'navigate_session_tree', { 'child', 'picker' },     desc = 'Select child session' },
            -- ['<leader>oP']  = { 'navigate_session_tree', { 'parent' },              desc = 'Go to parent session' },
            -- ['<leader>oB']  = { 'navigate_session_tree', { 'sibling', 'picker' },   desc = 'Select sibling session' },
            -- ['<leader>oR']  = { 'rename_session',                                    desc = 'Rename session' },
            -- ['<leader>op']  = { 'configure_provider',                                desc = 'Configure provider' },
            -- ['<leader>oV']  = { 'configure_variant',                                 desc = 'Configure model variant' },
            -- ['<leader>oy']  = { 'add_visual_selection',         mode = { 'v' },      desc = 'Add visual selection to context' },
            -- ['<leader>oY']  = { 'add_visual_selection_inline',  mode = { 'v' },      desc = 'Insert visual selection inline into input' },
            -- ['<leader>oz']  = { 'toggle_zoom',                                       desc = 'Toggle zoom' },
            -- ['<leader>ov']  = { 'paste_image',                                       desc = 'Paste image from clipboard' },
            -- ['<leader>od']  = { 'diff_open',                                         desc = 'Open diff view' },
            -- ['<leader>o]']  = { 'diff_next',                                         desc = 'Next diff' },
            -- ['<leader>o[']  = { 'diff_prev',                                         desc = 'Previous diff' },
            -- ['<leader>oc']  = { 'diff_close',                                        desc = 'Close diff view' },
            -- ['<leader>ora'] = { 'diff_revert_all_last_prompt',                       desc = 'Revert all (last prompt)' },
            -- ['<leader>ort'] = { 'diff_revert_this_last_prompt',                      desc = 'Revert this (last prompt)' },
            -- ['<leader>orA'] = { 'diff_revert_all',                                   desc = 'Revert all changes' },
            -- ['<leader>orT'] = { 'diff_revert_this',                                  desc = 'Revert this change' },
            -- ['<leader>orr'] = { 'diff_restore_snapshot_file',                        desc = 'Restore file snapshot' },
            -- ['<leader>orR'] = { 'diff_restore_snapshot_all',                         desc = 'Restore all snapshots' },
            -- ['<leader>ox']  = { 'swap_position',                                     desc = 'Swap window position' },
            -- ['<leader>otr'] = { 'toggle_reasoning_output',                           desc = 'Toggle reasoning output' },
            -- ['<leader>ott'] = { 'toggle_tool_output',                                desc = 'Toggle tool output' },
            -- ['<leader>otm'] = { 'toggle_max_messages',                               desc = 'Toggle max messages' },
            -- ['<leader>o/']  = { 'quick_chat',                   mode = { 'n', 'x' }, desc = 'Quick chat with current context' },
            -- ['<leader>oDu'] = { 'copy_server_url',                                   desc = 'Copy server url' },
          },
          output_window = {
            ['gg']          = { 'first_message',                                     desc = 'Load history and go to the first message' },
            ['<esc>']       = { 'close',                                             desc = 'Close Opencode windows' },
            ['<C-c>']       = { 'cancel',                                            desc = 'Cancel running request' },
            ['<tab>']       = { 'next_message',                                      desc = 'Go to next message' },
            ['<s-tab>']     = { 'prev_message',                                      desc = 'Go to previous message' },
            [')']           = { 'next_user_message',                                 desc = 'Go to next user message' },
            ['(']           = { 'prev_user_message',                                 desc = 'Go to previous user message' },
            ['[[']          = { 'toggle_pane',                  mode = { 'n' },      desc = 'Toggle input/output panes' },
            ['i']           = { 'focus_input',                                       desc = 'Focus input window' },
            ['gr']          = { 'references',                                        desc = 'Browse code references' },
            ['gf']          = { 'jump_to_file',                                       desc = 'Jump to file at cursor' },
            -- ['<CR>']        = { 'jump_to_target_at_cursor',                          desc = 'Jump to target at cursor' },
            ['<CR>']        = false,
            ['gd']          = { 'jump_to_target_at_cursor',                          desc = 'Jump to target at cursor' },
            ['<M-i>']       = { 'toggle_input',                 mode = { 'n' },      desc = 'Toggle input window' },
            ['<M-r>']       = { 'cycle_variant',                mode = { 'n' },      desc = 'Cycle model variants' },
            ['<C-p>']       = { 'navigate_session_tree', { 'child', 'picker' },     desc = 'Select child session' },
            ['<C-n>']       = { 'navigate_session_tree', { 'parent' },              desc = 'Go to parent session' },
            -- ['<leader>oB']  = { 'navigate_session_tree', { 'sibling', 'picker' },   desc = 'Select sibling session' },
            ['<leader>oB']  = false,
            ['<leader>oD']  = { 'debug_message',                                     desc = 'Open raw message debug view'                              },
            ['<leader>oO']  = { 'debug_output',                                      desc = 'Open raw output debug view'                               },
            ['<leader>oDs'] = { 'debug_session',                                     desc = 'Open raw session debug view'                              },

            ['<leader>oS']  = false,
            ['<leader>oP']  = false,

            ['<leader>oz']  = { 'toggle_zoom',                                       desc = 'Toggle zoom' },
            ['<leader>ov']  = { 'paste_image',                                       desc = 'Paste image from clipboard' },
            ['<leader>od']  = { 'diff_open',                                         desc = 'Open diff view' },
            ['<leader>o]']  = { 'diff_next',                                         desc = 'Next diff' },
            ['<leader>o[']  = { 'diff_prev',                                         desc = 'Previous diff' },
            ['<leader>oc']  = { 'diff_close',                                        desc = 'Close diff view' },
            ['<leader>ora'] = { 'diff_revert_all_last_prompt',                       desc = 'Revert all (last prompt)' },
            ['<leader>ort'] = { 'diff_revert_this_last_prompt',                      desc = 'Revert this (last prompt)' },
            ['<leader>orA'] = { 'diff_revert_all',                                   desc = 'Revert all changes' },
            ['<leader>orT'] = { 'diff_revert_this',                                  desc = 'Revert this change' },
            ['<leader>orr'] = { 'diff_restore_snapshot_file',                        desc = 'Restore file snapshot' },
            ['<leader>orR'] = { 'diff_restore_snapshot_all',                         desc = 'Restore all snapshots' },
            ['<leader>ox']  = { 'swap_position',                                     desc = 'Swap window position' },
            ['<leader>otr'] = { 'toggle_reasoning_output',                           desc = 'Toggle reasoning output' },
            ['<leader>ott'] = { 'toggle_tool_output',                                desc = 'Toggle tool output' },
            ['<leader>otm'] = { 'toggle_max_messages',                               desc = 'Toggle max messages' },
            ['<leader>oDu'] = { 'copy_server_url',                                   desc = 'Copy server url' },
            ["<C-b>"] = {
              function()
                local buf = vim.api.nvim_get_current_buf()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local row = cursor[1] - 1
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

                local in_block = false
                local block_start = nil
                local is_gitcommit = false

                for i, line in ipairs(lines) do
                  local line_idx = i - 1
                  if line:match("^```") then
                    if not in_block then
                      in_block = true
                      block_start = line_idx
                      is_gitcommit = line:match("^```gitcommit") ~= nil
                    else
                      in_block = false
                      if row > block_start and row < line_idx and is_gitcommit then
                        local content = {}
                        for j = block_start + 1, line_idx - 1 do
                          table.insert(content, lines[j + 1])
                        end
                        local text = table.concat(content, "\n")

                        local current_win = vim.api.nvim_get_current_win()
                        local wins = vim.api.nvim_list_wins()
                        local prev_win = nil
                        for idx, win in ipairs(wins) do
                          if win == current_win and idx > 1 then
                            prev_win = wins[idx - 1]
                            break
                          end
                        end

                        if prev_win then
                          vim.api.nvim_set_current_win(prev_win)
                          vim.api.nvim_paste(text, true, -1)
                        else
                          vim.notify("No previous window found", vim.log.levels.WARN)
                        end
                        return
                      end
                    end
                  end
                end

                -- Fallback: call context_items if not in a gitcommit block
                -- require("opencode.api").context_items()
              end,
              mode = { "n", "i" },
            },
          },
          input_window = {
            ['<cr>']        = { 'submit_input_prompt',          mode = { 'n' },      desc = 'Submit prompt'                                            },
            ['<C-s>']       = { 'submit_input_prompt',          mode = { 'i' },      desc = 'Submit prompt'                                            },
            ['<S-cr>']      = { 'submit_input_prompt',          mode = { 'n', 'i' }, desc = 'Submit prompt'                                            },
            -- ['<esc>']       = { 'close',                                             desc = 'Close Opencode windows',       defer_to_completion = true },
            ['<esc>']       = false,
            ['<C-c>']       = { 'cancel',                                            desc = 'Cancel running request' ,      defer_to_completion = true },
            ['~']           = { 'mention_file',                 mode = 'i',          desc = 'Mention file in context'                                  },
            ['@']           = { 'mention',                      mode = 'i',          desc = 'Open mention picker'                                      },
            ['/']           = { 'slash_commands',               mode = 'i',          desc = 'Open slash commands picker'                               },
            ['#']           = { 'context_items',                mode = 'i',          desc = 'Open context items picker'                                },
            ['<M-v>']       = { 'paste_image',                  mode = {'i', 'n'},          desc = 'Paste image from clipboard'                               },
            ['<leader>ov']       = { 'paste_image',                  mode = {'n'},          desc = 'Paste image from clipboard'                               },
            ['<tab>']       = { 'switch_mode',                  mode = { 'n' },      desc = 'Toggle input/output panes',    defer_to_completion = true },
            ['[[']       = { 'toggle_pane',                  mode = { 'n' },      desc = 'Toggle input/output panes',    defer_to_completion = true },
            -- ['<M-y>']       = { 'switch_mode',                  mode = { 'n', 'i' }, desc = 'Switch agent mode'                                        },
            ['<up>']        = { 'prev_prompt_history',          mode = { 'n', 'i' }, desc = 'Previous prompt history item', defer_to_completion = true },
            ['<down>']      = { 'next_prompt_history',          mode = { 'n', 'i' }, desc = 'Next prompt history item' ,    defer_to_completion = true },
            -- ['<M-m>']       = { 'switch_mode',                  mode = { 'n', 'i' }, desc = 'Switch agent mode'                                        },
            ['<M-m>']       = { 'toggle',                  mode = { 'n', 'i' }, desc = 'Toggle'                                        },
            ['<M-r>']       = { 'cycle_variant',                mode = { 'n', 'i' }, desc = 'Cycle model variants'                                     },
            ['<M-i>']       = { 'toggle_input',                 mode = { 'n', 'i' }, desc = 'Toggle input window'                                      },
            -- ['gr']          = { 'references',                                        desc = 'Browse code references'                                   },
            ['gr']          = false,
            ['<C-n>']       = { 'navigate_session_tree', { 'child', 'picker' },     desc = 'Select child session' },
            ['<C-p>']       = { 'navigate_session_tree', { 'parent', 'picker' },              desc = 'Go to parent session' },
            ['<leader>oS']  = false,
            ['<leader>oP']  = false,
            ['<leader>oB']  = false,
            ['<leader>oD']  = { 'debug_message',                                     desc = 'Open raw message debug view'                              },
            ['<leader>oO']  = { 'debug_output',                                      desc = 'Open raw output debug view'                               },
            ['<leader>oDs'] = { 'debug_session',                                     desc = 'Open raw session debug view'                              },
          },
					session_picker = {
						rename_session = { "<C-r>" }, -- Rename selected session in the session picker
						delete_session = { "<C-x>" }, -- Delete selected session in the session picker
						new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
					},
					timeline_picker = {
						undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
						fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
					},
					history_picker = {
						delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
						clear_all = { "<C-x>", mode = { "i", "n" } }, -- Clear all entries in the history picker
					},
					model_picker = {
						toggle_favorite = { "<C-f>", mode = { "i", "n" } },
					},
					mcp_picker = {
						toggle_connection = { "<C-t>", mode = { "i", "n" } }, -- Toggle MCP server connection in the MCP picker
					},
					permission = {
						accept = "a",
						accept_all = "A",
						deny = "D",
					},
				},
				context = {
					enabled = true, -- Enable automatic context capturing
					cursor_data = {
						enabled = false, -- Include cursor position and line content in the context
						context_lines = 5, -- Number of lines before and after cursor to include in context
					},
					diagnostics = {
						info = false, -- Include diagnostics info in the context (default to false
						warning = false, -- Include diagnostics warnings in the context
						error = false, -- Include diagnostics errors in the context
						only_closest = false, -- If true, only diagnostics for cursor/selection
					},
					current_file = {
						enabled = false, -- Include current file path and content in the context
						show_full_path = false,
					},
					files = {
						enabled = true,
						show_full_path = true,
					},
					selection = {
						enabled = true, -- Include selected text in the context
					},
					buffer = {
						enabled = false, -- Disable entire buffer context by default, only used in quick chat
					},
					git_diff = {
						enabled = false,
					},
				},
				ui = {
					enable_treesitter_markdown = true, -- Use Treesitter for markdown rendering in the output window (default: true)
					position = "right", -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
					float = {
						width = 0.45,
						height = 1,
						row = nil,
						col = 100,
						border = "rounded",
						gap = 4,
						zindex = 40,
						opts = {
							winblend = 0,
						},
					},
					input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
					window_width = 0.45, -- Width as percentage of editor width
					zoom_width = 0.9, -- Zoom width as percentage of editor width
					display_model = true, -- Display model name on top winbar
					display_context_size = true, -- Display context size in the footer
					display_cost = true, -- Display cost in the footer
					-- window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder', -- Highlight group for the opencode window
					persist_state = true, -- Keep buffers when toggling/closing UI so window state restores quickly
					output = {
						win_options = {
							cursorline = true,
							number = false,
							relativenumber = false,
						},
						-- rendering = {
						-- 	markdown_debounce_ms = 250,
						-- 	on_data_rendered = nil,
						-- 	event_throttle_ms = 40,
						-- 	event_collapsing = true,
						-- },
						tools = {
							show_output = true,
							show_reasoning_output = false,
							use_folds = false,
						},
						always_scroll_to_bottom = false,
					},
					questions = {
						use_vim_ui_select = false, -- If true, render questions with vim.ui.select instead of in the output buffer
					},
					input = {
						min_height = 0.20, -- min height of prompt input as percentage of window height
						max_height = 0.25, -- max height of prompt input as percentage of window height
						win_options = {
							signcolumn = "no",
							cursorline = true,
							number = true,
							relativenumber = false,
							foldcolumn = "0",
						},
						text = {
							wrap = true, -- Wraps text inside input window
						},
						-- Auto-hide input window when prompt is submitted or focus switches to output window
						auto_hide = false,
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
			},
			"saghen/blink.cmp",

			"folke/snacks.nvim",
		},
	},
}
