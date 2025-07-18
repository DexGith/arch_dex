set fdm=manual
" set foldmethod=indent   " Or 'syntax', 'expr', 'marker'
set textwidth=9999
set hidden
set relativenumber
set number
set mouse=a
set termguicolors
syntax on
set cursorline
set timeoutlen=1000
set ttimeoutlen=10  " this is for Esc to no feel slugish but makes keystrokes like leader and what not slwo 100
" --- 3. Folding Settings ---
set foldlevelstart=99   " Start with folds open
" set foldcolumn=1      " Optional if you want a dedicated column for +/- fold markers

set sidescrolloff=5
set sidescroll=0
set nowrap
set scrolloff=5
let g:airline#extensions#tabline#enabled = 0

set timeout " Ensure timeout is generally on

" 1. Define timeoutlen for Normal Mode
" This is the timeout for commands like "+p or your normal mode leader mappings.
" Adjust this value for comfortable phone typing.
let g:normal_mode_timeoutlen = 3000 " Example: 3 seconds for phone

" 2. Define timeoutlen for Insert Mode Mappings (like 'jjk')
" This should be short if you want 'jjk' to be responsive.
let g:insert_mode_timeoutlen = 165  " Example: 200ms. Adjust if 'jjk' feels off.

" 3. Set the initial global timeoutlen to your Normal mode preference
"    Use 'let &' to assign an option from a variable.
let &timeoutlen = g:normal_mode_timeoutlen

" 4. Autocommands to switch timeoutlen when entering/leaving Insert Mode
augroup InsertModeTimeoutSettings
    " Clear any previous autocommands defined in THIS group
    autocmd!

    " When entering Insert mode, set timeoutlen for insert mode mappings (like jjk)
    autocmd InsertEnter * let &timeoutlen = g:insert_mode_timeoutlen

    " When leaving Insert mode, restore the Normal mode timeoutlen
    autocmd InsertLeave * let &timeoutlen = g:normal_mode_timeoutlen
augroup END

call plug#begin()
    Plug 'https://github.com/akinsho/toggleterm.nvim', { 'tag': '*' }
    Plug 'https://github.com/tpope/vim-commentary'
    Plug 'https://github.com/preservim/nerdtree'
    Plug 'https://github.com/preservim/tagbar'
    Plug 'https://github.com/neoclide/coc.nvim'
    Plug 'https://github.com/vim-airline/vim-airline'  "<--- temp  unplugin
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/matze/vim-move'
    Plug 'nvim-tree/nvim-web-devicons' " For colored icons
    Plug 'ryanoasis/vim-devicons'      " For NERDTree integration
    Plug 'akinsho/bufferline.nvim', { 'tag': '*' } " this bugger is idk it's not functioning correctly and idk werid 
    Plug 'https://github.com/navarasu/onedark.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'kevinhwang91/nvim-bqf', { 'for': 'qf' }
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" ---- GLOBAL PLUGIN CONFIGURATIONS (EARLY) ----
" Tell ryanoasis/vim-devicons to patch NERDTree. IMPORTANT: Place this early.
let g:webdevicons_enable_nerdtree = 1

" ---- LUA CONFIGURATION ----
lua << EOF


vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*", -- Apply to all files
  callback = function()
    -- Check if the last known cursor position ('" mark) is valid
    -- and not just the beginning of the file (line 1, col 0 or 1).
    -- getpos returns [bufnum, lnum, col, off]
    -- lnum 0 means mark is not set in current buffer.
    local last_pos = vim.fn.getpos("'\"")
    if last_pos[2] > 0 and (last_pos[2] > 1 or last_pos[3] > 1) then
      -- Jump to the exact last cursor position
      vim.cmd('normal! g`"')
      -- Optional: If you also want to center the screen on the cursor
      -- vim.cmd('normal! zz')
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 }) -- timeout in milliseconds
    end,
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function() require('bqf').setup({}) end,
})

-- nvim-web-devicons setup: DEFINE YOUR ICON COLORS HERE
local devicons_status_ok, devicons = pcall(require, "nvim-web-devicons")
if not devicons_status_ok then
  vim.notify("nvim-web-devicons not found", vim.log.levels.WARN)
else
  devicons.setup {
    color_icons = true, -- Crucial for nvim-web-devicons to attempt coloring
    default = true,
    strict = true,
    override_by_extension = {
      -- Define your desired icons AND colors here
      ["vim"] = { icon = "", color = "#98C379", name = "Vim" },      -- Green
      ["log"] = { icon = "", color = "#E5C07B", name = "Log" },      -- Yellow
      ["lua"] = { icon = "", color = "#61AFEF", name = "Lua" },      -- Blue
      ["js"]  = { icon = "", color = "#D19A66", name = "JavaScript" },-- Orange/Yellow
      ["json"]= { icon = "", color = "#ABB2BF", name = "JSON" },     -- Grey
      ["html"]= { icon = "", color = "#E06C75", name = "HTML" },     -- Red/Coral
      ["css"] = { icon = "", color = "#56B6C2", name = "CSS" },      -- Cyan
      ["md"]  = { icon = "", color = "#C678DD", name = "Markdown" }, -- Purple
      ["py"]  = { icon = "", color = "#61AFEF", name = "Python" },   -- Blue
      ["txt"] = { icon = "", color = "#A0A0A0", name = "Text" },      -- Subtle Grey
      ["sh"]  = { icon = "", color = "#D19A66", name = "Sh" },       -- Shell icon, Orange/Yellow
      -- Add more as needed
    },
    override_by_filename = { -- Keep your existing .gitignore override
      [".gitignore"] = { icon = "", color = "#f1502f", name = "Gitignore" }
    }
  }
end

-- Toggleterm setup (using your full setup from the provided config)
require("toggleterm").setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-t>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = '2',
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal"
    }
  }
}

-- Bufferline Setup (using your full setup from the provided config)
-- vim.opt.termguicolors = true
-- require("bufferline").setup{ -- this is too confusing and makes like buffer tabs and idk annoying
--   options = {
--     mode = "buffers",
--     numbers = "none",
--     close_icon = '',
--     indicator = { style = 'underline' },
--     buffer_close_icon = '',
--     modified_icon = '●',
--     left_trunc_marker = '',
--     right_trunc_marker = '',
--     show_buffer_icons = true,
--     show_buffer_close_icons = true,
--     show_close_icon = true,
--     show_tab_indicators = true,
--     persist_buffer_sort = true,
--     separator_style = "thin",
--     enforce_regular_tabs = false,
--     always_show_bufferline = true,
--     hover = { enabled = true, delay = 200, reveal = {'close'} },
--     offsets = {
--         {
--             filetype = "NvimTree",
--             text = "File Explorer",
--             text_align = "left",
--             separator = true
--         }
--     },
--     diagnostics = "nvim_lsp",
--     diagnostics_indicator = function(count, level, diagnostics_dict, context)
--       local icon = level == vim.diagnostic.severity.ERROR and ' ' or (level == vim.diagnostic.severity.WARN and ' ' or ' ')
--       return icon .. count
--     end
--   }
-- }

-- In your lua << EOF block
vim.opt.termguicolors = true  -- simpler
require("bufferline").setup{
  options = {
    -- Show buffer numbers and icons, but keep it clean
    -- numbers = "buffer_id", -- this makes the tabs show buffer number
    numbers = "ordinal", -- this makes the tabs show just number in order
    show_buffer_icons = true,
    show_buffer_close_icons = false, -- Less clutter
    show_close_icon = false,         -- Less clutter
    
    -- IMPORTANT: This tells bufferline to NOT show Vim's native tabs.
    -- This helps resolve the "1 2 3" vs buffer list confusion.
    show_tab_indicators = false,
    
    -- This is the key to making it play nice with NERDTree.
    -- It pushes the bufferline to the side when a file explorer is open.
    offsets = {
        {
            filetype = "NvimTree", -- Change to "nerdtree" if you stick with it
            text = "File Explorer",
            text_align = "left",
            separator = true
        }
    }
  }
}


-- IBL Setup (using your full setup from the provided config)
require("ibl").setup({
    indent = { char = "▏", tab_char = "▏" },
    scope = { enabled = true, show_start = true, show_end = true },
    exclude = {
        filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "NvimTree", "TelescopePrompt" },
        buftypes = { "terminal" },
    },
})

-- Gitsigns Setup (using your full setup from the provided config)
local gitsigns_status_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_status_ok then
  vim.notify("gitsigns could not be loaded", vim.log.levels.WARN)
else
  gitsigns.setup({
    signs = {
      add          = { text = '▎' }, change       = { text = '▎' }, delete       = { text = '_' },
      topdelete    = { text = '‾' }, changedelete = { text = '~' }, untracked    = { text = '┆' },
    },
    signcolumn = true, numhl = false, linehl = false, word_diff  = false,
    watch_gitdir = { follow_files = true },
    auto_attach = true, attach_to_untracked = true, current_line_blame = false,
    current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol', delay = 1000, ignore_whitespace = false, virt_text_priority = 100, },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6, update_debounce = 100, status_formatter = nil, max_file_length = 40000,
    preview_config = { border = 'rounded', style = 'minimal', relative = 'cursor', row = 0, col = 1 },
  })
end
EOF

" ---- COLORSCHEME AND CUSTOM ICON REINFORCEMENT ----
" let g:onedark_config = { 'style': 'warmer' } " Or 'cool' or your preferred onedark style
" ======================================================================
" CUSTOM VISUAL SELECTION HIGHLIGHT (ADD THIS SECTION)
" ======================================================================
" Un-comment ONE of the following lines to choose your style.

colorscheme onedark
" Option 1: A strong, noticeable yellow background. The text color will remain the same.
" highlight Visual guibg=#E5C07B

" Option 2: A different, more muted blue background.
" highlight Visual guibg=#61AFEF

" Option 3: A brighter gray background from the onedark palette.
" highlight Visual guibg=#5c6370


highlight Visual gui=reverse
" Load your colorscheme first
" colorscheme gruvbox

" Load your colorscheme first

" ... other settings ...

" Set highlight groups to have no background
" This is the section you need to RE-ENABLE.
highlight Normal ctermbg=none guibg=NONE
highlight NormalNC ctermbg=none guibg=NONE
highlight NormalFloat ctermbg=none guibg=NONE
highlight LineNr ctermbg=none guibg=NONE
highlight SignColumn ctermbg=none guibg=NONE
highlight EndOfBuffer ctermbg=none guibg=NONE


" " " For your vim-airline status bar
highlight AirlineA guibg=NONE
highlight AirlineB guibg=NONE
highlight AirlineC guibg=NONE

" " For floating windows from plugins like CoC
highlight NormalFloat guibg=NONE

" For the NERDTree background
" (NERDTree often inherits from Normal, but if it doesn't, you may need this)
highlight NERDTreeDir guibg=NONE

" ======================================================================kk

" ---- NERDTREE CONFIGURATION ----
let g:NERDTreeHijackNetrw = 1 " NERDTREE :edit . , this makes the :edit . not pring nerdtree wish makes going back to previous buffer annying
let g:NERDTreeChDirMode = 0   " <-- ADD THIS LINE
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ "Modified"  : "✹", "Staged"    : "✚", "Untracked" : "✭",
            \ "Renamed"   : "➜", "Unmerged"  : "═", "Deleted"   : "✖",
            \ "Dirty"     : "✗", "Clean"     : "✔︎", "Ignored"   : "☒",
            \ "Unknown"   : "?"
            \ }
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowClean = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1



" Autocommand to re-apply/reinforce icon colors AFTER the colorscheme loads
" Autocommand to re-apply/reinforce icon colors AFTER the colorscheme loads
augroup MyNerdTreeIconColors
  autocmd!
  autocmd ColorScheme * call s:ApplyNerdTreeIconColors()
  autocmd ColorScheme * call s:ApplyBufferlineHighlights() 
augroup END


" --- Smart Bufferline Mappings for NERDTree ---
" This group creates special mappings only when NERDTree is the active window.
augroup NerdTreeBufferlineMappings
  autocmd!
  " When a file of type 'nerdtree' is opened, set up our custom mappings
  autocmd FileType nerdtree call s:SetupNerdTreeBufferlineMappings()
augroup END

function! s:SetupNerdTreeBufferlineMappings()
  " These <buffer> mappings ONLY exist when the NERDTree buffer is active.
  " We use <Bar> which is the special, canonical way to represent a pipe '|'
  " inside a mapping, as explained in ':help map_bar'.

  " Move buffer RIGHT from within NERDTree
  nnoremap <silent><buffer> <C-D-A-l> :wincmd p<CR> 

  " Move buffer LEFT from within NERDTree
  nnoremap <silent><buffer> <C-D-A-h> :wincmd p<CR>
endfunction

function! s:ApplyNerdTreeIconColors()
  if !&termguicolors | return | endif

  " Target ryanoasis/vim-devicons specific groups (DevIcons<FileType> - PLURAL)
  " These should use the same hex codes as intended in your Lua nvim-web-devicons setup.

  highlight clear DevIconsVim " Plural
  highlight DevIconsVim guifg=#98C379

  highlight clear DevIconsLog " Plural
  highlight DevIconsLog guifg=#E5C07B " For your .log file

  highlight clear DevIconsLua " Plural
  highlight DevIconsLua guifg=#61AFEF

  " For .js, ryanoasis/vim-devicons might use DevIconsJavascript or DevIconsJs. Try both if one fails.
  highlight clear DevIconsJs " Plural
  highlight DevIconsJs guifg=#D19A66
  " highlight clear DevIconsJavascript " Plural
  " highlight DevIconsJavascript guifg=#D19A66

  highlight clear DevIconsJson " Plural
  highlight DevIconsJson guifg=#ABB2BF

  highlight clear DevIconsHtml " Plural
  highlight DevIconsHtml guifg=#E06C75

  highlight clear DevIconsCss " Plural
  highlight DevIconsCss guifg=#56B6C2

  " For .md, ryanoasis/vim-devicons might use DevIconsMarkdown or DevIconsMd.
  highlight clear DevIconsMd " Plural
  highlight DevIconsMd guifg=#C678DD
  " highlight clear DevIconsMarkdown " Plural
  " highlight DevIconsMarkdown guifg=#C678DD

  " For .py, ryanoasis/vim-devicons might use DevIconsPython or DevIconsPy.
  highlight clear DevIconsPy " Plural
  highlight DevIconsPy guifg=#61AFEF
  " highlight clear DevIconsPython " Plural
  " highlight DevIconsPython guifg=#61AFEF

  highlight clear DevIconsTxt " Plural
  highlight DevIconsTxt guifg=#A0A0A0

  " For .gitignore, the Lua setup uses name "Gitignore".
  " nvim-web-devicons would create DevIconGitignore (singular).
  " ryanoasis/vim-devicons might use DevIconsGit or try to map DevIconGitignore to DevIconsGitignore (plural).
  " This one is a bit tricky. Let's try DevIconsGitignore first as that's what the name field implies.
  highlight clear DevIconsGitignore " Plural, assuming it maps from the 'name' field
  highlight DevIconsGitignore guifg=#f1502f
  " If that doesn't work, ryanoasis/vim-devicons might use a more generic 'DevIconsGit' for .gitignore
  " highlight clear DevIconsGit
  " highlight DevIconsGit guifg=#f1502f

  " For Shell scripts (.sh files like your testinglocation.sh)
  highlight clear DevIconsSh " Plural
  highlight DevIconsSh guifg=#D19A66 " Let's try the same orange/yellow as JS for .sh for now

  highlight clear DevIconsDefault " Plural
  highlight DevIconsDefault guifg=#ABB2BF " Fallback
endfunction

" --- ApplyBufferlineHighlights ----
function! s:ApplyBufferlineHighlights()
    if !&termguicolors | return | endif

    " --- Strong Highlight for the CURRENT/SELECTED buffer ---
    highlight BufferLineBufferSelected guibg=#3E4452 guifg=#E5C07B gui=bold
    " It now has a lighter background, bright yellow text, and is bold.

    " --- Make INACTIVE buffers less prominent ---
    " This makes the selected one stand out even more.
    highlight BufferLineBuffer guibg=NONE guifg=#6B7280

    " --- (Optional) Highlight for VISIBLE but not selected buffers (e.g., in a split) ---
    " highlight BufferLineBufferVisible guibg=NONE guifg=#ABB2BF
    highlight BufferLineBufferVisible guibg=NONE guifg=#E5C07B " <<< THIS IS THE NEW, VISIBLE HIGHLIGHT
endfunction

call s:ApplyNerdTreeIconColors()
call s:ApplyBufferlineHighlights()


" ---- FOLDING ----
function! MyFoldText()
  let line_nr_str = printf('%3s', v:foldstart)
  let fold_char = '▸'
  let line_text = substitute(getline(v:foldstart), '^\s*\|\s*$', '', 'g')
  let max_len = winwidth(0) - 20
  if strlen(line_text) > max_len && max_len > 0
    let line_text = strcharpart(line_text, 0, max_len - 3) . '...'
  endif
  let num_folded_lines = v:foldend - v:foldstart + 1
  let lines_str = num_folded_lines . ' line' . (num_folded_lines > 1 ? 's' : '')
  return line_nr_str . '  ' . fold_char . ' ' . line_text . ' (' . lines_str . ')'
endfunction
set foldtext=MyFoldText()

" ---- OTHER CUSTOM HIGHLIGHTS ----
highlight Folded guifg=#888888 guibg=NONE ctermfg=darkgrey ctermbg=NONE
highlight IblIndent guifg=#4A4A4A ctermfg=darkgrey
highlight IblScope guifg=#E5C07B ctermfg=yellow
highlight CursorLineNr guifg=#E5C07B guibg=NONE gui=bold ctermfg=yellow ctermbg=NONE term=bold


" ---- MAPPINGS AND THE REST OF YOUR CONFIG ----
let mapleader = " "
let maplocalleader = ' '




function! SetupToggleTermMappings()
  tnoremap <silent><buffer> <Esc> <C-\><C-n>
  tnoremap <silent><buffer> jjk <C-\><C-n>
endfunction
autocmd TermOpen term://*toggleterm#* call SetupToggleTermMappings()

nnoremap <leader>Tv :ToggleTerm direction=vertical<CR>
nnoremap <leader>Th :ToggleTerm direction=horizontal<CR>
nnoremap <leader>Tf :ToggleTerm direction=float<CR>
nnoremap <leader>Tt :ToggleTerm direction=tab<CR>
nnoremap <leader>Ts :ToggleTermSendCurrentLine<CR>
vnoremap <leader>TS :ToggleTermSendVisualLines<CR>
vnoremap <leader>Ts :ToggleTermSendVisualSelection<CR>
nnoremap <leader>TT <Cmd>ToggleTerm<CR>

inoremap <F24> <Nop>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fz :Windows<CR>
vnoremap <leader>fz <Esc>:Windows<CR>
nnoremap <silent><C-`> :Windows<CR>
inoremap <silent><C-`> <Esc>:Windows<CR>
vnoremap <silent><C-`> <Esc>:Windows<CR>

nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>
nnoremap <leader>qn :cnext<CR>
nnoremap <leader>qp :cprevious<CR>
nnoremap <leader>qf :cfirst<CR>
nnoremap <leader>ql :clast<CR>

nnoremap <silent> <leader>bn :bnext<CR>
nnoremap <silent> <leader>bp :bprevious<CR>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>b1 :BufferLineGoToBuffer 1<CR>
nnoremap <silent> <leader>b2 :BufferLineGoToBuffer 2<CR>
nnoremap <silent> <leader>b3 :BufferLineGoToBuffer 3<CR>
nnoremap <silent> <leader>b4 :BufferLineGoToBuffer 4<CR>
nnoremap <silent> <leader>b5 :BufferLineGoToBuffer 5<CR>
nnoremap <silent> <leader>b6 :BufferLineGoToBuffer 6<CR>
nnoremap <silent> <leader>b7 :BufferLineGoToBuffer 7<CR>
nnoremap <silent> <leader>b8 :BufferLineGoToBuffer 8<CR>
nnoremap <silent> <leader>b9 :BufferLineGoToBuffer 9<CR>
nnoremap <silent> <leader>b0 :BufferLineGoToBuffer 10<CR>
nnoremap <silent> <leader>bi :BufferLinePick<CR>

nnoremap <C-G> <C-F>
vnoremap <C-G> <C-F>
noremap <A-S-O> O<Esc>r<Space>
noremap <A-o> o<Esc>r<Space>

nnoremap <leader>// <Cmd>nohlsearch <Bar> redraw!<CR>
nnoremap <leader>/v /\%V
xnoremap <leader>/v <Esc>/\%V
vnoremap <leader>/i y/\V<C-R>"

inoremap <C-Delete> <C-O>dw
inoremap <C-Backspace> <C-O>dw
inoremap <C-W> <C-O>dw
inoremap <C-B> <C-O>db

inoremap <C-l> <S-right>
inoremap <C-h> <S-left>
inoremap jjk <Esc>
inoremap <C-k> <up><up>
noremap <C-k>  2<up>
inoremap <C-j> <down><down>
noremap <C-j> 2<down>

noremap <C-l> 4<right>
noremap <C-h> 4<left>
noremap <D-A-l> 4<right>
noremap <D-A-h> 4<left>

noremap <A-i> <Esc>
inoremap <A-i> <Esc>
inoremap <A-h> <right><Esc><left>
inoremap <A-l> <right><Esc><right>

noremap <D-h> h
noremap <D-S-h> g^
noremap <D-l> l
noremap <D-C-h> 12<left>
noremap <D-S-l> g$
noremap <D-C-l> 12<right>
noremap  <D-j> gj
noremap  <D-C-k> 8<up>
noremap <D-k> gk
noremap <D-C-j> 8<down>
inoremap <D-h> <left>
inoremap <C-h> <left><left><left><left>
inoremap <D-l> <right>
inoremap <C-l> <right><right><right><right>
inoremap <D-k> <Esc>lgki
inoremap <C-k> <Esc>l2gki
inoremap <D-C-k> <Esc>l8gki
inoremap <D-j> <Esc>lgji
inoremap <C-j> <Esc>l2gji
inoremap <D-C-j> <Esc>l8gji

nnoremap <leader>nf :NERDTreeFocus<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nr :NERDTreeFind<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-S-e> :NERDTreeFind<CR>
nnoremap <C-S-j> <Nop>
vnoremap <C-S-j> <Nop>
inoremap <C-S-j> <Nop>
nnoremap <leader>et :TagbarToggle<CR>
nnoremap <leader>SW :set wrap!<CR>

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

noremap  <C-A-h> <C-w>h
noremap  <C-A-j> <C-w>j
noremap  <C-A-k> <C-w>k
noremap  <C-A-l> <C-w>l
inoremap <C-A-h> <C-o><C-w>h
inoremap <C-A-j> <C-o><C-w>j
inoremap <C-A-k> <C-o><C-w>k
inoremap <C-A-l> <C-o><C-w>l
tnoremap <C-A-h> <C-\><C-n><C-w>h
tnoremap <C-A-j> <C-\><C-n><C-w>j
tnoremap <C-A-k> <C-\><C-n><C-w>k
tnoremap <C-A-l> <C-\><C-n><C-w>l

noremap  <leader>hh <C-w>h
noremap  <leader>jj <C-w>j
noremap  <leader>kk <C-w>k
noremap  <leader>ll <C-w>l
tnoremap <leader>hh <C-\><C-n><C-w>h
tnoremap <leader>jj <C-\><C-n><C-w>j
tnoremap <leader>kk <C-\><C-n><C-w>k
tnoremap <leader>ll <C-\><C-n><C-w>l
nnoremap ; :

noremap H ^
noremap L $

noremap gH g^
noremap L g$

nnoremap <Leader>bb <C-^>

" In your MAPPINGS section
" ...

" Move buffers left/right in the bufferline with Alt + h/l
nnoremap <silent> <C-D-A-h> <Cmd>BufferLineMovePrev<CR>
nnoremap <silent> <C-D-A-l> <Cmd>BufferLineMoveNext<CR>

" ... rest of your mappings
" A more ergonomic single-key toggle for line numbers
function! ToggleLineNumbers()
  if &relativenumber
    set norelativenumber
    set nonumber
  else
    set relativenumber
    set number
  endif
endfunction

" Map <leader>tn to call the function
nnoremap <silent> <leader>00 :call ToggleLineNumbers()<CR>


" A more ergonomic single-key toggle for line numbers
function! ToggleLineNumbersNoRelative()
  if &relativenumber
    set norelativenumber
  else
    set number
  endif
endfunction

function! NoLineNumber()
  if &relativenumber
    set norelativenumber
    set nonumber
  else
    set nonumber
    set norelativenumber
  endif
endfunction
" Map <leader>tn to call the function
nnoremap <silent> <leader>09 :call ToggleLineNumbersNoRelative()<CR>
nnoremap <silent> <leader>99 :call NoLineNumber()<CR>

nnoremap <leader>2 @

vnoremap $ $h
