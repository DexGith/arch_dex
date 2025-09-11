-- ~/.config/nvim/lua/user/lualine.lua -- SIMPLE & CORRECT VERSION

local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end



-- STEP 1: CONFIGURE NAVIC
-- We do this right here in lualine.lua to guarantee it's set up correctly.
require("nvim-navic").setup {
    icons = {
        File          = "󰈙 ",
        Module        = " ",
        Namespace     = "󰌗 ",
        Package       = " ",
        Class         = "󰌗 ",
        Method        = "󰆧 ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "󰕘 ",
        Interface     = "󰕘 ",
        Function      = "󰊕 ",
        Variable      = "󰆧 ",
        Constant      = "󰏿 ",
        String        = "󰀬 ",
        Number        = "󰎠 ",
        Boolean       = "◩ ",
        Array         = "󰅪 ",
        Object        = "󰅩 ",
        Key           = "󰌋 ",
        Null          = "󰟢 ",
        EnumMember    = " ",
        Struct        = "󰌗 ",
        Event         = " ",
        Operator      = "󰆕 ",
        TypeParameter = "󰊄 ",
    },
    lsp = { auto_attach = true },
    highlight = true, -- This tells navic to try and use theme colors by default
}


-- ===================================================================
-- CUSTOM NAVIC HIGHLIGHTS
-- Link navic components to our theme's colors 
-- Telescope highlight helps
-- ===================================================================

vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "BlinkCmpKindEnum" }) -- The blue for {}
vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "BlinkCmpKindSnippet" }) -- The blue for {}
vim.api.nvim_set_hl(0, "NavicText",        { link = "Identifier" })

-- vim.api.nvim_set_hl(0, "NavicText",        { link = "Normal" })         -- Use the default text color
vim.api.nvim_set_hl(0, "NavicSeparator",   { link = "Comment" })        -- Use the comment color for '>'




-- STEP 2: SETUP LUALINE
lualine.setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      winbar = { 'neo-tree', 'NvimTree' },
    },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  -- STEP 3: CONFIGURE THE WINBAR to use Navic
  winbar = {
    lualine_c = {
      {
        'navic',
        -- We can use the simple string 'navic' because lualine has built-in
        -- support for nvim-navic. This is the most reliable method.
      }
    },
    lualine_x = { { 'filename', path = 1 } },
  },
  inactive_winbar = {
      lualine_c = { { 'filename', path = 1 } },
  },
  extensions = {}
})
