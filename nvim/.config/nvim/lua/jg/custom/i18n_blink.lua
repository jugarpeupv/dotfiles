-- blink.cmp provider wrapper for yelog/i18n.nvim.
--
-- The bundled source only opens the menu for function-call syntax such as
-- t('KEY') / $t('KEY'). Angular templates use `'KEY' | translate`, which the
-- source's should_show_completion_items() rejects, so add that context here.
--
-- Usage (blink.cmp config):
--   providers = {
--     i18n = { name = 'i18n', module = 'jg.custom.i18n_blink', opts = {} },
--   }

local original = require("i18n.integration.blink_source")

local M = {}

function M.new(opts)
	local source = original.new(opts)
	local orig_should_show = source.should_show_completion_items

	function source:should_show_completion_items(ctx)
		local ft = vim.bo.filetype
		if ft == "html" or ft == "htmlangular" then
			local before = ctx.line:sub(1, ctx.cursor[2])
			-- Cursor sits inside a quoted key and the line uses the Angular
			-- translate pipe.
			if before:match("['\"][%w%.%-_]*$") and ctx.line:find("translate", 1, true) then
				return true
			end
		end

		return orig_should_show(self, ctx)
	end

	return source
end

return M
