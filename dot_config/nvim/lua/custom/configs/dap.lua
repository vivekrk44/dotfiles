local dap = require("dap")
local dapui = require("dapui")
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
