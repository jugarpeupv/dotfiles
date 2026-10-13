return {
	{
		"letieu/jira.nvim",
		cmd = { "Jira" },
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
		config = function()
			require("atlas").setup({
				providers = {
          github = {
            cache_ttl = 300
          },
					jira = {
						base_url = "https://mapfrealm.atlassian.net",
						email = os.getenv("JIRA_NVIM_USER") or "",
						--- See: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
						token = os.getenv("JIRA_NVIM_TOKEN_SCOPES") or "",
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
