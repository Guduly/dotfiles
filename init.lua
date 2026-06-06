-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Compile & Run file fuction
local function run_file()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:r")

  local cmds = {
    cpp = string.format("g++ -std=c++17 -o %s %s && ./%s", out, file, out),
    c = string.format("gcc -o %s %s && ./%s", out, file, out),
    python = string.format("python3 %s", file),
    javascript = string.format("node %s", file),
    typescript = string.format("ts-node %s", file),
    rust = string.format("cargo run"),
    go = string.format("go run %s", file),
    sh = string.format("bash %s", file),
    lua = string.format("lua %s", file),
  }
  local cmd = cmds[ft]
  if not cmd then
    print("Runner not configured for filetype: " .. ft)
    return
  end

  vim.cmd("write")
  vim.cmd("botright split | terminal " .. cmd)
  vim.cmd("startinsert")
end

-- Close all terminal buffer
local function closeTerminals()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

---------------- KEYBINDINGS
-- run & compile bind
vim.keymap.set("n", "<C-x>", run_file, { desc = "Compiling & Running..." })

-- delete terminal buffer
vim.keymap.set("n", "<C-q>", closeTerminals, { desc = "Closing all Terminals..." })
