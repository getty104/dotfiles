return {
  {
    "crusoexia/vim-monokai",
    config = function()
      vim.cmd('syntax on')
      vim.cmd('colorscheme monokai')
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup()
    end
  },
  {
    "neoclide/coc.nvim",
    branch = "release"
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup()
    end
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({})
      vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd>FzfLua git_files<CR>', { noremap = true })
    end
  },
  {
    'scrooloose/nerdtree',
    config = function()
      vim.api.nvim_set_keymap('n', '<C-e>', '<Cmd>NERDTreeToggle<CR>', { noremap = true })
    end
  }
}
