local servers = { "clangd", "lua-language-server", "pyright"}


require ("mason").setup()

local mr = require("mason-registry")
for _, tool in ipairs(servers) do
  local p = mr.get_package(tool)
  if not p:is_installed() then
    p:install()
  end
end
