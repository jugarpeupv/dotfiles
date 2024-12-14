-- return {}
return {
  {
    "akinsho/git-conflict.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    lazy = true,
    -- "CWood-sdf/git-conflict.nvim",
    -- version = "*",
    branch = "main",
    -- cmd = { "DiffviewOpen" },
    -- event = { "BufReadPost" },
    -- event = "User GitConflictDetected",

    config = function()
      require("git-conflict").setup({
        -- default_mappings = true,    -- disable buffer local mapping created by this plugin
        default_mappings = false,
        list_opener = "copen",
        debug = false,
        -- default_mappings = {
        --   ours = 'o',
        --   theirs = 't',
        --   none = '0',
        --   both = 'b',
        --   next = 'n',
        --   prev = 'p',
        -- },
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = {
          -- They must have background color, otherwise the default color will be used
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })

      vim.cmd([[hi GitConflictIncoming gui=none]])
      vim.cmd([[hi GitConflictCurrent gui=none]])

      local function map(bufnr)
        local function nvmap(lhs, rhs, desc)
          vim.keymap.set({ "n", "v" }, lhs, rhs, {
            buffer = bufnr,
            desc = "Git Conflict: " .. desc,
          })
        end

        nvmap("cj", "<Plug>(git-conflict-next-conflict)", "Next Conflict")
        nvmap("ck", "<Plug>(git-conflict-prev-conflict)", "Previous Conflict")
        nvmap("cc", "<Plug>(git-conflict-ours)", "Choose Ours")
        nvmap("ci", "<Plug>(git-conflict-theirs)", "Choose Theirs")
        nvmap("cb", "<Plug>(git-conflict-both)", "Choose Both")
        nvmap("cn", "<Plug>(git-conflict-none)", "Choose None")
        vim.b[bufnr].conflict_mappings_set = true
      end

      ---@param key string
      ---@param mode "'n'|'v'|'o'|'nv'|'nvo'"?
      ---@return boolean
      local function is_mapped(key, mode)
        return vim.fn.hasmapto(key, mode or "n") > 0
      end

      local function unmap(bufnr)
        if not bufnr or not vim.b[bufnr].conflict_mappings_set then
          return
        end
        if is_mapped("co") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "cj")
        end
        if is_mapped("cb") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "ck")
        end
        if is_mapped("c0") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "cc")
        end
        if is_mapped("ct") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "ci")
        end
        if is_mapped("n") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "cb")
        end
        if is_mapped("p") then
          vim.api.nvim_buf_del_keymap(bufnr, "n", "cn")
        end
        vim.b[bufnr].conflict_mappings_set = false
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        group = vim.api.nvim_create_augroup("GitConflictDetected", { clear = true }),
        callback = function()
          map(vim.api.nvim_get_current_buf())
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictResolved",
        group = vim.api.nvim_create_augroup("GitConflict", { clear = true }),
        callback = function()
          unmap(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
}
