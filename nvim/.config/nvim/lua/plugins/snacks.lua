return {
	"folke/snacks.nvim",
	enabled = true,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- input = {},
		-- indent = {
		--   animate = {
		--     enabled = false
		--   }
		-- },
		layout = {},
		bigfile = {
			notify = false, -- show notification when big file detected
			size = 0.7 * 1024 * 1024, -- 1.5MB
			line_length = 1000, -- average line length (useful for minified files)
			-- Enable or disable features when big file detected
			---@param ctx {buf: number, ft:string}
			setup = function(ctx)
        vim.b.matchparen_enabled = false
        vim.treesitter.stop(ctx.buf)

        vim.b.matchup_matchparen_enabled = 0
        vim.b.matchup_matchparen_fallback = 0

				-- Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0, number = false, relativenumber = false })
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0, relativenumber = false, number = false })
				vim.b.minianimate_disable = true
				vim.b.minihipatterns_disable = true
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
		picker = {
			ui_select = true,
			layout = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.4,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "none" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", width = 0.35, border = "left" },
          },
        },
			},

			-- layout = {
			-- 	preset = "ivy",
			-- 	preview = "main",
			-- 	layout = {
			-- 		box = "vertical",
			-- 		backdrop = false,
			-- 		width = 0,
			-- 		height = 0.4,
			-- 		position = "bottom",
			-- 		border = "top",
			-- 		title = " {title} {live} {flags}",
			-- 		title_pos = "left",
			-- 		{ win = "input", height = 1, border = "bottom" },
			-- 		{
			-- 			box = "horizontal",
			-- 			{ win = "list", border = "none" },
			-- 			{ win = "preview", title = "{preview}", width = 0.6, border = "left" },
			-- 		},
			-- 	},
			-- },
		},
		explorer = { enabled = false },
	},
	keys = {
		-- Top Pickers & Explorer
		{ mode = { "n", "v" }, "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { silent = true } },
    {
      "<leader><space>",
      function()
        Snacks.picker.resume({
          -- layout = {
          -- 	preset = "ivy_split",
          -- },
        })
      end,
      desc = "Smart Find Files",
    },
		-- {
		-- 	"<leader><space>",
		-- 	function()
		-- 		Snacks.picker.smart({
		-- 			-- layout = {
		-- 			-- 	preset = "ivy_split",
		-- 			-- },
		-- 		})
		-- 	end,
		-- 	desc = "Smart Find Files",
		-- },
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep({
          layout = {
            preview = false
          }
				})
			end,
			desc = "Grep",
		},
		-- -- find
		-- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		-- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		-- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		-- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		-- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		-- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- -- git
		-- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
		-- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
		-- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
		-- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
		-- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
		-- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		-- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		-- -- Grep
		-- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		-- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{
			"<leader>sg",
			function()
				---@diagnostic disable-next-line: undefined-global
				Snacks.picker.grep({ preview = false })
			end,
			desc = "Grep",
		},
		-- {
		-- 	"<leader>sw",
		-- 	function()
		-- 		---@diagnostic disable-next-line: undefined-global
		-- 		Snacks.picker.grep_word()
		-- 	end,
		-- 	desc = "Visual selection or word",
		-- 	mode = { "n", "x" },
		-- },
		-- search
	},
}
