require("lazy-nvim").setup()
require("handlers").setup()

vim.o.encoding = "utf-8"
vim.o.fileformats = "unix,dos,mac"
vim.o.fileencoding = "utf-8"
vim.o.hlsearch = true
vim.o.hidden = true
vim.o.number = true
vim.o.showmatch = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.list = true
vim.o.clipboard = "unnamed"
vim.o.backspace = "indent,eol,start"
vim.o.swapfile = false
vim.o.backup = false
vim.o.errorbells = false
vim.o.visualbell = true
vim.api.nvim_create_user_command("T", "tabnew", {})
vim.api.nvim_set_keymap("n", "<C-y>", "<Cmd>%y<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<ESC><ESC>", "<Cmd>noh<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "r", "<Cmd>e!<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-p>", '"0p', { noremap = true })
vim.api.nvim_set_keymap("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true })
