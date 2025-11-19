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
    null_ls.builtins.formatting.prettier,
    -- Conditionally enable eslint based on project root detection
    require("none-ls.diagnostics.eslint").with({
      condition = function(utils)
        return utils.root_has_file(eslint_config_files)
      end,
    }),
    require("none-ls.code_actions.eslint").with({
      condition = function(utils)
        return utils.root_has_file(eslint_config_files)
      end,
    }),
  },
  on_attach = function(client, bufnr)
    -- Format on save disabled to prevent performance issues
    -- To manually format, use :lua vim.lsp.buf.format()
  end
})

