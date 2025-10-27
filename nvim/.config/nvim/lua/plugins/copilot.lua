-- return {}
return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
		enabled = false,
		init = function()
			vim.g.copilot_nes_debounce = 500
			vim.lsp.enable("copilot_ls")
      vim.keymap.set("n", "<esc>", function()
				if not require("copilot-lsp.nes").clear() then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
				end
      end, { desc = "Clear Copilot suggestion or fallback" })

			-- vim.keymap.set("n", "<tab>", function()
			-- 	local bufnr = vim.api.nvim_get_current_buf()
			-- 	local state = vim.b[bufnr].nes_state
			-- 	if state then
			-- 		-- Try to jump to the start of the suggestion edit.
			-- 		-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
			-- 		local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
			-- 			or (
			-- 				require("copilot-lsp.nes").apply_pending_nes()
			-- 				and require("copilot-lsp.nes").walk_cursor_end_edit()
			-- 			)
			-- 		return nil
			-- 	else
			-- 		-- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
			-- 		return "<C-i>"
			-- 	end
			-- end, { desc = "Accept Copilot NES suggestion", expr = true })
		end,
	},
	-- event = { "BufReadPost" },
	-- enabled = false,
	-- enabled = function()
	--   local is_headless = #vim.api.nvim_list_uis() == 0
	--   if is_headless then
	--     return false
	--   end
	--   return true
	-- end,
	config = function()
		require("copilot").setup({
			nes = {
				enabled = false,
				keymap = nil,
				-- keymap = {
				-- 	accept_and_goto = "<tab>",
				-- 	accept = false,
				-- 	dismiss = "<Esc>",
				-- },
			},
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					-- this keymap is open to use, option control
					-- open = "<M-CR>",
					open = "<D-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 10,
				keymap = {
					-- accept = "<TAB>",
					accept = false,
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				lua = false,
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
				["grug-far"] = false,
				["grug-far-history"] = false,
				["grug-far-help"] = false,
			},
			server = {
				type = "nodejs",
				custom_server_filepath = os.getenv("HOME")
					.. "/.local/share/nvim/mason/packages/copilot-language-server/node_modules/@github/copilot-language-server/dist/language-server.js",
			},
			-- copilot_model = "gpt-4o-copilot",
			compilot_model = "gpt-41-copilot",
			copilot_node_command = os.getenv("HOME") .. "/.nvm/versions/node/v22.17.0/bin/node", -- Node.js version must be > 18.x
			server_opts_overrides = {},
		})
	end,
}
