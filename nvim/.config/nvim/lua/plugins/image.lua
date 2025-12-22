vim.g.image_rendered = false

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
	{
		"3rd/image.nvim",
		enabled = true,
		-- commit = "21909e3eb03bc738cce497f45602bf157b396672",
		branch = "master",
		-- branch = "main",
		-- event = "VeryLazy",
		-- event = { "BufReadPost" },
		-- ft = { "png", "jpg", "jpeg", "gif", "webp", "md", "markdown", "vimwiki" },
    ft = { "png", "jpg", "jpeg", "gif", "webp", "md", "vimwiki" },
		keys = {
			{
				mode = { "n", "v" },
				"<leader>it",
				function()
					local function get_full_path(path)
						-- Get the user's home directory
						local home_dir = os.getenv("HOME")

						-- Check if the path starts with the home directory
						if string.sub(path, 1, #home_dir) == home_dir then
							return path
						end

						-- Get the current buffer's full path
						local current_buffer_dos = vim.api.nvim_buf_get_name(0)
						-- Get the directory of the current buffer
						local current_dir = vim.fn.fnamemodify(current_buffer_dos, ":p:h")
						-- Combine the directory with the relative path
						local full_path = vim.fn.fnamemodify(current_dir .. "/" .. path, ":p")

						if vim.fn.filereadable(full_path) == 1 then
							return full_path
						else
							full_path = vim.fn.fnamemodify(vim.loop.cwd() .. "/" .. path, ":p")
						end

						return full_path
					end

					local image_util = require("jg.custom.image-utils")
					if image_util.image_rendered and image_util.loaded_image_under_cursor then
						-- vim.g.image_object:clear() -- remove the image if it is already rendered
						image_util.loaded_image_under_cursor:clear() -- remove the image if it is already rendered
						image_util.image_rendered = false
						-- vim.g.image_object = nil
						image_util.loaded_image_under_cursor = nil
						return
					end

					local current_window = vim.api.nvim_get_current_win()
					local current_buffer = vim.api.nvim_get_current_buf()
					local cursor_pos = vim.api.nvim_win_get_cursor(current_window)
					local cursor_row = cursor_pos[1] - 1 -- 0-indexed row
					-- local cursor_col = cursor_pos[2]

					-- Get the file path under the cursor
					local line = vim.api.nvim_buf_get_lines(current_buffer, cursor_row, cursor_row + 1, false)[1]
					-- print("line", line)

					local file_path

					local toggle_image_under_cursor = function(file_path_cb)
						image_util.toggle_image_under_cursor(file_path_cb, current_window, current_buffer, cursor_row)
					end

					-- -- Try to extract <img src="...">
					local url = line:match('<img%s+[^>]*src="([^"]+)"')
					if url and url:match("^https?://") then
						image_util.get_github_attachment_image(url, toggle_image_under_cursor)
					else
						-- Fallback to your existing logic
						local extracted_content = string.match(line, "%[%[(.-)%]%]")
						-- print("extracted_content", extracted_content)

						if extracted_content then
							file_path = extracted_content.gsub(extracted_content, "|.*", "")
							file_path = vim.loop.cwd() .. "/zadjuntos/" .. file_path
						else
							file_path = line:match("%((.-)%)")
							if not file_path then
								print("No image found under the cursor")
								return
							end
							file_path = get_full_path(file_path)
						end

						toggle_image_under_cursor(file_path)
					end
				end,
			},
			{
				mode = { "n", "v" },
				"<leader>pI",
				function()
					local Job = require("plenary.job")
					Job:new({
						command = "bun",
						args = { "upload.ts" },
						cwd = "/Users/jgarcia/work/tmp/cookies-test",
						on_exit = function(j, return_val)
							if return_val == 0 then
								local href = table.concat(j:result(), "\n"):gsub("%s+$", "")
								vim.schedule(function()
									local img_tag = string.format('<img src="%s">', href)
									vim.api.nvim_put({ img_tag }, "c", true, true)
								end)
							else
								vim.schedule(function()
									vim.notify("❌ Upload failed: " .. table.concat(j:stderr_result(), "\n"))
								end)
							end
						end,
					}):start()
				end,
			},
		},
		-- branch = "feat/toggle-rendering",
		config = function()
			local image = require("image")
			image.setup({
        disable = { 'markdown' },
				backend = "kitty",
				integrations = {
					markdown = {
						enabled = false,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = true,
						-- only_render_image_at_cursor_mode = "inline",
						floating_windows = true,
						filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
						resolve_image_path = function(document_path, image_path, fallback)
							if image_path:match("^<") then
								-- Remove < and > characters
								image_path = string.gsub(image_path, "[<>]", "")

								-- Substitute white space with %20
								image_path = string.gsub(image_path, " ", "%%20")
							end

							-- print("image_path_before", image_path)
							image_path = image_path.gsub(image_path, "|.*", "")
							-- print("image_path_after", image_path)
							local cwd = vim.loop.cwd()
							local image_cwd_path = cwd .. "/" .. image_path
							if vim.fn.filereadable(image_cwd_path) == 1 then
								return image_cwd_path
							end

							local adjuntos_path = cwd .. "/zadjuntos/" .. image_path
							if image_path:match("^Pasted") then
								return adjuntos_path
							end
							local fallback_path = fallback(document_path, image_path)

							-- you can call the fallback function to get the default behavior
							return fallback_path
						end,
					},
					neorg = {
						enabled = false,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "norg" },
					},
					-- syslang = {
					-- 	enabled = true,
					-- },
					-- html = {
					-- 	enabled = true,
					-- },
					-- css = {
					-- 	enabled = true,
					-- },
				},
				max_width = 2000,
				max_height = 2000,
				max_width_window_percentage = 80,
				max_height_window_percentage = 80,
				window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
				scale_factor = 3, -- scales the window size up or down
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
				editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
				tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
				-- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened

				hijack_file_patterns = {}, -- render image files as images when opened
			})
		end,
	},
  {
    "edluffy/hologram.nvim",
    enabled = false,
    config = function()
      require("hologram").setup({
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      })
    end,
  },
  {
    "kjuq/sixelview.nvim",
    enabled = false,
    opts = {},
  },
}
