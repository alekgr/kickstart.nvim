return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true, -- Enables a transparent background
    styles = {
      -- You can also make specific UI elements transparent
      sidebars = "transparent", -- e.g., NvimTree, symbols-outline
      floats = "transparent",   -- e.g., Telescope, hover windows
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}

