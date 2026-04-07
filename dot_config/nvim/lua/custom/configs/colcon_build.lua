-- Add this to your init.lua or a separate plugin file

local build_state = {
  buf = nil,
  is_building = false,
}

local function get_package_name_from_cmake()
  local cmake_file = vim.fn.getcwd() .. "/CMakeLists.txt"
  local file = io.open(cmake_file, "r")
  
  if not file then
    return nil, "No CMakeLists.txt found in current directory"
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Match project(package_name) or project(package_name ...) with optional whitespace
  local package_name = content:match("project%s*%(%s*([%w_-]+)")
  
  if not package_name then
    return nil, "Could not find project() in CMakeLists.txt"
  end
  
  return package_name, nil
end

local function get_workspace_root()
  local cwd = vim.fn.getcwd()
  local parts = vim.split(cwd, "/")
  
  for i, part in ipairs(parts) do
    if part:match("^ws_") then
      return table.concat(parts, "/", 1, i)
    end
  end
  
  return nil, "Not inside a ws_* workspace folder"
end

local function get_package_info()
  local package_name, err = get_package_name_from_cmake()
  if not package_name then
    return nil, err
  end
  
  local ws_root, ws_err = get_workspace_root()
  if not ws_root then
    return nil, ws_err
  end
  
  return {
    workspace_root = ws_root,
    package_name = package_name,
    package_path = vim.fn.getcwd(),
  }, nil, nil
end

local function read_cmake_args(package_path)
  local cmake_args_file = package_path .. "/.cmake_args"
  local file = io.open(cmake_args_file, "r")
  
  if not file then
    return ""
  end
  
  local args = {}
  for line in file:lines() do
    line = vim.trim(line)
    if line ~= "" and not line:match("^#") then
      table.insert(args, line)
    end
  end
  file:close()
  
  return table.concat(args, " ")
end

local function is_buf_visible(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end
  return false
end

local function get_buf_win(buf)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
  return nil
end

local function toggle_build_terminal()
  if not build_state.buf or not vim.api.nvim_buf_is_valid(build_state.buf) then
    vim.notify("No build terminal exists", vim.log.levels.WARN)
    return
  end
  
  local current_buf = vim.api.nvim_get_current_buf()
  if current_buf == build_state.buf then
    vim.cmd("buffer #")
  else
    build_state.prev_buf = current_buf
    vim.api.nvim_set_current_buf(build_state.buf)
  end
end

local function run_build()
  local info, err = get_package_info()
  
  if not info then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  
  local extra_cmake_args = read_cmake_args(info.package_path)
  local cmake_args = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
  
  if extra_cmake_args ~= "" then
    cmake_args = cmake_args .. " " .. extra_cmake_args
  end
  
  local cmd = string.format(
    "cd %s && source /opt/ros/humble/install/setup.bash && colcon build --symlink-install --packages-select %s --cmake-args %s",
    vim.fn.shellescape(info.workspace_root),
    vim.fn.shellescape(info.package_name),
    cmake_args
  )
  
  -- Clean up old buffer
  if build_state.buf and vim.api.nvim_buf_is_valid(build_state.buf) then
    local win = get_buf_win(build_state.buf)
    if win then
      vim.api.nvim_win_close(win, true)
    end
    vim.api.nvim_buf_delete(build_state.buf, { force = true })
  end
  
  -- Store current buffer to return to later
  build_state.prev_buf = vim.api.nvim_get_current_buf()
  
  -- Open terminal in current window (replaces buffer, no split)
  vim.cmd("terminal " .. cmd)
  build_state.buf = vim.api.nvim_get_current_buf()
  build_state.is_building = true
  
  vim.notify("Building: " .. info.package_name, vim.log.levels.INFO)
  
  -- Track build completion
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = build_state.buf,
    once = true,
    callback = function(args)
      build_state.is_building = false
      local exit_code = vim.v.event.status
      if exit_code == 0 then
        vim.notify("Build succeeded: " .. info.package_name, vim.log.levels.INFO)
      else
        vim.notify("Build failed: " .. info.package_name, vim.log.levels.ERROR)
      end
    end,
  })
end

local function colcon_build()
  if build_state.is_building then
    toggle_build_terminal()
  else
    run_build()
  end
end

vim.keymap.set("n", "<F5>", colcon_build, { desc = "Colcon build / toggle terminal" })
vim.keymap.set("n", "<leader>h", toggle_build_terminal, { desc = "Toggle build terminal" })
