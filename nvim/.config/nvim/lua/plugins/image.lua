-- return {}
-- return {}
return {
  -- {
  --   "adelarsq/image_preview.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("image_preview").setup({})
  --   end,
  -- },
  {
    "kjuq/sixelview.nvim",
    enabled = false,
    opts = {},
  },
  {
    "3rd/image.nvim",
    -- rocks = { "magick" },
    enabled = true,
    rocks = { hererocks = true },
    -- branch = "feature/only_render_image_at_cursor_mode",
    -- branch = "main",
    -- event = "VeryLazy",
    ft = { "png", "jpg", "jpeg", "gif", "webp", "md", "markdown", "vimwiki" },
    -- branch = "feat/toggle-rendering",
    config = function()
      require("image").setup({
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
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true,                                  -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,                              -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true,                               -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened

        -- hijack_file_patterns = {}, -- render image files as images when opened
      })

      local image = require("image")
      vim.keymap.set({ "n", "v" }, "<leader>it", function()
        if image.is_enabled() then
          image.disable()
        else
          image.enable()
        end
      end, {})
    end,
  },
}
