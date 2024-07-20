-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

---[[ - ]]- -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- -- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- -- is not what someone will guess without a bit more experience.
-- --
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
-- -- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- -- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --
-- --  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', 'bn', '<CMD>bNext<CR>', { desc = 'Next buffer', silent = true, noremap = true })
vim.keymap.set('n', 'bp', '<CMD>bprev<CR>', { desc = 'Prev buffer', silent = true, noremap = true })
vim.keymap.set('n', 'bl', '<CMD>ls<CR>', { desc = 'List buffers', silent = true, noremap = true })
vim.keymap.set('n', 'bd', '<CMD>bd<CR>', { desc = 'Delete buffer', silent = true, noremap = true })

--saving
vim.keymap.set('n', '<leader>w', '<CMD>w<CR>', { desc = 'save a file', silent = false, noremap = true })

--quickfix
vim.keymap.set('n', '<leader>co', '<CMD>copen<CR>', { desc = 'open quickfix window', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cx', '<CMD>cclose<CR>', { desc = 'close quickfix window', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cn', '<CMD>cn<CR>', { desc = 'go to quickfix next item', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cp', '<CMD>cp<CR>', { desc = 'go to quickfix previous item', silent = false, noremap = true })

-- -- [[ Basic Autocommands ]]
-- --  See `:help lua-guide-autocommands`
--
-- -- Highlight when yanking (copying) text
-- --  Try it with `yap` in normal mode
-- --  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
