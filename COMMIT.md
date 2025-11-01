# Commit Message

## Major improvements to LSP, plugins, and configuration stability

### LSP Enhancements
- **Fixed LSP loading issues**: Replaced conditional project detection with proper `root_dir` pattern matching that searches up directory tree
- **Expanded LSP keybindings**: Added hover (K), references (gr), rename (<leader>rn), code actions (<leader>ca), format (<leader>fm), diagnostics navigation ([d, ]d), and more
- **Added language servers**: Lua LSP (lua_ls) for Neovim config editing, Markdown LSP (marksman)
- **Auto-install servers**: Added ensure_installed list for ts_ls, eslint, tailwindcss, gopls, pyright, lua_ls, dockerls, marksman
- **Utility commands**: Added :LspRestart and :LspLog for troubleshooting
- **Suppressed deprecation warnings**: Filtered lspconfig Neovim 0.11+ warnings via vim.notify/vim.deprecate overrides

### UI & Status Line
- **Enabled lualine**: Clean status line with git branch, diagnostics, file info, auto-adapting theme
- **Enhanced treesitter**: Added parsers for json, yaml, toml, markdown, bash, dockerfile, vim, vimdoc, regex
- **Fallback syntax**: Enabled built-in syntax highlighting when treesitter parsers unavailable

### Plugins & Features
- **Added toggleterm**: Terminal integration with <C-t> toggle, floating/horizontal/vertical modes
- **Switched to Glow**: Replaced buggy markdown-preview.nvim with terminal-based glow.nvim
- **Fixed LuaSnip**: Made build step conditional, auto-loads VSCode snippets
- **Removed image.nvim**: Eliminated buggy image preview functionality and dependencies

### File Management
- **Telescope improvements**: Added --no-ignore flag to include git-ignored files in search
- **Cleaned up config**: Removed unused telescope.lua and nvmtree.lua files

### Bug Fixes
- Fixed white text issue caused by LSP not loading when opening files in subdirectories
- Fixed LuaSnip build failures with conditional make check
- Fixed markdown-preview.nvim build errors by switching to Glow
- Removed tmux image passthrough settings

---

**Files Changed:**
- lua/config/lsp.lua (major refactor)
- lua/plugins.lua (lualine, toggleterm, glow, removed image.nvim)
- lua/config/treesitter.lua (expanded parsers)
- init.lua (LSP commands, syntax fallback, removed viu binding)
- .tmux.conf (reverted image passthrough)
- Deleted: lua/config/telescope.lua, lua/config/nvmtree.lua

**Key Improvements:**
✅ Reliable LSP loading in any project structure
✅ Comprehensive LSP workflow keybindings
✅ Better visual feedback with lualine
✅ Clean terminal integration
✅ No more startup errors or deprecation warnings
