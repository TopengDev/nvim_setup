require("lazy").setup({
    { "mg979/vim-visual-multi", branch = "master", event = "VeryLazy" },
    -- Color schemes
    {"rebelot/kanagawa.nvim"},
    {"tahayvr/themery.nvim", priority = 1000, lazy = false},
    {"EdenEast/nightfox.nvim", lazy = true},
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, event = "BufReadPost" },
    {"morhetz/gruvbox", lazy = true},
    {"folke/tokyonight.nvim", lazy = true},
    {"vague2k/vague.nvim", lazy = true},
    {"sainnhe/everforest", lazy = true},
    {"Mofiqul/vscode.nvim", lazy = true},
    {"rose-pine/neovim", lazy = true},
    {"metalelf0/black-metal-theme-neovim", lazy = true},
    {"scottmckendry/cyberdream.nvim", lazy = true},
    {"joshdick/onedark.vim", lazy = true},
    {"nyoom-engineering/oxocarbon.nvim", lazy = true},
    {"loctvl842/monokai-pro.nvim", lazy = true},
    {"shyuan/vim-color-schemes", lazy = true},
    {"cocopon/iceberg.vim", lazy = true},
    {"Shatur/neovim-ayu", lazy = true},
    {"m6vrm/gruber.vim", lazy = true},
    {"yorumicolors/yorumi.nvim", lazy = true},
    {"jpo/vim-railscasts-theme", lazy = true},
    {"hallison/vim-darkdevel", lazy = true},
    {"hannakalinowska/vim_colors", lazy = true},
    {"adonaldson/vim-tictoc", lazy = true},
    {"trapd00r/neverland-vim-theme", lazy = true},
    {"geetarista/ego.vim", lazy = true},
    {"catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = true}, -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- optional but recommended
            "MunifTanjim/nui.nvim"
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,
                window = {
                    position = "left",
                    width = 45,
                    mappings = {
                        ["<space>"] = "toggle_node",
                        ["<cr>"] = "open",
                        ["s"] = "open_vsplit",
                        ["S"] = "open_split",
                        ["<C-x>"] = "open_split",
                        ["<C-v>"] = "open_vsplit",
                        ["<C-t>"] = "open_tabnew"
                    }
                },
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        never_show = {".DS_Store", "thumbs.db"}
                    }
                },
                buffers = {
                  show_unloaded = true,
                  follow_current_file = {
                    enabled = true,
                  },
                  window = {
                    mappings = {
                      ["d"] = "delete", -- normal delete mapping
                    },
                  },
                },
                event_handlers = {
                  {
                    event = "file_opened",
                    handler = function(file_path)
                      -- Make buffer modifiable just in case
                      vim.cmd("setlocal modifiable")
                    end,
                  },
                },
                git_status = {
                    symbols = {
                        added = "✚",
                        modified = "",
                        deleted = "✖",
                        renamed = "➜",
                        untracked = "★",
                        ignored = "◌",
                        unstaged = "✗",
                        staged = "✓",
                        conflict = ""
                    }
                }
            })

            -- Optional: disable netrw and hijack directory opening
            vim.cmd([[ let g:loaded_netrw = 1 ]])
            vim.cmd([[ let g:loaded_netrwPlugin = 1 ]])

            -- Keybinding to toggle Neo-tree
            vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>",
                           {silent = true, noremap = true})
        end
    }, -- { "nvim-tree/nvim-tree.lua" },
    -- { "nvim-tree/nvim-web-devicons" },
    -- LuaLine
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     dependencies = {"nvim-tree/nvim-web-devicons"},
    --     event = "VeryLazy",
    --     config = function()
    --         require("lualine").setup({
    --             options = {
    --                 theme = "catppuccin", -- or whatever your theme is
    --                 icons_enabled = true,
    --                 section_separators = {left = "", right = ""},
    --                 component_separators = "|"
    --             },
    --             sections = {
    --                 lualine_a = {"mode"}, -- e.g. NORMAL
    --                 lualine_b = {"hostname", "branch"},
    --                 lualine_c = {
    --                     {"filename", path = 1} -- shows folder/file path
    --                 },
    --                 lualine_x = {
    --                     {
    --                         function()
    --                             return " " ..
    --                                        vim.fn
    --                                            .matchstr(
    --                                            vim.fn.system("node -v"),
    --                                            "v[0-9.]*")
    --                         end,
    --                         icon = "",
    --                         color = {fg = "#6cc644"}
    --                     }, "encoding", "fileformat", "filetype",
    --                     {
    --                         function()
    --                             return " " .. os.date("%H:%M")
    --                         end,
    --                         color = {fg = "#ff9ead"}
    --                     }
    --
    --                 },
    --                 lualine_y = {
    --                     {"progress"} -- % through file
    --                 },
    --                 lualine_z = {
    --                     {"location"} -- line & column
    --                 }
    --             }
    --         })
    --     end
    --},
    -- LSP and completion
    {"neovim/nvim-lspconfig", event = {"BufReadPre", "BufNewFile"}},
    {"williamboman/mason.nvim", cmd = "Mason"},
    {"williamboman/mason-lspconfig.nvim", event = {"BufReadPre", "BufNewFile"}},
    {"hrsh7th/nvim-cmp", event = "InsertEnter"},
    {"hrsh7th/cmp-nvim-lsp", event = "InsertEnter"},
    {"L3MON4D3/LuaSnip", event = "InsertEnter"},
    {"saadparwaiz1/cmp_luasnip", event = "InsertEnter"},
    { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "hrsh7th/cmp-path", event = "InsertEnter" },
    {"nvimtools/none-ls.nvim", event = {"BufReadPre", "BufNewFile"}},
    {"nvimtools/none-ls-extras.nvim", event = {"BufReadPre", "BufNewFile"}},

    -- Syntax highlighting
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = {"BufReadPost", "BufNewFile"}},
    { "windwp/nvim-ts-autotag", event = "InsertEnter" },

    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {"nvim-lua/plenary.nvim"},
        cmd = {"Telescope"},
        keys = {
            {"<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files"},
            {"<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep"},
            {"<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers"},
            {"<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files"},
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    layout_config = {horizontal = {preview_width = 0.5}},
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    prompt_prefix = " 🔍 ",
                    selection_caret = " "
                }
            })
        end
    },
    -- Auto-close & auto-rename tag
    {"windwp/nvim-autopairs", event = "InsertEnter"},
    {"windwp/nvim-ts-autotag", event = "InsertEnter"},

    -- Prettier and eslint
    {"MunifTanjim/prettier.nvim", event = {"BufReadPre", "BufNewFile"}},

    -- Commenter
    {
      "numToStr/Comment.nvim",
      keys = {
        {"<C-/>", mode = {"n", "v"}},
        {"gcc", mode = "n"},
        {"gc", mode = "v"},
      },
      config = function()
        require("Comment").setup()
      end
    },
    -- Auto tag closer (duplicate removed)



})


