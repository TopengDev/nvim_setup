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

local root = vim.fn.getcwd()

local sources = {
  null_ls.builtins.formatting.prettier
}

if has_eslint_config(root) then
  table.insert(sources, require("none-ls.diagnostics.eslint"))
  table.insert(sources, require("none-ls.code_actions.eslint"))
end

null_ls.setup({
  debug = false,
  log_level = "warn",
  sources = sources,
  on_attach = function(client, bufnr)
    -- Format on save disabled to prevent performance issues
    -- To manually format, use :lua vim.lsp.buf.format()
  end
})

