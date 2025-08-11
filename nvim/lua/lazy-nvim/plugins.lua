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
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      use_default_keymaps = false,

      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-m>"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      }
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = { { "<C-e>", "<Cmd>Oil<CR>" } },
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
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim", -- Optional dependency for enhanced terminal
    },
    opts = {
      -- Configuration for claudecode main
      terminal_cmd = "~/.claude/local/claude --dangerously-skip-permissions",

      -- Configuration for the interactive terminal:
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.3, -- 0.0 to 1.0
        provider = "snacks", -- "snacks" or "native"
      },
    },
    -- The plugin will call require("claudecode").setup(opts)
    config = true,
    keys = {
      { "<C-n>", "<Cmd>ClaudeCode<CR>" },
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
