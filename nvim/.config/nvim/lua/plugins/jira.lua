return {
	{
		"letieu/jira.nvim",
		cmd = { "Jira" },
    enabled = false,
		opts = {
			-- Your setup options...
			jira = {
				limit = 200, -- Global limit of tasks per view (default: 200)
			},
		},
	},
	{
		"emrearmagan/atlas.nvim",
		cmd = { "Atlas", "AtlasIssues", "AtlasPulls", "AtlasLogs", "AtlasJqlSearch" },
		init = function()
			require("jg.custom.jira-proxy").setup()
		end,
		config = function()
			require("jg.custom.jira-proxy").ensure()
			require("atlas").setup({
        ui = {
          -- "auto", "default", "snacks", or "fzf-lua".
          picker = "default",
          -- Make the main Atlas dashboard a listed buffer.
          listed_buffer = true,
        },
				providers = {
          github = {
            cache_ttl = 300
          },
					jira = {
						-- base_url = "https://mapfrealm.atlassian.net",
						--       base_url = "https://mapfrealm.atlassian.net",
						-- email = os.getenv("JIRA_NVIM_USER") or "",
						-- --- See: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
						-- token = os.getenv("JIRA_NVIM_TOKEN_SCOPES") or "",
            base_url = "http://127.0.0.1:8787",
            auth_method = "bearer",
            api_type = "cloud",
            token = os.getenv("JIRA_PROXY_TOKEN") or "local",
						cache_ttl = 300,

						project_config = {
							-- The Jira custom field ID used for story points. Defaults to "customfield_10016".
							story_points_field = "customfield_10016",

							KAN = {
								customfield_10003 = {
									name = "Approvers",
									format = function(value)
										if type(value) ~= "table" or #value == 0 then
											return nil -- nil hides the field
										end
										return table.concat(value, ", ")
									end,
									hl_group = "AtlasChipActive",
									display = "chip", -- "chip" or "table"
								},
							},
						},
					},
				},
				issues = {
          jira = {
            views = {
              { name = "Me", key = "1", search = "assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC" },
              { name = "Project", key = "2", search = "project = PTIZ AND statusCategory != Done ORDER BY updated DESC" },
            },
          },
					---@type AtlasGitHubIssuesConfig
					github = {
						---@type AtlasGitHubIssuesViewConfig[]
						views = {
							{
								name = "Assigned",
								key = "1",
								layout = "plain",
								-- current_repo = true, -- Limit this view to the local repository.
								search = "assignee:@me is:open",
							},
							{
								name = "Created",
								key = "2",
								layout = "compact",
								search = "author:@me is:open",
							},
							{
								name = "Mentions",
								key = "3",
								layout = "plain",
								search = "mentions:@me is:open",
							},
						},

						bookmarks = {
							key = "S", -- default
							label = "Search", -- default
							items = {
								["Bugs"] = "is:issue is:open label:bug",
								["Recently closed"] = "is:issue is:closed author:@me sort:updated-desc",
							},
						},
					},
				},
			})
		end,
	},
}
