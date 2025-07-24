-- return {}
return {
	-- enabled = false,
	"andymass/vim-matchup",
	-- event = { "CursorMoved" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- event = { "VeryLazy" },
	event = { "BufReadPost", "BufNewFile" },
	-- keys = { "%", mode = "n" },
	config = function()
		-- vim.cmd([[let g:matchup_matchparen_offscreen
		--       \ = {'method': 'popup', 'highlight': 'Comment'}]])
		-- vim.cmd[[let g:loaded_matchit = 1]]
		-- vim.g.matchup_transmute_enabled = 1
		-- vim.g.matchup_matchpref = {
		--   htmlangular = { tagnameonly = 1 },
		--   html = { tagnameonly = 1 },
		-- }

		vim.g.matchup_matchparen_enabled = 0
		vim.g.matchup_matchpref = {
			svelte = { tagnameonly = 1 },
			vue = { tagnameonly = 1 },
			typescriptreact = { tagnameonly = 1 },
			tsx = { tagnameonly = 1 },
			html = { tagnameonly = 1 },
			htmlangular = { tagnameonly = 1 },
		}

		-- vim.cmd([[
		--     function! HTMLHotFix()
		--     echo 'Applying HTML hotfix...'
		--
		--     " Use the matching rules for the 'html' filetype
		--     let b:match_words = matchup#filetype#detect('html')
		--
		--
		--     endfunction
		--
		--     let g:matchup_hotfix = {}
		--     let g:matchup_hotfix['htmlangular'] = 'HTMLHotFix'
		--     ]])

		-- vim.g.matchup_delim_nomids = 1
		vim.g.matchup_delim_noskips = 2
		-- vim.g.matchup_delim_start_plaintext = 0
		vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		-- vim.g.matchup_matchparen_offscreen = { method = "popup" }
		vim.g.matchup_matchparen_end_sign = "󱐋"

		vim.g.matchup_treesitter_include_match_words = 1

		-- local function configureHtmlAngularMatchup()
		-- 	vim.cmd([[
		--   function! JSXHotFix()
		--     echo('Applying JSX hotfix...')
		--     " setlocal matchpairs=(:),{:},[:],<:>
		--     " let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}\%(>\|$\|[ \t][^>]*\%(>\|$\)\):<\@<=/\1\g{hlend}>'
		--     " let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
		--     let b:match_words = matchup#util#standard_html()
		--   endfunction
		--
		--   " let g:matchup_hotfix = {'jsx': 'JSXHotFix'}
		--   let g:matchup_hotfix = {'htmlangular': 'JSXHotFix'}
		--   " let g:matchup_matchparen_offscreen = {'method': 'popup'}
		--   " let g:matchup_transmute_enabled = 1
		--
		--   " Deferred highlight for performance reasons
		--   " let g:matchup_matchparen_deferred = 1
		--   " let b:match_words = matchup#util#standard_html()
		--   "
		--   " let g:matchup_matchpref = {
		--   " \ 'htmlangular': { 'tagnameonly': 1, },
		--   " \ 'html': { 'tagnameonly': 1, },
		--   " \ 'javascript.jsx': { 'tagnameonly': 1, },
		--   " \ 'javascript': { 'tagnameonly': 1, },
		--   " \ 'jsx': { 'tagnameonly': 1, },
		--   " \}
		--   ]])
		-- end
		--
		-- configureHtmlAngularMatchup()

		-- vim.cmd("NoMatchParen")
		vim.cmd("DoMatchParen")

		-- vim.cmd("DoMatchParen")
		-- vim.api.nvim_create_autocmd("VimEnter", {
		--   callback = function()
		--   end,
		-- })

		-- vim.api.nvim_create_autocmd("FileType", {
		--   pattern = "htmlangular",
		--   callback = function()
		--     print('hello')
		--     vim.fn["matchup#filetype#override"]("html")
		--   end,
		-- })
	end,
}
