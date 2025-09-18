-- ~/.config/nvim/after/plugin/toggleterm.lua

vim.g.toggleterm_loaded = true

-- Define the function to set keymaps locally before using it
local function set_terminal_keymaps()
  local opts = { buffer = 0 } -- 0 means the current buffer
  -- Exit terminal mode and go back to normal mode
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  -- A more ergonomic way to exit terminal mode
  vim.keymap.set('t', 'jjk', [[<C-\><C-n>]], opts)
  -- Navigate between windows from the terminal
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Main setup for the plugin
require("toggleterm").setup({
  open_mapping = [[<c-\>]],
  on_open = function(term)
    vim.cmd("setlocal nonumber norelativenumber") -- Hide line numbers
    vim.cmd("startinsert!")                     -- Enter insert mode automatically for shell
    set_terminal_keymaps()                       -- Set our custom keymaps
  end,
  start_in_insert = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shade_terminals = true,
  shading_factor = 0,
  float_opts = {
    -- border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- Lazygit custom terminal
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  hidden = true,
  -- We don't need startinsert for lazygit, but we can set the 'q' mapping
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
})

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

---# this is the same is the snacks on so who is better ? 
---# for terminal ofc We have to go with toggleterm right?
vim.keymap.set("n", "<leader>tl", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })

-- We have removed the redundant autocmd because the on_open callback already handles it.
