-- return {}

return {
	{
		"saghen/blink.pairs",
    enabled = false,
		version = "*", -- (recommended) only required with prebuilt binaries
		-- event = "BufReadPre",

		-- download prebuilt binaries from github releases
		dependencies = "saghen/blink.download",
		-- OR build from source, requires nightly:
		-- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable()
				-- and require("blink.pairs.mappings").disable()
				-- to enable/disable mappings at runtime
				enabled = true,
				cmdline = true,
				-- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
				-- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
				disabled_filetypes = {},
				-- see the defaults:
				-- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
				pairs = {},
			},
			highlights = {
				enabled = true,
				-- requires require('vim._extui').enable({}), otherwise has no effect
				cmdline = true,
				-- groups = {
				-- 	"BlinkPairsRed",
				-- 	"BlinkPairsYellow",
				-- 	"BlinkPairsBlue",
				-- 	"BlinkPairsOrange",
				-- 	"BlinkPairsGreen",
				-- 	"BlinkPairsPurple",
				-- 	"BlinkPairsCyan",
				-- },
				groups = {
					-- "BlinkPairsOrange",
					-- "BlinkPairsPurple",
					-- "BlinkPairsBlue",
				      "TSRainbowBlue",
				      "TSRainbowOrange",
				      "TSRainbowGreen",
				},
				unmatched_group = "BlinkPairsUnmatched",

				-- highlights matching pairs under the cursor
				matchparen = {
					enabled = true,
					-- known issue where typing won't update matchparen highlight, disabled by default
					cmdline = false,
					-- also include pairs not on top of the cursor, but surrounding the cursor
					include_surrounding = false,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
			debug = false,
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		-- event = { "BufReadPost", "BufNewFile" },
    event = { "VeryLazy" },
		enabled = true,
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
          ["editorconfig"] = function()
            return nil
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
