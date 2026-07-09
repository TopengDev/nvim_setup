-- nvim-treesitter main branch config (Neovim 0.12+)
-- Native vim.treesitter highlighting replaces the old configs.setup() highlight module.
-- incremental_selection dropped: no main-branch equivalent and the minimal reimplementation
-- via vim.treesitter.get_node() is non-trivial with multi-byte edge cases. Known delta vs master.

require("nvim-treesitter").setup({})

-- Install / ensure parsers present (async; safe to call on every startup - skips already-installed)
require("nvim-treesitter").install({
  "typescript", "tsx", "javascript", "html", "css", "lua", "go", "php", "python",
  "java", "c", "cpp", "solidity", "json", "yaml", "toml", "markdown", "markdown_inline",
  "bash", "dockerfile", "vim", "vimdoc", "regex", "query",
})

-- Explicit filetype -> parser registrations for cases where nvim filetype name differs.
-- nvim-treesitter main registers these on install, but explicit registration is defensive.
vim.treesitter.language.register("tsx", "typescriptreact")
vim.treesitter.language.register("bash", "sh")

-- Enable native highlighting + folding per FileType.
-- pcall(vim.treesitter.start) silently skips filetypes with no installed parser.
-- Folding is only applied when highlighting successfully attached.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if ok then
      local buf = vim.api.nvim_get_current_buf()
      if vim.treesitter.highlighter.active[buf] then
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldlevel = 99
        vim.wo.foldenable = true
      end
    end
  end,
})

-- nvim-ts-autotag works against vim.treesitter directly on main branch.
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  per_filetype = {
    ["html"] = { enable_close = true },
    ["typescript"] = { enable_close = true },
    ["typescriptreact"] = { enable_close = true },
    ["tsx"] = { enable_close = true },
    ["javascript"] = { enable_close = true },
    ["javascriptreact"] = { enable_close = true },
  },
})
