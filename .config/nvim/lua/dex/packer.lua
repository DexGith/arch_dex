-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- lua/plugins/rose-pine.lua
    use ({
        "rose-pine/neovim",
        lazy = false, -- Load this theme on startup
        priority = 1000, -- Make sure it loads before other plugins
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    })
    use {
        'folke/tokyonight.nvim',
        -- lazy = false, -- Load this theme on startup
        -- priority = 1000, -- Make sure it loads before other plugins
        -- config = function()
        --     -- This sets the colorscheme when the plugin is loaded
        --     vim.cmd.colorscheme 'tokyonight'
        -- end
    }

use {'kevinhwang91/nvim-bqf', ft = 'qf'}

use {
    "SmiteshP/nvim-navbuddy",
    requires = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim",        -- Optional
        "nvim-telescope/telescope.nvim" -- Optional
    }
}


    -- in packer.lua
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    })

    -- in packer.lua

    use {
        's1n7ax/nvim-window-picker',
        config = function()
            require('window-picker').setup({
                -- This sets the style you want
                hint = 'floating-big-letter',

                -- Add this section to change what windows are ignored
                filter_rules = {
                    bo = {
                        -- By default, this list includes 'neo-tree'.
                        -- We are giving it a new list that doesn't have it.
                        filetype = { 'NvimTree', 'notify', 'snacks_notif', 'packer' },
                    }
                }
            })
        end,
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
    }

    use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use {
        'neovim/nvim-lspconfig', -- The main plugin for LSP configuration
        requires = {
            -- All the dependencies that nvim-lspconfig needs to provide a good experience

            -- For code formatting
            'stevearc/conform.nvim',

            -- For managing LSP servers, formatters, etc.
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- The completion engine
            'hrsh7th/nvim-cmp',

            -- Sources for the completion engine
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',

            -- The snippet engine
            'L3MON4D3/LuaSnip',

            -- A completion source for snippets
            'saadparwaiz1/cmp_luasnip',

            -- A UI plugin to show LSP status
            'j-hui/fidget.nvim',
        },
    }
end)

