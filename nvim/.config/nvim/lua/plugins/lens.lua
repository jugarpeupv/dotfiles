-- return {}
return {
  {
    "haya14busa/vim-asterisk",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "n",  mode = "n" },
      { "*",  mode = "n" },
      { "#",  mode = "n" },
      { "g#", mode = "n" },
    },
    config = function()
      vim.api.nvim_set_keymap("n", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("n", "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("n", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("n", "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

      vim.api.nvim_set_keymap("x", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("x", "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("x", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap("x", "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n",  mode = "n" },
      { "*",  mode = "n" },
      { "#",  mode = "n" },
      { "g#", mode = "n" },
    },
    config = function()
      require("hlslens").setup({
        auto_enable = true,
        nearest_only = true,
        nearest_float_when = "never",
        calm_down = true,
      })

      local opts = { noremap = true, silent = true }
      -- Hlslens
      vim.api.nvim_set_keymap(
        "n",
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        opts
      )
      vim.api.nvim_set_keymap(
        "n",
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        opts
      )

      -- if Neovim is 0.8.0 before, remap yourself.
      local function nN(char)
        local ok, winid = require('hlslens').nNPeekWithUFO(char)
        if ok and winid then
          -- Safe to override buffer scope keymaps remapped by ufo,
          -- ufo will restore previous buffer keymaps before closing preview window
          -- Type <CR> will switch to preview window and fire `trace` action
          vim.keymap.set('n', '<CR>', function()
            return '<Tab><CR>'
          end, {buffer = true, remap = true, expr = true})
        end
      end

      vim.keymap.set({'n', 'x'}, 'n', function() nN('n') end)
      vim.keymap.set({'n', 'x'}, 'N', function() nN('N') end)
      -- vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
      -- vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
      -- vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
      -- vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
    end,
  },
}
