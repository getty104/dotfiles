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
    lazy = false,
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
    "prisma/vim-prisma",
    ft = { "prisma" },
  },
  {
    "wuelnerdotexe/vim-astro",
    ft = { "astro" },
    config = function()
      vim.g.astro_typescript = "enable"
    end,
  },
  {
    "google/vim-jsonnet",
    ft = { "jsonnet" },
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
    config = function()
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        debug = true,
        context = "buffers",
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN 選択された部分の説明を段落で書いてください。",
          },
          Review = {
            prompt = "/COPILOT_REVIEW 選択されたコードをレビューしてください。",
            callback = function(response, source) end,
          },
          Fix = {
            prompt = "/COPILOT_GENERATE このコードには問題があります。バグを修正してコードを書き直してください。",
          },
          Optimize = {
            prompt = "/COPILOT_GENERATE 選択されたコードを最適化して、パフォーマンスと読みやすさを向上させてください。",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE 選択された部分にドキュメントコメントを追加してください。",
          },
          Tests = {
            prompt = "/COPILOT_GENERATE コードのテストを生成してください。",
          },
          FixDiagnostic = {
            prompt = "ファイル内の次の診断問題の対処を支援してください:",
            selection = select.diagnostics,
          },
          Commit = {
            prompt = "変更に対するコミットメッセージを書いてください。commitizenの規約に従い、タイトルは最大50文字にし、メッセージは72文字で折り返してください。メッセージ全体をgitcommitの言語でコードブロックに包んでください。",
            selection = select.gitdiff,
          },
          CommitStaged = {
            prompt = "変更に対するコミットメッセージを書いてください。commitizenの規約に従い、タイトルは最大50文字にし、メッセージは72文字で折り返してください。メッセージ全体をgitcommitの言語でコードブロックに包んでください。",
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
        },
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
