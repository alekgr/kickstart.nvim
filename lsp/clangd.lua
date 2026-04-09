return {
  cmd = {
    "clangd",
    "--background-index",
    "--fallback-style=LLVM",
    "--query-driver=/usr/bin/gcc",
    "--index-file=.cache/clangd/index.idx",
    "--header-insertion=never",
    "--clang-tidy"
      },
  init_options = {
	"--fallback-flags=-std=c89"
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git', 'makefile', 'Makefile'},
  capabilities = {
	  offsetEncoding = { "utf-16" },
  },
  -- This runs whenever clangd attaches to a buffer
  on_attach = function(client, bufnr)
    -- Enable native auto-completion for this buffer
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
    -- You can also put clangd-specific keymaps here
    local opts = { buffer = bufnr }
    --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
}
