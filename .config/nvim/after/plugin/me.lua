-- /home/dex/.config/nvim/lua/dex/me.lua

--# this is for the yank visuales when yanking something... it's nice addition 
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 80 }) -- timeout in milliseconds
    end,
})



vim.keymap.set('n', '<leader>sh', '<cmd>:sp<cr>', { desc = "Open Quickfix List" })
vim.keymap.set('n', '<leader>sv', '<cmd>:vsp<cr>', { desc = "Open Quickfix List" })
-- vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = "Next Quickfix Item" })
-- vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = "Previous Quickfix Item" })

-- tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt




--# this is meh but you can like do it manully with like o<esc>{{cc or S}} or
--# just git the vim-impared I guess and learn to use [ and ] better I guess 
-- Open a new, blank, indented line below
-- vim.keymap.set('n', '<leader>oo', function()
--   vim.cmd('put =""')   -- Puts a new blank line below the current one
--   vim.cmd('normal! cc') -- 'cc' clears the line and enters insert mode, respecting indent
-- end, { desc = "Open new line below (no comment/indent)" })
--
-- -- Open a new, blank, indented line above
-- vim.keymap.set('n', '<leader>O', function()
--   vim.cmd('put! =""')  -- Note the '!' to put the line above
--   vim.cmd('normal! cc') -- 'cc' clears the line and enters insert mode, respecting indent
-- end, { desc = "Open new line above (no comment/indent)" })



-- ==============================================================================
-- ==                           Smart Word Wrap                            ==
-- ==============================================================================

-- Function to toggle word wrap and show a notification
function ToggleWrapWithNotification()
  vim.opt.wrap = not vim.opt.wrap:get()
  if vim.opt.wrap:get() then
    vim.notify("Word wrap is ON", vim.log.levels.INFO)
  else
    vim.notify("Word wrap is OFF", vim.log.levels.INFO)
  end
end

-- Keymap to toggle wrap
vim.keymap.set('n', '<leader>W', ToggleWrapWithNotification, { desc = 'Toggle word wrap' })

-- ------------------------------------------------------------------------------
-- --         Motion Overrides for Wrap Mode (The Correct Way)
-- ------------------------------------------------------------------------------
--
-- We use `luaeval()` to execute a snippet of Lua code and return its value.
-- This value is then used in the Vimscript ternary operator (`? :`).
-- This is the correct and robust way to create conditional keymaps.

-- Make j and k move by visual lines when wrap is on.
vim.keymap.set({'n', 'v'}, 'j', "luaeval('vim.opt.wrap:get()') ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({'n', 'v'}, 'k', "luaeval('vim.opt.wrap:get()') ? 'gk' : 'k'", { expr = true, silent = true })

-- Make start/end of line motions wrap-aware.
vim.keymap.set({'n', 'v', 'o'}, '0', "luaeval('vim.opt.wrap:get()') ? 'g0' : '0'", { expr = true, silent = true })
vim.keymap.set({'n', 'v', 'o'}, '^', "luaeval('vim.opt.wrap:get()') ? 'g^' : '^'", { expr = true, silent = true })
vim.keymap.set({'n', 'v', 'o'}, '$', "luaeval('vim.opt.wrap:get()') ? 'g$' : '$'", { expr = true, silent = true })




-- Map Ctrl+f to move the cursor forward (right) in Insert Mode
vim.keymap.set("i", "<C-f>", "<Right>")

-- Map Ctrl+b to move the cursor backward (left) in Insert Mode
        vim.keymap.set("i", "<C-b>", "<Left>")


-- Go to the first non-whitespace character of the line (like ^)
-- Not quite like C-a if I want C-a I just do the like Capslock+a
vim.keymap.set("i", "<C-a>", "<C-o>^")


-- Go to the end of the line (like Ctrl+e in the terminal)
vim.keymap.set("i", "<C-e>", "<End>")


vim.keymap.set('n', '<leader>tt', function()
    vim.fn.system('alacritty --working-directory ' .. vim.fn.expand('%:p:h') .. ' &')
end, { noremap = true, silent = true, desc = "Open Alacritty in current file's directory" })




--# idk didn't work so I put them here for now 
--# I added this for fun just testing things out 
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { silent = true })
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { silent = true })

