require("dex")


vim.deprecate = function()
    return function() end
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Automatically handle Zsh command-line editing
local zsh_edit_group = vim.api.nvim_create_augroup('ZshEdit', { clear = true })




-- Create an autocommand group to organize our autocommands.
local wrap_group = vim.api.nvim_create_augroup('WrapSettings', { clear = true })

-- Enable wrap for specific file types (prose, text, etc.).
vim.api.nvim_create_autocmd('FileType', {
  group = wrap_group,
  -- A list of file types where you want text to wrap.
  pattern = {
    'markdown',
    'text',
    'gitcommit',
    'help',
  },
  callback = function()
    vim.opt_local.wrap = true
    -- Optional: You might also want different line breaking behavior for text.
    -- vim.opt_local.linebreak = true
  end,
  desc = 'Enable wrap for text-based filetypes.',
})




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






-- ~/.config/nvim/init.lua

-- Create a group for our custom highlights
local myHighlights = vim.api.nvim_create_augroup("MyHighlights", { clear = true })
-- Set the Visual highlight background when a colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
    group = myHighlights,
    pattern = "*",
    callback = function()
        -- Choose one of the lines below
        -- vim.api.nvim_set_hl(0, "Visual", { bg = "#85674A" }) -- Muted Light Brown
        vim.api.nvim_set_hl(0, "Visual", { bg = "#6B553D" }) -- Subtle Brown (Transparent Feel)


        -- Option 3: Brighter Accent Background
        -- vim.api.nvim_set_hl(0, "MatchParen", { underline = true, bg = "#284B63" })

        -- Option 3: Brighter Accent Background
        vim.api.nvim_set_hl(0, "MatchParen", { bg = "#D14D21" })

        -- Option 3: Brighter Accent Background
        -- vim.api.nvim_set_hl(0, "MatchParen", { bg = "#85674A" })

        -- vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#ff5555', fg = '#ffffff', bold = true })

        -- Option 1: Subtle Underline (Recommended)
        -- vim.api.nvim_set_hl(0, "MatchParen", { underline = true, bg = 'none' })

        -- Option 2: Consistent Brown Background
        -- vim.api.nvim_set_hl(0, "MatchParen", { underline = true, bg = "#6B553D" })



    end,
})


