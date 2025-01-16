-- vim.filetype.add({
--   pattern = {
--     -- [".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
--     [".*%.component%.html"] = "html", -- Sets the filetype to `angular.html` if it matches the pattern
--   },
-- })

vim.filetype.add({
  pattern = {
    [".*%.component%.html"] = "myangular", -- Sets the filetype to `htmlangular` if it matches the pattern
  },
})

-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
-- 	group = vim.api.nvim_create_augroup('set-angular-filetype', { clear = true }),
-- 	pattern = '*.component.html',
-- 	callback = function()
-- 		-- Necessary for lsps to get attached.
-- 		vim.cmd([[set filetype=html]])
-- 		vim.cmd([[set filetype=myangular]])
-- 	end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  -- pattern = "angular.html",
  pattern = "myangular",
  callback = function()
    -- vim.treesitter.language.register("angular", "angular.html") -- Register the filetype with treesitter for the `angular` language/parser
    -- vim.treesitter.language.register("html", "myangular") -- Register the filetype with treesitter for the `angular` language/parser
    vim.treesitter.language.register("angular", "myangular") -- Register the filetype with treesitter for the `angular` language/parser
    -- vim.treesitter.language.register("html", "myangular") -- Register the filetype with treesitter for the `angular` language/parser
    vim.cmd([[set commentstring=<!--%s-->]])
    -- vim.cmd([[hi @variable guifg=#F2CDCD]])
    -- local luasnip_status, luasnip = pcall(require, "luasnip")
    -- if not luasnip_status then
    --   return
    -- end

    -- luasnip.filetype_extend("myangular", { "html" })
  end,
})


-- Define a function to set the highlight for myangular filetype
local function set_myangular_highlight()
  vim.cmd([[hi @variable guifg=#F2CDCD]])
end

-- Define a function to revert the highlight to its original state
local function revert_variable_highlight()
  vim.cmd([[hi @variable guifg=#cdd6f5>]])
end

-- Create an autocommand group
vim.api.nvim_create_augroup('MyAngularHighlights', { clear = true })

-- Set the highlight when entering a buffer with the myangular filetype
vim.api.nvim_create_autocmd('BufEnter', {
  group = 'MyAngularHighlights',
  pattern = '*.component.html',
  callback = set_myangular_highlight,
})

-- Revert the highlight when leaving a buffer with the myangular filetype
vim.api.nvim_create_autocmd('BufLeave', {
  group = 'MyAngularHighlights',
  pattern = '*.component.html',
  callback = revert_variable_highlight,
})
