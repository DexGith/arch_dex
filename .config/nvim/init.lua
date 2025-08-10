require("theprimegen")



-- Automatically quit after saving a Zsh command-line edit file

-- 1. Create an autocommand group.
--    The `clear = true` option clears the group every time this config is sourced,
--    preventing duplicate autocommands from piling up.
local zsh_edit_group = vim.api.nvim_create_augroup('ZshEditQuit', { clear = true })

-- 2. Create the autocommand.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = zsh_edit_group,
  pattern = '/tmp/zsh*',
  command = 'q!',
})



vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"



vim.keymap.set("n", "gl", vim.diagnostic.open_float)
