return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    view_options = {
      show_hidden = true,
    },
  },
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open oil' }),
}
