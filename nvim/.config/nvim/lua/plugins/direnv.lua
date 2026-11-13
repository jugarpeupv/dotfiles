return {
	{
		"https://codeberg.org/ejri/mise.nvim",
		cmd = { "Mise" },
		init = function()
		  local group = vim.api.nvim_create_augroup("mise_nvim_cwd", { clear = true })
		  vim.api.nvim_create_autocmd("DirChanged", {
		    group = group,
		    callback = function()
		      if vim.fn.filereadable(vim.fn.getcwd() .. "/.mise.toml") == 1 then
		        require("lazy").load({ plugins = { "mise.nvim" } })
		      end
		    end,
		  })
		end,
		opts = {
			-- Executable to run
			run = "mise",
			-- Args for the executable, set to "env --json --quiet" to ignore mise warnings
			args = "env --json",
			-- Set to override the base PATH
			initial_path = vim.env.PATH,
			-- Removes env vars set by mise when navigating away from a directory
			unset_vars = true,
			-- Loads env vars when setup() is called, don't need this if mise is hooked into your shell
			load_on_setup = true,
			-- Force a run when using an unsupported executable
			force_run = false,
		},
	},
	{
		"https://github.com/tpope/vim-dotenv",
		cmd = { "Dotenv" },
		init = function()
			local group = vim.api.nvim_create_augroup("vim_dotenv_cwd", { clear = true })
			vim.api.nvim_create_autocmd("DirChanged", {
				group = group,
				callback = function()
					if vim.fn.filereadable(vim.fn.getcwd() .. "/.env") == 1 then
						require("lazy").load({ plugins = { "vim-dotenv" } })
					end
				end,
			})
		end,
	},
	{
		"NotAShelf/direnv.nvim",
		lazy = true,
		init = function()
			local group = vim.api.nvim_create_augroup("nvim_direnv_cwd", { clear = true })
			vim.api.nvim_create_autocmd("DirChanged", {
				group = group,
				callback = function()
					if vim.fn.filereadable(vim.fn.getcwd() .. "/.envrc") == 1 then
						require("lazy").load({ plugins = { "direnv.nvim" } })
					end
				end,
			})
		end,
		config = function()
			require("direnv").setup({
				-- Path to the direnv executable
				bin = "direnv",

				-- Whether to automatically load direnv when entering a directory with .envrc
				autoload_direnv = true,

				-- Statusline integration
				statusline = {
					-- Enable statusline component
					enabled = true,
					-- Icon to display in statusline
					icon = "",
				},
				-- Keyboard mappings
				keybindings = {
					allow = "<Leader>Da",
					deny = "<Leader>Dd",
					reload = "<Leader>Dr",
					edit = "<Leader>De",
				},
				-- Notification settings
				notifications = {
					-- Log level (vim.log.levels.INFO, ERROR, etc.)
					level = vim.log.levels.INFO,
					-- Don't show notifications during autoload
					silent_autoload = false,
				},
			})
		end,
	},
}
