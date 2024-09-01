-- vim.filetype.add({
--   pattern = {
--     -- [".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
--     [".*%.component%.html"] = "html", -- Sets the filetype to `angular.html` if it matches the pattern
--   },
-- })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
	group = vim.api.nvim_create_augroup('set-angular-filetype', { clear = true }),
	pattern = '*.component.html',
	callback = function()
		-- Necessary for lsps to get attached.
		vim.cmd([[set filetype=html]])
		vim.cmd([[set filetype=myangular]])
	end,
})

vim.api.nvim_create_autocmd("FileType", {
  -- pattern = "angular.html",
  pattern = "myangular",
  callback = function()
    -- vim.treesitter.language.register("angular", "angular.html") -- Register the filetype with treesitter for the `angular` language/parser
    vim.treesitter.language.register("angular", "myangular") -- Register the filetype with treesitter for the `angular` language/parser
    vim.cmd([[set commentstring=<!--%s-->]])
    -- local luasnip_status, luasnip = pcall(require, "luasnip")
    -- if not luasnip_status then
    --   return
    -- end

    -- luasnip.filetype_extend("myangular", { "html" })
  end,
})
