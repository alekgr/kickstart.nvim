local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then return end

gitsigns.setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  -- Useful keymaps
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Jump to next/previous change
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Next Change" })

    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Prev Change" })

    -- Preview the change in a floating window
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview Change" })
  end
})
