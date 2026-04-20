vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp", "lua" },
  callback = function()
    -- Start native highlighting
    vim.treesitter.start()

    local opts = { buffer = true, silent = true }

    -- DYNAMIC PATH LOGIC: Works on nvim12 or nvim master automatically
    local data_path = vim.fn.stdpath('data')
    local plugin_root = data_path .. "/site/pack/plugins/start/nvim-treesitter-textobjects/lua"
    
    if not string.find(package.path, plugin_root) then
        package.path = package.path .. ";" .. plugin_root .. "/?.lua"
    end

    -- Load move module (Using DASH name to prevent 'shared' module errors)
    local ok, ts_move = pcall(require, 'nvim-treesitter-textobjects.move')

    if ok then
        -- Directional Jumping (Normal Mode)
        vim.keymap.set('n', ']f', function() ts_move.goto_next_start('@function.outer') end, opts)
        vim.keymap.set('n', '[f', function() ts_move.goto_previous_start('@function.outer') end, opts)
        vim.keymap.set('n', ']]', function() ts_move.goto_next_start('@class.outer') end, opts)
        vim.keymap.set('n', '[[', function() ts_move.goto_previous_start('@class.outer') end, opts)
        vim.keymap.set('n', ']a', function() ts_move.goto_next_start('@parameter.inner') end, opts)
        vim.keymap.set('n', '[a', function() ts_move.goto_previous_start('@parameter.inner') end, opts)
    end

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
  local ext = file:match("^.+(%..+)$")
  if not ext then return end
  ext = ext:sub(2)
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
function _G.get_treesitter_context()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return "" end
  while node do
    if node:type() == "function_definition" or node:type() == "class_definition" then
      local name_node = node:child(1)
      if name_node then
        return "  " .. vim.treesitter.get_node_text(name_node, 0) .. " "
      end
    end
    node = node:parent()
  end
  return ""
end
