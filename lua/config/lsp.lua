-- Suppress lspconfig deprecation warning for Neovim 0.11+
-- This warning is about the upcoming v3.0.0 API change, but lspconfig still works fine
local original_notify = vim.notify
local original_notify_once = vim.notify_once
local original_deprecate = vim.deprecate

vim.notify = function(msg, ...)
  if msg and type(msg) == "string" then
    if msg:match("lspconfig") or msg:match("deprecated") or msg:match("vim.lsp.config") or msg:match("framework") then
      return
    end
  end
  original_notify(msg, ...)
end

vim.notify_once = function(msg, ...)
  if msg and type(msg) == "string" then
    if msg:match("lspconfig") or msg:match("deprecated") or msg:match("vim.lsp.config") or msg:match("framework") then
      return
    end
  end
  original_notify_once(msg, ...)
end

-- Suppress vim.deprecate for lspconfig warnings
vim.deprecate = function(name, alternative, version, plugin, ...)
  -- Only suppress lspconfig-related deprecation warnings
  if plugin and plugin:match("lspconfig") then
    return
  end
  if name and name:match("lspconfig") then
    return
  end
  original_deprecate(name, alternative, version, plugin, ...)
end

-- mason & mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",        -- TypeScript/JavaScript
    "eslint",       -- ESLint
    "tailwindcss",  -- TailwindCSS
    "gopls",        -- Go
    "pyright",      -- Python
    "lua_ls",       -- Lua
    "dockerls",     -- Docker
    "marksman",     -- Markdown
  },
  automatic_installation = true,
})

-- Include cmp capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

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
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  bufmap("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  bufmap("v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  bufmap("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
  bufmap("v", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
  bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  bufmap("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>")
  bufmap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
end

-- TypeScript/JavaScript LSP
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  single_file_support = false,
})

-- ESLint
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "package.json"
  ),
})

-- TailwindCSS
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.ts",
    "tailwind.config.cjs",
    "postcss.config.js",
    "postcss.config.cjs"
  ),
})

-- Go LSP
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern("go.mod", "go.sum", ".git"),
})

-- Solidity LSP
lspconfig.solidity_ls_nomicfoundation.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(
    "hardhat.config.js",
    "hardhat.config.ts",
    "truffle-config.js",
    "foundry.toml",
    ".git"
  ),
})

-- Docker LSP
lspconfig.dockerls.setup({
  cmd = { "docker-langserver", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern("Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".git"),
})

-- Python LSP
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "poetry.lock",
    ".git"
  ),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- Lua LSP (for Neovim config editing)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".git"),
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Markdown LSP
lspconfig.marksman.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = util.root_pattern(".git", ".marksman.toml"),
  filetypes = { "markdown", "markdown.mdx" },
})

-- Restore original functions after all LSP configurations are done
vim.notify = original_notify
vim.notify_once = original_notify_once
vim.deprecate = original_deprecate