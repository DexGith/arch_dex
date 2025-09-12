

--# this is for the yank visuales when yanking something... it's nice addition 
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 80 }) -- timeout in milliseconds
    end,
})



-- Keymaps for the Quickfix List
vim.keymap.set('n', '<leader>co', '<cmd>copen<cr>', { desc = "Open Quickfix List" })
-- vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = "Next Quickfix Item" })
-- vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = "Previous Quickfix Item" })

-- tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt



-- ------------- Word Wrap ---------------------

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

-- Make j and k move by visual lines when wrap is on. so you move where you see
-- This works automatically with the toggle above.
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Optional: Do the same for Visual mode
vim.keymap.set('v', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('v', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- END------------- Word Wrap END---------------------
