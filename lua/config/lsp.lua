-- mason & mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
  -- Only install servers that we detect are needed
  ensure_installed = {},
  automatic_installation = true,
})

-- Include cmp capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper functions for project detection
local function has_file(filename)
  return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. filename) == 1
end

local function has_dependency(package_name)
  local package_json = vim.fn.getcwd() .. "/package.json"
  if vim.fn.filereadable(package_json) == 1 then
    local content = vim.fn.readfile(package_json)
    local json_str = table.concat(content, "\n")
    return string.find(json_str, package_name) ~= nil
  end
  return false
end

local function is_js_ts_project()
  return has_file("package.json") or has_file("tsconfig.json") or has_file("jsconfig.json")
end

local function is_go_project()
  return has_file("go.mod") or has_file("go.sum")
end

local function is_solidity_project()
  return has_file("hardhat.config.js") or has_file("hardhat.config.ts") or
         has_file("truffle-config.js") or has_file("foundry.toml") or
         has_dependency("hardhat") or has_dependency("truffle")
end

local function is_tailwind_project()
  return has_file("tailwind.config.js") or has_file("tailwind.config.ts") or
         has_dependency("tailwindcss")
end

-- Shared on_attach logic
local on_attach = function(client, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true })
  end

  -- Disable tsserver formatting if using prettier/eslint_d
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- Keymaps
  bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
end

-- Setup language servers conditionally
local lspconfig = require("lspconfig")

-- TypeScript/JavaScript LSP - only for JS/TS projects
if is_js_ts_project() then
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = false,
  })

  -- ESLint - only if eslint config exists
  local eslint_configs = {".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml"}
  local has_eslint = false
  for _, config in ipairs(eslint_configs) do
    if has_file(config) then
      has_eslint = true
      break
    end
  end

  if has_eslint or has_dependency("eslint") then
    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end
end

-- TailwindCSS - only for projects using Tailwind
if is_tailwind_project() then
  lspconfig.tailwindcss.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- Go LSP - only for Go projects
if is_go_project() then
  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- Solidity LSP - only for Solidity projects
if is_solidity_project() then
  lspconfig.solidity_ls_nomicfoundation.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end