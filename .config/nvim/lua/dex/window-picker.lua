-- in remap.lua or a similar keymap file

local picker = require('window-picker')

-- A function to pick a window and then jump to it
local function pick_and_jump()
  local picked_window_id = picker.pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end

-- Map this function to a key. <leader>w is a common choice.
-- The 'n' means normal mode.
vim.keymap.set('n', '<leader>pa', pick_and_jump, { desc = "Pick a window to focus" })
