require "nvchad.mappings"

-- add yours here
-- require "custom.mappings"

local map = vim.keymap.set
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line"})
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Start or continue the debugger"})

map("n", "<leader>ch", "<cmd>CodeCompanionChat<CR>", { desc = "Code Completion chat toggle"})
map("n", "<leader>cc", "<cmd>CodeCompanion<CR>", { desc = "Code Completion prompt"})
map("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "Code Completion actions"})

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
