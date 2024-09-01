return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- event = "VeryLazy",
    -- dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        auto_close = false,  -- auto close when there are no items
        auto_open = false,   -- auto open when there are items
        auto_preview = false, -- automatically open preview when on an item
        auto_refresh = true, -- auto refresh when open
        auto_jump = false,   -- auto jump to the item when there's only one
        focus = false,       -- Focus the window when opened
        restore = true,      -- restores the last location in the list when opening
        follow = true,       -- Follow the current item
        indent_guides = true, -- show indent guides
        max_items = 200,     -- limit number of items that can be displayed per section
        multiline = false,   -- render multi-line messages
        pinned = false,      -- When pinned, the opened trouble window will be bound to the current buffer
        warn_no_results = true, -- show a warning when there are no results
        open_no_results = false, -- open the trouble window when there are no results
        ---@type trouble.Window.opts
        win = {
          size = 60,     -- width of the list window
          position = "right", -- position of the list can be: bottom, top, left, right
        },               -- window options for the results window. Can be a split or a floating window.
      })
    end,
  },
}
