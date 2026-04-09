 require("blink.cmp").setup({
  completion = {
    menu = {
      -- Add a border around the whole menu if you haven't already
      border = "rounded",
      draw = {
        -- 1. Define the layout of your columns
        columns = {
          { "kind_icon" }, 
          { "vertical_bar" }, -- Your custom separator
          { "label", "label_description", gap = 1 }, 
        },
        -- 2. Define what the 'vertical_bar' actually looks like
        components = {
          vertical_bar = {
            text = function() return "│" end, -- Use a box-drawing character
            highlight = "BlinkCmpMenuBorder", -- Use your theme's border color
          },
        },
      },
    },
  },
})                                                                                              
