return {
	{ "vim-scripts/ReplaceWithRegister", keys = { { "gr", mode = "n" }, { "gr", mode = "v" } } },
	{
		"gbprod/yanky.nvim",
		enabled = function()
			local is_headless = #vim.api.nvim_list_uis() == 0
			if is_headless then
				return false
			end
			return true
		end,
		dependencies = {
			{ "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local utils = require("yanky.utils")
			local mapping = require("yanky.telescope.mapping")
			require("yanky").setup({
				ring = {
					storage = "sqlite",
					history_length = 200,
				},
				highlight = {
					on_put = false,
					on_yank = false,
					timer = 500,
				},
				preserve_cursor_position = {
					enabled = false,
				},
				textobj = {
					enabled = true,
				},
				picker = {
					telescope = {
						mappings = {
							default = mapping.set_register(utils.get_default_register()),
							i = {
								["<c-p>"] = mapping.put("p"),
								-- ["<c-g>"] = mapping.put("P"),
								["<c-x>"] = mapping.delete(),
								["<c-k>"] = require("telescope.actions").move_selection_previous,
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(utils.get_default_register()),
							},
						},
					},
				},
			})
		end,
		keys = {
			{
				"<M-`>",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				mode = { "i", "x", "n", "c" },
				desc = "Open Yank History",
			},
      {
        "<leader>cL", -- dump vs <leader>cl (picker) - markdown with injections
        function()
          local history = require("yanky.history").all()
          if #history == 0 then
            vim.notify("yank history empty", vim.log.levels.INFO)
            return
          end
          vim.cmd("enew")
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
          vim.bo.buflisted = true
          vim.bo.swapfile = false
          vim.bo.filetype = "markdown"
          local lines = {}
          for i, item in ipairs(history) do
            local content = item.regcontents or ""
            local ft = item.filetype and vim.trim(item.filetype) or ""
            -- normalize ft: yanky stores empty or real ft, fallback to text
            if ft == "" then
              ft = "text"
            end
            local type_str = item.regtype == "V" and "[line]" or item.regtype == "\22" and "[block]" or "[char]"
            local header = string.format("# --- %03d %s ft=%s ---", i, type_str, ft)
            vim.list_extend(lines, { header, "", "```" .. ft })
            vim.list_extend(lines, vim.split(content, "\n", { plain = true }))
            vim.list_extend(lines, { "```", "" })
          end
          -- remove last blank
          if #lines > 0 and lines[#lines] == "" then
            table.remove(lines)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          vim.bo.modifiable = false
          vim.bo.modified = false
          -- ensure treesitter markdown + injections are active
          -- vim.treesitter.start()
          vim.cmd("normal! gg")
        end,
        mode = { "n", "x" },
        desc = "Dump Yank History to buffer",
      },
			{
				"<leader>cl",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
			{
				"y",
				"<Plug>(YankyYank)",
				mode = { "n", "x" },
				desc = "Yank text",
			},
			-- { "p", "<Plug>(YankyPutAfterFilter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
			-- { "P", "<Plug>(YankyPutBeforeFilter)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
			-- {
			--   "p",
			--   "<Plug>(YankyPutAfter)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text after cursor",
			-- },
			-- {
			--   "P",
			--   "<Plug>(YankyPutBefore)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text before cursor",
			-- },
			-- {
			--   "gp",
			--   "<Plug>(YankyGPutAfter)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text after selection",
			-- },
			-- {
			--   "gP",
			--   "<Plug>(YankyGPutBefore)",
			--   mode = { "n", "x" },
			--   desc = "Put yanked text before selection",
			-- },
			-- {
			--   "<C-p>",
			--   "<Plug>(YankyPreviousEntry)",
			--   desc = "Select previous entry through yank history",
			-- },
			-- {
			--   "<C-n>",
			--   "<Plug>(YankyNextEntry)",
			--   desc = "Select next entry through yank history",
			-- },
			-- {
			-- 	"]p",
			-- 	"<Plug>(YankyPutIndentAfterLinewise)",
			-- 	desc = "Put indented after cursor (linewise)",
			-- },
			-- {
			-- 	"[p",
			-- 	"<Plug>(YankyPutIndentBeforeLinewise)",
			-- 	desc = "Put indented before cursor (linewise)",
			-- },
			-- {
			-- 	"]P",
			-- 	"<Plug>(YankyPutIndentAfterLinewise)",
			-- 	desc = "Put indented after cursor (linewise)",
			-- },
			-- {
			-- 	"[P",
			-- 	"<Plug>(YankyPutIndentBeforeLinewise)",
			-- 	desc = "Put indented before cursor (linewise)",
			-- },
			-- { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
			-- { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
			-- { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
			-- { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
			-- { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
			-- { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
		},
	},
}
