


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
require("config.autopairs")
require("config.lsp")
require("config.none-ls")
require("config.treesitter")
require("config.cmp")

-- Live preview colorschemes
vim.keymap.set("n", "<leader>cs", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true, -- 👈 preview instantly when moving the cursor
  })
end, { desc = "Pick Colorscheme (live preview)" })


vim.cmd.colorscheme("kanagawa")


-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- Transparent line number background
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })


-- LSP utility commands
vim.api.nvim_create_user_command("LspRestart", function()
  vim.cmd("LspStop")
  vim.defer_fn(function()
    vim.cmd("edit") -- Reload buffer to trigger LSP
  end, 100)
end, { desc = "Restart LSP for current buffer" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("edit " .. vim.lsp.get_log_path())
end, { desc = "Open LSP log file" })

-- Show absolute line numbers
vim.wo.number = true

vim.wo.cursorline = true -- highlight current line


-- Show relative line numbers (optional, good for motions like 5j/5k)
-- vim.wo.relativenumber = true

-- Find files (like Ctrl+P in VSCode)
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { silent = true })

-- Search in files (like Ctrl+Shift+F)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true })

-- Show open buffers
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true })

-- Recently opened files
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { silent = true })

-- Treesitter-based folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- so folds are open by default

-- Toggle comment shortcut
vim.keymap.set("n", "<C-/>", "gcc", { remap = true }) -- Ctrl+/ in normal
vim.keymap.set("v", "<C-/>", "gc", { remap = true })  -- Ctrl+/ in visual

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

-- Error popup on hover
vim.o.updatetime = 500
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Normal mode: Alt+Down moves current line down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
-- Normal mode: Alt+Up moves current line up
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Insert mode: Alt+Down moves current line down
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
-- Insert mode: Alt+Up moves current line up
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })

-- Visual mode: Alt+Down moves selection down
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
-- Visual mode: Alt+Up moves selection up
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
