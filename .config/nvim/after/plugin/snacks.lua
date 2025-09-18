-- This file contains all keymaps and setup for snacks.nvim

-- A helper function to make setting keymaps easier
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end


-- At the BOTTOM of snacks.lua, after all your other maps:

--# doens't work
-- require("snacks").setup({
--   picker = {
--     keys = {
--       i = {
--         ["<C-p>"] = require("snacks.picker").select_vertical,
--         ["<C-j>"] = function(state)
--           require("snacks.picker").scroll_preview(1, state)
--         end,
--         ["<C-k>"] = function(state)
--           require("snacks.picker").scroll_preview(-1, state)
--         end,
--       },
--       n = {
--         ["<C-p>"] = require("snacks.picker").select_vertical,
--       },
--     },
--   },
-- })



-----------------------------------------------------
-- PICKERS (The main feature)
-----------------------------------------------------
-- These are for finding things across your project

-- why use this when I have like telescope lol
-- map("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "Find Files" })


--for now let's screw around with s I like f more but f is used but you know  we got B which is good 

-- because of telescope no need for this... mainly because I can't do what telescope does... mainly with the hotkeys and keybinds
-- map("n", "<leader>sb", function() require("snacks").picker.buffers() end, { desc = "Find Buffers" })
-- map("n", "<leader>fb", function() require("snacks").picker.buffers() end, { desc = "Find Buffers" })


-- map("n", "<leader>fg", function() require("snacks").picker.git_files() end, { desc = "Find Git Files" })
-- map("n", "<leader>fr", function() require("snacks").picker.recent() end, { desc = "Find Recent Files" })
-- map("n", "<leader>sw", function() require("snacks").picker.grep_word() end, { desc = "Grep for Word Under Cursor" })
-- map("n", "<leader>sg", function() require("snacks").picker.grep() end, { desc = "Grep (Live)" })
-- map("n", "<leader>sH", function() require("snacks").picker.highlights() end, { desc = "Search Highlight Groups" })
--
-- -----------------------------------------------------
-- -- INTERACTIVE TOOLS
-- -----------------------------------------------------
map("n", "<leader>se", function() require("snacks").explorer() end, { desc = "File Explorer (Snacks)" })
map("n", "<leader>sz", function() require("snacks").zen() end, { desc = "Toggle Zen Mode" })
map({"n", "t"}, "<leader>st", function() require("snacks").terminal() end, { desc = "Toggle Floating Terminal" })
-- map({"n", "t"}, "<c-_>", function() require("snacks").terminal() end, { desc = "Toggle Floating Terminal" })
--
-- -----------------------------------------------------
-- -- GIT INTEGRATION
-- -----------------------------------------------------
-- -- Make sure you have 'lazygit' installed on your system for this to work


--#good
map("n", "<leader>Lg", function() require("snacks").lazygit() end, { desc = "Open Lazygit" })
-- map("n", "<leader>Gb", function() require("snacks").picker.git_branches() end, { desc = "Git Branches" })
--#Because I have it in telescope
-- map("n", "<leader>Gs", function() require("snacks").picker.git_status() end, { desc = "Git Status" })
map("n", "<leader>Gl", function() require("snacks").picker.git_log() end, { desc = "Git Log" })



-----------------------------------------------------
-- TOGGLES (The init function logic)
-----------------------------------------------------
-- This autocommand waits until all plugins are loaded ("VeryLazy" event)
-- before setting up the toggle keymaps. This is best practice.

-- CORRECTED VERSION
-- What the heck is going on down here man 
-- # what even is this does it even work?
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     local snacks_toggle = require("snacks").toggle
--     -- These keymaps let you turn features on and off
--     snacks_toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
--     snacks_toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
--     snacks_toggle.option("spell", { name = "Spelling" }):map("<leader>us")
--     snacks_toggle.diagnostics():map("<leader>ud")
--     snacks_toggle.dim():map("<leader>uD") -- Toggle the dimming effect
--   end,
-- })
