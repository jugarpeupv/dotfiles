local M = {}

M.loaded_image_under_cursor = nil
M.image_rendered = false

-- When the experimental ui2 renderer is active (require('vim._core.ui2').enable()
-- has been called), the kitty backend routes writes through nvim_ui_send(), which
-- buffers data in the UI event queue. Without an explicit flush the render/clear
-- is invisible until some unrelated redraw fires.
-- We detect ui2 being active by checking that its internal cmd window is valid —
-- that window is only created after enable() has run successfully.
-- The flush is wrapped in vim.schedule so it fires after the full render() call
-- stack has unwound — including nvim_buf_set_extmark() calls that happen inside
-- Image:render() after backend.render() returns.  Flushing before those extmark
-- operations settle causes the subsequent Neovim screen redraw to overwrite the
-- kitty graphics data.
local function flush_if_ui2_active()
	local ok, ui2 = pcall(require, "vim._core.ui2")
	if ok and vim.api.nvim_win_is_valid(ui2.wins and ui2.wins.cmd or -1) then
		vim.schedule(function()
			pcall(vim.api.nvim__redraw, { flush = true })
		end)
	end
end

--- @param file_path string Required
--- @param window integer Required
--- @param buffer integer Required
--- @param row integer Required
M.toggle_image_under_cursor = function(file_path, window, buffer, row)
	local api = require("image")
	if M.image_rendered and M.loaded_image_under_cursor then
		-- vim.g.image_object:clear() -- remove the image if it is already rendered
		M.loaded_image_under_cursor:clear() -- remove the image if it is already rendered
		flush_if_ui2_active()
		M.image_rendered = false
		-- vim.g.image_object = nil
		M.loaded_image_under_cursor = nil
	else
		if vim.fn.filereadable(file_path) == 0 then
			print("Image file does not exist: " .. file_path)
			return
		end
		-- from a file (absolute path)
		M.loaded_image_under_cursor = api.from_file(file_path, {
			id = "my_image_id", -- optional, defaults to a random string
			window = window, -- binds image to the current window
			buffer = buffer, -- binds image to the current buffer
			with_virtual_padding = true, -- optional, pads vertically with extmarks, defaults to false
			inline = true, -- binds image to an extmark which it follows
			-- geometry (optional)
			-- x = cursor_col,
			x = 0,
			y = row + 1,
			-- width = 1000,
			-- height = 1000,
		})
		-- vim.print('my_image: ', my_image)

		if not M.loaded_image_under_cursor then
			return
		end

		M.loaded_image_under_cursor:render()
		flush_if_ui2_active()
		M.image_rendered = true
	end
end

--- Download a GitHub attachment image.
--- @param url string Required. The image URL.
--- @param callback function Optional. Callback
--- @param cookies_path string|nil Optional. Path to cookies.txt. Defaults to ~/Downloads/cookies.txt.
--- @param output_path string|nil Optional. Output file path. Defaults to a temp file.
--- @return string|nil
M.get_github_attachment_image = function(url, callback, cookies_path, output_path)
	local home = os.getenv("HOME")
	output_path = output_path or os.tmpname()
	cookies_path = cookies_path or home .. "/Downloads/cookies.txt"

	local Job = require("plenary.job")

	Job
		:new({
      command = os.getenv("HOME") .. "/.config/bin/github_image_download",
      args = { url, output_path },
      -- command = "bun",
      -- args = { "download.ts", url, output_path },
      -- cwd = "/Users/jgarcia/work/tmp/cookies-test",

      -- cwd = "/Users/jgarcia/work/tmp/cookies-test",
      -- on_exit = function(j, return_val)
      --   local output = table.concat(j:result(), "\n")
      --   print("Downloaded file path:", output)
      -- end,
			on_exit = function(j, return_val)
				if return_val == 0 then
					vim.schedule(function()
						-- vim.notify("✅ Image downloaded to " .. output_path)
						callback(output_path)
					end)
				else
					vim.schedule(function()
						vim.notify("❌ Download failed: " .. table.concat(j:stderr_result(), "\n"))
					end)
				end
			end,
		})
		:start()
	return output_path
end

return M
