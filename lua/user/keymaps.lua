--vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- terminal commands
vim.keymap.set('n', '<leader>tt', '<CMD>terminal<CR>')
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

--quit before making writting changes
vim.keymap.set('n', '<leader>qw', '<CMD>wq!<CR>', { desc = 'quit nvim', silent = false, noremap = true } )

--quit  with out making any changes
vim.keymap.set('n', '<leader>qq', '<CMD>q!<CR>', { desc = 'quit nvim', silent = false, noremap = true } )

--quickfix
vim.keymap.set('n', '<leader>co', '<CMD>copen<CR>', { desc = 'open quickfix window', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cx', '<CMD>cclose<CR>', { desc = 'close quickfix window', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cn', '<CMD>cn<CR>', { desc = 'go to quickfix next item', silent = false, noremap = true })
vim.keymap.set('n', '<leader>cp', '<CMD>cp<CR>', { desc = 'go to quickfix previous item', silent = false, noremap = true })

-- when moving page down also put the cursor in middle
vim.keymap.set('n', '<C-u>','<C-u>zz')
vim.keymap.set('n', '<C-d>','<C-d>zz')

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

-- when opening terminal remove numbers 
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'remove numbers in terminal mode',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Small terminal 
vim.keymap.set('n', '<leader>st', function()

    if vim.bo.buftype == 'terminal' then
	    vim.cmd('vsplit | terminal')
    else
	    vim.cmd('botright 20split | terminal')
    end


    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd('startinsert')
  --vim.api.nvim_win_set_height(0, 20)
end)

-- lsp commands
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    -- 1. Generic Keybinds
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- 2. Generic Completion (v0.11 native)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

local my_lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = my_lsp_group,
	pattern = { 'c','h'},
	callback = function()
		vim.bo.commentstring = '/* %s */'
	end,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>ee', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
--vim.keymap.set('n', '<leader>ee', vim.diagnostic.setqflist(), { desc = 'Open errors in
