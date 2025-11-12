require("lazy").setup({
    {
      "mg979/vim-visual-multi",
      branch = "master",
      event = "VeryLazy",
      init = function()
        -- Disable vim-visual-multi's Ctrl+Up/Down mappings
        vim.g.VM_maps = {
          ["Add Cursor Down"] = "",  -- Disable Ctrl+Down for adding cursors
          ["Add Cursor Up"] = "",    -- Disable Ctrl+Up for adding cursors
        }
      end,
    },
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
                      ["d"] = "buffer_delete", -- use buffer-friendly delete command
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
    },
    -- LuaLine
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- automatically adapts to your colorscheme
                    icons_enabled = true,
                    section_separators = {left = "", right = ""},
                    component_separators = "|",
                    globalstatus = true, -- single statusline for all windows
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch", "diff", "diagnostics"},
                    lualine_c = {{"filename", path = 1}}, -- shows relative path
                    lualine_x = {"encoding", "fileformat", "filetype"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                },
                extensions = {"neo-tree", "trouble", "mason"}
            })
        end
    },
    -- LSP and completion
    {"neovim/nvim-lspconfig", event = {"BufReadPre", "BufNewFile"}},
    {"williamboman/mason.nvim", cmd = "Mason"},
    {"williamboman/mason-lspconfig.nvim", event = {"BufReadPre", "BufNewFile"}},
    {"hrsh7th/nvim-cmp", event = "InsertEnter"},
    {"hrsh7th/cmp-nvim-lsp", event = "InsertEnter"},
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      -- Build is optional - only needed for advanced regex support
      -- If build fails, snippets will still work fine
      build = (function()
        if vim.fn.executable("make") == 1 then
          return "make install_jsregexp"
        end
        return nil
      end)(),
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    },
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
                        "--hidden",  -- search hidden files
                        "--no-ignore",  -- include git-ignored files
                        "--glob=!.git/",  -- but exclude .git directory
                    },
                    layout_config = {horizontal = {preview_width = 0.5}},
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    prompt_prefix = " 🔍 ",
                    selection_caret = " "
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",  -- include hidden files
                            "--no-ignore",  -- include git-ignored files
                            "--glob=!.git/",  -- but exclude .git directory
                        },
                    },
                },
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

    -- Essential plugins
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("config.which-key")
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      event = {"BufReadPre", "BufNewFile"},
      config = function()
        require("config.gitsigns")
      end
    },
    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      keys = {
        {"<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)"},
        {"<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)"},
        {"<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)"},
        {"<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)"},
      },
      config = function()
        require("trouble").setup()
      end
    },

    -- Quality of life
    {"tpope/vim-surround", event = "VeryLazy"},
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = {"nvim-lua/plenary.nvim"},
      keys = {
        {"<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add file"},
        {"<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu"},
        {"<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1"},
        {"<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2"},
        {"<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3"},
        {"<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4"},
      },
      config = function()
        require("harpoon"):setup()
      end
    },
    -- {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    --   build = "make",
    --   config = function()
    --     require("telescope").load_extension("fzf")
    --   end
    -- },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      keys = {
        {"s", mode = {"n", "x", "o"}, function() require("flash").jump() end, desc = "Flash"},
        {"S", mode = {"n", "x", "o"}, function() require("flash").treesitter() end, desc = "Flash Treesitter"},
      },
      config = function()
        require("flash").setup()
      end
    },

    -- Nice to have
    {
      "folke/todo-comments.nvim",
      dependencies = {"nvim-lua/plenary.nvim"},
      event = {"BufReadPost", "BufNewFile"},
      config = function()
        require("todo-comments").setup()
      end
    },
    -- {
    --   "numToStr/Navigator.nvim",
    --   keys = {
    --     {"<C-Up>", "<cmd>NavigatorUp<cr>", desc = "Navigate Up"},
    --     {"<C-Down>", "<cmd>NavigatorDown<cr>", desc = "Navigate Down"},
    --   },
    --   config = function()
    --     require("Navigator").setup()
    --   end
    -- },
    {
      "stevearc/oil.nvim",
      cmd = "Oil",
      keys = {
        {"-", "<cmd>Oil<cr>", desc = "Open parent directory"},
      },
      config = function()
        require("oil").setup()
      end
    },
    {
      "nvim-pack/nvim-spectre",
      dependencies = {"nvim-lua/plenary.nvim"},
      keys = {
        {"<leader>S", function() require("spectre").toggle() end, desc = "Toggle Spectre"},
        {"<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word"},
        {"<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search in current file"},
      },
      config = function()
        require("spectre").setup()
      end
    },

    -- Stack-specific plugins
    {
      "echasnovski/mini.ai",
      event = "VeryLazy",
      config = function()
        require("mini.ai").setup()
      end
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = {"nvim-treesitter/nvim-treesitter"},
      event = {"BufReadPost", "BufNewFile"},
      config = function()
        require("config.treesitter-textobjects")
      end
    },

    -- Terminal integration
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      keys = {
        {"<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal"},
        {"<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal"},
        {"<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal"},
        {"<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle vertical terminal"},
      },
      config = function()
        require("toggleterm").setup({
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end,
          open_mapping = [[<C-t>]],
          hide_numbers = true,
          shade_terminals = true,
          shading_factor = 2,
          start_in_insert = true,
          insert_mappings = true,
          terminal_mappings = true,
          persist_size = true,
          persist_mode = true,
          direction = "float",
          close_on_exit = true,
          shell = vim.o.shell,
          float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
              border = "Normal",
              background = "Normal",
            },
          },
        })

        -- Terminal mode keybindings for easy escape
        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        end

        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      end
    },

    -- Markdown preview with browser
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = "cd app && npm install",
      keys = {
        {"<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview"},
      },
      config = function()
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_theme = 'dark'
      end
    },

  -- Speedtyper for typing test
  {
    "NStefan002/speedtyper.nvim",
    branch = "v2",
    lazy = false,
  },
	{
  	"mg979/vim-visual-multi",
  	branch = "master"
	},


})

