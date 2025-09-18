require("neo-tree").setup({

    --- you can have other settings here ---


  source_selector = {
    winbar = true, -- This is the crucial line to enable the tabs at the top
    statusline = false, -- We don't need it in both places
    sources = {
      -- This table configures the individual tabs.
      -- The order here determines the order they appear in.
      { source = "filesystem",     display_name = " 󰉓 Files " },
      { source = "buffers",        display_name = " 󰈚 Buffers " },
      { source = "git_status",     display_name = " 󰊢 Git " },
      { source = "document_symbols", display_name = " 󰌞 Symbols " },
    },
    -- You can also customize the layout and look of the tabs
    tabs_layout = "equal", -- makes tabs equally sized
  },

  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols", -- This is the crucial line
  },

  -- Add or update the document_symbols specific config if you like
  document_symbols = {
    follow_cursor = true,
    kinds = {
      -- This is the default, but you can customize icons and colors here
      File = { icon = "󰈙", hl = "Constant" },
      Module = { icon = "", hl = "Constant" },
      Namespace = { icon = "󰌗", hl = "Constant" },
      Package = { icon = "", hl = "Constant" },
      Class = { icon = "󰌗", hl = "Include" },
      Method = { icon = "󰆧", hl = "Function" },
      Property = { icon = "", hl = "Identifier" },
      Field = { icon = "", hl = "Identifier" },
      Constructor = { icon = "", hl = "Special" },
      Enum = { icon = "", hl = "Type" },
      Interface = { icon = "󰕘", hl = "Type" },
      Function = { icon = "󰊕", hl = "Function" },
      Variable = { icon = "󰆧", hl = "Identifier" },
      Constant = { icon = "󰏿", hl = "Constant" },
      String = { icon = "󰀬", hl = "String" },
      Number = { icon = "󰎠", hl = "Number" },
      Boolean = { icon = "◩", hl = "Boolean" },
      Array = { icon = "󰅪", hl = "Constant" },
      Object = { icon = "󰅩", hl = "Type" },
      Key = { icon = "󰌋", hl = "Type" },
      Null = { icon = "󰟢", hl = "Comment" },
      EnumMember = { icon = "", hl = "Identifier" },
      Struct = { icon = "󰌗", hl = "Type" },
      Event = { icon = "", hl = "Type" },
      Operator = { icon = "󰆕", hl = "Operator" },
      TypeParameter = { icon = "󰊄", hl = "Type" },
    }
  },


  -- ... other neo-tree settings
  window = {
    position = "float",
    close_if_last_window = true,
    width = 30,
    mappings = {
      -- ... your other mappings ...

      --    This is useful for jumping and highlighting really good. should be there by default in 
      --    neo tree
      ["/"] = "",


      --   these are questionable... the fuzzy sorter is better than the fuzzy finder
      --   because it gives you like it sorts it's really nice... while the actual
      --   fuzzy finder is ass tbh.... telescope's fussy finder is better I think. 
      --   just make sure to like set root before you telescope right... and ez win.
      --   the neotree is nice you can like navigate up then set that to root to make telescope
      --   fuzzy finder better I guess... Anyways 
      ["f"] = "fuzzy_sorter",
      ["#"] = "fuzzy_finder",
      ["e"] = "toggle_node",
      -- Add this mapping to recursively open all nodes
      ["E"] = "expand_all_nodes",
        ["X"] = "filter_on_submit", -- Map <leader>f to the "submit" action
      -- this is fine can act as a filter but I never really use it? why even use this again
      -- instead of like find or telescope or just terminal idk man 
      -- it's meh man... btw you clear it with ctrl+x... it's whatever dude

      -- All your other custom mappings can go here as well.


      ['Y'] = function(state)
        local node = state.tree:get_node()
        if not node or not node.id then
          vim.notify("No node selected.", vim.log.levels.WARN)
          return
        end

        if vim.fn.has('clipboard') == 0 then
          vim.notify("System clipboard is not available.", vim.log.levels.ERROR)
          return
        end

        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local choices = {
          { label = "Absolute path",              value = filepath },
          { label = "Path relative to CWD",       value = modify(filepath, ':.') },
          { label = "Path relative to HOME",      value = modify(filepath, ':~') },
          { label = "Filename",                   value = filename },
          { label = "Filename without extension", value = modify(filename, ':r') },
          { label = "Extension of the filename",  value = modify(filename, ':e') },
        }

        -- THE CHANGE IS ON THIS LINE:
        -- Instead of vim.ui.select, we call the snacks picker directly.
        require("snacks").picker.select(choices, {
          prompt = 'Choose to copy to clipboard:',
          format_item = function(item)
            return string.format("%-30s %s", item.label, item.value)
          end
        }, function(choice)
          if not choice then
            vim.notify("Copy cancelled.", vim.log.levels.INFO)
            return
          end

          local value_to_copy = choice.value

          vim.fn.setreg('+', value_to_copy)
          vim.notify('Copied to clipboard: ' .. value_to_copy)
        end)
      end,

      -- ... other mappings ...
    }
  },
  -- ... other neo-tree settings


  -- default_component_configs = {
  --   modified = {
  --     enabled = true,
  --     padding = 1,
  --     format = "%d-%m-%Y %H:%M",
  --   },
  --   file_size = {
  --     enabled = true,
  --     padding = 1,
  --     format = "%.2f",
  --   },
  --   type = {
  --     enabled = true,
  --     padding = 1,
  --   },
  --   -- You can configure other built-in components here too, like git_status or indent
  -- },


  filesystem = {
    find_by_full_path_words = true,
    follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
    },
    -- hijack_netrw_behavior = "open_current",
    -- ADD OR MODIFY THIS "filter" SECTION
    filter = {
      -- STEP 1: ENABLE THE SETTING
      filter_on_submit = true, -- This tells neo-tree to WAIT for a submit key
      -- STEP 2: MAP THE SUBMIT KEY
      -- mappings = {
      --   -- This is a special mapping context that is ONLY active
        -- ["<leader>f"] = "filter_on_submit", -- Map <leader>f to the "submit" action
      --   -- when you are typing in the filter prompt.
      --   ["<cr>"] = "submit",      -- Keep Enter as a submit key too
      --   ["<esc>"] = "cancel",     -- Escape key to cancel filtering
      -- }
    },
    -- ... your other filesystem settings like filtered_items ...
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = true,
    },
     renderers = {
      -- directory = {
      --   { "indent" },
      --   { "icon" },
      --   { "name" },
      --   { "diagnostics", optional = true },
      --   { "git_status", optional = true },
      -- },
      file = {
        -- { "indent" },
        { "icon" },
        { "name" },
        { "modified", optional = true },
        { "git_status", optional = true },
        { "file_size", optional = true },
        { "diagnostics", optional = true },
        -- { "type", optional = true },
      },
    },
  },

})



-- ------- This will try to solve the noe tree ----------
-- the problem is that neotree doesn't focus filesystem on current file or around it



-- Command to ALWAYS open Neotree in the left sidebar, focused on the current file
vim.api.nvim_create_user_command('NeotreeFocusSidebarHere',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      position = 'left', -- Explicitly set the position!
      -- toggle = true,
      dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree sidebar at the current file\'s directory'
  }
)


-- Command to ALWAYS open Neotree in the left sidebar, focused on the current file
vim.api.nvim_create_user_command('NeotreeFocusSidebarFocus',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      position = 'left', -- Explicitly set the position!
      -- toggle = true,
      -- dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree sidebar at the current file\'s directory'
  }
)

vim.api.nvim_create_user_command('NeotreeFocusSidebarFocus',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      position = 'left', -- Explicitly set the position!
      -- toggle = true,
      dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree sidebar at the current file\'s directory'
  }
)

-- Creates the :NeotreeFloat command
vim.api.nvim_create_user_command('NeotreeFloat',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      -- toggle = true,
      position = 'float',
      -- dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree in a floating window at the current file\'s directory'
  }
)


-- Creates the :NeotreeFloat command
vim.api.nvim_create_user_command('NeotreeFloatHere',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      toggle = true,
      position = 'float',
      dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree in a floating window at the current file\'s directory'
  }
)


-- Creates the :NeotreeFloat command
vim.api.nvim_create_user_command('NeotreeNetrw',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      toggle = true,
      position = 'current',
      -- dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree in a floating window at the current file\'s directory'
  }
)

vim.api.nvim_create_user_command('NeotreeNetrw',
  function()
    require('neo-tree.command').execute({
      source = 'filesystem',
      toggle = true,
      position = 'current',
      -- dir = vim.fn.expand('%:p:h')
    })
  end,
  {
    desc = 'Open Neotree in a floating window at the current file\'s directory'
  }
)


-- Place this in your keymaps file or after the command definition
-- vim.keymap.set('n', '<leader>ppe', vim.cmd.NeotreeFocusSidebarHere, { silent = true, desc = 'Neotree at current file' })


-- # This is sick but I don't like using netrw anymore it makes the buffers scuffed
vim.keymap.set("n", "<leader>pv", vim.cmd.NeotreeFloat)
vim.keymap.set("n", "<leader>pV", vim.cmd.NeotreeFloatHere)

vim.keymap.set("n", "<leader>pw", vim.cmd.NeotreeNetrw)
vim.keymap.set("n", "<leader>pW", vim.cmd.NeotreeNetrwHere)

-- vim.keymap.set("n", "<leader>e", vim.cmd.NeotreeFocusSidebarFocus)
-- vim.keymap.set("n", "<leader>nf", vim.cmd.NeotreeFocusSidebarFocus)

vim.keymap.set('n', '<leader>nf', function()
  require('neo-tree.command').execute({
      source = 'filesystem',
      position = 'left', -- Explicitly set the position!
      -- toggle = true,
      -- dir = vim.fn.expand('%:p:h')
  })
end, { desc = "Neo-tree: open/focus filesystem left" })

-- vim.keymap.set("n", "<leader>nnf", vim.cmd.NeotreeFocusSidebarHere)


vim.keymap.set('n', '<leader>nF', '<cmd>Neotree reveal<CR>', { desc = 'Neotree: Reveal current file' })

-- in your keymaps file or init.lua

-- CORRECTED AND FINAL KEYMAP for document symbols
vim.keymap.set('n', '<leader>ns', function()
  require('neo-tree.command').execute({
    source = "document_symbols",
    -- toggle = true,
    position = "left" -- This achieves the layout you liked in the screenshot
  })
end, { desc = "Neo-tree: Toggle document symbols" })

-- CORRECTED AND FINAL KEYMAP for document symbols
vim.keymap.set('n', '<leader>nb', function()
  require('neo-tree.command').execute({
    source = "buffers",
    -- toggle = true,
    position = "left" -- This achieves the layout you liked in the screenshot
  })
end, { desc = "Neo-tree: Toggle Buffers" })


vim.keymap.set('n', '<leader>ng', function()
  require('neo-tree.command').execute({
    source = "git_status",
    -- toggle = true,
    position = "left", -- This achieves the layout you liked in the screenshot
    dir = vim.fn.expand('%:p:h')
  })
end, { desc = "Neo-tree: Toggle git_status" })



