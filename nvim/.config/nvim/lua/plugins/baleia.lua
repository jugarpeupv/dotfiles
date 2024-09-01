return {
  {
    "m00qek/baleia.nvim",
    event = { "BufReadPost", "BufNewFile" },
    tag = "v1.3.0",
    config = function()
      local baleia = require("baleia").setup({})

      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*-tmux-logs",
        callback = function()
          baleia.once(vim.fn.bufnr(vim.fn.expand("%")))
        end,
      })

      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "TelescopePreviewerLoaded",
      --   callback = function(args)
      --     print(vim.inspect(args))
      --     if args.buf ~= nil then
      --       baleia.once(vim.fn.bufnr(args.buf))
      --     end
      --     -- if args.data.filetype ~= "help" then
      --     --   vim.wo.number = true
      --     -- elseif args.data.bufname:match("*.csv") then
      --     --   vim.wo.wrap = false
      --     -- end
      --   end,
      -- })
    end,
  },
}
