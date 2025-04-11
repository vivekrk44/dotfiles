local ui_config = {
  icons = { expanded = "🞃", collapsed = "🞂", current_frame = "→" },
  controls = {
    icons = {
      pause = "⏸",
      play = "⯈",
      step_into = "↴",
      step_over = "↷",
      step_out = "↑",
      step_back = "↶",
      run_last = "🗘",
      terminate = "🕱",
      disconnect = "⏻"
    }
  }
}
require("dapui").setup(ui_config)
