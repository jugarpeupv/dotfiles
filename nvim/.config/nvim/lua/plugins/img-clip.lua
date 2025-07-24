return {
	{
		"HakonHarnes/img-clip.nvim",
		-- keys = { "<leader>pi" },
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
			},
			default = {
				verbose = false,
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = {
					insert_mode = true,
				},
				-- required for Windows users
				use_absolute_path = true,
				show_dir_path_in_prompt = true,
				dir_path = function()
					-- return "assets/imgs" .. vim.fn.expand("%:t:r")
					return "assets/imgs"
				end,
			},
			-- filetypes = {
			--   markdown = {
			--     -- relative_to_current_file = true,
			--   },
			-- },
			-- add options here
			-- or leave it empty to use the default settings
		},
		keys = {
			-- suggested keymap
			-- { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
			{
				"<leader>pi",
				function()
					require("img-clip").paste_image({ use_absolute_path = false })
				end,
				desc = "Paste image from system clipboard",
			},
		},
	},
}
