-- Starts/stops the local Caddy proxy that authenticates against Jira with the
-- browser session cookie. See jira/Caddyfile.
local M = {}

M.port = tonumber(vim.env.JIRA_PROXY_PORT) or 8787
M.caddyfile = vim.fn.stdpath("config") .. "/jira/Caddyfile"
M.env_file = vim.fn.expand(vim.env.JIRA_PROXY_ENV or "~/.config/jira-proxy/env")
M.start_timeout = 5000

local notified_once = false

local function notify(msg, level)
	vim.notify("[jira-proxy] " .. msg, level or vim.log.levels.INFO)
end

---@return boolean
local function port_open()
	local tcp = vim.uv.new_tcp()
	if not tcp then
		return false
	end

	local opened, done = false, false
	tcp:connect("127.0.0.1", M.port, function(err)
		opened = err == nil
		done = true
	end)
	vim.wait(200, function()
		return done
	end, 10)
	pcall(function()
		tcp:close()
	end)

	return opened
end

---@return table<string, string>
local function parse_env_file()
	local vars = {}
	local file = io.open(M.env_file, "r")
	if not file then
		return vars
	end

	for line in file:lines() do
		line = vim.trim(line)
		if line ~= "" and not line:match("^#") then
			line = line:gsub("^export%s+", "")
			local key, value = line:match("^([%w_]+)%s*=%s*(.*)$")
			if key then
				value = vim.trim(value):gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
				vars[key] = value
			end
		end
	end
	file:close()

	return vars
end

---@return string|nil, string|nil
local function credentials()
	local vars = parse_env_file()
	local session = vars.JIRA_SESSION or vim.env.JIRA_SESSION
	local xsrf = vars.JIRA_XSRF or vim.env.JIRA_XSRF

	if not session or session == "" then
		return nil
	end

	return session, xsrf
end

function M.is_running()
	return port_open()
end

--- Starts Caddy unless something is already listening on the port.
---@param opts { quiet?: boolean }|nil
---@return boolean
function M.ensure(opts)
	opts = opts or {}

	if port_open() then
		if not notified_once then
			notified_once = true
			if not opts.quiet then
				notify(
					("something is already listening on 127.0.0.1:%d, not starting another one"):format(M.port),
					vim.log.levels.WARN
				)
			end
		end
		return true
	end

	if vim.fn.executable("caddy") == 0 then
		notify("can't find the 'caddy' binary in PATH", vim.log.levels.ERROR)
		return false
	end

	if vim.fn.filereadable(M.caddyfile) == 0 then
		notify("Caddyfile not found: " .. M.caddyfile, vim.log.levels.ERROR)
		return false
	end

	local session, xsrf = credentials()
	if not session then
		notify(
			("missing JIRA_SESSION. Set it in %s (chmod 600) or export it before opening nvim"):format(M.env_file),
			vim.log.levels.ERROR
		)
		return false
	end

	local command = ("exec caddy run --config %s > /dev/null 2>&1"):format(
		vim.fn.shellescape(M.caddyfile)
	)
	local job = vim.fn.jobstart({ "sh", "-c", command }, {
		detach = true,
		env = { JIRA_SESSION = session, JIRA_XSRF = xsrf or "" },
	})

	if job <= 0 then
		notify("couldn't launch caddy", vim.log.levels.ERROR)
		return false
	end

	local deadline = vim.uv.now() + M.start_timeout
	while vim.uv.now() < deadline do
		if port_open() then
			notified_once = true
			notify(("proxy ready at http://127.0.0.1:%d"):format(M.port))
			return true
		end
		vim.wait(100)
	end

	notify(
		("caddy didn't respond within %dms on 127.0.0.1:%d"):format(M.start_timeout, M.port),
		vim.log.levels.ERROR
	)
	return false
end

function M.stop()
	if not port_open() then
		notify("no proxy is running", vim.log.levels.WARN)
		return
	end

	-- Kill whatever is listening on the port, regardless of which Caddyfile it
	-- was started with (it may have been started by hand from another path).
	local pids = vim.fn.systemlist({
		"lsof",
		"-nP",
		"-ti",
		("tcp:%d"):format(M.port),
		"-sTCP:LISTEN",
	})
	if vim.v.shell_error ~= 0 or #pids == 0 then
		vim.fn.system({ "pkill", "-f", M.caddyfile })
	else
		vim.fn.system({ "kill", unpack(pids) })
	end

	for _ = 1, 20 do
		if not port_open() then
			notified_once = false
			notify("proxy stopped")
			return
		end
		vim.wait(100)
	end

	notify("couldn't stop caddy", vim.log.levels.ERROR)
end

function M.setup()
	vim.api.nvim_create_user_command("JiraProxy", function(args)
		local sub = args.args ~= "" and args.args or "status"

		if sub == "start" then
			M.ensure()
		elseif sub == "stop" then
			M.stop()
		elseif sub == "restart" then
			M.stop()
			M.ensure()
		else
			notify(port_open() and ("running at 127.0.0.1:" .. M.port) or "stopped")
		end
	end, {
		nargs = "?",
		desc = "Control the local Jira proxy (Caddy)",
		complete = function()
			return { "start", "stop", "restart", "status" }
		end,
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = vim.api.nvim_create_augroup("JiraProxyAtlas", { clear = true }),
		callback = function()
			local line = vim.fn.getcmdline()
			if line:match("^%s*Atlas[%s!]") or line:match("^%s*Atlas$") then
				M.ensure()
			end
		end,
	})
end

return M
