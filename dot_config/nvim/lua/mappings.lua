require "nvchad.mappings"

-- add yours here
-- require "custom.mappings"

local map = vim.keymap.set
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line"})
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Start or continue the debugger"})

map("n", "<leader>cch", "<cmd>CodeCompanionChat<CR>", { desc = "Code Completion chat toggle"})
map("n", "<leader>cc", "<cmd>CodeCompanion<CR>", { desc = "Code Completion prompt"})
map("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "Code Completion actions"})


-- Function to navigate to buffer in a specific direction
local function navigate_buffer(direction)
  -- Get current window position
  local current_win = vim.api.nvim_get_current_win()
  local current_pos = vim.api.nvim_win_get_position(current_win)
  local current_width = vim.api.nvim_win_get_width(current_win)
  local current_height = vim.api.nvim_win_get_height(current_win)
  local current_row = current_pos[1]
  local current_col = current_pos[2]
  
  -- Get all windows
  local wins = vim.api.nvim_list_wins()
  local target_win = nil
  local min_distance = math.huge
  
  for _, win in ipairs(wins) do
    if win ~= current_win and vim.api.nvim_win_is_valid(win) then
      local pos = vim.api.nvim_win_get_position(win)
      local width = vim.api.nvim_win_get_width(win)
      local height = vim.api.nvim_win_get_height(win)
      local row = pos[1]
      local col = pos[2]
      
      -- Calculate window centers
      local current_center_row = current_row + current_height / 2
      local current_center_col = current_col + current_width / 2
      local win_center_row = row + height / 2
      local win_center_col = col + width / 2
      
      -- Check if window is in the desired direction
      local is_candidate = false
      if direction == "left" and col < current_col then
        is_candidate = true
      elseif direction == "right" and col > current_col then
        is_candidate = true
      elseif direction == "up" and row < current_row then
        is_candidate = true
      elseif direction == "down" and row > current_row then
        is_candidate = true
      end
      
      if is_candidate then
        -- Calculate distance (Manhattan distance)
        local distance
        if direction == "left" or direction == "right" then
          distance = math.abs(win_center_row - current_center_row) + math.abs(win_center_col - current_center_col)
        else
          distance = math.abs(win_center_row - current_center_row) + math.abs(win_center_col - current_center_col)
        end
        
        if distance < min_distance then
          min_distance = distance
          target_win = win
        end
      end
    end
  end
  
  -- If no window found in that direction, try to find a buffer in that direction
  if target_win == nil then
    vim.cmd("wincmd " .. ({left = "h", right = "l", up = "k", down = "j"})[direction])
  else
    vim.api.nvim_set_current_win(target_win)
  end
end

-- Set up keybindings
vim.keymap.set('n', '<C-Left>', function() navigate_buffer("left") end, {silent = true, desc = "Navigate to left buffer"})
vim.keymap.set('n', '<C-Right>', function() navigate_buffer("right") end, {silent = true, desc = "Navigate to right buffer"})
vim.keymap.set('n', '<C-Up>', function() navigate_buffer("up") end, {silent = true, desc = "Navigate to buffer above"})
vim.keymap.set('n', '<C-Down>', function() navigate_buffer("down") end, {silent = true, desc = "Navigate to buffer below"})

 

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
