require "nvchad.mappings"

-- add yours here
-- require "custom.mappings"

local map = vim.keymap.set
-- keybindings for DAP plugin
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line"})
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Start or continue the debugger"})

-- keybindings for CodeCompanion
map("n", "<leader>cch", "<cmd>CodeCompanionChat<CR>", { desc = "Code Completion chat toggle"})
map("n", "<leader>cc", "<cmd>CodeCompanion<CR>", { desc = "Code Completion prompt"})
map("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "Code Completion actions"})

-- Set up keybindings for buffer navigation
local nav = require("custom.mappings.navigation")
vim.keymap.set('n', '<C-Left>',  function() nav.navigate_buffer("left") end, {silent = true, desc = "Navigate to left buffer"})
vim.keymap.set('n', '<C-Right>', function() nav.navigate_buffer("right") end, {silent = true, desc = "Navigate to right buffer"})
vim.keymap.set('n', '<C-Up>',    function() nav.navigate_buffer("up") end, {silent = true, desc = "Navigate to buffer above"})
vim.keymap.set('n', '<C-Down>',  function() nav.navigate_buffer("down") end, {silent = true, desc = "Navigate to buffer below"})

 

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
