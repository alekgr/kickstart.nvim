require('projectmarks').setup({
  shadafile = 'nvim.shada', -- Default local shada filename
})

require('guttermarks').setup({
  -- Ensure global marks (A-Z) are displayed
  global = true,
  special = true,
  highlight_groups = {
  GutterMarksGlobal = { fg = "#119e64" }, -- Change color to make them stand out
  },
  global_sign = "  ", -- Example: a document icon
  local_sign = "  ",  -- Example: a checkbox icon
  refresh_interval = 100,
})
