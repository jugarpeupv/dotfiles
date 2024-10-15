vim.g.vira_config_file_servers = vim.env.HOME .. "/.config/vira/vira_servers.json"
vim.g.vira_config_file_projects = vim.env.HOME .. "/.config/vira/vira_projects.json"

return {
  {
    "n0v1c3/vira",
    build = "./install.sh",
    keys = {
      { "<leader>jr", ":ViraReport<cr>", silent = true },
      { "<leader>ji", ":ViraIssues<cr>", silent = true },
      { "<leader>js", ":ViraSetStatus<cr>", silent = true },
    },
    config = function()
      vim.api.nvim_exec2(
        [[
        function! s:Vira_GitActiveIssue()
            let g:vira_active_issue = execute("Git branch --show-current > echo")
            ViraReport
        endfunction

        nnoremap <silent> <leader>vgi :call Vira_GitActiveIssue()<cr>
      ]],
        {}
      )
    end,
  },
}
