local function opencode_snapshot_picker()
  local snap_git_dir = require("opencode.config_file").get_workspace_snapshot_path():wait()
  if not snap_git_dir or snap_git_dir == "" then
    vim.notify("No opencode snapshot path for this workspace", vim.log.levels.ERROR)
    return
  end

  local state = require("opencode.state")
  if not state.active_session then
    vim.notify("No active opencode session", vim.log.levels.WARN)
    return
  end

  local session = require("opencode.session")
  local seen = {}
  local items = {}

  for _, msg in ipairs(state.messages or {}) do
    local snapshots = session.get_message_snapshot_ids(msg)
    if snapshots then
      local created = msg.info and msg.info.time and msg.info.time.created
      if created and created > 1e10 then
        created = created / 1000
      end
      local time_str = created and os.date("%Y-%m-%d %H:%M:%S", created) or "?"
      local role = (msg.info and msg.info.role) or "unknown"
      for _, hash in ipairs(snapshots) do
        if not seen[hash] then
          seen[hash] = true
          local r = vim.system({
            "git", "--git-dir", snap_git_dir, "cat-file", "-t", hash
          }, { text = true }):wait()
          if r.code == 0 then
            table.insert(items, {
              hash = hash,
              time = created or 0,
              time_str = time_str,
              role = role,
              display = string.format("%s  %s  %s", hash:sub(1, 8), time_str, role),
            })
          end
        end
      end
    end
  end

  if #items == 0 then
    vim.notify("No valid snapshots found", vim.log.levels.WARN)
    return
  end

  table.sort(items, function(a, b) return a.time > b.time end)

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Snapshots",
    finder = finders.new_table {
      results = items,
      entry_maker = function(item)
        return {
          value = item,
          display = item.display,
          ordinal = item.time_str .. " " .. item.hash,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          local cmd = 'DiffviewOpen "-C=' .. snap_git_dir .. '"' .. " " .. selection.value.hash
          print('cmd: ', cmd)
          vim.cmd(cmd)
        end
      end)
      return true
    end,
  }):find()
end

return {
	{
		-- "sudo-tee/opencode.nvim",
		-- enabled = true,
		-- commit = "92ad9bf550f10ac24c0076dd564fa5b424ce4fab",
		"jugarpeupv/opencode.nvim",
    branch = "feature/upstream-main",
		-- dev = true,
		-- dir = "~/projects/opencode.nvim/wt-feature-upstream-main/",
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
				opencode_snapshot_picker,
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

          local prompt = "Write a commit message for the current staged changes, following "
          .. "Conventional Commits convention. Keep the title under 50 characters and "
          .. "wrap the body at 72 characters. Run git diff --cached yourself to inspect "
          .. "the staged changes, then output the result as a ```gitcommit <the-git-commit-message>``` "
          .. "containing the commit message with its body on the following lines. Important, the gitcommit block should have ```gitcommit in the same line then \n with the git commit block"
          require("opencode.api").run(prompt)
				end,
				desc = "Opencode - Generate commit message from staged changes",
			},
			{
				mode = { "v" },
				"<leader>oa",
				function()
					local start_pos = vim.fn.getpos("'<")
					local end_pos = vim.fn.getpos("'>")
					require("opencode.api").add_visual_selection_inline({ open_input = true }, {
						start = start_pos[2],
						stop = end_pos[2],
					})
				end,
			},
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
			-- Default configuration with all available options
			require("opencode").setup({
				preferred_picker = "telescope",
				preferred_completion = "blink",
				default_global_keymaps = false,
				default_mode = "build",
				keymap_prefix = "<leader>o",
				-- server = false,
				hooks = {
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
							vim.fn.expand("~/nvim.png"),
						}, { detach = true })
					end,
				},
				keymap = {
					session_picker = {
						rename_session = { "<C-q>" }, -- Rename selected session in the session picker
						delete_session = { "<C-d>" }, -- Delete selected session in the session picker
						new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
					},
					timeline_picker = {
						undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
						fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
					},
					history_picker = {
						delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
						clear_all = { "<C-X>", mode = { "i", "n" } }, -- Clear all entries in the history picker
					},
					model_picker = {
						toggle_favorite = { "<C-f>", mode = { "i", "n" } },
					},
					mcp_picker = {
						toggle_connection = { "<C-t>", mode = { "i", "n" } }, -- Toggle MCP server connection in the MCP picker
					},
					editor = {
						-- ["<C-.>"] = { "toggle" }, -- Open opencode. Close if opened
						-- ["<C-.>"] = false,
						["<M-m>"] = { "toggle" }, -- Open opencode. Close if opened
						["<D-m>"] = { "toggle" }, -- Open opencode. Close if opened
						["<leader>og"] = false,
						["<leader>oi"] = false,
						["<leader>oI"] = { "open_input_new_session" }, -- Opens and focuses on input window on insert mode. Creates a new session
						["<leader>oo"] = false,
						["<leader>ot"] = false,
						["<leader>oT"] = { "timeline" }, -- Display timeline picker to navigate/undo/redo/fork messages
						["<leader>oq"] = false,
						["<leader>oS"] = { "select_session" }, -- Select and load a opencode session
						["<leader>oR"] = { "rename_session" }, -- Rename current session
						["<leader>oP"] = { "configure_provider" }, -- Quick provider and model switch from predefined list
						["<leader>oV"] = { "configure_variant" }, -- Switch model variant for the current model
						-- ['ga'] = { 'add_visual_selection', mode = {'v'} },
						["<leader>oa"] = {
							"add_visual_selection_inline",
							mode = { "v" },
							desc = "Insert visual selection inline into input",
						},
						-- ['<leader>oa'] = { 'add_visual_selection_inline', { open_input = false }, mode = {'v'} },
						["<leader>oz"] = { "toggle_zoom" }, -- Zoom in/out on the Opencode windows
						["<leader>ov"] = { "paste_image" }, -- Paste image from clipboard into current session
						["<leader>oD"] = { "diff_open" }, -- Opens a diff tab of a modified file since the last opencode prompt
						["<leader>o]"] = { "diff_next" }, -- Navigate to next file diff
						["<leader>o["] = { "diff_prev" }, -- Navigate to previous file diff
						["<leader>oC"] = { "diff_close" }, -- Close diff view tab and return to normal editing
						["<leader>ora"] = false,
						["<leader>ort"] = false,
						["<leader>orA"] = false,
						["<leader>orT"] = false,
						["<leader>orr"] = false,
						["<leader>orR"] = false,
						["<leader>ox"] = false,
						["<leader>ott"] = false,
						["<leader>o/"] = false,
						-- ['<leader>og'] = { 'toggle' }, -- Open opencode. Close if opened
						-- ['<leader>oi'] = { 'open_input' }, -- Opens and focuses on input window on insert mode
						-- ['<leader>oI'] = { 'open_input_new_session' }, -- Opens and focuses on input window on insert mode. Creates a new session
						-- ['<leader>oo'] = { 'open_output' }, -- Opens and focuses on output window
						-- ['<leader>ot'] = { 'toggle_focus' }, -- Toggle focus between opencode and last window
						-- ['<leader>oT'] = { 'timeline' }, -- Display timeline picker to navigate/undo/redo/fork messages
						-- ['<leader>oq'] = { 'close' }, -- Close UI windows
						-- ['<leader>os'] = { 'select_session' }, -- Select and load a opencode session
						-- ['<leader>oR'] = { 'rename_session' }, -- Rename current session
						-- ['<leader>op'] = { 'configure_provider' }, -- Quick provider and model switch from predefined list
						-- ['<leader>oV'] = { 'configure_variant' }, -- Switch model variant for the current model
						-- ['<leader>oy'] = { 'add_visual_selection', mode = {'v'} },
						-- ['<leader>oz'] = { 'toggle_zoom' }, -- Zoom in/out on the Opencode windows
						-- ['<leader>ov'] = { 'paste_image'}, -- Paste image from clipboard into current session
						-- ['<leader>od'] = { 'diff_open' }, -- Opens a diff tab of a modified file since the last opencode prompt
						-- ['<leader>o]'] = { 'diff_next' }, -- Navigate to next file diff
						-- ['<leader>o['] = { 'diff_prev' }, -- Navigate to previous file diff
						-- ['<leader>oc'] = { 'diff_close' }, -- Close diff view tab and return to normal editing
						-- ['<leader>ora'] = { 'diff_revert_all_last_prompt' }, -- Revert all file changes since the last opencode prompt
						-- ['<leader>ort'] = { 'diff_revert_this_last_prompt' }, -- Revert current file changes since the last opencode prompt
						-- ['<leader>orA'] = { 'diff_revert_all' }, -- Revert all file changes since the last opencode session
						-- ['<leader>orT'] = { 'diff_revert_this' }, -- Revert current file changes since the last opencode session
						-- ['<leader>orr'] = { 'diff_restore_snapshot_file' }, -- Restore a file to a restore point
						-- ['<leader>orR'] = { 'diff_restore_snapshot_all' }, -- Restore all files to a restore point
						-- ['<leader>ox'] = { 'swap_position' }, -- Swap Opencode pane left/right
						-- ['<leader>ott'] = { 'toggle_tool_output' }, -- Toggle tools output (diffs, cmd output, etc.)
						["<leader>oE"] = { "toggle_reasoning_output" }, -- Toggle reasoning output (thinking steps)
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
						-- ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
					},
					input_window = {
            ["<leader>oD"] = { "diff_open" }, -- Opens a diff tab of a modified file since the last opencode prompt
						["<esc>"] = false, -- Close UI windows
						["<cr>"] = { "submit_input_prompt", mode = { "n" } }, -- Submit prompt (normal mode and insert mode)
						["<c-s>"] = { "submit_input_prompt", mode = { "i" } }, -- Submit prompt (normal mode and insert mode)
						["<S-cr>"] = false,
						["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
						-- ["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
						-- ["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
						["~"] = false, -- Pick a file and add to context. See File Mentions section
						["@"] = false, -- Insert mention (file/agent)
						["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
						["#"] = { "context_items", mode = "i" }, -- Manage context items (current file, selection, diagnostics, mentioned files)
						["<M-v>"] = { "paste_image", mode = "i" }, -- Paste image from clipboard as attachment
						["<tab>"] = { "switch_mode" },
						["<up>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
						["<down>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
						["<M-m>"] = false,
						["<M-r>"] = { "cycle_variant", mode = { "n", "i" } }, -- Cycle through available model variants
            ["<leader>oR"] = { "rename_session" }, -- Rename current session
            ["<leader>oP"] = { "configure_provider" }, -- Quick provider and model switch from predefined list
            ["<leader>oV"] = { "configure_variant" }, -- Switch model variant for the current model

						-- ['<S-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }, -- Submit prompt (normal mode and insert mode)
						-- ['<esc>'] = { 'close' }, -- Close UI windows
						-- ['<C-c>'] = { 'cancel' }, -- Cancel opencode request while it is running
						-- ['~'] = { 'mention_file', mode = 'i' }, -- Pick a file and add to context. See File Mentions section
						-- ['@'] = { 'mention', mode = 'i' }, -- Insert mention (file/agent)
						-- ['/'] = { 'slash_commands', mode = 'i' }, -- Pick a command to run in the input window
						-- ['#'] = { 'context_items', mode = 'i' }, -- Manage context items (current file, selection, diagnostics, mentioned files)
						-- ['<M-v>'] = { 'paste_image', mode = 'i' }, -- Paste image from clipboard as attachment
						-- ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } }, -- Toggle between input and output panes
						-- ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' } }, -- Navigate to previous prompt in history
						-- ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' } }, -- Navigate to next prompt in history
						-- ['<M-m>'] = { 'switch_mode' }, -- Switch between modes (build/plan)
						-- ['<M-r>'] = { 'cycle_variant', mode = { 'n', 'i' } }, -- Cycle through available model variants
					},
					output_window = {
            ["<leader>oD"] = { "diff_open" }, -- Opens a diff tab of a modified file since the last opencode prompt
						["<esc>"] = false, -- Close UI windows
						["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
						["]]"] = { "next_message" }, -- Navigate to next message in the conversation
						["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
						["<tab>"] = false,
						["i"] = false,
						["<M-r>"] = false,
						["<leader>oO"] = false, -- Open raw output in new buffer for debugging
						["<leader>ods"] = false, -- Open raw session in new buffer for debugging
            -- ['<leader>oS'] = { 'select_child_session' }, -- Select and load a child session

						-- ['<esc>'] = { 'close' }, -- Close UI windows
						-- ['<C-c>'] = { 'cancel' }, -- Cancel opencode request while it is running
						-- [']]'] = { 'next_message' }, -- Navigate to next message in the conversation
						-- ['[['] = { 'prev_message' }, -- Navigate to previous message in the conversation
						-- ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } }, -- Toggle between input and output panes
						-- ['i'] = { 'focus_input', 'n' }, -- Focus on input window and enter insert mode at the end of the input from the output window
						-- ['<M-r>'] = { 'cycle_variant', mode = { 'n' } }, -- Cycle through available model variants
						-- ['<leader>oS'] = { 'select_child_session' }, -- Select and load a child session
						-- ['<leader>oD'] = { 'debug_message' }, -- Open raw message in new buffer for debugging
						-- ['<leader>oO'] = { 'debug_output' }, -- Open raw output in new buffer for debugging
						-- ['<leader>ods'] = { 'debug_session' }, -- Open raw session in new buffer for debugging
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
						enabled = true,
					},
				},
				ui = {
					enable_treesitter_markdown = true, -- Use Treesitter for markdown rendering in the output window (default: true).
					position = "right", -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
					input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
					window_width = 0.45, -- Width as percentage of editor width
					zoom_width = 0.9, -- Zoom width as percentage of editor width
					display_model = true, -- Display model name on top winbar
					display_context_size = true, -- Display context size in the footer
					display_cost = true, -- Display cost in the footer
					-- window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder', -- Highlight group for the opencode window
					persist_state = true, -- Keep buffers when toggling/closing UI so window state restores quickly
					buflisted = true, -- OpenCode buffers won't be closed by :only
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
							use_folds = false,
							show_reasoning_output = false,
						},
						always_scroll_to_bottom = false,
					},
					questions = {
						use_vim_ui_select = false, -- If true, render questions with vim.ui.select instead of in the output buffer
					},
					input = {
						min_height = 0.30, -- min height of prompt input as percentage of window height
						max_height = 0.35, -- max height of prompt input as percentage of window height
						win_options = {
							signcolumn = "no",
							cursorline = true,
							number = false,
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
			vim.api.nvim_create_autocmd("User", {
				pattern = "OpencodeEvent:question.asked",
				callback = function(args)
					-- args.data.event.properties.questions
					local questions = args.data.event.properties.questions
					local session = args.data.event.properties.session
					local workspace = (session and session.workspace) or vim.fn.getcwd()
					local parts = vim.split(workspace, "/")
					local repo = table.concat({ parts[#parts - 1], parts[#parts] }, "/")
					local questions_text = ""
					local time = os.date("%H:%M")
					if questions then
						local lines = {}
						for _, q in ipairs(questions) do
							table.insert(lines, q.question)
						end
						questions_text = "\n" .. table.concat(lines, "\n")
					end
					vim.fn.jobstart({
						"terminal-notifier",
						"-title",
						"Neovim",
						"-message",
						time .. " OpenCode needs input in " .. repo .. ":" .. questions_text,
						"-contentImage",
						vim.fn.expand("~/.config/nvim/nvim.png"),
					}, { detach = true })
				end,
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
