-- -- File: ~/.config/nvim/after/plugin/bqf.lua




--# idk where to fking get started with this shit man how do I configure it man
--# same with harpoon I want it to have the C-s and C-h but anyways 


--
-- vim.api.nvim_create_autocmd('FileType', {
--   -- This pattern ensures the code only runs when you open the quickfix window
--   pattern = 'qf',
--
--   -- The callback function runs AFTER packer has loaded the plugin
--   callback = function()
--     -- Now, we place all the configuration from the documentation inside here.
--     require('bqf').setup({
--         ----------------------------------------------------
--         -- START: YOUR CUSTOM CONFIGURATION FROM THE DOCS --
--         ----------------------------------------------------
--
--         -- Highly recommended setting from the docs
--         auto_resize_height = true,
--
--         -- Your custom key mappings
--         func_map = {
--             vsplit = 'C-s',     -- Remap vertical split to 's'
--             split = '<C-h>',  -- Remap horizontal split to 'Ctrl+h'
--         },
--
--         -- You can add any other options from the docs here.
--         -- For example, to change the preview window border:
--         preview = {
--             border = 'single', -- Options: 'rounded', 'single', 'double', etc.
--             win_height = 12,
--         },
--
--         -- To add custom fzf options:
--         filter = {
--             fzf = {
--                 extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
--             }
--         }
--
--         --------------------------------------------------
--         -- END: YOUR CUSTOM CONFIGURATION FROM THE DOCS --
--         --------------------------------------------------
--     })
--   end,
-- })
