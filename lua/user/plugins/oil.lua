require("oil").setup({
  -- Optional: configuration goes here
  -- If you leave it empty, it uses the defaults
  columns = {
	  'icon',
	  'permissions',
	  'size',
	  'mtime'
  },
  default_file_explorer = true,
  view_options = {
    show_hidden = true, -- Show dotfiles by default
  },
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open oil' })
