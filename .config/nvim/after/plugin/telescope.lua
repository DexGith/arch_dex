-- ~/.config/nvim/lua/user/telescope.lua

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require("telescope.actions")

-- =======================================================
-- PART 1: TELESCOPE SETUP
-- This configures the behavior *inside* the Telescope window.
-- This is where we fix <C-v> and <C-s>.
-- =======================================================
telescope.setup({
  defaults = {
    mappings = {
      -- Mappings for insert mode (the prompt at the bottom)
      i = {
        ["<C-s>"] = actions.select_vertical,   -- Open in vertical split
        ["<C-h>"] = actions.select_horizontal, -- Open in horizontal split
        -- ["<C-x>"] = actions.select_horizontal, -- A more reliable alternative to <C-s>
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      },
      -- Mappings for normal mode (the results list)
      n = {
        ["<C-s>"] = actions.select_vertical,
        ["<C-h>"] = actions.select_horizontal,
        -- ["<C-x>"] = actions.select_horizontal,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    -- You can add picker-specific configurations here later
  },
  extensions = {
    -- Your extension configurations
  },
})


-- =======================================================
-- PART 2: YOUR PERSONAL KEYMAPS
-- These are the shortcuts to *launch* the different Telescope pickers.
-- =======================================================
local builtin = require('telescope.builtin')
local keymap = vim.keymap.set

-- Your keymaps, cleaned up and organized:
keymap('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>tt', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>T', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<C-p>', builtin.git_files, { desc = 'Telescope find Git files' })
keymap('n', '<leader>gf', builtin.git_files, { desc = 'Telescope find Git files' })
keymap('n', '<leader>gs', builtin.git_status, { desc = 'Telescope Git status' })

keymap('n', '<leader>tg', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope Grep string' })

keymap('n', '<leader>ts', builtin.lsp_document_symbols, { desc = 'Telescope Document symbols' })
keymap('n', '<leader>tS', builtin.lsp_workspace_symbols, { desc = 'Telescope Workspace symbols' })
keymap('n', '<leader>tw', builtin.lsp_workspace_symbols, { desc = 'Telescope Workspace symbols' })

keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Find buffers' })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Find helper' })
keymap('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>F', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope Find keymaps' })
keymap('n', '<leader>tr', builtin.registers, { desc = 'Telescope Paste from register' })
keymap('n', '<leader>tj', builtin.jumplist, { desc = 'Telescope Jumplist' })
keymap('n', '<leader>to', builtin.oldfiles, { desc = 'Telescope Old files' })
keymap('n', '<leader>tc', builtin.commands, { desc = 'Telescope Commands' })
keymap('n', '<leader>th', builtin.command_history, { desc = 'Telescope Commands history' })
keymap('n', '<leader>tm', builtin.marks, { desc = 'Telescope Find marks' })
keymap('n', '<leader>tH', builtin.man_pages, { desc = 'Telescope Man pages' })
keymap('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope Fuzzy find in buffer' })
keymap('n', '<leader>f?', builtin.builtin, { desc = 'List Telescope built-ins' })
