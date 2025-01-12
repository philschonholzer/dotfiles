-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 15

-- Enable this option to avoid conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

-- inherit the indentation of the previous line
vim.opt.autoindent = true

vim.o.title = true
vim.o.titlestring = "Neovim " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
