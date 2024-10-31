local M = {}

M.is_bare = function(path)
  local is_bare_result = vim.system({ "git", "rev-parse", "--is-bare-repository" }, { cwd = path }):wait()
  local is_bare = false
  if
      is_bare_result.stdout ~= nil
      and string.len(is_bare_result.stdout) > 1
      and string.find(is_bare_result.stdout, "true")
  then
    is_bare = true
  end
  return is_bare
end

M.update_git_head = function(path, branch)
  if (path) then
    -- old way
    local git_head_path = path .. "/.git/HEAD"
    local fp = io.open(git_head_path, "w+")
    if fp ~= nil then
      fp:write("ref: refs/heads/" .. branch)
      fp:close()
    end

    -- new way
    git_head_path = path .. "/HEAD"
    fp = io.open(git_head_path, "w+")
    if fp ~= nil then
      fp:write("ref: refs/heads/" .. branch)
      fp:close()
    end
  end
end

M.has_worktrees = function(path_to_git_folder)
  local is_bare = vim.fn.system("git rev-parse --is-bare-repository")
  if is_bare ~= "true\n" then
    return false
  end

  local is_inside_work_tree = vim.fn.system("git rev-parse --is-inside-work-tree")
  if is_inside_work_tree == "true\n" then
    return true
  end

  local git_dir = vim.fn.system("git rev-parse --git-dir")
  local git_common_dir = vim.fn.system("git rev-parse --git-common-dir")

  local is_root_dir = git_dir == git_common_dir


  local git_worktree_path = path_to_git_folder .. "/worktrees"

  local git_worktree_path_alt_location = path_to_git_folder .. "/.git/worktrees"

  local exists_worktrees = vim.fn.isdirectory(git_worktree_path)
  local exists_worktrees_alt_location = vim.fn.isdirectory(git_worktree_path_alt_location)

  if is_root_dir and exists_worktrees == 0 and exists_worktrees_alt_location == 0 then
    return false
  end

  return true
end

M.get_wt_info = function(path_to_wt)
  local wt_info = {}

  local git_file_path = (path_to_wt or vim.loop.cwd()) .. "/.git"
  local git_file_exists = M.file_exists(git_file_path)

  if git_file_exists then
    local fp = io.open(git_file_path, "r")
    if fp ~= nil then
      local git_file_raw = fp:read("*a")
      local wt_gitdir = string.match(git_file_raw, "gitdir: (.*)"):match("[^\n]*")
      local wt_name = string.match(wt_gitdir, ".*/(.*)"):match("[^\n]*")
      local wt_root_dir = string.match(wt_gitdir, "(.*)/worktrees/(.*)"):match("[^\n]*")

      local wt_dir_fp = io.open(wt_gitdir .. "/gitdir", "r")
      if wt_dir_fp ~= nil then
        local wt_dir_raw = wt_dir_fp:read("*a")
        local wt_dir = string.match(wt_dir_raw, "(.*)/.git")
        wt_info["wt_dir"] = wt_dir
        wt_dir_fp:close()
      end

      local wt_head_file = io.open(wt_gitdir .. "/HEAD", "r")
      -- print("wt_gitdir", wt_gitdir)
      if wt_head_file ~= nil then
        local wt_head_raw = wt_head_file:read("*a")
        local wt_head = string.match(wt_head_raw, "ref: refs/heads/(.*)")
        if wt_head then
          wt_head = wt_head:match("[^\n]*")
          wt_info["wt_head"] = wt_head
        end
        wt_head_file:close()
      end

      wt_info["wt_git_dir"] = wt_gitdir
      wt_info["wt_root_dir"] = wt_root_dir
      wt_info["wt_name"] = wt_name
      fp:close()
    end
  end
  return wt_info
end


M.file_exists = function(name)
  local result = vim.fn.filereadable(name)
  if result == 0 then
    return false
  end
  return true
end

M.directory_exists = function(path)
  local exists_dir = vim.fn.isdirectory(path)
  if exists_dir == 0 then
    return false
  end
  return true
end

return M
