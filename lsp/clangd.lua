vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }
    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    
    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f',  function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

-- 2. Clangd Configuration Table
-- You can return this from a file or pass it directly to your LSP setup function
return {
  cmd = {
    "clangd",
    "--background-index",
    -- UNIVERSAL FORMATTING: 4-space indents, 80 char limit, C89 standard
    "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, ColumnLimit: 80, Standard: C89}",
    "--query-driver=/usr/bin/gcc",
    "--header-insertion=never",
    "--clang-tidy",
    "--function-arg-placeholders=0", -- Kills snippets at the source
          -- Forces C89 logic/diagnostics
  },

  init_options = {
	  fallbackFlags = { "-std=c89", "-pedantic-errors"}
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git', 'makefile', 'Makefile' },
  capabilities = require('blink.cmp').get_lsp_capabilities({
    offsetEncoding = { "utf-16" },
    textDocument = {
      completion = {
        completionItem = {
          -- Tell the server we don't want snippets
          snippetSupport = false
        }
      }
    }
  }),

  -- Native 0.12+ on_attach behavior
  on_attach = function(client, bufnr)
    -- This handles the internal buffer management for the LSP
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end,
}
