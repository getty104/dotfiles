return {
  {
    "crusoexia/vim-monokai",
    config = function()
      vim.cmd("syntax on")
      vim.cmd("colorscheme monokai")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    keys = { { "<C-p>", "<Cmd>FzfLua git_files<CR>" } },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
    keys = {
      { "gsh", "<Cmd>call CocActionAsync('definitionHover')<CR>" },
      { "gsd", "<Plug>(coc-definition)" },
      { "gsr", "<Plug>(coc-references)" },
    },
    config = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-solargraph",
        "coc-git",
        "coc-pyright",
        "coc-prisma",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = "all",
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "tm", "<Cmd>TM 1<CR>" },
      { "t2", "<Cmd>TM 2<CR>" },
      { "t3", "<Cmd>TM 3<CR>" },
      { "t4", "<Cmd>TM 4<CR>" },
      { "t5", "<Cmd>TM 5<CR>" },
      { "t6", "<Cmd>TM 6<CR>" },
      { "t7", "<Cmd>TM 7<CR>" },
      { "t8", "<Cmd>TM 8<CR>" },
      { "t9", "<Cmd>TM 9<CR>" },
      { "t10", "<Cmd>TM 10<CR>" },
      { "ta", "<Cmd>ToggleTermToggleAll<CR>" },
    },
    config = function()
      require("toggleterm").setup()
      vim.api.nvim_create_user_command("TM", "<args>ToggleTerm size=40", { nargs = 1 })
    end,
  },
  {
    "scrooloose/nerdtree",
    keys = { { "<C-e>", "<Cmd>NERDTreeToggle<CR>" } },
    config = function()
      vim.g.NERDTreeShowHidden = 1
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        markdown = true,
        gitcommit = true,
        yaml = true,
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    lazy = false,
    keys = {
      { "<C-n>", "<Cmd>CodeCompanionChat Toggle<CR>" },
      { "<C-a>", "<Cmd>CodeCompanionActions<CR>" },
    },
    config = function()
      vim.g.codecompanion_auto_tool_mode = true

      require("codecompanion").setup({
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.5-sonnet",
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["buffer"] = {
                opts = {
                  provider = "fzf_lua",
                },
              },
              ["file"] = {
                opts = {
                  provider = "fzf_lua",
                },
              },
              ["help"] = {
                opts = {
                  provider = "fzf_lua",
                },
              },
              ["symbols"] = {
                opts = {
                  provider = "fzf_lua",
                },
              },
              ["workspace"] = {
                opts = {
                  provider = "fzf_lua",
                },
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        opts = {
          language = "Japanese",
          log_level = "INFO",
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "|" },
    },
  },
  {
    "ohakutsu/socks-copypath.nvim",
    keys = {
      { "cf", "<Cmd>CopyFileName<CR>" },
      { "cp", "<Cmd>CopyPath<CR>" },
      { "crp", "<Cmd>CopyRelativePath<CR>" },
    },
    config = function()
      require("socks-copypath").setup()
    end,
  },
  {
    "slim-template/vim-slim",
    ft = { "slim" },
  },
  {
    "getty104/air-duster.nvim",
    config = function()
      require("air-duster").setup()
    end,
  },
}
