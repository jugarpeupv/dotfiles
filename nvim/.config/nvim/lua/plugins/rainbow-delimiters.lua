-- return {}

return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local rainbow = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					-- Use global strategy by default
					-- [""] = rainbow.strategy["global"],
					[""] = function(bufnr)
						local line_number = 1
						local line = vim.fn.getline(line_number)
						local char_count = #line

						if char_count > 1000 then
							return nil
						end

						local line_count = vim.api.nvim_buf_line_count(bufnr)
						if line_count > 10000 then
							return nil
						elseif line_count > 2000 then
							-- return rainbow.strategy['local']
							return nil
						end

						return rainbow.strategy["global"]
					end,

					["html"] = function()
						return nil
					end,
					["htmlangular"] = function()
						return nil
					end,

					-- Use local for HTML
					-- Pick the strategy for LaTeX dynamically based on the buffer size
					["javascript"] = function()
						return nil
					end,

					["json"] = function(bufnr)
						-- Disabled for very large files, global strategy for large files,
						-- local strategy otherwise
						local line_count = vim.api.nvim_buf_line_count(bufnr)
						if line_count > 10000 then
							return nil
						elseif line_count > 1000 then
							-- return rainbow.strategy["local"]
              return nil
						end

            if line_count > 500 then
                return rainbow.strategy["local"]
            end

						return rainbow.strategy["global"]
						-- return nil
					end,
					["jsonc"] = function(bufnr)
						-- Disabled for very large files, global strategy for large files,
						-- local strategy otherwise
						local line_count = vim.api.nvim_buf_line_count(bufnr)
						if line_count > 10000 then
							return nil
						elseif line_count > 1000 then
							-- return rainbow.strategy["local"]
              return nil
						end

            if line_count > 500 then
                return rainbow.strategy["local"]
            end

						return rainbow.strategy["global"]
						-- return nil
					end,
					-- ["jsonc"] = function(bufnr)
					-- 	-- -- Disabled for very large files, global strategy for large files,
					-- 	-- -- local strategy otherwise
					-- 	local line_count = vim.api.nvim_buf_line_count(bufnr)
					--        print("line count", line_count)
					-- 	if line_count > 2000 then
					-- 		return nil
					-- 	elseif line_count > 1000 then
					-- 		return rainbow.strategy["local"]
					-- 	end
					--
					-- 	local line_number = 1
					-- 	local line = vim.fn.getline(line_number)
					-- 	local char_count = #line
					--
					-- 	if char_count > 1000 then
					-- 		return nil
					-- 	end
					--
					-- 	return rainbow.strategy["global"]
					-- 	-- return nil
					-- end,
				},
				-- query = {

				--   [""] = "rainbow-delimiters",
				--   lua = "rainbow-blocks",
				-- },
				-- priority = {
				--   [""] = 110,
				--   lua = 210,
				-- },
				highlight = {
					"TSRainbowRed",
					"TSRainbowYellow",
					"TSRainbowBlue",
					"TSRainbowOrange",
					"TSRainbowGreen",
					"TSRainbowViolet",
					"TSRainbowCyan",
				},
			}
		end,
	},
}
