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
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },
  -- dependencies for "ibhagwan/fzf-lua", "nvim-lualine/lualine.nvim"
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "neoclide/coc.nvim",
    branch = "release",
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
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    config = function()
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        debug = true,
        model = "o1",
        mappings = {
          complete = {
            detail = "Use @<C-e> or /<C-e> for options.",
            insert = "<C-e>",
          },
        },
      })
    end,
    keys = {
      {
        "ccp",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      { "<C-n>", "<Cmd>CopilotChatToggle<CR>" },
    },
  },
  -- dependencies for "CopilotC-Nvim/CopilotChat.nvim"
  { "nvim-lua/plenary.nvim", lazy = true },
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
