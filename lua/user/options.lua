vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = ''

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = 'eol:\\x23'

--  tab = '│─',
--  multispace = 'space',
-- lead = 'space',--  trail = 'space',

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 0

vim.opt.shortmess:append 'c'

-- turn on highlighting 
vim.opt.hlsearch = true

vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }

vim.g_c_syntax_for_h = 1

vim.filetype.add({
	extension = {
		h = 'c',
	}
})

-- Create a single group to manage all folding autocmds
local fold_group = vim.api.nvim_create_augroup("UniversalFolding", { clear = true })

vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
    group = fold_group,
    callback = function(args)
        -- 1. Ensure the buffer is valid
        if not vim.api.nvim_buf_is_valid(args.buf) then return end

        -- 2. Determine folding method (Treesitter vs. Indent)
        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)

        if ok and parser then
            -- High-accuracy folding for Python, C, C++, Lua, Bash, etc.
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
            -- Reliable fallback for languages without a TS parser
            vim.wo.foldmethod = "indent"
        end

        -- 3. Folding Preferences
        vim.wo.foldlevel = 99    -- Start with all folds open
        vim.wo.foldenable = true -- Ensure folding is turned on
        vim.wo.foldminlines = 0  -- Allow folding even 1-line functions

        -- 4. Initial "Poke" (Only runs ONCE per buffer to avoid cursor lag)
        if not vim.b[args.buf].folded_once then
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                    -- Re-calculates folds without moving the cursor while you type
                    vim.cmd("normal! zx")
                    vim.b[args.buf].folded_once = true
                end
            end)
        end
    end,
})
