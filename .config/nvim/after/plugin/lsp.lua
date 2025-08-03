-- ~/.config/nvim/lua/user/lsp.lua

-- This is the core setup for your LSP configuration.
-- It should be called after your LSP-related plugins have been loaded.


-- Setup for nvim-cmp, the completion engine
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    -- This is the official snippet integration for nvim-cmp
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  -- These are the sources nvim-cmp will use for suggestions
  sources = cmp.config.sources({
    -- { name = "copilot", group_index = 2 }, -- IMPORTANT: Uncomment this ONLY if you have the Copilot plugin
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Setup for vim diagnostics (the little icons and popups that show errors)
vim.diagnostic.config({
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Setup for fidget, the LSP progress indicator
require("fidget").setup({})

-- Setup for mason, the LSP installer
require("mason").setup()

-- Setup for mason-lspconfig, which connects mason to the lspconfig plugin
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup({
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "pyright"
    -- Add other servers here, like "pyright", "tsserver", etc.
  },
  -- This is where you configure each LSP server
  handlers = {
    -- This is the default handler for servers that don't have a specific setup below
    function(server_name)
      require("lspconfig")[server_name].setup {
        capabilities = lsp_capabilities,
      }
    end,

    -- Custom setup for the Lua language server
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup {
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            -- Tell the language server about your Neovim runtime files
            runtime = { version = 'Neovim' },
            diagnostics = {
              -- Get the language server to recognize "vim" as a global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      }
    end,
  },
})

-- Optional: Setup for conform.nvim (auto-formatting)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- You can add other formatters here
    -- python = { "isort", "black" },
    -- javascript = { "prettier" },
  },
  -- If you want auto-formatting on save, uncomment the following
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
})

