require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- Custom width
        width = 0.8,
        -- Custom previewer
        previewer = false,
        -- Custom mappings
        mappings = {
          -- Custom key mappings here
        }
      })
    }
  }
})

-- load the extenstion
require("telescope").load_extension("ui-select")
