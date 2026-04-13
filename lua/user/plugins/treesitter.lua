local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

configs.setup({
  -- A list of parser names, or "all"
  ensure_installed = { "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true, -- This is what makes TokyoNight look amazing
    additional_vim_regex_highlighting = true,
  },
  
  indent = {
    enable = true -- Better indentation based on code structure
  },
})
