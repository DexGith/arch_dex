-- File: ~/.config/nvim/lua/user/harpoon.lua

-- 1. Initialize the plugin first. This is the crucial step.
--    It creates the necessary tables and prevents the "nil" error.
require("harpoon").setup({})

-- 2. Now that the plugin is initialized, require the modules
--    and set up your keymaps. This code is your exact config.
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- Optional: A print statement to confirm the file was loaded.
