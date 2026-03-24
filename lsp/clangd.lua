return {
  cmd = {
    'clangd',
    '--background-index',
    '--query-driver=/usr/bin/gcc,/usr/bin/g++',
    '--completion-style=detailed',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
  -- This runs whenever clangd attaches to a buffer
  on_attach = function(client, bufnr)
    -- Enable native auto-completion for this buffer
    if client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
    -- You can also put clangd-specific keymaps here
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
}
