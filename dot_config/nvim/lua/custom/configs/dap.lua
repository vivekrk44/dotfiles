local dap = require("dap")
local dapui = require("dapui")
-- local ui_config = {
--   icons = { expanded = "🞃", collapsed = "🞂", current_frame = "→" },
--   controls = {
--     icons = {
--       pause = "⏸",
--       play = "⯈",
--       step_into = "↴",
--       step_over = "↷",
--       step_out = "↑",
--       step_back = "↶",
--       run_last = "🗘",
--       terminate = "🕱",
--       disconnect = "⏻"
--     }
--   }
-- }
-- dapui.setup(ui_config)
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  print("[dapui] Start event received")
  dapui.open()
end
dap.listeners.after.disconnect["dapui_config"] = function()
  print("[dapui] Disconnected event received")
  dapui.close()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
  print("[dapui] Terminated event received")
  dapui.close()
end

for event_name, _ in pairs(dap.listeners.after) do
  dap.listeners.after[event_name]["debugger_log"] = function(session, body)
    print("[DAP EVENT after]", event_name)
  end
end
