-- return {}
return {
  {
    "cbochs/grapple.nvim",
    opts = {
      scope = "git", -- also try out "git_branch"
    },
    -- event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "Grapple", "Telescope" },
    keys = {
      { "<leader>hh", "<cmd>Telescope grapple tags<cr>" },
      { "<leader>hg", "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window" },
      { "<leader>ha", "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag" },
      { "<leader>S",  "<cmd>Grapple toggle_scopes<cr>",   desc = "Grappel toggle scopes" },
      { "<leader>N",  "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "<leader>P",  "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },

      { "<leader>1",  "<cmd>Grapple select index=1<cr>",  desc = "Select first tag" },
      { "<leader>2",  "<cmd>Grapple select index=2<cr>",  desc = "Select second tag" },
      { "<leader>3",  "<cmd>Grapple select index=3<cr>",  desc = "Select third tag" },
      { "<leader>4",  "<cmd>Grapple select index=4<cr>",  desc = "Select fourth tag" },
      { "<leader>5",  "<cmd>Grapple select index=5<cr>",  desc = "Select fifth tag" },
    },
    -- config = function()
    --   require("grapple").setup({
    --     scope = "worktree",
    --     scopes = {
    --       {
    --         name = "worktree",
    --         desc = "worktree scope",
    --         fallback = "git_branch",
    --         -- cache = {
    --         --   event = { "DirChanged" },
    --         -- },
    --         resolver = function()
    --           local wt_utils = require("jg.custom.worktree-utils")
    --           local wt_info = wt_utils.get_wt_info(vim.loop.cwd())
    --
    --           if next(wt_info) == nil then
    --             return
    --           end
    --           -- local root = vim.loop.cwd()
    --
    --           -- local result = vim.fn.system({ "git", "symbolic-ref", "--short", "HEAD" })
    --           -- local branch = vim.trim(string.gsub(result, "\n", ""))
    --           --
    --           -- local id = string.format("%s:%s", wt, branch)
    --           local id = wt_info.wt_root_dir
    --           local path = wt_info.wt_root_dir
    --
    --           return id, path
    --         end,
    --       },
    --     },
    --   })
    -- end,
  },
}
