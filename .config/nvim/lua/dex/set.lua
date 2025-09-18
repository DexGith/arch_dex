-- /home/dex/.config/nvim/lua/dex/set.lua

vim.opt.guicursor = ""
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--# whatt even is this lol 
-- vim.o.laststatus = 3 -- Use a global statusline at the very bottom of the window

local opt = vim.opt
opt.number = true
-- ... all your other persona


vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- ADD THESE TWO LINES HERE
-- vim.opt.timeoutlen = 650 -- Time in ms to wait for a mapped sequence to complete
-- vim.opt.ttimeoutlen = 10  -- Time in ms to wait for a key code sequence


vim.opt.listchars = 'tab:▸\\ ,trail:·,space:·,extends:»,precedes:«'

-- Allow the mouse to be used in neovim
vim.o.mouse = 'a'


-- :set virtualedit=onemore: A popular setting. It allows the cursor to move one character past the end of the line. This is surprisingly useful.
-- vim.opt.virtualedit = onemore

-- :set virtualedit=all: Allows the cursor to move to any column on any line, even if it's completely empty.
-- vim.opt.virtualedit = all

