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
	  name = "rose-pine",
	  config = function()
		  vim.cmd("colorscheme rose-pine")
	  end
  })


  use({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          "nvim-tree/nvim-web-devicons", -- optional, but recommended
      }
  })


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

