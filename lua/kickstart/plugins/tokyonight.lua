return {
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = {
      style = 'night',
      styles = {
        sidebars = 'dark',
        floats = 'dark',
      },
      sidebars = { 'qf' },
    },
  },
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    config = {
      extra_groups = {
        'FloatBorder',
        'LSPInfoBorder',
        'NeoTreeNormal',
        'NeoTreeNormalNC',
        'NormalFloat',
        'NotifyDEBUGBody',
        'NotifyDEBUGBorder',
        'NotifyERRORBody',
        'NotifyERRORBorder',
        'NotifyINFOBody',
        'NotifyINFOBorder',
        'NotifyTRACEBody',
        'NotifyTRACEBorder',
        'NotifyWARNBody',
        'NotifyWARNBorder',
        'TelescopeBorder',
        'TelescopePreviewNormal',
        'TelescopePromptNormal',
        'TelescopeResultsNormal',
        'WhichKeyFloat',
      },
      exclude_groups = {},
    },
    keys = {
      {
        '<Leader>ut',
        '<Cmd>TransparentToggle<Cr>',
        desc = 'Toggle Transparency',
      },
    },
  },
}
