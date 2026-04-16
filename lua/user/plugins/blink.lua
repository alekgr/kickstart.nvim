require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    -- Use C-y for intentional selection
    ['<C-y>'] = { 'select_and_accept' , 'fallback' },
    -- Manual menu trigger
    ['<C-s>'] = { 'show' , 'fallback' },
    -- Tab handles jumping through snippets or selecting items
    ['<Tab>'] = { 'snippet_forward', 'select_and_accept', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback'},
    -- Enter is for new lines only (safe mode)
    ['<CR>'] =  { 'fallback' },
    -- Menu navigation
    ['<C-n>'] = { 'select_next' ,'fallback'},
    ['<C-p>'] = { 'select_prev', 'fallback'}
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lsp = {
        score_offset = 100,
        -- FIX: Demote Constants/Macros so they don't clutter the top of the list
        transform_items = function(_, items)
          for _, item in ipairs(items) do
	    local kind = item.kind
            if kind == vim.lsp.protocol.CompletionItemKind.Constant or
               kind == vim.lsp.protocol.CompletionItemKind.Macro or
	       kind == vim.lsp.protocol.CompletionItemKind.EnumMember or
               kind == vim.lsp.protocol.CompletionItemKind.Field then
              item.score_offset = item.score_offset - 300
            end
          end
          return items
        end,
      },
      snippets = {
        score_offset = -100,
        -- Your custom snippet logic for 'def'
        transform_items = function(ctx, items)
          local keyword = ctx.get_keyword()
          if keyword == 'def' then
            return vim.tbl_filter(function(item)
              return item.label == 'def'
            end, items)
          end
          return items
        end,
        opts = {
          search_paths = {
            '/home/alek/.local/share/nvim12/site/pack/plugins/start/friendly-snippets'
          }
        }
      },
    }
  },

  completion = {
    list = {
      -- auto_insert = false ensures C-n doesn't jump your cursor
      selection = { preselect = true, auto_insert = false }
    },
    accept = {
      -- Disables automatic () to prevent "snipping stuff" on plain functions
      auto_brackets = { enabled = false }
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    menu = {
      auto_show = true,
      border = 'rounded',
      draw = {
        padding = 0,
        gap = 1,
        columns = {
          { 'kind_icon' }, { 'label', 'label_description', gap = 1 },
        },
        components = {
          label = {
            width = { fill = false, max = 40 },
          },
        },
      }
    },
    -- Stops 'sse' from matching 'assert'
    keyword = { range = 'prefix' },
  },

  snippets = { preset = 'default' }
})
