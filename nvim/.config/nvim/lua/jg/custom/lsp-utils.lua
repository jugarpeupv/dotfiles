-- local navbuddy = require("nvim-navbuddy")

local FeedKeys = function(keymap, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, false)
end

local M = {}

M.attach_lsp_config = function(client, bufnr)
	-- if string.match(vim.api.nvim_buf_get_name(bufnr), 'node_modules') then
	--   vim.lsp.stop_client(client.id)
	-- end

	-- navbuddy.attach(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap -- for conciseness
	-- keymap.set("n", "gI", "<cmd>Lspsaga finder<CR>", opts)                  -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	-- keymap.set("n", "<leader>gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	-- keymap.set("n", "gd", function()
	-- 	vim.lsp.buf.definition()
	-- 	vim.cmd("normal! zz")
	-- end, opts) -- see definition and make edits in window

	vim.keymap.set({ "n" }, "gd", function()
		--   local params = vim.lsp.util.make_position_params(0, 'utf-8')
		-- vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
		-- 	if result then
		--       vim.lsp.util.show_document(result)
		-- 		vim.cmd("normal! zz")
		-- 	end
		-- end)
    Snacks.picker.lsp_definitions()
	end, opts)

	vim.keymap.set({ "n" }, "gv", function()
		vim.cmd("vsp")
    Snacks.picker.lsp_definitions()
	end, opts)

	vim.keymap.set({ "n" }, "gs", function()
		vim.cmd("sp")
    Snacks.picker.lsp_definitions()
	end, opts)

	-- vim.keymap.set({ "n" }, "gv", function()
	--   require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
	--   -- vim.schedule(function()
	--   --   FeedKeys("zz", "n")
	--   --   -- vim.api.nvim_feedkeys("zz", "n", true)
	--   -- end)
	--   -- vim.schedule(function()
	--   --   vim.api.nvim_feedkeys("zz", "n", true)
	--   -- end)
	-- end, { noremap = true, silent = true })

	if vim.fn.has("nvim-0.12") == 1 then
		vim.keymap.set({ "o", "x" }, "an", function()
			vim.lsp.buf.selection_range(1)
		end, opts)
		vim.keymap.set({ "o", "x" }, "in", function()
			vim.lsp.buf.selection_range(-1)
		end, opts)
	end

	keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	-- keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

	-- keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
	-- keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.references({ context = { includeDeclaration = false } })<cr>", opts)
	vim.keymap.set({ "n" }, "gR", function()
		-- vim.lsp.buf.references({ context = {
		-- 	includeDeclaration = false,
		-- } })
		vim.lsp.buf.references()
	end, opts)
	-- keymap.set("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format({ async = true})<cr>", opts)
	keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- keymap.set("n", "<Leader>re", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	vim.keymap.set("n", "<leader>re", function()
		-- when rename opens the prompt, this autocommand will trigger
		-- it will "press" CTRL-F to enter the command-line window `:h cmdwin`
		-- in this window I can use normal mode keybindings
		local cmdId
		cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
      group = vim.api.nvim_create_augroup('cmdlineenterlsputils', { clear = true }),
			callback = function()
				local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
				vim.api.nvim_feedkeys(key, "c", false)
				vim.api.nvim_feedkeys("0", "n", false)
				-- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
				cmdId = nil
				return true
			end,
		})
		vim.lsp.buf.rename()
		-- vim.cmd(":IncRename " .. vim.fn.expand("<cword>"))

		-- if LPS couldn't trigger rename on the symbol, clear the autocmd
		vim.defer_fn(function()
			-- the cmdId is not nil only if the LSP failed to rename
			if cmdId then
				vim.api.nvim_del_autocmd(cmdId)
			end
		end, 500)
	end, opts)

	-- keymap.set("n", "<Leader>re", "<cmd>lua require('renamer').rename()<CR>", opts)
	-- keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	-- keymap.set("n", "<Leader>re", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

	-- keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

	-- keymap.set({ "n", "v" }, "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

	-- keymap("n", "<M-.>", "<cmd>Lspsaga code_action<CR>", opts)

	-- keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor

	keymap.set("n", "<leader>gk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "<leader>gj", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts) -- jump to previous diagnostic in buffer

	-- keymap.set("n", "<leader>gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	-- keymap.set("n", "<leader>gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	-- keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)                    -- show documentation for what is under cursor

	-- keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	-- keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)      -- show documentation for what is under cursor
	-- keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)              -- show documentation for what is under cursor

	-- version 10 of nvim
	-- if client.server_capabilities.inlayHintProvider then
	--   -- vim.lsp.buf.inlay_hint(bufnr, true)
	--   -- vim.lsp.inlay_hint.enable(bufnr, true)
	--   vim.lsp.inlay_hint.enable(true)
	-- end

	-- typescript specific keymaps (e.g. rename file and update imports)

	-- require("lsp_signature").on_attach({
	--   floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
	--   toggle_key = "<M-lt>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
	--   hint_enable = false,    -- virtual hint enable
	--   wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
	--   -- floating_window_above_cur_line = true,
	--   hint_prefix = {
	--     above = "↙ ", -- when the hint is on the line above the current line
	--     current = "← ", -- when the hint is on the same line
	--     below = "↖ ", -- when the hint is on the line below the current line
	--   },
	--   hint_inline = function()
	--     return 'eol'
	--   end, -- show hint inline in current line
	-- }, bufnr)

	keymap.set({ "n" }, "gh", function()
		vim.lsp.buf.signature_help()
	end, opts)

  keymap.set({ "i" }, "<M-lt>", function()
    vim.lsp.buf.signature_help()
  end, opts)

	-- keymap.set({ "n" }, "gh", function()
	--   require("lsp_signature").toggle_float_win()
	-- end, opts)

	if client.name == "jdtls" then
		vim.keymap.set("n", "<leader>oi", function()
			require("jdtls").organize_imports()
		end, { desc = "Organize Imports" })
	end

	if client.name == "pyright" then
		keymap.set({ "n" }, "<leader>oi", function()
			vim.cmd("PyrightOrganizeImports")
		end, opts)
	end

	if client.name == "vtsls" then
		keymap.set({ "n" }, "<leader>oi", function()
			require("vtsls").commands.organize_imports(bufnr)
		end, opts)

		keymap.set({ "n" }, "<leader>ru", function()
			require("vtsls").commands.remove_unused_imports(bufnr)
		end, opts)

		keymap.set({ "n" }, "<leader>rU", function()
			require("vtsls").commands.remove_unused(bufnr)
		end, opts)

		keymap.set({ "n" }, "<leader>ia", function()
			require("vtsls").commands.add_missing_imports(bufnr)
		end, opts)

		keymap.set({ "n" }, "<leader>rf", function()
			require("vtsls").commands.rename_file(bufnr)
		end, opts)
	end
end

local function fetch_github_repo(repo_name, token, org, workspace_path)
	-- local cmd = {
	-- 	"curl",
	-- 	"-H",
	-- 	"Authorization: Bearer " .. token,
	-- 	"-H",
	-- 	"User-Agent: Neovim",
	-- 	"https://api.github.com/repos/" .. org .. "/" .. repo_name,
	-- }
	--
	-- local result = vim.system(cmd):wait()
	-- if not result or not result.stdout then
	-- 	print("No result from GitHub API")
	-- 	return {}
	-- end
	--
	-- local raw_json = result.stdout
	-- if raw_json == "" then
	-- 	print("Empty JSON from GitHub API")
	-- 	return {}
	-- end
	--
	-- local ok, data = pcall(vim.json.decode, raw_json)
	-- if not ok or type(data) ~= "table" then
	-- 	-- print("Failed to decode JSON from GitHub API")
	-- 	return {}
	-- end

	local repo_info = {
		-- id = data.id,
    id = '1344400112',
		owner = org,
		name = repo_name,
		workspaceUri = "file://" .. workspace_path,
		organizationOwned = true,
	}
	return repo_info
end

M.get_gh_actions_init_options = function(org, workspace_path, session_token)
	org = org or "mapfre-tech"
	workspace_path = workspace_path or vim.fn.getcwd()
	session_token = session_token or os.getenv("GH_ACTIONS_PAT")

	if not session_token then
		return
	end

	local function get_repo_owner_and_name()
		local handle = io.popen("git remote get-url origin 2>/dev/null")
		if not handle then
			return vim.loop.cwd()
		end
		local result = handle:read("*a")
		handle:close()
		if not result or result == "" then
			return nil
		end
		-- Remove trailing newline
		result = result:gsub("%s+$", "")
		-- Extract repo name from URL
		-- local repo = result:match("([^/:]+)%.git$")
    local owner, repo = result:match("[/:]([%w%-_]+)/([%w%-_]+)%.git$")
    if owner and repo then
      return { owner = owner, repo = repo }
    end
    return nil
	end
	local repo = get_repo_owner_and_name()

	if not repo then
		return {
			sessionToken = session_token,
			repos = {},
		}
	end

	local repo_info = fetch_github_repo(repo.repo, session_token, repo.owner, workspace_path)
	return {
		sessionToken = session_token,
		repos = {
			repo_info,
		},
	}
end

return M
