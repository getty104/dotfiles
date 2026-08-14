return {
  {
    'tanvirtin/monokai.nvim',
    config = function()
      vim.cmd("syntax on")
      require("monokai").setup({
        palette = require("monokai").classic
      })
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
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- this plugin does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(require("nvim-treesitter.config").get_available())

      -- treesitter はファイルサイズの 10〜30 倍のメモリを確保し、
      -- 一度確保した分はバッファを破棄しても OS に返らない。
      -- 長期間動かしっぱなしのセッションで RSS が積み上がるため、
      -- 巨大ファイル・minified ファイルではアタッチしない。
      local MAX_FILESIZE = 512 * 1024
      local MAX_LINE_LENGTH = 5000

      -- vim.treesitter.start を冪等にする。
      -- アタッチ済みバッファに再度呼ぶと LanguageTree:register_cbs が
      -- table.insert でコールバックを積み増し、TSHighlighter:destroy() は
      -- それを解除しない（LanguageTree に unregister API が無い）ため、
      -- 死んだ TSHighlighter が parser から参照され続けて GC されない。
      --
      -- ponytail: この wrapper が防げるのは「アタッチ済みへの再 start」だけ。
      -- runtime/ftplugin/markdown.lua は b:undo_ftplugin 経由で
      -- vim.treesitter.stop() してから start() し直すので ts_highlight が
      -- 一旦クリアされ、stop/start の往復 1 回につき 5 個の
      -- コールバックが漏れ続ける（neovim 本体のバグ）。
      -- 実測で支配的だったのは下の should_attach 側なので、ここは
      -- 本体が修正されるまで放置。再発したら upstream に報告する。
      local ts_start = vim.treesitter.start
      vim.treesitter.start = function(buf, lang)
        buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
        if vim.b[buf].ts_highlight then
          return
        end
        return ts_start(buf, lang)
      end

      local function should_attach(buf)
        -- ディスク上のファイルサイズではなくバッファの実バイト数で判定する。
        -- fzf-lua のプレビューバッファなど無名バッファはファイルが無く、
        -- fs_stat 判定だとサイズ無制限で素通りしてしまう。
        local lines = vim.api.nvim_buf_line_count(buf)
        if vim.api.nvim_buf_get_offset(buf, lines) > MAX_FILESIZE then
          return false
        end

        -- minified など 1 行が極端に長いファイルを弾く
        local first = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
        if first and #first > MAX_LINE_LENGTH then
          return false
        end

        return true
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if not should_attach(args.buf) then
            -- runtime/ftplugin/markdown.lua など、コア側が無条件で
            -- vim.treesitter.start() を呼ぶ filetype があるため、
            -- ftplugin の実行後に明示的に停止させる
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                pcall(vim.treesitter.stop, args.buf)
              end
            end)
            return
          end
          pcall(vim.treesitter.start, args.buf)
        end,
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
      require("toggleterm").setup({
        size = vim.o.lines * 0.4,
      })
      vim.api.nvim_create_user_command("TM", "<args>ToggleTerm", { nargs = 1 })
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
      },
      win_options = {
        winbar = "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}",
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = { { "<C-e>", "<Cmd>Oil<CR>" } },
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
    "jannis-baum/vivify.vim",
    ft = { "markdown" },
    cmd = { "Vivify" },
  },
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim", -- Optional dependency for enhanced terminal
    },
    opts = {
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
