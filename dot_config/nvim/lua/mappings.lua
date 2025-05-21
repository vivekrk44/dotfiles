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
map('n', '<C-Left>',  function() nav.navigate_buffer("left") end, {silent = true, desc = "Navigate to left buffer"})
map('n', '<C-Right>', function() nav.navigate_buffer("right") end, {silent = true, desc = "Navigate to right buffer"})
map('n', '<C-Up>',    function() nav.navigate_buffer("up") end, {silent = true, desc = "Navigate to buffer above"})
map('n', '<C-Down>',  function() nav.navigate_buffer("down") end, {silent = true, desc = "Navigate to buffer below"})

-- Setup telescope keybindings
map("n", "<leader>tr",  "<cmd>Telescope lsp_references<CR>",        { desc = "Telescope find all references using LSP"})
map("n", "<leader>ti",  "<cmd>Telescope lsp_implementations<CR>",   { desc = "Telescope find all implementations of interfaces using LSP"})
map("n", "<leader>tdg", "<cmd>Telescope diagnostics<CR>",           { desc = "Telescope code disagnostics using LSP"})
map("n", "<leader>tds", "<cmd>Telescope lsp_document_symbols<CR>",  { desc = "Telescope list all symbols in current file using LSP"})
map("n", "<leader>tdS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Telescope find symbols across your entire project using LSP"})
map("n", "<leader>tgd", "<cmd>Telescope lsp_definitions<CR>",       { desc = "Telescope go to definition using LSP"})
map("n", "<leader>tca", "<cmd>lua vim.lsp.buf.code_action()<CR>",   { desc = "Telescope suggested code action using LSP"})

map("n", "<leader>:",   function() require("telescope.builtin").commands() end, { desc = "Telescope command view" })

-- Tab navigation
map("n", "<leader>{" , "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>}" , "<cmd>tabnext<CR>", { desc = "Next tab" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Set relative line number
map("n", "<leader>rnl", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- Use F8 to toggle symbols outline
map("n", "<F2>", "<cmd>SymbolsOutline<CR>", { desc = "Toggle symbols outline" })

-- Use F3 to switch source/header
map("n", "<F3>", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Source/Header Toggle" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
