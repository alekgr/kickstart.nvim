-- =============================================================================
-- 1. TREESITTER & NATIVE MOTIONS
-- =============================================================================
-- We skip require('nvim-treesitter.configs').setup() for 0.12 native core logic

-- Attach buffer-local keymaps and start parser automatically
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp", "lua" },
  callback = function()
    -- Native 0.12 command to start Treesitter highlighting
    vim.treesitter.start()

    -- Helper for sniper selections (af, if, ac)
    local function select_node_by_type(types)
      local node = vim.treesitter.get_node()
      if not node then return end
      while node do
        if vim.tbl_contains(types, node:type()) then
          local s_row, s_col, e_row, e_col = node:range()
          vim.cmd([[exe "normal! \<Esc>"]]) -- Reset selection anchors
          vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
          vim.cmd("normal! v")
          vim.api.nvim_win_set_cursor(0, { e_row + 1, math.max(0, e_col - 1) })
          return
        end
        node = node:parent()
      end
    end

    -- Sniper mappings (Around/Inside Function and Class)
    local opts = { buffer = true, silent = true }
    vim.keymap.set({ "x", "o" }, "af", function() select_node_by_type({ "function_definition", "declaration" }) end, opts)
    vim.keymap.set({ "x", "o" }, "if", function() select_node_by_type({ "compound_statement", "block" }) end, opts)
    vim.keymap.set({ "x", "o" }, "ac", function() select_node_by_type({ "struct_specifier", "class_specifier" }) end, opts)
  end,
})

-- =============================================================================
-- 2. C SOURCE/HEADER SWITCHER
-- =============================================================================
local function switch_source_header()
  local file = vim.api.nvim_buf_get_name(0)
  local utils = { c = "h", cpp = "hpp", h = "c", hpp = "cpp" }
  local ext = file:match("^.+(%..+)$"):sub(2)
  local target_ext = utils[ext]

  if target_ext then
    local target_file = file:gsub("%." .. ext .. "$", "." .. target_ext)
    if vim.fn.filereadable(target_file) == 1 then
      vim.cmd("edit " .. target_file)
    else
      print("No matching ." .. target_ext .. " file found")
    end
  end
end
vim.keymap.set("n", "<leader>a", switch_source_header, { desc = "Switch C Source/Header" })

-- =============================================================================
-- 3. NATIVE WINBAR (v0.12 Context Fix)
-- =============================================================================
-- We define the function globally so the winbar can access it via v:lua
function _G.get_treesitter_context()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return "" end
  while node do
    if node:type() == "function_definition" or node:type() == "class_definition" then
      -- Get child(1) which is usually the name/identifier node
      local name_node = node:child(1)
      if name_node then
        return "  " .. vim.treesitter.get_node_text(name_node, 0) .. " "
      end
    end
    node = node:parent()
  end
  return ""
end
