


-- Performance optimizations
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Set leader key before loading plugins
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Faster startup
vim.loader.enable()

-- Enable syntax highlighting and filetype detection
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

require("config.lazy")
require("plugins")

-- Live preview colorschemes
vim.keymap.set("n", "<leader>cs", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true, -- 👈 preview instantly when moving the cursor
  })
end, { desc = "Pick Colorscheme (live preview)" })


vim.cmd.colorscheme("kanagawa")


-- Transparent background — re-applied on EVERY colorscheme change so themery /
-- the live <leader>cs picker / any :colorscheme don't wipe the transparency.
local function apply_transparency()
  for _, group in ipairs({
    "Normal", "NormalNC", "NormalFloat", "SignColumn",
    "EndOfBuffer", "LineNr", "CursorLineNr", "FoldColumn",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })
apply_transparency()


-- LSP utility commands
-- Override the built-in LspRestart to handle null-ls properly
vim.api.nvim_create_user_command("LspRestart", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    print("No LSP clients attached to this buffer")
    return
  end

  local restarted = {}
  for _, client in ipairs(clients) do
    -- Skip null-ls/none-ls as it's managed differently
    if client.name ~= "null-ls" then
      vim.lsp.stop_client(client.id, true)
      table.insert(restarted, client.name)
    end
  end

  if #restarted > 0 then
    vim.defer_fn(function()
      vim.cmd("edit") -- Reload buffer to trigger LSP
      print("Restarted: " .. table.concat(restarted, ", "))
    end, 100)
  else
    print("No LSP servers to restart (only null-ls attached)")
  end
end, { desc = "Restart LSP for current buffer", force = true })

-- Alternative command that doesn't use LspStop
vim.api.nvim_create_user_command("LspRestartAll", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id, true)
  end

  vim.defer_fn(function()
    vim.cmd("edit")
    print("All LSP clients restarted")
  end, 200)
end, { desc = "Restart all LSP clients (including null-ls)" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("edit " .. vim.lsp.get_log_path())
end, { desc = "Open LSP log file" })

-- Comprehensive buffer recovery command
vim.api.nvim_create_user_command("FixBuffer", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  print("Fixing buffer...")

  -- 1. Stop all LSP clients for this buffer (except null-ls)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" then
      vim.lsp.stop_client(client.id)
    end
  end

  -- 2. Stop native treesitter highlighting for this buffer
  pcall(vim.treesitter.stop, bufnr)

  -- 3. Clear completion state
  local has_cmp, cmp = pcall(require, "cmp")
  if has_cmp then
    cmp.setup.buffer({ enabled = false })
  end

  -- 4. Reload the buffer
  vim.defer_fn(function()
    vim.cmd("edit!")

    -- 5. Restart native treesitter highlighting
    pcall(vim.treesitter.start, bufnr)

    -- 6. Re-enable completion
    if has_cmp then
      cmp.setup.buffer({ enabled = true })
    end

    -- 7. Force syntax sync
    vim.cmd("syntax sync fromstart")

    -- Restore cursor position
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)

    print("Buffer fixed! LSP and treesitter restarted.")
  end, 200)
end, { desc = "Fix broken buffer (restart LSP, treesitter, completion)" })

-- Show absolute line numbers
vim.opt.number = true
vim.opt.cursorline = true -- highlight current line

-- Show relative line numbers (optional, good for motions like 5j/5k)
-- vim.opt.relativenumber = true

-- Toggle comment shortcut
vim.keymap.set("n", "<C-/>", "gcc", { remap = true }) -- Ctrl+/ in normal
vim.keymap.set("v", "<C-/>", "gc", { remap = true })  -- Ctrl+/ in visual

-- Word navigation with Ctrl+Left/Right
vim.keymap.set("n", "<C-Left>", "b", { noremap = true, silent = true })  -- Move to beginning of word
vim.keymap.set("n", "<C-Right>", "e", { noremap = true, silent = true }) -- Move to end of word
vim.keymap.set("i", "<C-Left>", "<C-o>b", { noremap = true, silent = true })  -- Move to beginning of word in insert mode
vim.keymap.set("i", "<C-Right>", "<C-o>e<C-o>a", { noremap = true, silent = true }) -- Move to end of word in insert mode
vim.keymap.set("v", "<C-Left>", "b", { noremap = true, silent = true })  -- Move to beginning of word in visual mode
vim.keymap.set("v", "<C-Right>", "e", { noremap = true, silent = true }) -- Move to end of word in visual mode

-- Move 5 lines up/down with Ctrl+Up/Down
-- Set after plugins load to override vim-visual-multi
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.keymap.set("n", "<C-Up>", "5k", { noremap = true, silent = true, desc = "Move 5 lines up" })
    vim.keymap.set("n", "<C-Down>", "5j", { noremap = true, silent = true, desc = "Move 5 lines down" })
    vim.keymap.set("i", "<C-Up>", "<C-o>5k", { noremap = true, silent = true, desc = "Move 5 lines up" })
    vim.keymap.set("i", "<C-Down>", "<C-o>5j", { noremap = true, silent = true, desc = "Move 5 lines down" })
    vim.keymap.set("v", "<C-Up>", "5k", { noremap = true, silent = true, desc = "Move 5 lines up" })
    vim.keymap.set("v", "<C-Down>", "5j", { noremap = true, silent = true, desc = "Move 5 lines down" })
  end,
})

-- Scroll view by 10 lines with Ctrl+Shift+Up/Down (cursor stays in place)
vim.keymap.set("n", "<C-S-Up>", "10<C-y>", { noremap = true, silent = true, desc = "Scroll view up 10 lines" })
vim.keymap.set("n", "<C-S-Down>", "10<C-e>", { noremap = true, silent = true, desc = "Scroll view down 10 lines" })
vim.keymap.set("i", "<C-S-Up>", "<C-o>10<C-y>", { noremap = true, silent = true, desc = "Scroll view up 10 lines" })
vim.keymap.set("i", "<C-S-Down>", "<C-o>10<C-e>", { noremap = true, silent = true, desc = "Scroll view down 10 lines" })
vim.keymap.set("v", "<C-S-Up>", "10<C-y>", { noremap = true, silent = true, desc = "Scroll view up 10 lines" })
vim.keymap.set("v", "<C-S-Down>", "10<C-e>", { noremap = true, silent = true, desc = "Scroll view down 10 lines" })

-- Also override paragraph motions { and } to not interfere
vim.keymap.set("n", "{", "{", { noremap = true, silent = true, desc = "Paragraph backward" })
vim.keymap.set("n", "}", "}", { noremap = true, silent = true, desc = "Paragraph forward" })

-- NORMAL mode: duplicate line up/down
vim.keymap.set("n", "<S-A-Up>", "yyP", { noremap = true, silent = true })
vim.keymap.set("n", "<S-A-Down>", "yyp", { noremap = true, silent = true })

-- VISUAL mode: duplicate selection
vim.keymap.set("v", "<S-A-Up>", "y`<Pgv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-A-Down>", "y`>pgv", { noremap = true, silent = true })

-- INSERT mode: temporarily leave insert, duplicate, and return
vim.keymap.set("i", "<S-A-Up>", "<Esc>yyPgi", { noremap = true, silent = true })
vim.keymap.set("i", "<S-A-Down>", "<Esc>yypgi", { noremap = true, silent = true })

-- Tab configs
-- Use spaces instead of tabs
vim.o.expandtab = true

-- Number of spaces a <Tab> counts for
vim.o.tabstop = 2

-- Number of spaces for auto-indent (e.g., pressing Enter)
vim.o.shiftwidth = 2

-- Use `shiftwidth` when pressing tab in insert mode
vim.o.softtabstop = 2

-- Error popup on hover (CursorHold). Guarded so it does NOT re-fire/flicker every
-- 500ms: skip if a floating window is already open, and only show diagnostics for
-- the symbol under the cursor (scope = "cursor").
vim.o.updatetime = 500
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        return -- a float is already open; don't stack / flicker
      end
    end
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end,
})

-- Move lines / selections up & down with Alt+Up/Down, re-indenting after the move.
-- Canonical `:m` (:move) mappings:
--   * `==` / `gv=gv` re-indent via the active indentexpr (fixes wrong indent after a move)
--   * visual mode uses the '< / '> marks (`:` auto-inserts '<,'>), so the cursor no
--     longer jumps to a random spot — the old custom version read stale marks
--   * no forced `redraw` and no stopinsert/startinsert bounce -> no stutter
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
