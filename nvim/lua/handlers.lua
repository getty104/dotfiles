local function RemoveDust()
  if vim.bo.filetype ~= "markdown" then
    vim.api.nvim_exec("%s/\\s\\+$//ge", false)
  end
  vim.api.nvim_exec("%s/\\t/  /ge", false)
end

local function RemoveMergedBranches()
  vim.fn.system({ "git", "branch", "-d", "$(git branch --merged | grep -v main | grep -v master | grep -v '*')" })
end

local function BeforeSaveHandler()
  local cursor = vim.api.nvim_win_get_cursor(0)
  RemoveDust()
  vim.api.nvim_win_set_cursor(0, cursor)
end

local function AfterSaveHandler()
  RemoveMergedBranches()
end

return {
  setup = function()
    vim.api.nvim_create_augroup("handler", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "handler",
      pattern = "*",
      callback = BeforeSaveHandler,
    })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = "handler",
      pattern = "*",
      callback = AfterSaveHandler,
    })
  end,
}
