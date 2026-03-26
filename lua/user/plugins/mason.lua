return {
  -- 1. The core manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      -- CRITICAL: Add Mason's bin to PATH so native vim.lsp can find the binaries
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
    end,
  },

  -- 2. The automatic installer (replaces the old mason-lspconfig's ensure_installed)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "lua-language-server", -- Note the Mason registry name!
	"pyright",
      },
    },
  },
}
