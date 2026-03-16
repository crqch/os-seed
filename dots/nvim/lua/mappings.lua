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

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

local paraglide = require "utils.paraglide"

map("v", "<leader>px", paraglide.extract, { desc = "Extract text to Paraglide i18n JSON" })
map("n", "<leader>pl", paraglide.set_locale, { desc = "Set Paraglide Locale" })
map("n", "<leader>pn", paraglide.toggle_newline_replacement, { desc = "Toggle Newlines to Spaces for Paraglide" })
