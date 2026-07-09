-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

---Disabling numlock
local numpad_keys = {
  "<kUp>",
  "<kDown>",
  "<kLeft>",
  "<kRight>",
  "<k0>",
  "<k1>",
  "<k2>",
  "<k3>",
  "<k4>",
  "<k5>",
  "<k6>",
  "<k7>",
  "<k8>",
  "<k9>",
  "<kDivide>",
  "<kMultiply>",
  "<kMinus>",
  "<kPlus>",
  "<kEnter>",
  "<kPoint>",
}

-- Compile & Run file fuction
local function run_file()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:t:r")

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

-------------- enabling mouse movement for drag
vim.opt.mouse = "a"

---------------- KEYBINDINGS
-- run & compile bind
vim.keymap.set("n", "<C-x>", run_file, { desc = "Compiling & Running..." })

-- delete terminal buffer
vim.keymap.set("n", "<C-q>", closeTerminals, { desc = "Closing all Terminals..." })

--remap delete without overwrite
vim.keymap.set({ "n", "x" }, "d", '"_d')

-- Navigate buffers with Ctrl+Left / Ctrl+Right
vim.keymap.set("n", "<C-Left>", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<C-Right>", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })

-- Switch to buffers based on CRTL + # (1..9)
for i = 1, 9 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    require("bufferline").go_to(i, true)
  end, { silent = true, desc = "Go to buffer " .. i })
end

for _, key in ipairs(numpad_keys) do
  vim.keymap.set({ "n", "i", "v" }, key, "<Nop>", { silent = true })
end

-- nvim reload keybind
vim.keymap.set("n", "<leader>r", ":source ~/.config/nvim/init.lua<CR>", { desc = "Reload init.lua" })
