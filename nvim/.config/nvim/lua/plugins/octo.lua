return {
  {
    "pwntester/octo.nvim",
    -- commit = "c96a03d2aa4688f45fb8d58e832fdd37d104f12d",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    keys = {
      {
        mode = { "n" },
        "<leader>os",
        "<cmd>Octo search assignee:GPJULI6_mapfre is:issue is:open<cr>",
        { noremap = true, silent = true },
      },
    },
    opts = {
      -- github_hostname = "github.com", -- Change to your own ghe host
      ssh_aliases = {
        ["github.com-mar"] = "github.com",
        ["github.com-work"] = "github.com",
        ["github.com-izertis"] = "github.com",
        ["github.com-personal"] = "github.com",
      }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
      mappings = {
        review_diff = {
          submit_review = { lhs = "<localleader>vs", desc = "submit review" },
          discard_review = { lhs = "<localleader>vd", desc = "discard review" },
          add_review_comment = { lhs = "<localleader>ca", desc = "add a new review comment", mode = { "n", "x" } },
          add_review_suggestion = { lhs = "<localleader>sa", desc = "add a new review suggestion", mode = { "n", "x" } },
          focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
          select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
        file_panel = {
          submit_review = { lhs = "<localleader>vs", desc = "submit review" },
          discard_review = { lhs = "<localleader>vd", desc = "discard review" },
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
          select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
        },
        review_thread = {
          goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<localleader>ca", desc = "add comment" },
          add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "<Tab>", desc = "move to next changed file" },
          select_prev_entry = { lhs = "<S-Tab>", desc = "move to previous changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
          resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
          unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
        },
      }
    },
    config = function(_, opts)
      require("octo").setup(opts)
      vim.cmd([[hi octo_mf_1e1e2f guifg=#1e1e2f]])
      vim.cmd([[hi octo_mb_d73a4a guifg=#ffffff guibg=#F38BA8]])
      vim.cmd([[hi octo_mf_d73a4a guifg=#F38BA8]])
      vim.cmd([[hi octo_mb_d19821 guifg=#000000 guibg=#F5E0DC]])
      vim.cmd([[hi octo_mf_d19821 guifg=#F5E0DC]])
      vim.cmd([[hi octo_mb_1d76db guifg=#ffffff guibg=#89ddff]])
      vim.cmd([[hi octo_mf_1d76db guifg=#89ddff]])
    end,
    -- config = function()
    --   require("octo").setup({
    --     -- github_hostname = "github.com", -- Change to your own ghe host
    --     ssh_aliases = {
    --       ["github.com-mar"] = "github.com",
    --       ["github.com-work"] = "github.com",
    --       ["github.com-izertis"] = "github.com",
    --       ["github.com-personal"] = "github.com",
    --     }, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
    --   })
    -- end,
  },
}
