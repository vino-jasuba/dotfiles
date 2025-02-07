-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable annoying command line thing.
vim.keymap.set("n", "q:", ":q<CR>")

-- Easy insertion of a trailing ; or , from insert mode.
-- vim.keymap.set("i", ";;", "<Esc>A;<Esc>")
-- vim.keymap.set("i", ",,", "<Esc>A,<Esc>")
