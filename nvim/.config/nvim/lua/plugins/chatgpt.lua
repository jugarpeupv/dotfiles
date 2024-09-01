return {
  "robitx/gp.nvim",
  event = { "BufReadPost", "BufNewFile" },
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
}
