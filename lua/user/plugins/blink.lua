require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    -- Tab grabs the only remaining item (your snippet) and expands it
    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      snippets = {
        score_offset = 1000,
        -- THE FIX: If you type 'def', physically delete 'default' from the list
        transform_items = function(ctx, items)
          local keyword = ctx.get_keyword()
          if keyword == 'def' then
            return vim.tbl_filter(function(item)
              -- Hide anything that isn't exactly 'def'
              return item.label == 'def'
            end, items)
          end
          return items
        end,
        opts = {
          -- Absolute path for your nvim12 setup
          search_paths = { 
            '/home/alek/.local/share/nvim12/site/pack/plugins/start/friendly-snippets' 
          }
        }
      },
      lsp = { score_offset = -100 }
    }
  },

  completion = {
    list = {
      selection = { preselect = true, auto_insert = true }
    },
    -- Use 'prefix' range to stop 'sse' from matching 'assert'
    keyword = { range = 'prefix' }, 
  },

  snippets = { preset = 'default' }
})
