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
    config = function()
      require("lualine").setup()
    end,
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
    config = function()
      require("toggleterm").setup({})
      vim.api.nvim_create_user_command("TM", "<args>ToggleTerm size=40", { nargs = 1 })
      vim.api.nvim_set_keymap("n", "tm", "<Cmd>TM 1<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t2", "<Cmd>TM 2<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t3", "<Cmd>TM 3<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t4", "<Cmd>TM 4<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t5", "<Cmd>TM 5<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t6", "<Cmd>TM 6<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t7", "<Cmd>TM 7<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t8", "<Cmd>TM 8<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t9", "<Cmd>TM 9<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "t10", "<Cmd>TM 10<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "ta", "<Cmd>ToggleTermToggleAll<CR>", { noremap = true })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({})
      vim.api.nvim_set_keymap("n", "<C-p>", "<Cmd>FzfLua git_files<CR>", { noremap = true })
    end,
  },
  {
    "scrooloose/nerdtree",
    config = function()
      vim.api.nvim_set_keymap("n", "<C-e>", "<Cmd>NERDTreeToggle<CR>", { noremap = true })
    end,
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
    config = function()
      require("ibl").setup({
        indent = { char = "|" },
      })
    end,
  },
}
