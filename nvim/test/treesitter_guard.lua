-- treesitter アタッチガードの回帰テスト
--   nvim --headless -u ~/.config/nvim/init.lua -c "luafile nvim/test/treesitter_guard.lua"
-- 失敗すると assert で落ちる。成功すると "ALL OK" を出して終了。

local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")

local function rss()
  return tonumber(vim.fn.system({ "ps", "-o", "rss=", "-p", tostring(vim.fn.getpid()) }):match("%d+")) or 0
end

-- 12MB 程度のフィクスチャ
local big = {}
for i = 1, 200000 do
  big[i] = ("def f%d(a, b): return a + b * %d  # %s"):format(i, i, ("x"):rep(20))
end
local big_path = tmp .. "/big.py"
vim.fn.writefile(big, big_path)

-- 1. 無名バッファ（fzf-lua のプレビューと同じ形）にはアタッチしない。
--    ファイル名が無いので fs_stat では素通りしてしまい、実測で +700MB の
--    RSS が確保されたまま OS に返らなかった。
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, big)
vim.bo[buf].filetype = "python"
vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
vim.wait(300)
vim.cmd("redraw")
assert(not vim.b[buf].ts_highlight, "無名の巨大バッファに treesitter がアタッチされた")
assert(rss() < 400000, "RSS が急増した: " .. rss() .. "KB")
vim.api.nvim_buf_delete(buf, { force = true })

-- 2. 通常サイズのファイルはこれまで通りハイライトされる
local small_path = tmp .. "/small.py"
vim.fn.writefile({ "def f(a, b):", "    return a + b" }, small_path)
vim.cmd("edit " .. small_path)
assert(vim.b[vim.api.nvim_get_current_buf()].ts_highlight, "通常ファイルのハイライトが消えた")

-- 3. 名前付きの巨大ファイルも従来通り弾く
vim.cmd("edit " .. big_path)
assert(not vim.b[vim.api.nvim_get_current_buf()].ts_highlight, "名前付きの巨大ファイルにアタッチされた")

vim.fn.delete(tmp, "rf")
print("ALL OK rss=" .. rss() .. "KB")
vim.cmd("qa!")
