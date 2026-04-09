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
