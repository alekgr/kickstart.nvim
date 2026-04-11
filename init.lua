vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.loaded_ruby_provider = 0
-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- load transparency before loading any plugins
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

require("user.options")
require("user.keymaps")
require("user.plugins")

vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Your transparency settings (keep these here too)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

    -- YOUR MARK COLORS (This is the important part)
    vim.api.nvim_set_hl(0, "GutterMarksGlobal", { fg = "#ff9e64", bold = true })
    vim.api.nvim_set_hl(0, "GutterMarksLocal", { fg = "#7aa2f7" })
  end,
})

-- Trigger it immediately for the current session
vim.cmd("colorscheme " .. vim.g.colors_name)

-- Force backtick and single quote to be native
vim.keymap.set('n', '`', '`', { noremap = true })
vim.keymap.set('n', "'", "'", { noremap = true })
