vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require ("user.plugins.tokyonight")

vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets"},
	{ src = "https://github.com/saghen/blink.cmp", version = "v1" }
})
require ("user.plugins.blink")

vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
require ("user.plugins.indent-blankline")

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require ("user.plugins.gitsigns")

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
require ("user.plugins.mini")

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter"})
require ("user.plugins.treesitter")

vim.pack.add({ "https://github.com/williamboman/mason.nvim"})
require ("user.plugins.mason")

vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-telescope/telescope.nvim'
})
require ("user.plugins.telescope")

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/stevearc/oil.nvim"
})
require ("user.plugins.oil")

vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',          -- The core debugger
  'https://github.com/rcarriga/nvim-dap-ui',           -- The graphical interface
  'https://github.com/nvim-neotest/nvim-nio',           -- Required dependency for dap-ui
  'https://github.com/theHamsta/nvim-dap-virtual-text'  -- Inline variable values
})
require ("user.plugins.debug")

vim.pack.add({
	"https://github.com/BartSte/nvim-project-marks",
	"https://github.com/dimtion/guttermarks.nvim"
})
require ("user.plugins.marks")
