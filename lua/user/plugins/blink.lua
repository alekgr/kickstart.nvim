return {
  'saghen/blink.cmp',
  -- Optional: adds icons to the completion menu
  dependencies = 'rafamadriz/friendly-snippets',

  -- Use a release tag to ensure stability
  version = '*',

  -----@module 'blink.cmp'
  -----@type    blink.cmp.Config
  opts = {
    -- 'default' for built-in, 'super-tab' for a common alternative
    completion = {
	    menu = {
		    auto_show = true,
		    border = 'rounded',

   },
    snippets = {
	present = 'default',
    },
    keymap = {
	    preset = 'default',
	    ['<CR>'] = { 'accept', 'fallback' },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's groups
      -- Useful if your colorscheme doesn't support blink.cmp yet
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      nerd_font_variant = 'mono'
    },

    -- Default list of enabled providers
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { "sources.default" }
  }
}
