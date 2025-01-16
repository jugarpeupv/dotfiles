return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    branch = "main",
    dependencies = {
      -- { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",    -- Only on MacOS or Linux
    opts = {
      log_level = "fatal",
      mappings = {
        toggle_sticky = {
          detail = "Makes line under cursor sticky or deletes sticky line.",
          normal = "gR",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        jump_to_diff = {
          normal = "go",
        },
        quickfix_diffs = {
          normal = "gq",
        },
        yank_diff = {
          normal = "gy",
          register = '"',
        },
        show_diff = {
          normal = "gF",
        },
        show_info = {
          normal = "gi",
        },
        show_context = {
          normal = "gc",
        },
        show_help = {
          normal = "gh",
        },
      },
      -- window = {
      --   layout = 'float',
      --   relative = 'cursor',
      --   width = 1,
      --   height = 0.4,
      --   row = 1
      -- },
      -- See Configuration section for options
      callback = function()
        local chat = require("CopilotChat")
        -- if vim.g.chat_title then
        --   chat.save(vim.g.chat_title)
        --   return
        -- end

        local cwd = vim.fn.getcwd()
        local wt_utils = require("jg.custom.worktree-utils")
        local wt_info = wt_utils.get_wt_info(cwd)
        print("wt_info", vim.inspect(wt_info))

        if next(wt_info) == nil then
          vim.g.chat_title = vim.trim(cwd:gsub(vim.env.HOME, ""):gsub("/", "-"))
        else
          vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub(vim.env.HOME, ""):gsub("/", "-"))
        end
        chat.save(vim.g.chat_title)
      end,
    },
    keys = {
      {
        "<leader>cx",
        function()
          local chat = require("CopilotChat")
          vim.g.chat_title = nil
          chat.reset()
        end,
        desc = "CopilotChat - Prompt actions",
      },

      -- { "<leader>ct", mode = { "n", "v" }, "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot" },
      {
        "<leader>ct",
        mode = { "n", "v" },
        function()
          -- local chat = require("CopilotChat")
          -- chat.toggle()
          local chat = require("CopilotChat")

          local cwd = vim.fn.getcwd()
          local wt_utils = require("jg.custom.worktree-utils")
          local wt_info = wt_utils.get_wt_info(cwd)

          if next(wt_info) == nil then
            vim.g.chat_title = vim.trim(cwd:gsub(vim.env.HOME, ""):gsub("/", "-"))
          else
            vim.g.chat_title = vim.trim(wt_info["wt_root_dir"]:gsub(vim.env.HOME, ""):gsub("/", "-"))
          end

          print("vim.g.chat_title", vim.g.chat_title)

          local existing_chat_path = vim.fn.stdpath("data")
              .. "/copilotchat_history/"
              .. vim.g.chat_title
              .. ".json"
          print("existing_chat_path", existing_chat_path)

          local chat_exits = wt_utils.file_exists(existing_chat_path)

          if chat_exits then
            chat.toggle()
            chat.load(vim.g.chat_title)
          else
            chat.toggle()
          end
        end,
        desc = "Toggle Copilot",
      },
      {
        "<leader>ca",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",                                                                 -- Optional: For using slash commands and variables in the chat buffer
      "echasnovski/mini.diff",
      "nvim-telescope/telescope.nvim",                                                    -- Optional: For using slash commands
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
      { "stevearc/dressing.nvim",                    opts = {} },                         -- Optional: Improves `vim.ui.select`
    },
    -- config = true,
    config = function()
      require("codecompanion").setup({
        display = {
          chat = {
            diff = {
              enabled = true,
              close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
              layout = "vertical", -- vertical|horizontal split for default provider
              opts = {
                "internal",
                "filler",
                "closeoff",
                "algorithm:patience",
                "followwrap",
                "linematch:120",
              },
              provider = "mini_diff", -- default|mini_diff
            },
          },
        },
      })
    end,
    keys = {
      { mode = { "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>" },
      { mode = { "v" },      "ga",         "<cmd>CodeCompanionChat Add<CR>" },
    },
  },
  {
    "yetone/avante.nvim",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    -- event = "BufReadPost",
    -- version = "*",
    version = false,
    opts = {
      provider = "copilot",
      mappings = {
        ask = "<leader>aa", -- ask
        edit = "<leader>ae", -- edit
        refresh = "<leader>ar", -- refresh
        diff = {
          ours = "cc",
          theirs = "ci",
          all_theirs = "ca",
          both = "cb",
          cursor = "cu",
          next = "]x",
          prev = "[x",
        },
        -- suggestion = {
        --   accept = "<M-l>",
        --   next = "<M-]>",
        --   prev = "<M-[>",
        --   dismiss = "<C-]>",
        -- },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = false },
    },
    keys = function(_, keys)
      local opts = require("lazy.core.plugin").values(
        require("lazy.core.config").spec.plugins["avante.nvim"],
        "opts",
        false
      )

      local mappings = {
        {
          "<leader>ip",
          function()
            return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
                or require("img-clip").paste_image()
          end,
          desc = "clip: paste image",
        },
        {
          opts.mappings.ask,
          function()
            require("avante.api").ask()
          end,
          desc = "avante: ask",
          mode = { "n", "v" },
        },
        {
          opts.mappings.refresh,
          function()
            require("avante.api").refresh()
          end,
          desc = "avante: refresh",
          mode = "v",
        },
        {
          opts.mappings.edit,
          function()
            require("avante.api").edit()
          end,
          desc = "avante: edit",
          mode = { "n", "v" },
        },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    -- lazy = false,
    -- version = false, -- set this if you want to always pull the latest change
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "stevearc/dressing.nvim",
        -- keys = { "<leader>re", "<M-.>" },
        opts = {
          input = {
            -- Set to false to disable the vim.ui.input implementation
            enabled = false,

            -- Default prompt string
            default_prompt = "Input",

            -- Trim trailing `:` from prompt
            trim_prompt = true,

            -- Can be 'left', 'right', or 'center'
            title_pos = "left",

            -- When true, input will start in insert mode.
            start_in_insert = false,

            -- These are passed to nvim_open_win
            border = "rounded",
            -- 'editor' and 'win' will default to being centered
            relative = "cursor",

            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            prefer_width = 40,
            width = nil,
            -- min_width and max_width can be a list of mixed types.
            -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
            max_width = { 140, 0.9 },
            min_width = { 20, 0.2 },

            buf_options = {},
            win_options = {
              -- Disable line wrapping
              wrap = false,
              -- Indicator for when text exceeds window
              list = true,
              listchars = "precedes:…,extends:…",
              -- Increase this for more context when text scrolls off the window
              sidescrolloff = 0,
            },

            -- Set to `false` to disable
            mappings = {
              n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
              },
              i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
              },
            },

            override = function(conf)
              -- This is the config that will be passed to nvim_open_win.
              -- Change values here to customize the layout
              return conf
            end,

            -- see :help dressing_get_config
            get_config = nil,
          },
          select = {
            -- Set to false to disable the vim.ui.select implementation
            enabled = true,

            -- Priority list of preferred vim.select implementations
            backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

            -- Trim trailing `:` from prompt
            trim_prompt = true,

            -- Options for telescope selector
            -- These are passed into the telescope picker directly. Can be used like:
            -- telescope = require('telescope.themes').get_ivy({...})
            telescope = nil,

            -- Options for fzf selector
            fzf = {
              window = {
                width = 0.5,
                height = 0.4,
              },
            },

            -- Options for fzf-lua
            fzf_lua = {
              -- winopts = {
              --   height = 0.5,
              --   width = 0.5,
              -- },
            },

            -- Options for nui Menu
            nui = {
              position = "50%",
              size = nil,
              relative = "editor",
              border = {
                style = "rounded",
              },
              buf_options = {
                swapfile = false,
                filetype = "DressingSelect",
              },
              win_options = {
                winblend = 0,
              },
              max_width = 80,
              max_height = 40,
              min_width = 40,
              min_height = 10,
            },

            -- Options for built-in selector
            builtin = {
              -- Display numbers for options and set up keymaps
              show_numbers = true,
              -- These are passed to nvim_open_win
              border = "rounded",
              -- 'editor' and 'win' will default to being centered
              relative = "editor",

              buf_options = {},
              win_options = {
                cursorline = true,
                cursorlineopt = "both",
              },

              -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
              -- the min_ and max_ options can be a list of mixed types.
              -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
              width = nil,
              max_width = { 140, 0.8 },
              min_width = { 40, 0.2 },
              height = nil,
              max_height = 0.9,
              min_height = { 10, 0.2 },

              -- Set to `false` to disable
              mappings = {
                ["<Esc>"] = "Close",
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
              },

              override = function(conf)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                return conf
              end,
            },

            -- Used to override format_item. See :help dressing-format
            format_item_override = {},

            -- see :help dressing_get_config
            get_config = nil,
          },
        },
      },
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",   -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        -- event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "robitx/gp.nvim",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    cmd = { "GpChatToggle", "GpChatNew", "GpChatPaste", "GpWhisper" },
    keys = { { "<leader>ch", "<cmd>GpChatToggle<CR>" } },
    config = function()
      local conf = {
        -- openai_api_key = os.getenv("OPENAI_API_KEY"),
        -- openai_api_key = os.getenv("OPENAI_API_KEY"),
        -- For customization, refer to Install > Configuration in the Documentation/Readme
        -- providers = {
        --   openai = {
        --     endpoint = "https://api.openai.com/v1/chat/completions",
        --     secret = os.getenv("OPENAI_API_KEY_GPT"),
        --   },
        -- },
        providers = {
          copilot = {
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
        },
        agents = {
          {
            provider = "copilot",
            name = "CopilotCommand",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "copilot",
            name = "ChatCopilot",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
        },
        hooks = {
          -- GpImplement rewrites the provided selection/range based on comments in it
          Implement = function(gp, params)
            local template = "Having following from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please rewrite this according to the contained instructions."
                .. "\n\nRespond exclusively with the snippet that should replace the selection above."

            local agent = gp.get_command_agent()
            gp.logger.info("Implementing selection with agent: " .. agent.name)

            gp.Prompt(
              params,
              gp.Target.rewrite,
              agent,
              template,
              nil, -- command will run directly without any prompting for user input
              nil -- no predefined instructions (e.g. speech-to-text from Whisper)
            )
          end,

          -- example of adding command which explains the selected code
          Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, agent, template)
          end,
        },
      }
      require("gp").setup(conf)
      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },
}
