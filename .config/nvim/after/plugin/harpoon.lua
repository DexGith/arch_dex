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

vim.keymap.set("n", "<C-s>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-f>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-g>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<C-5>", function() ui.nav_file(5) end)
-- I would love to add C-6 but ctrl+6 returns you to the previous buffer it's alright
-- There is also C-5 that doens't have a corresponding like letter but like... do you really
-- need more than 5 bookmarks ? idk ? also harpoon seem to work depending on the dir you are on 
-- so like you can go to neotree and hit like dot on a file and boom the root changes and harpoon
-- stuff you had is gone. or you can like hit spacebar to go 1 dir up and go to liek all the way up
-- and set the like current dir in the filesystemn to the harpoon list and boom harpoon bookmarks are
-- back. now I need a way to like make... like current files or like opened files open the like like
-- netrw

-- These are nice like kidna like alt+tab and alt+shift+tab... idk if I'm gonna use them tbh 
-- but whatever right... should be fine to just cycle between my like harpoon saved shit I guess 
vim.keymap.set("n", "<C-b>", ui.nav_prev) -- 'p' for previous
vim.keymap.set("n", "<C-n>", ui.nav_next) -- 'n' for next


-- Optional: A print statement to confirm the file was loaded.

