-- Setting encoding
vim.o.encoding = "utf-8"
vim.o.fileformats = "unix,dos,mac"
vim.o.fileencoding = "utf-8"

-- Running a script at startup
vim.api.nvim_exec(
  [[call system("git branch -d $(git branch --merged | grep -v main | grep -v master | grep -v '*')")]],
  false
)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = require("plugins")
require("lazy").setup(plugins)

-- Function to remove trailing spaces and convert tabs to spaces
function RemoveDust()
  if vim.bo.filetype ~= "markdown" then
    vim.api.nvim_exec("%s/\\s\\+$//ge", false)
  end
  vim.api.nvim_exec("%s/\\t/  /ge", false)
end

-- Function to save the current position, remove dust, and restore the position
function SaveHandler()
  local cursor = vim.api.nvim_win_get_cursor(0)
  RemoveDust()
  vim.api.nvim_win_set_cursor(0, cursor)
end

-- Autocommands for recovery_position and save_handler
vim.api.nvim_create_augroup("handler", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "handler",
  pattern = "*",
  callback = SaveHandler,
})

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
vim.o.ambiwidth = "double"
vim.o.clipboard = "unnamed"
vim.o.backspace = "indent,eol,start"
vim.o.swapfile = false
vim.o.backup = false
vim.o.errorbells = false
vim.o.visualbell = true
vim.o.t_vb = ""
vim.api.nvim_create_user_command("T", "tabnew", {})
vim.api.nvim_set_keymap("n", "<C-y>", "<Cmd>%y<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<ESC><ESC>", "<Cmd>noh<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "r", "<Cmd>e!<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-p>", '"0p', { noremap = true })
vim.api.nvim_set_keymap("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true })
