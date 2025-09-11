require("dex")


--
-- Automatically handle Zsh command-line editing
local zsh_edit_group = vim.api.nvim_create_augroup('ZshEdit', { clear = true })

-- Rule 1: When we enter a temporary Zsh buffer, mark it as disposable.
-- 'bufhidden=wipe' tells Neovim to completely erase the buffer from memory
-- when it's no longer on screen. This prevents it from polluting the jumplist.
vim.api.nvim_create_autocmd('BufEnter', {
  group = zsh_edit_group,
  pattern = '/tmp/zsh*',
  callback = function()
    vim.bo.bufhidden = 'wipe'
  end,
})

-- Rule 2: After saving the Zsh buffer, quit Neovim immediately.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = zsh_edit_group,
  pattern = '/tmp/zsh*',
  command = 'q!',
})

vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.keymap.set("n", "gl", vim.diagnostic.open_float)



-- -- Get the shada option object
-- local shada_opt = vim.opt.shada
--
-- -- Remove the single quote from the list of items to save.
-- -- The single quote (') is responsible for saving the jump list.
-- shada_opt:remove("'")
--
-- -- Clear the jumplist every time Neovim starts
-- vim.api.nvim_create_autocmd('VimEnter', {
--   pattern = '*',
--   command = 'clearjumps',
-- })
--
--




-- -- Disable folding for zsh files to prevent rendering bugs
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--   pattern = {"*.zsh", ".zshrc"},
--   command = "setlocal nofoldenable",
-- })










