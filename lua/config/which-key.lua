local wk = require("which-key")

wk.setup({
  preset = "classic", -- Use classic style instead of modern popup
  delay = 500, -- Delay before showing which-key (in ms)
  plugins = {
    marks = false,
    registers = false,
    spelling = {
      enabled = false,
    },
  },
  win = {
    border = "none",
    position = "bottom",
  },
})

-- Register key groups for better organization
wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>c", group = "Colorscheme" },
  { "<leader>x", group = "Trouble" },
  { "<leader>s", group = "Spectre/Search" },
})
