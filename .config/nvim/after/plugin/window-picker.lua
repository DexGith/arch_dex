-- in remap.lua

-- This function calls the picker. It will use your default settings.
local function pick_and_jump()
  -- Notice we don't need to pass any options here anymore!
  local picked_window_id = require('window-picker').pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end

vim.keymap.set('n', '<leader>pa', pick_and_jump, { desc = "Pick a window to focus" })

