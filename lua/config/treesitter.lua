require("nvim-treesitter.configs").setup({
  ensure_installed = { "typescript", "tsx", "javascript", "html", "css", "lua", "go", "php", "python", "java", "c", "cpp", "solidity" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false, -- Disable vim regex highlighting for performance
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
  -- Performance optimizations
  auto_install = true,
  sync_install = false, -- Install parsers asynchronously
})

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = true -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = true
    },
    ["typescript"] = {
      enable_close = true
    },
    ["typescriptreact"] = {
      enable_close = true
    },
    ["tsx"] = {
      enable_close = true
    },
    ["javascript"] = {
      enable_close = true
    },
    ["javascriptreact"] = {
      enable_close = true
    }
  }
})