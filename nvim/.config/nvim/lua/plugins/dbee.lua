-- For now, I'm going to stick with dadbod,
-- but if the completion continues to improve I will probably switch
return {
  {
    "kndndrj/nvim-dbee",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = { "<leader>od" },
    build = function()
      require("dbee").install()
    end,
    config = function()
      local source = require("dbee.sources")
      require("dbee").setup({
        sources = {
          -- source.MemorySource:new({
          --   -- ---@diagnostic disable-next-line: missing-fields
          --   {
          --     type = "mysql",
          --     name = "mysql-dev",
          --     -- url = "mysql://auth_user:auth_pass@127.0.0.1:3306/auth",
          --     url = "auth_user:auth_pass@tcp(127.0.0.1:3306)/auth"
          --   },
          -- }),
          source.MemorySource:new({
            -- ---@diagnostic disable-next-line: missing-fields
            {
              type = "mongo",
              name = "mongo-dev",
              -- url = "mysql://root@127.0.0.1:3306/auth",
              url = "@tcp(127.0.0.1:27017)/videos",
            },
          }),
        },
      })
      -- require "custom.dbee"

      vim.keymap.set("n", "<leader>od", function()
        require("dbee").toggle()
      end)

      ---@diagnostic disable-next-line: param-type-mismatch
      local base = vim.fs.joinpath(vim.fn.stdpath("state"), "dbee", "notes")
      local pattern = string.format("%s/.*", base)
      vim.filetype.add({
        extension = {
          sql = function(path, _)
            if path:match(pattern) then
              return "sql.dbee"
            end

            return "sql"
          end,
        },

        pattern = {
          [pattern] = "sql.dbee",
        },
      })
    end,
  },
}
