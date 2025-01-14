-- local navbuddy = require("nvim-navbuddy")

local FeedKeys = function(keymap, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, false)
end

local M = {}

M.attach_lsp_config = function(client, bufnr)
  if string.match(vim.api.nvim_buf_get_name(bufnr), 'node_modules') then
    vim.lsp.stop_client(client.id)
  end

  -- navbuddy.attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap                                              -- for conciseness
  -- keymap.set("n", "gI", "<cmd>Lspsaga finder<CR>", opts)                  -- show definition, references
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)  -- got to declaration
  keymap.set("n", "<leader>gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)    -- see definition and make edits in window

  -- vim.keymap.set({ "n" }, "gd", function()
  --   require("telescope.builtin").lsp_definitions()
  --   -- vim.schedule(function()
  --   --   FeedKeys("zz", "n")
  --   --   -- vim.api.nvim_feedkeys("zz", "n", true)
  --   -- end)
  -- end, { noremap = true, silent = true })


  vim.keymap.set({"n"}, "gv", "<cmd>vsp | lua vim.lsp.buf.definition()<cr>", opts)

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

  keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

  -- keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
  keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.references({ context = { includeDeclaration = false } })<cr>", opts)
  keymap.set("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format({ async = true})<cr>", opts)
  keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- keymap.set("n", "<Leader>re", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  vim.keymap.set("n", "<leader>re", function()
    -- when rename opens the prompt, this autocommand will trigger
    -- it will "press" CTRL-F to enter the command-line window `:h cmdwin`
    -- in this window I can use normal mode keybindings
    local cmdId
    cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
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
  -- keymap.set("n", "<leader>ot", "<cmd>Lspsaga outline<CR>", opts)

  -- keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

  keymap.set("n", "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

  -- keymap("n", "<M-.>", "<cmd>Lspsaga code_action<CR>", opts)

  -- keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor

  keymap.set("n", "<leader>gk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts) -- jump to previous diagnostic in buffer
  keymap.set("n", "<leader>gj", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts) -- jump to previous diagnostic in buffer

  -- keymap.set("n", "<leader>gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  -- keymap.set("n", "<leader>gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  -- keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)                    -- show documentation for what is under cursor
  keymap.set({ "n" }, "gh", function()
    require("lsp_signature").toggle_float_win()
  end, opts)

  -- keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  -- keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)      -- show documentation for what is under cursor
  -- keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)              -- show documentation for what is under cursor
  -- keymap.set("n", "<leader>oo", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  -- version 10 of nvim
  -- if client.server_capabilities.inlayHintProvider then
  --   -- vim.lsp.buf.inlay_hint(bufnr, true)
  --   -- vim.lsp.inlay_hint.enable(bufnr, true)
  --   vim.lsp.inlay_hint.enable(true)
  -- end

  -- typescript specific keymaps (e.g. rename file and update imports)

  if client.name == "jdtls" then
    vim.keymap.set(
      "n",
      "<leader>oi",
      function ()
        require'jdtls'.organize_imports()
      end,
      { desc = "Organize Imports" }
    )

    keymap.set({ "n" }, "<leader>jr", function()
      require("java").runner.built_in.run_app({})
    end, opts)

    keymap.set({ "n" }, "<leader>js", function()
      require("java").runner.built_in.stop_app()
    end, opts)

    keymap.set({ "n" }, "<leader>jt", function()
      require("java").test.run_current_class()
    end, opts)

    keymap.set({ "n" }, "<leader>jd", function()
      require("java").test.debug_current_class()
    end, opts)

    keymap.set({ "n" }, "<leader>jo", function()
      require("java").test.view_last_report()
    end, opts)

    keymap.set({ "n" }, "<leader>jp", function()
      require("java").profile.ui()
    end, opts)

    keymap.set({ "n" }, "<leader>jR", function()
      require("java").settings.change_runtime()
    end, opts)
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

return M
