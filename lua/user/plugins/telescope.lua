local telescope = require('telescope')

telescope.setup({
  defaults = {
    -- Appearance
    prompt_prefix = " 🔍 ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    -- File ignoring
    file_ignore_patterns = { "node_modules", ".git/" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
  },
  pickers = {
    -- Specific settings for individual pickers
    find_files = {
      theme = "dropdown", -- "dropdown", "cursor", or "ivy"
      previewer = false,
    }
  },
  extensions = {
    -- Extension config goes here
  }
})

-- 3. Keymaps
local builtin = require('telescope.builtin')

-- Files and Text
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {desc = 'Telescope diagnostics' })
vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = 'Telescope [S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope [S]earch  current []W]ord' })
vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = "Telescope Marks"})
vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files(require('telescope.themes').get_dropdown {
        previewer = true,
        cwd = '~/notes',
        prompt_title = 'Notes',
      })
    end, { desc = 'Find notes' })


vim.keymap.set('n', '<leader>fc', function ()
	    require('telescope.builtin').find_files({
		    search_dirs = {
			    vim.fn.getcwd(),
			    vim.fn.stdpath("config")
		    },
		    hidden = true,
		    prompt_title = "Multi-directory Search",
	    })
    end, { desc = 'Telescope find files in home direcotries and inclding configs' })


vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
