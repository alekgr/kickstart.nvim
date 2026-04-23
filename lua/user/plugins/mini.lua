vim.keymap.set({ 'x', 'o' }, 'an', '<Nop>')
vim.keymap.set({ 'x', 'o' }, 'in', '<Nop>')

-- 2. SETUP BASIC MODULES
require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.comment').setup()

local statusline = require('mini.statusline')
statusline.setup({ use_icons = vim.g.have_nerd_font })
statusline.section_location = function() return '%2l:%-2v' end

-- 3. SETUP MINI.AI
local ai = require('mini.ai')
ai.setup({
  custom_textobjects = {
    -- 'a' for Argument: The "Greedy Space" Pattern
    -- This captures: [content] + [optional comma] + [any number of spaces]
    a = { 
      '().-()%,?%s*()', 
      '^%s*(.-)%s*$' 
    },
    
    -- 'f' for Function: Uses Treesitter
    f = ai.gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),

    -- 'c' for Class/Struct: Uses Treesitter
    c = ai.gen_spec.treesitter({
      a = '@class.outer',
      i = '@class.inner',
    }),
  },
  
  mappings = {
    around = 'a',
    inside = 'i',
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',
  },
  
  n_lines = 50,
})
