local M = {}

M.attach_lsp_config = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap                                               -- for conciseness
  keymap.set("n", "gI", "<cmd>Lspsaga finder<CR>", opts)                  -- show definition, references
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)   -- got to declaration
  keymap.set("n", "<leader>gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)    -- see definition and make edits in window
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

  keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
  keymap.set("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format({ async = true})<cr>", opts)
  keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- keymap.set("n", "<Leader>re", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  keymap.set("n", "<Leader>re", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  keymap.set("n", "<leader>ot", "<cmd>Lspsaga outline<CR>", opts)

  -- keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "gL", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

  keymap.set("n", "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

  -- keymap("n", "<M-.>", "<cmd>Lspsaga code_action<CR>", opts)

  -- keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "<leader>gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  keymap.set("n", "<leader>gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  -- keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)                    -- show documentation for what is under cursor
  keymap.set({ "n" }, "gh", function()
    require("lsp_signature").toggle_float_win()
  end, opts)

  -- keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  -- keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)      -- show documentation for what is under cursor
  -- keymap.set("n", "gH", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)              -- show documentation for what is under cursor
  keymap.set("n", "<leader>oo", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  -- version 10 of nvim
  -- if client.server_capabilities.inlayHintProvider then
  --   -- vim.lsp.buf.inlay_hint(bufnr, true)
  --   -- vim.lsp.inlay_hint.enable(bufnr, true)
  --   vim.lsp.inlay_hint.enable(true)
  -- end

  -- typescript specific keymaps (e.g. rename file and update imports)

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
