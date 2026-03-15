require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
vim.keymap.set("n", "<leader><leader>", require("telescope.builtin").find_files, { desc = "Telescope Find Files" })
map("n", "<leader>gs", "<cmd>Neogit<CR>", { desc = "Open Neogit Status" })
map("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Git Commit" })
map("i", "<C-s>", "<ESC><cmd>w<cr>", { desc = "File Save and Escape" })
map("v", "<C-s>", "<ESC><cmd>w<cr>", { desc = "File Save and Escape" })

map("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore Session" })

map("n", "L", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer Next" })

map("n", "H", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer Prev" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
