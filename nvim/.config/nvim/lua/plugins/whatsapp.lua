-- lazy.nvim
return {
	{
		"dwmkerr/whatsapp.nvim",
		build = "make -C dist",
		enabled = false,
		cmd = { "WhatsApp" },
		config = function()
			vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/whatsapp.nvim/dist")
			vim.cmd("runtime! plugin/whatsapp.lua")
			require("whatsapp").setup()
		end,
	},
}
