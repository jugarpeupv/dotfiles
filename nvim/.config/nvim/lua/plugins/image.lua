-- return {}
-- return {}
return {
  {
    "edluffy/hologram.nvim",
    enabled = false,
    config = function()
      require("hologram").setup({
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      })
    end,
  },
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 10001, -- this plugin needs to run before anything else
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },
  {
    "kjuq/sixelview.nvim",
    enabled = false,
    opts = {},
  },
  {
    "3rd/image.nvim",
    enabled = true,
    branch = "master",
    -- branch = "main",
    -- event = "VeryLazy",
    -- event = { "BufReadPost" },
    ft = { "png", "jpg", "jpeg", "gif", "webp", "md", "markdown", "vimwiki" },
    -- branch = "feat/toggle-rendering",
    config = function()
      local image = require("image")
      image.setup({
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
        },
        max_width = 2000,
        max_height = 2000,
        max_width_window_percentage = 80,
        max_height_window_percentage = 80,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        scale_factor = 3,                   -- scales the window size up or down
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        -- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened

        hijack_file_patterns = {}, -- render image files as images when opened
      })

      local image_rendered = false
      local my_image = nil

      vim.keymap.set({ "n", "v" }, "<leader>it", function()
        local api = require("image")
        local current_window = vim.api.nvim_get_current_win()
        local current_buffer = vim.api.nvim_get_current_buf()
        local cursor_pos = vim.api.nvim_win_get_cursor(current_window)
        local cursor_row = cursor_pos[1] - 1 -- 0-indexed row
        -- local cursor_col = cursor_pos[2]

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

        -- Get the file path under the cursor
        local line = vim.api.nvim_buf_get_lines(current_buffer, cursor_row, cursor_row + 1, false)[1]
        -- print("line", line)

        local file_path
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

        -- print("file_path", file_path)

        -- print("file_path", file_path)

        if image_rendered and my_image then
          my_image:clear() -- remove the image if it is already rendered
          image_rendered = false
          my_image = nil
        else
          if vim.fn.filereadable(file_path) == 0 then
            print("Image file does not exist: " .. file_path)
            return
          end
          -- from a file (absolute path)
          my_image = api.from_file(file_path, {
            id = "my_image_id",    -- optional, defaults to a random string
            window = current_window, -- binds image to the current window
            buffer = current_buffer, -- binds image to the current buffer
            with_virtual_padding = true, -- optional, pads vertically with extmarks, defaults to false
            inline = true,         -- binds image to an extmark which it follows
            -- geometry (optional)
            -- x = cursor_col,
            x = 0,
            y = cursor_row,
            -- width = 1000,
            -- height = 1000,
          })

          -- print("my_image", vim.inspect(my_image))

          if not my_image then
            return
          end

          my_image:render() -- render image
          image_rendered = true

          -- local map = vim.keymap.set
          -- map("n", "+", function()
          --   my_image.image_width = my_image.image_width * 1.25
          --   my_image.image_height = my_image.image_height * 1.25
          --   my_image:render()
          -- end, {
          --     buffer = current_buffer,
          --     desc = "Zoom in image",
          --   })
          --
          -- map("n", "_", function()
          --   my_image.image_width = my_image.image_width / 1.25
          --   my_image.image_height = my_image.image_height / 1.25
          --   my_image:render()
          -- end, {
          --     buffer = current_buffer,
          --     desc = "Zoom out image",
          --   })
        end
      end, {})
    end,
  },
}
