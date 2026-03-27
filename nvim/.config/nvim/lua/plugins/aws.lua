-- Session state: persists region/profile for the lifetime of this Neovim session.
-- Seeded with sane defaults; updated every time the user submits an Aws* command.
local aws_state = {
	region = "eu-west-1",
	profile = "mar-snd",
}

-- Extract --region / --profile values from a raw command-line string.
local function parse_aws_cmdline(cmdline)
	local region = cmdline:match("%-%-region%s+(%S+)")
	local profile = cmdline:match("%-%-profile%s+(%S+)")
	return region, profile
end

-- Open the command line pre-populated with the current session state.
-- Whatever the user edits and submits is captured by the autocmd below.
local function open_aws_cmd(base_cmd)
	local line = base_cmd .. " --region " .. aws_state.region .. " --profile " .. aws_state.profile
	-- feedkeys puts us in command-line mode with the text ready to edit
	vim.api.nvim_feedkeys(":" .. line, "n", false)
end

-- One-shot CmdlineLeave autocmd that saves whatever region/profile the
-- user actually submitted back into aws_state for the next invocation.
local aws_cmds = { "AwsS3", "AwsCW", "AwsCF", "AwsLambda", "AwsSM", "AwsCFront", "AwsAGW", "AwsPicker" }
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("AwsStateCapture", { clear = true }),
	callback = function()
		local cmdline = vim.fn.getcmdline()
		-- Only process Aws* commands
		local is_aws = false
		for _, cmd in ipairs(aws_cmds) do
			if cmdline:match("^" .. cmd) then
				is_aws = true
				break
			end
		end
		if not is_aws then
			return
		end

		local region, profile = parse_aws_cmdline(cmdline)
		if region then
			aws_state.region = region
		end
		if profile then
			aws_state.profile = profile
		end
	end,
})

return {
	{
		"jugarpeupv/aws.nvim",
    dependencies = {
      "folke/snacks.nvim"
    },
		dev = true,
		dir = "~/projects/aws.nvim/",
		lazy = true,
		keys = {
			{
				mode = { "n" },
				"<leader>ap",
				function()
					open_aws_cmd("AwsPicker")
				end,
				{ desc = "AWS S3" },
			},
			{
				mode = { "n" },
				"<leader>as",
				function()
					open_aws_cmd("AwsS3")
				end,
				{ desc = "AWS S3" },
			},
			{
				mode = { "n" },
				"<leader>ac",
				function()
					open_aws_cmd("AwsCW")
				end,
				{ desc = "AWS CloudWatch" },
			},
			{
				mode = { "n" },
				"<leader>af",
				function()
					open_aws_cmd("AwsCF")
				end,
				{ desc = "AWS CloudFormation" },
			},
			{
				mode = { "n" },
				"<leader>al",
				function()
					open_aws_cmd("AwsLambda")
				end,
				{ desc = "AWS Lambda" },
			},
			{
				mode = { "n" },
				"<leader>am",
				function()
					open_aws_cmd("AwsACM")
				end,
				{ desc = "AWS acm" },
			},
			{
				mode = { "n" },
				"<leader>ae",
				function()
					open_aws_cmd("AwsSM")
				end,
				{ desc = "AWS Secrets Manager" },
			},
			{
				mode = { "n" },
				"<leader>at",
				function()
					open_aws_cmd("AwsCFront")
				end,
				{ desc = "AWS CloudFront" },
			},
			{
				mode = { "n" },
				"<leader>ag",
				function()
					open_aws_cmd("AwsAGW")
				end,
				{ desc = "AWS API Gateway" },
			},
		},
		config = function()
			require("aws").setup({
				-- Status icons (requires a Nerd Font; replace with ASCII if needed)
				icons = {
					stack = "󰆼 ", -- stack / neutral
					complete = "󰱑 ", -- checkmark
					failed = "󰱞 ", -- cross / error
					in_progress = "󰔟 ", -- spinning / clock
					deleted = "󰩺 ", -- trash
				},
			})
		end,
	},
}
