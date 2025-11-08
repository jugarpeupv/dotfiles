return {
	"folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
	opts = {
		-- add any options here
    nes = {
      enabled = false,
    },
		cli = {
      tools = {
        copilot = { cmd = { "copilot", "--allow-all-tools" } }
      },
			mux = {
				backend = "tmux",
				enabled = false,
			}
		},
	},
	keys = {
		-- {
		-- 	"<tab>",
		-- 	function()
		-- 		-- if there is a next edit, jump to it, otherwise apply it if any
		-- 		if not require("sidekick").nes_jump_or_apply() then
		-- 			return "<Tab>" -- fallback to normal tab
		-- 		end
		-- 	end,
		-- 	expr = true,
		-- 	desc = "Goto/Apply Next Edit Suggestion",
		-- },
    -- {
    --   "<tab>",
    --   function()
    --     -- if there is a next edit, jump to it, otherwise apply it if any
    --     if require("sidekick.nes").apply() then
    --       return -- jumped or applied
    --     end
    --
    --     -- if you are using Neovim's native inline completions
    --     -- if vim.lsp.inline_completion.get() then
    --     --   return
    --     -- end
    --
    --     -- any other things (like snippets) you want to do on <tab> go here.
    --
    --     -- fall back to normal tab
    --     return "<tab>"
    --   end,
    --   mode = { "i", "n" },
    --   expr = true,
    --   desc = "Goto/Apply Next Edit Suggestion",
    -- },
		{
			"<c-.>",
			function()
				require("sidekick.cli").toggle({ name = "copilot", focus = true })
			end,
			desc = "Sidekick Toggle",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}", name = "copilot" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
