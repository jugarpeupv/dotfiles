-- return {}
return {
	-- enabled = false,
	"andymass/vim-matchup",
	enabled = true,
  lazy = true,
	-- dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- event = { "VeryLazy" },
	-- event = { "BufReadPost", "BufNewFile" },
	-- keys = { { mode = "n", "%" } },
	config = function()
		vim.g.matchup_matchparen_enabled = 0
		vim.g.matchup_matchpref = {
			xml = { tagnameonly = 1 },
			svelte = { tagnameonly = 1 },
			vue = { tagnameonly = 1 },
			typescriptreact = { tagnameonly = 1 },
			tsx = { tagnameonly = 1 },
			html = { tagnameonly = 1 },
			htmlangular = { tagnameonly = 1 },
		}
		vim.g.matchup_delim_noskips = 2
		vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		vim.g.matchup_matchparen_end_sign = "󱐋"
		vim.g.matchup_treesitter_include_match_words = 1

    local match_parent_active = false

    vim.keymap.set("n", "%", function()
      if not match_parent_active then
        match_parent_active = true
        vim.cmd("DoMatchParen")
        match_parent_active = false
      end
      vim.api.nvim_feedkeys("%", "n", false)
    end, { noremap = true, silent = true })
		-- vim.cmd("NoMatchParen")
		-- vim.cmd("DoMatchParen")
	end,
}
