return {
  "dimtion/guttermarks.nvim",
  event = { "BufReadPost", "BufNewFile" },
  -- Move your settings inside 'opts' so they actually get passed to setup
  opts = {
    local_mark = {
      enabled = true,
      sign = function(mark)
        return mark.mark
      end,
      priority = 100, -- Bump priority to stay above other signs
    },

    global_mark = {
	    enabled = true,
	    sign = function(mark)
		    return mark.mark
	    end,
    },
    -- Ensure common triggers are active
    autocmd_triggers = { "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" },
  },
  config = function(_, opts)
    local guttermarks = require("guttermarks")
    guttermarks.setup(opts)

  vim.api.nvim_set_hl(0, "GutterMarksLocal", { fg = "#89b4fa", bold = true })   -- Local marks (e.g., Blue)
  vim.api.nvim_set_hl(0, "GutterMarksGlobal", { fg = "#f38ba8", bold = true })  -- Global marks (e.g., Red)
  vim.api.nvim_set_hl(0, "GutterMarksSpecial", { fg = "#fab387" })

    -- Your manual 'm' remap for instant feedback
    vim.keymap.set("n", "m", function()
      local char = vim.fn.getcharstr()
      -- Ignore <Esc> or other non-character inputs
      if char:match("[%w]") then
        vim.cmd("normal! m" .. char)
        guttermarks.refresh()
      end
    end, { desc = "Set mark and refresh gutter immediately" })
  end,
}
