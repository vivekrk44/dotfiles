-- File: ~/.config/nvim/lua/config/copilot.lua

local M = {}

function M.setup()
  -- Load copilot only if node is available and version is compatible
  local node_ok, node_ver = pcall(vim.fn.system, "node --version")
  if not node_ok then
    vim.notify("Node.js not found. Copilot requires Node.js 18.0.0 or higher.", vim.log.levels.WARN)
    return
  end
  
  -- Check Node.js version
  if node_ok and node_ver then
    local version = string.match(node_ver, "v(%d+%.%d+%.%d+)")
    if version then
      local major = tonumber(string.match(version, "(%d+)%."))
      if major and major < 18 then
        vim.notify("Copilot requires Node.js 18.0.0 or higher. Current version: " .. version, vim.log.levels.WARN)
        return
      end
    end
  end

  -- Require and setup the copilot plugin
  local status_ok, copilot = pcall(require, "copilot")
  if not status_ok then
    vim.notify("Copilot plugin not found", vim.log.levels.WARN)
    return
  end

  copilot.setup({
    -- Copilot panel settings
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>"  -- Alt+Enter to open panel
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
      },
    },
    
    -- Copilot suggestion settings
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,  -- Debounce time in ms
      keymap = {
        accept = "<leader><Tab>",
        accept_word = "<leader><Tab>w",
        accept_line = "<leader><Tab>a",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    
    -- Filetypes to enable or disable copilot
    filetypes = {
      -- Enable for all filetypes
      ["*"] = true,
      
      -- Disable for specific filetypes if needed
      -- ["markdown"] = false,
      -- ["help"] = false,
      -- ["gitcommit"] = false,
      
      -- You can also override settings per filetype
      -- ["python"] = {
      --   suggestion = {
      --     enable = true,
      --     auto_trigger = true,
      --   }
      -- },
    },
    
    -- Copilot server options
    server_opts_overrides = {
      -- trace = "verbose",
      -- settings = {
      --   advanced = {
      --     listCount = 10,         -- Number of suggestions
      --     inlineSuggestCount = 3, -- Number of inline suggestions
      --   }
      -- },
    },
    
    -- Specify which paths/file patterns should be ignored
    -- copilot_node_command = 'node', -- Node.js version to use
  })
  
  -- Create commands to control Copilot
  vim.api.nvim_create_user_command("CopilotToggle", function()
    local suggestion = require("copilot.suggestion")
    if suggestion.is_auto_triggering() then
      suggestion.set_auto_trigger(false)
      vim.notify("Copilot auto-suggestion disabled", vim.log.levels.INFO)
    else
      suggestion.set_auto_trigger(true)
      vim.notify("Copilot auto-suggestion enabled", vim.log.levels.INFO)
    end
  end, {})
  
  -- Create key mappings for Copilot
  -- Toggle auto-suggestions with <leader>ct
  vim.keymap.set("n", "<leader>ct", ":CopilotToggle<CR>", { silent = true, noremap = true })
  
  -- Open Copilot panel with <leader>cp
  vim.keymap.set("n", "<leader>cp", function()
    local panel = require("copilot.panel")
    panel.open({})
  end, { silent = true, noremap = true })
end

return M
