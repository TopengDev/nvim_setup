local null_ls = require("null-ls")

local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  "package.json",
}

local function has_eslint_config(root_dir)
  for _, file in ipairs(eslint_config_files) do
    if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
      return true
    end
  end
  return false
end

-- Setup sources with conditional eslint based on project root
null_ls.setup({
  debug = false,
  log_level = "warn",
  sources = {
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "scss", "html", "json", "yaml", "markdown" },
    }),
    -- ESLint removed from none-ls (2026-06-18): it errored on every buffer change
    -- (none-ls/helpers/cache.lua:52 "attempt to index a nil value" with flat eslint
    -- configs) AND duplicated the eslint LSP (lspconfig.eslint). The eslint LSP now
    -- owns eslint diagnostics + code actions (and lints onSave). Running both on every
    -- change was a big contributor to the move/undo stutter + CPU/RAM spike.
  },
  on_attach = function(client, bufnr)
    -- Format on save disabled to prevent performance issues
    -- To manually format, use :lua vim.lsp.buf.format()
  end
})

