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
    cmd = { "AtlasIssues", "AtlasPulls", "AtlasLogs", "AtlasJqlSearch" },
		config = function()
			require("atlas").setup({
				issues = {
					max_results = 100,
					fetch_parent_issues = true,
					custom_actions = {}, -- See Custom Actions below.

					providers = {
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

							---@type AtlasJiraViewConfig[]
							views = {
								{
									name = "My Board",
									key = "M",
									jql = "project = KAN AND assignee = currentUser() ORDER BY updated DESC",
								},
								{
									name = "Team Board",
									key = "T",
									jql = "project = KAN ORDER BY updated DESC",
								},
							},
						},
					},
				},
			})
		end,
	},
}
