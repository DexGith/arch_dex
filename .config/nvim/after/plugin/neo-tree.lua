require("neo-tree").setup({
  -- ... your other neo-tree settings might be here ...

  window = {
    mappings = {
      -- 1. Free up '/' for native vim search by mapping it to the "search" command.
      --    Alternatively, `false` or `"noop"` would also work.
      ["/"] = "search",
      
      -- 2. Move the interactive "fuzzy_finder" from '/' to 'f'.
      --    This overrides the default 'f' mapping.
      ["f"] = "fuzzy_finder",

      -- 3. Move the "filter_on_submit" command to '<leader>f'.
      ["<leader>f"] = "filter_on_submit",

      -- All your other custom mappings can go here as well.
    }
  },

  -- ... other settings ...
})
