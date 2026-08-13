return {
	{
		"kkvh/vim-docker-tools",
		cmd = { "DockerToolsToggle" },
		enabled = true,
		keys = {
			{
				"<leader>dt",
				"<cmd>DockerToolsToggle<cr>",
				desc = "Toggle Docker Tools",
			},
		},
	},
	{
		"jrop/tuis.nvim",
		enabled = true,
		dependencies = { "folke/snacks.nvim" },
		keys = {
			{
				mode = { "n" },
				"<leader>tu",
				function()
					require("tuis").choose()
				end,
			},
			{
				mode = { "n" },
				"<leader>up",
				function()
					require("tuis").run("processes")
				end,
			},
			{
				mode = { "n" },
				"<leader>ul",
				function()
					require("tuis").run("lsof")
				end,
			},
			{
				mode = { "n" },
				"<leader>ud",
				function()
					require("tuis").run("docker")
				end,
			},
		},
	},
	{
		-- "skanehira/denops-docker.vim",
		"jugarpeupv/denops-docker.vim",
    branch = "feature/fixes",
		enabled = false,
		dependencies = {
			{ "vim-denops/denops.vim" },
		},
		-- cmd = { "Docker", "DockerContainers", "DockerImages" },
		-- event = { "BufReadPost", "BufNewFile" },
		event = { "CmdlineEnter" },
		lazy = true,
		-- config = function ()
		--   vim.keymap.set("n", "<leader>dt", "<cmd>DockerContainers<cr>", { desc = "Docker Containers" })
		-- end,
		keys = {
			{
				"<leader>dI",
				function()
					-- vim.cmd(":e docker://images")
					-- vim.defer_fn(function()
					--   vim.cmd(":e")
					--   vim.g.docker_denops_loaded = true
					-- end, 500)

					vim.cmd(":e docker://images")

					-- vim.defer_fn(function()
					--    vim.cmd(":e docker://images")
					-- end, 200)

					-- if vim.g.docker_denops_loaded then
					-- 	vim.cmd(":e docker://images")
					-- 	return
					-- else
					-- 	vim.cmd(":e docker://images")
					-- 	vim.defer_fn(function()
					-- 		vim.cmd(":e")
					-- 		vim.g.docker_denops_loaded = true
					-- 	end, 500)
					-- end
				end,
				desc = "Docker Images",
			},
			{
				"<leader>dc",
				-- "<cmd>DockerContainers<cr>",
				function()
					vim.cmd(":e docker://containers")

					-- vim.defer_fn(function()
					--   vim.cmd(":e docker://containers")
					-- end, 200)
					-- vim.defer_fn(function()
					--   vim.cmd(":e")
					-- end, 500)

					-- if vim.g.docker_denops_loaded then
					-- 	vim.cmd(":e docker://containers")
					-- else
					-- 	vim.cmd(":e docker://containers")
					-- 	vim.defer_fn(function()
					-- 		vim.cmd(":e docker://containers")
					-- 	end, 500)
					-- end

					-- vim.schedule(function() vim.cmd(":e docker://containers") end)
					-- Execute the DockerContainers command
					-- vim.cmd("DockerContainers")
				end,
				desc = "Docker Containers",
			},
		},
	},
}
