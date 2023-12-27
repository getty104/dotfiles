-- Setting encoding
vim.o.encoding = 'utf-8'
vim.o.fileformats = 'unix,dos,mac'
vim.o.fileencoding = 'utf-8'

-- Running a script at startup
vim.api.nvim_exec([[call system("git branch -d $(git branch --merged | grep -v main | grep -v master | grep -v '*')")]], false)

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

-- Highlighting settings
vim.api.nvim_create_augroup('extra-whitespace', {})
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter'}, {
    group = 'extra-whitespace',
    pattern = {'*'},
    command = [[call matchadd('ExtraWhitespace', '[\u200B\u3000]')]]
  })
vim.api.nvim_create_autocmd({'ColorScheme'}, {
    group = 'extra-whitespace',
    pattern = {'*'},
    command = [[highlight default ExtraWhitespace ctermbg=202 ctermfg=202 guibg=salmon]]
  })

-- Function to remove trailing spaces and convert tabs to spaces
function RemoveDust()
  if vim.bo.filetype ~= 'markdown' then
    vim.api.nvim_exec('%s/\\s\\+$//ge', false)
  end
  vim.api.nvim_exec('%s/\\t/  /ge', false)
end

function CodeFormat()
  local cursor = vim.api.nvim_win_get_cursor(0)
end

-- Function to format code without changing the current position
function CodeFormatPreserveCursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  CodeFormat()
  vim.api.nvim_win_set_cursor(0, cursor)
end

-- Function to save the current position, remove dust, and restore the position
function SaveHandler()
  local cursor = vim.api.nvim_win_get_cursor(0)
  RemoveDust()
  vim.api.nvim_win_set_cursor(0, cursor)
end

-- Function to restore the last cursor position
function RecoveryPosition()
  if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
    vim.api.nvim_exec('normal! g\'\"', false)
  end
end

-- Autocommand group for checking modified files
vim.api.nvim_create_augroup('vimrc_checktime', { clear = true })
vim.api.nvim_create_autocmd('CursorHold', {
    group = 'vimrc_checktime',
    pattern = '*',
    command = 'checktime'
  })

-- Autocommands for recovery_position and save_handler
vim.api.nvim_create_augroup('handler', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
    group = 'handler',
    pattern = '*',
    callback = RecoveryPosition
  })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'handler',
    pattern = '*',
    callback = SaveHandler
  })

-- Autocommand to open quickfix window after grep
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern = '*grep*',
    command = 'cwindow'
  })

-- Setting various Neovim options
vim.o.cmdheight = 1
vim.o.laststatus = 2
vim.o.showmode = true
vim.o.ruler = true
vim.o.title = true
vim.o.wildmenu = true
vim.o.history = 5000
vim.o.hlsearch = true

-- For 'incsearch', Lua API does not provide direct option setting, so use vim.cmd
vim.cmd('set incsearch')

-- More Neovim settings
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
vim.o.ambiwidth = 'double'

-- Setting 'listchars' for visualizing tabs and trailing spaces
vim.o.listchars = 'tab:>\\ ,extends:<'

-- Additional Neovim settings
vim.o.clipboard = 'unnamed'
vim.o.backspace = 'indent,eol,start'
vim.o.swapfile = false
vim.o.backup = false
vim.o.errorbells = false
vim.o.visualbell = true
vim.o.t_vb = ''

-- Enable filetype-specific indent plugins
vim.cmd('filetype plugin indent on')

-- Aliases (commands in Neovim)
vim.api.nvim_create_user_command('T', 'tabnew', {})
vim.api.nvim_create_user_command('TM', function(args)
  -- Command to toggle term, adjust as needed for Lua
  -- Example: ToggleTerm with size 50
end, { nargs = 1 })

-- Normal mode key mappings
vim.api.nvim_set_keymap('n', '<C-f>', '<Cmd>lua CodeFormat()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-y>', ':%y<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<ESC><ESC>', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'r', ':e!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tm', ':TM 1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't2', ':TM 2<CR>', { noremap = true })
-- Add more key mappings as needed

-- Normal mode key mappings continued
vim.api.nvim_set_keymap('n', 't3', ':TM 3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't4', ':TM 4<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't5', ':TM 5<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't6', ':TM 6<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't7', ':TM 7<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't8', ':TM 8<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't9', ':TM 9<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 't10', ':TM 10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'ta', ':ToggleTermToggleAll<CR>', { noremap = true })

-- Visual mode key mappings
vim.api.nvim_set_keymap('v', '<C-p>', '"0p', { noremap = true })

-- Terminal mode key mappings
vim.api.nvim_set_keymap('t', '<ESC><ESC>', '<C-\\><C-n>', { noremap = true })
