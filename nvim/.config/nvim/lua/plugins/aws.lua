return {
  {
    "jugarpeupv/aws.nvim",
    -- dev = true,
    -- dir = "~/projects/aws.nvim/",
    lazy = true,
    keys = {
      { "<leader>as", ":AwsS3 --profile mar-snd",            desc = "AWS S3" },
      { "<leader>ac", ":AwsCW --profile mar-snd",    desc = "AWS CloudWatch" },
      { "<leader>af", ":AwsCF --profile mar-snd", desc = "AWS CloudFormation" },
    },
    config = function ()
      require("aws").setup({
        -- Optional AWS CLI environment overrides.
        -- Authentication must already be handled by your environment.
        -- default_aws_profile = "mar-snd",   -- sets AWS_PROFILE for every CLI call
        -- default_aws_region  = "eu-west-1",   -- sets AWS_DEFAULT_REGION for every CLI call

        -- Status icons (requires a Nerd Font; replace with ASCII if needed)
        icons = {
          stack       = "󰆼 ",  -- stack / neutral
          complete    = "󰱑 ",  -- checkmark
          failed      = "󰱞 ",  -- cross / error
          in_progress = "󰔟 ",  -- spinning / clock
          deleted     = "󰩺 ",  -- trash
        },
      })
    end
  }
}
