return {
	{
		"philosofonusus/ecolog.nvim",
		enabled = false,
		branch = "beta",
		lazy = true,
		-- commit = "d92107c88febabc2f51190339cabf0bc5e072bd9",
		-- dependencies = {
		--   -- "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
		--   "nvim-tree/nvim-tree.lua"
		-- },
		event = { "BufReadPost", "BufNewFile" },
		-- Optional: you can add some keybindings
		-- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
		keys = {
			{ "<leader>eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
			{ "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
			{ "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
			{ "<leader>el", "<cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Shelter Line Peek" },
			{ "<leader>et", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog Shelter Line Peek" },
		},
		opts = {
			integrations = {
				-- WARNING: for both cmp integrations see readme section below
				files = true,
				nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
				-- If you are planning to use blink cmp uncomment this line
				-- blink_cmp = true,
			},
			-- Enables shelter mode for sensitive values
			shelter = {
				configuration = {
					partial_mode = false,
					skip_comments = false,
				},
				modules = {
					cmp = true, -- Mask values in completion
					peek = true, -- Mask values in peek view
					telescope = true, -- Mask values in telescope
					telescope_previewer = true, -- Mask values in telescope preview buffers
					files = {
						shelter_on_leave = false, -- Control automatic re-enabling of shelter when leaving buffer
						disable_cmp = true, -- Disable completion in sheltered buffers (default: true)
					},
				},
			},
			-- true by default, enables built-in types (database_url, url, etc.)
			types = true,
			path = vim.fn.getcwd(), -- Path to search for .env files
			preferred_environment = "development", -- Optional: prioritize specific env files
			env_file_patterns = {
				"*.env*",
				-- "*env*",
				".env",
				".env.*",
				"config/env.*",
				".env.local.*",
				"config/.env", -- Matches .env file in config directory
				"config/.env.*", -- Matches any .env.* file in config directory
				"environments/*",
				-- "*.zshrc",
				-- ".config/zshrc/*.zshrc",
				-- "/Users/jgarcia/.config/zshrc/.zshrc",
				-- ".config/zshrc/.zshrc",
				".config/zshrc/.env.*",
				os.getenv("HOME") .. "/dotfiles/zshrc/.config/zshrc/.env",
				os.getenv("HOME") .. "/.config/zshrc/.env",
			},
			-- env_file_pattern = {
			--   ".env",
			--   "^%.env%.%w+$",    -- Matches .env.development, .env.production, etc.
			--   "^config/env%.%w+$", -- Matches config/env.development, config/env.production, etc.
			--   "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
			--   ".+%.zsh$",
			--   ".+%.zshrc$",
			--   "^.config/zshrc/.+%.zshrc$",
			--   "/Users/jgarcia/.config/zshrc/.zshrc",
			--   "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
			--   "^.config/zshrc/^%.env%.%w+$", -- Matches config/env.development, config/env.production, etc.
			-- },
			-- Controls how environment variables are extracted from code and how cmp works
			provider_patterns = true, -- true by default, when false will not check provider patterns
		},

		-- opts = {
		--   integrations = {
		--     lsp = false,
		--     fzf = true,
		--   },
		--   -- Enables shelter mode for sensitive values
		--   shelter = {
		--     configuration = {
		--       partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
		--       mask_char = "*", -- Character used for masking
		--       -- patterns = {
		--       --   ["*_KEY"] = "full", -- Always fully mask API keys
		--       --   ["*_TOKEN"] = "full", -- Always fully mask API keys
		--       --   ["*_PAT"] = "full", -- Always fully mask API keys
		--       --   ["*_KEY_*"] = "full", -- Always fully mask API keys
		--       -- },
		--     },
		--     modules = {
		--       cmp = true,  -- Mask values in completion
		--       peek = false, -- Mask values in peek view
		--       files = true, -- Mask values in files
		--       telescope = true, -- Mask values in telescope
		--     },
		--   },
		--   -- true by default, enables built-in types (database_url, url, etc.)
		--   types = true,
		--   path = vim.fn.getcwd(), -- Path to search for .env files
		--   env_file_pattern = {
		--     "^%.env%.%w+$",       -- Matches .env.development, .env.production, etc.
		--     "^config/env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
		--     "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
		--     ".+%.zsh$",
		--     ".+%.zshrc$",
		--     "^.config/zshrc/.+%.zshrc$",
		--     "/Users/jgarcia/.config/zshrc/.zshrc",
		--     "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
		--     "^.config/zshrc/^%.env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
		--   },
		--   preferred_environment = "development", -- Optional: prioritize specific env files
		-- },
	},
}
