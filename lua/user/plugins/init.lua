vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require ("user.plugins.tokyonight")

vim.pack.add({ 
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
