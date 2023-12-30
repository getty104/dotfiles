return {
  {
    "crusoexia/vim-monokai",
    config = function()
      vim.cmd("syntax on")
      vim.cmd("colorscheme monokai")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.api.nvim_set_keymap("n", "gsd", "<Plug>(coc-definition)", { noremap = true })
      vim.api.nvim_set_keymap("n", "gsr", "<Plug>(coc-references)", { noremap = true })
      vim.api.nvim_set_keymap("n", "gsh", "<Cmd>call CocActionAsync('definitionHover')<CR>", { noremap = true })
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-solargraph",
        "coc-git",
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
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
      vim.api.nvim_create_user_command("TM", "<args>ToggleTerm size=40", { nargs = 1 })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    keys = { { "<C-p>", "<Cmd>FzfLua git_files<CR>" } },
  },
  {
    "scrooloose/nerdtree",
    keys = { { "<C-e>", "<Cmd>NERDTreeToggle<CR>" } },
    lazy = true,
  },
  {
    "github/copilot.vim",
    cofig = function()
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
}
