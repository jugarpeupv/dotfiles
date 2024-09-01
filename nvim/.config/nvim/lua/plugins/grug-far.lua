-- return {}
return {
  keys = { { "<leader>fg", "<cmd>GrugFar<cr>" } },
  cmd = { "GrugFar" },
  "MagicDuck/grug-far.nvim",
  config = function()
    require("grug-far").setup({
      startInInsertMode = false
    })
  end,
}
