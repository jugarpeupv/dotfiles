vim.g.vira_config_file_servers = vim.env.HOME .. "/.config/vira/vira_servers.json"
vim.g.vira_config_file_projects = vim.env.HOME .. "/.config/vira/vira_projects.json"
vim.g.vira_menu_height = 12
vim.g.vira_active_issue = "None"

return {
  {
    "n0v1c3/vira",
    build = "./install.sh",
    keys = {
      { "<leader>jb", ":ViraBrowse<cr>",    silent = true },
      { "<leader>jr", ":ViraReport<cr>",    silent = true },
      { "<leader>ji", ":ViraIssues<cr>",    silent = true },
      { "<leader>jc", ":ViraComment<cr>",    silent = true },
      { "<leader>js", ":ViraSetStatus<cr>", silent = true },
      {
        "<leader>ja",
        function()
          local current_branch = vim.fn.system("git branch --show-current")
          if current_branch == "" then
            print("No branch found")
            return
          end

          if current_branch:find("feature/") == 1 then
            current_branch = current_branch:gsub("feature/", ""):gsub("^", ""):gsub("\n", ""):gsub("@", "")
            vim.g.vira_active_issue = current_branch
            vim.cmd("ViraIssues")
            vim.cmd("ViraReport")
          end
        end,
      },
    },
  },
}