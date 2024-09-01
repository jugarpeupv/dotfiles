local M = {}

M.curr_buf = function()
  local opts = {}
  opts.tiebreak = function(entry1, entry2, prompt)
          local start_pos1, _ = entry1.ordinal:find(prompt)
          if start_pos1 then
            local start_pos2, _ = entry2.ordinal:find(prompt)
            if start_pos2 then
              return start_pos1 < start_pos2
            end
          end
          return false
        end
  opts.additional_args = { "--ignore-case", "--pcre2" }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

M.hi = function ()
  print('hola')
end

return M
