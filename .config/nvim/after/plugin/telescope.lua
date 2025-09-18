-- ~/.config/nvim/lua/user/telescope.lua



--# START--[]-- [ what not ? how to improve from now on ? ] START----
--# DESCRIPTION: 

-- - maybe with this telescope config make it like inside folder https://imgur.com/a/3qynQwx to make it easy to see


--# END--[]-- [ what not ? how to improve from now on ? ] END----





local Layout = require("nui.layout")
local Popup = require("nui.popup")

local telescope = require("telescope")

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout") -- We'll need this for new mappings


local action_state = require("telescope.actions.state")

-- Our new custom functions
local function resize_preview(direction)
    return function(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local current_height = picker.layout_config.preview_height or 0.5 -- Default to 0.5 if not set

    local new_height
    if direction == "increase" then
        new_height = math.min(current_height + 0.1, 0.95) -- Increase by 10%, max 95%
    else
        new_height = math.max(current_height - 0.1, 0.1) -- Decrease by 10%, min 10%
    end

    picker.layout_config.preview_height = new_height
    picker:refresh() -- This is the magic call to re-render the layout
end
end

-- there is no such thing this



telescope.setup({
defaults = {
layout_strategy = "flex",
--# I think it's on by default
-- color_devicons = true,  -- already in your config — good!

layout_config = {
    -- preview_width = 0.5,
    -- Use 95% width/height. 100% can sometimes cause weird border artifacts.
    width = 0.95,
    height = 0.95,
    -- You can also configure the flex-specific options if you want
    flex = {
        flip_columns = 120,
    }
},

selection_strategy = "follow",

dynamic_preview_title = true,
-- let's try this for now and later we try it with this on for like full path problem solving
path_display = { "truncate" },
-- path_display = { "smart" },
borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
prompt_prefix = "  ",
selection_caret = " ",
history = {
    path = vim.fn.stdpath "data" .. "/telescope_history.sqlite3",
    limit = 100,
},
-- vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--trim" },

vimgrep_arguments = {
    "rg",
    "-L",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--hidden", -- <<< ADD THIS LINE
    "--smart-case",
    "--glob", "!**/.git/*",      -- exclude .git
    "--glob", "!**/node_modules/*", -- exclude node_modules (if not in ignore_patterns)
},



preview = { 
    filesize_limit = 1,
    check_mime_type = true,

},


-- cycle_layout_list = { "horizontal", "vertical" },

cycle_layout_list = {
    -- Step 2: A custom "Focus Preview" mode
    {
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.95,
            height = 0.95,
            -- Make the preview HUGE, leaving only a tiny sliver for results
            -- preview_height = 0.9, 
            preview_width = math.floor(vim.o.lines * 3.37)
        },
    },
    {
        layout_strategy = 'vertical',
        layout_config = {
            width = 0.95,
            height = 0.95,
            -- Make the preview HUGE, leaving only a tiny sliver for results
            -- preview_height = 0.9, 
            preview_height = math.floor(vim.o.lines * 0.69)
        },
    },

    {
        layout_strategy = 'flex',
        layout_config = {
            -- width = 0.1,
            -- height = 0.1,
        },
    },
},


mappings = {
    i = {
        -- Make <esc> close Telescope directly from insert mode
        -- ##ISSUE(W38 Wed, 17 at 09:58) This does't work well in insert mode
        -- ##FIX(W38 Wed, 17 at 10:00) bro just use escape or double capslock tap or capslock go to nomal mode and q. in normal mode it works
        -- ["A-q"] = actions.close,


        ["<C-u>"] = function(prompt_bufnr)
            -- This function clears the entire prompt buffer
            vim.api.nvim_buf_set_lines(prompt_bufnr, 0, -1, false, { "" })
        end,
        ["<C-x>"] = actions.select_vertical + actions.center,
        ["<C-h>"] = actions.select_horizontal + actions.center,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<A-k>"] = actions.preview_scrolling_up,
        ["<A-j>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<A-p>"] = action_layout.toggle_preview,
        --# this is so good so you can look for some live_grep and then fuzzy find over those files
        --# so it's like search for something in general and then fuzzy find over those search results
        ["<C-Space>"] = actions.to_fuzzy_refine,
        --# very sick select all
        ["<A-q>"] = actions.toggle_all, -- "A" for "All"
        --# THis is just some ai bs I like the idea for sure 
        -- ["<A-P>"] = require('telescope.actions').preview_fullscreen,
        ["<C-l>"] = actions.cycle_previewers_next,
        -- ["C-w"] = resize_preview("increase"),
        -- ["C-e"] = resize_preview("decrease"),
        ["<M-l>"] = action_layout.cycle_layout_next,
        ["<M-h>"] = action_layout.cycle_layout_prev,
        ["<C-a>"] = actions.cycle_previewers_prev,
        --# this only works on newer versions of telescope 
        ["<C-e>"] = actions.preview_scrolling_left,
        ["<C-s>"] = actions.preview_scrolling_right,
        ["<C-left>"] = actions.preview_scrolling_left,
        ["<C-right>"] = actions.preview_scrolling_right,
    },
    n = {
        ["q"] = actions.close,
        ["<C-x>"] = actions.select_vertical + actions.center,
        ["<C-h>"] = actions.select_horizontal + actions.center,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<M-l>"] = action_layout.cycle_layout_next,
        ["<M-h>"] = action_layout.cycle_layout_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<A-p>"] = action_layout.toggle_preview,
        ["<A-k>"] = actions.preview_scrolling_up,
        ["<A-j>"] = actions.preview_scrolling_down,
        ["<Up>"] = actions.cycle_history_prev,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<C-Space>"] = actions.to_fuzzy_refine,
        ["<Down>"] = actions.cycle_history_next,
        ["<C-left>"] = actions.preview_scrolling_left,
        ["<C-right>"] = actions.preview_scrolling_right,
        ["<A-q>"] = actions.toggle_all, -- "A" for "All"
        ["<C-l>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,
        --# this only works on newer versions of telescope
        ["<C-e>"] = actions.preview_scrolling_left,
        ["<C-s>"] = actions.preview_scrolling_right,
    },
},
},

pickers = {
    buffers = {
        preview_width = 0.7,
        layout_config = { height = 0.6, width = 0.8 },
        mappings = {
            i = { ["<A-d>"] = actions.delete_buffer }, -- Use <c-d> to delete
            n = { ["dd"] = actions.delete_buffer },
        },
    },

-- --- NEW ---
-- Add this new entry for the current buffer fuzzy finder
current_buffer_fuzzy_find = {
    -- Tell it to use a centered dropdown theme without a preview
    -- theme = "dropdown",
    previewer = false,
},


find_files = {
    hidden = true,
    preview_width = 0.3,
    find_command = {
        "fd", "--type", "f", "--hidden", "--follow",
        "--exclude", ".git",
        "--exclude", ".node_modules", 
        "--exclude", ".cache", 
        "--exclude", ".steam", 
    },
    -- --- NEW ---
    -- RECIPE: Add a mapping in normal mode to change directory
    -- #this is not worth it it's better to do it with after find you do <leader>cwd or do it through the neotree
    -- mappings = {
        --   n = {
            --     ["<leader>cd"] = function(prompt_bufnr)
                --       local selection = require("telescope.actions.state").get_selected_entry()
                --       local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                --       require("telescope.actions").close(prompt_bufnr)
                --       vim.cmd.lcd(dir) -- Use :lcd to change dir for the current window only
                --       vim.notify("Changed CWD to: " .. dir)
                --     end,
                --   },
                -- },
            },

            live_grep = {
                debounce = 150,  -- ms delay before searching after typing stops
            },


        },

        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },

        -- V V V ADD THIS NEW SECTION FOR THE FILE BROWSER V V V
        file_browser = {
            -- You can customize the theme here, for example
            -- theme = "dropdown",
            -- This is the cool part, it replaces the default file explorer
            hijack_netrw = true,
        },
        -- ^ ^ ^ END OF THE NEW SECTION ^ ^ ^


        },

})


require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('projects')
require('telescope').load_extension('notify')
-- =======================================================
-- PART 2: YOUR PERSONAL KEYMAPS
-- These are the shortcuts to *launch* the different Telescope pickers.
-- =======================================================
local builtin = require('telescope.builtin')
local keymap = vim.keymap.set


    --# btw this only searches one line... you can't search for multiple lines... that's umm that's kinda complex
    --# even though I can grep_string all the other lines with this... I'll stop from doing that to be honest... I'll only use this
    --# for fuzzy find only 1 line and selection text within that line. for multiple lines maybe I need something else like regex or something
    local function get_selection_or_cword()
        local mode = vim.fn.mode()
        if mode == 'v' or mode == 'V' or mode == string.char(22) then
            -- Get the start and end of visual selection
            local start_pos = vim.fn.getpos('v')
            local end_pos = vim.fn.getpos('.')
            -- Make sure start comes before end
            if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
                start_pos, end_pos = end_pos, start_pos
            end
            local start_line = start_pos[2]
            local end_line = end_pos[2]
            local start_col = start_pos[3]
            local end_col = end_pos[3]
            -- Get all lines in the selection range
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            if #lines == 0 then
                return ''
            end
            if mode == 'V' then
                -- Line-wise visual mode: take entire lines
                return table.concat(lines, '\n')
            elseif mode == string.char(22) then
                -- Block-wise visual mode: extract column range from each line
                for i = 1, #lines do
                    local line = lines[i]
                    if start_col > #line then
                        lines[i] = ""
                    else
                        local end_idx = math.min(end_col, #line)
                        lines[i] = line:sub(start_col, end_idx)
                    end
                end
                return table.concat(lines, '\n')
            else
                -- Character-wise visual mode (v)
                if #lines == 1 then
                    -- Single line selection
                    return lines[1]:sub(start_col, end_col)
                else
                    -- Multi-line selection
                    lines[1] = lines[1]:sub(start_col)
                    lines[#lines] = lines[#lines]:sub(1, end_col)
                    return table.concat(lines, '\n')
                end
            end
        else
            return vim.fn.expand('<cword>')
        end
    end

-- Your keymaps, cleaned up and organized:
-- # grown used to ff and pf
-- keymap('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
-- keymap('n', '<leader>tt', builtin.find_files, { desc = 'Telescope find files' })
-- keymap('n', '<leader>T', builtin.find_files, { desc = 'Telescope find files' })


-- File & Project Finders
keymap('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>ff', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end)

--# pf makes more sense because I have nf which is for neotree so they work kinda the same... 
--so always think of a letter+f if it's p then it's telescrop if it's n then it's neotree
-- keymap('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
--# I'm not sure about the <leaader>F tbh I'm just too used to ff and pf
-- keymap('n', '<leader>F', builtin.find_files, { desc = 'Telescope find files' })

--# idk why prime has C-p umm isn't <leader>gf and <leader>gs better and more optimized ? regardless whatever
--# this finds only files tracked by git so it's useful instead of searching the whole dir which could be bad
--# this one repects the .gitignore too right so you can kinda have filters which is sick but also when you need to ignore
--# the filter you just use pf or ff
-- keymap('n', '<C-p>', builtin.git_files, { desc = 'Telescope find Git files' })


--# idk what these are and how to use them and what not .... 
keymap('n', '<leader>Gf', builtin.git_files, { desc = 'Telescope find Git files' })
keymap('n', '<leader>Gs', builtin.git_status, { desc = 'Telescope Git status' })
keymap('n', '<leader>Gb', builtin.git_branches, { desc = 'Telescope Git branches' })
keymap('n', '<leader>Gc', builtin.git_commits, { desc = 'Telescope Git commits' })
keymap('n', '<leader>GS', builtin.git_stash, { desc = 'Telescope Git stash' })
keymap('n', '<leader>GC', builtin.git_bcommits, { desc = 'Telescope Git bcommits' })


keymap('n', '<leader>B', builtin.buffers, { desc = 'Telescope Find buffers' })

--# grep string only for buffers Super handy for multi-file refactors:
--# fb I think find in buffer... or like we could do gb like grep buffer but nah idk
vim.keymap.set('n', '<leader>fb', function()
    require('telescope.builtin').grep_string({
        -- search = vim.fn.input("Search in buffers: "),
        search = "",
        grep_open_files = true,
    })
end, { desc = 'Grep string in all open buffers' })


-- keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Find buffers' })

keymap('n', '<leader>ts', builtin.lsp_document_symbols, { desc = 'Telescope Document symbols' })
keymap('n', '<leader>tS', builtin.lsp_workspace_symbols, { desc = 'Telescope Workspace symbols' })
keymap('n', '<leader>tw', builtin.lsp_workspace_symbols, { desc = 'Telescope Workspace symbols' })

keymap('n', '<leader>tr', builtin.resume, { desc = 'Telescope Resume' })
-- I'll try this out 
keymap('n', '<leader>t/', builtin.resume, { desc = 'Telescope Resume' })
keymap('n', '<A-p>', builtin.resume, { desc = 'Telescope Resume' })


keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Find helper' })
keymap('n', '<leader>f?', builtin.builtin, { desc = 'List Telescope built-ins' })
keymap('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope Find keymaps' })

-- # because I use tr for telescope resume
-- keymap('n', '<leader>tr', builtin.registers, { desc = 'Telescope Paste from register' })
keymap('n', '<leader>R', builtin.registers, { desc = 'Telescope Paste from register' })

keymap('n', '<leader>tj', builtin.jumplist, { desc = 'Telescope Jumplist' })
keymap('n', '<leader>J', builtin.jumplist, { desc = 'Telescope Jumplist' })

keymap('n', '<leader>to', builtin.oldfiles, { desc = 'Telescope Old files' })
keymap('n', '<leader>of', builtin.oldfiles, { desc = 'Telescope Old files' })

keymap('n', '<leader>tc', builtin.commands, { desc = 'Telescope Commands' })
keymap('n', '<leader>C', builtin.commands, { desc = 'Telescope Commands' })

keymap('n', '<leader>th', builtin.command_history, { desc = 'Telescope Commands history' })
keymap('n', '<leader>H', builtin.command_history, { desc = 'Telescope Commands history' })

keymap('n', '<leader>tm', builtin.marks, { desc = 'Telescope Find marks' })
keymap('n', '<leader>M', builtin.marks, { desc = 'Telescope Find marks' })

keymap('n', '<leader>man', builtin.man_pages, { desc = 'Telescope Man pages' })


-- -------------- Search the current buffer or dir for strings ----------------------------
--# search in current buffer on the word with telescope fzf supports selection and no word
vim.keymap.set({'n', 'v'}, '<leader>gs', function()
    local text_to_find = get_selection_or_cword()

    -- If the text is nil or empty, just open Telescope without a prompt
    if not text_to_find or text_to_find == '' then
        builtin.current_buffer_fuzzy_find()
        return
    end

    -- Clean up the text for better fuzzy matching
    text_to_find = text_to_find
    :gsub("\n", " ")           -- Replace newlines with spaces
    :gsub("%s+", " ")          -- Replace multiple spaces with single space
    :gsub("^%s+", "")          -- Trim leading whitespace
    :gsub("%s+$", "")          -- Trim trailing whitespace

    -- Use default_text for an interactive prompt!
    builtin.current_buffer_fuzzy_find({
        default_text = text_to_find,
    })
end, { desc = 'Fuzzy find selection/cword in buffer' })

--# search in folder dir on the word with telescope fzf supports selection and no word
vim.keymap.set({'n', 'v'}, '<leader>gS', function()
    local text_to_find = get_selection_or_cword()

    -- If the text is nil or empty, just open Telescope without a prompt
    if not text_to_find or text_to_find == '' then
        builtin.grep_string({
            default_text = vim.fn.expand('<cword>')
        })
        return
    end

    -- Clean up the text for better fuzzy matching
    text_to_find = text_to_find
    :gsub("\n", " ")           -- Replace newlines with spaces
    :gsub("%s+", " ")          -- Replace multiple spaces with single space
    :gsub("^%s+", "")          -- Trim leading whitespace
    :gsub("%s+$", "")          -- Trim trailing whitespace

    -- Use default_text for an interactive prompt!
    builtin.grep_string({
        default_text = text_to_find,
    })
end, { desc = 'Fuzzy find selection/cword in buffer' })

--# this is one of the classics maybe it could be useful maybe it's not useful i'm not sure but whatever
-- keymap('n', '<leader>gs', function()
    -- 	builtin.grep_string({ search = vim.fn.input("Grep > ") });
    -- end, { desc = 'Telescope Grep string' })

    -- # this one I made but it seems useless and repitiave
    -- no need for Mr.Prime's <leader>gs
    keymap('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope Fuzzy find in buffer' })


    -- this pre-populates the prompt with an empty string.
    -- pressing Enter will match and list EVERY line in your project.
    -- This can be very slow and is generally not very useful.
    keymap('n', '<leader>g/', function()
        require('telescope.builtin').grep_string({ search = "" });
    end, { desc = 'Telescope Grep all lines (press Enter)' })


    -- This is your modified <leader>gS mapping in PART 2

    vim.keymap.set({'n', 'v'}, '<leader>G/', function()
        builtin.grep_string({
            --#idk if this even works this cwd I mean it should right?
            --# it seems like it's working 
            cwd = vim.fn.expand('%:p:h'),
            search = "",  -- 👈 THIS forces empty prompt
        })
    end, { desc = 'Fuzzy find in CURRENT DIRECTORY (empty prompt)' })
    -- #hello_world

    vim.keymap.set({'n', 'v'}, '<leader>G?', function()
        builtin.grep_string({
            --#idk if this even works this cwd I mean it should right?
            --# it seems like it's working 
            cwd = vim.fn.expand('%:p:h'),
            search = "",  -- 👈 THIS forces empty prompt
            additional_args = function()
                return { "--max-depth", "1" }
            end,
        })
    end, { desc = 'Fuzzy find in CURRENT DIRECTORY (empty prompt)' })

    -- --# this is g/ but g/ searches all the files but this one searches only files within the directory for the string 
    -- vim.keymap.set({'n', 'v'}, '<leader>G/', function()
        --     -- --- ADD THIS LINE ---
        --     local current_dir = vim.fn.expand('%:p:h')
        --
        --     local text_to_find = get_selection_or_cword()
        --
        --     if not text_to_find or text_to_find == '' then
        --         builtin.grep_string({
            --             default_text = vim.fn.expand('<cword>'),
            --             -- --- AND ADD THIS LINE ---
            --             cwd = current_dir,
            --         })
            --         return
            --     end
            --
            --     text_to_find = text_to_find
            --         :gsub("\n", " ")
            --         :gsub("%s+", " ")
            --         :gsub("^%s+", "")
            --         :gsub("%s+$", "")
            --
            --     builtin.grep_string({
                --         default_text = text_to_find,
                --         -- --- AND ADD THIS LINE ---
                --         cwd = current_dir,
                --     })
                -- end, { desc = 'Fuzzy find selection/cword in CURRENT DIRECTORY' })

                -- END-------------- Search the current buffer or dir for strings END----------------------------



--# for live_grep for big files not limited to like you know
--# I gotta learn how to use grep you know regex and shit this has freaking 5k results limits lol. it searches everything in the dir
vim.keymap.set('n', '<leader>lg', function()
    require('telescope.builtin').live_grep({
        results_limit = 5000
    })
end, { desc = 'Live grep with 5000 result limit' })

---# This will not ignore the .git and node_modules basically --no-ignore.. Sometimes you want to search in node_modules or .git
---# remember this is live grep so better learn how to use grep son
vim.keymap.set('n', '<leader>lG', function()
    require('telescope.builtin').live_grep({
        additional_args = function()
            return { "--no-ignore" }
        end
    })
end, { desc = 'Live grep (ignore filters)' })


keymap({'n', 'v'}, '<leader>gB', function()
    builtin.live_grep({
        -- This is the magic option
        grep_open_files = true,
        -- default_text = get_selection_or_cword(),
    })
end, { desc = 'Grep in Open Buffers' })

keymap({'n', 'v'}, '<leader>gb', function()
    builtin.grep_string({
        -- This is the magic option
        grep_open_files = true,
        search = "",
        -- default_text = get_selection_or_cword(),
    })
end, { desc = 'Grep in Open Buffers' })



-- Add these to PART 2: YOUR PERSONAL KEYMAPS

-- Diagnostics
keymap('n', '<leader>td', builtin.diagnostics, { desc = 'Telescope Diagnostics' })

-- LSP
keymap('n', 'gr', builtin.lsp_references, { desc = 'Telescope LSP References' })

-- Quickfix History
keymap('n', '<leader>fa', builtin.quickfixhistory, { desc = 'Telescope Quickfix History' })



-- In PART 2 of ~/.config/nvim/lua/user/telescope.lua

-- ... your other keymaps ...

-- V V V ADD THIS NEW KEYMAP FOR THE FILE BROWSER V V V
keymap("n", "<leader>fe", function()
    -- To call an extension's function, you use `telescope.extensions.<name>.<function>()`
    require("telescope").extensions.file_browser.file_browser({
        -- This will open the file browser in the directory of the current file.
        path = "%:p:h",
    })
end, { desc = "Telescope File Browser" })
-- ^ ^ ^ END OF THE NEW KEYMAP ^ ^ ^

-- ... rest of your keymaps ...






--# this is weird and meh
-- vim.keymap.set('n', '<leader>sb', function()
--   require('telescope.builtin').grep_string({
--     search = vim.fn.input("Search in buffers: "),
--     bufnr = vim.api.nvim_list_bufs(),
--   })
-- end, { desc = 'Grep string in all open buffers' })


-- In PART 2 of ~/.config/nvim/lua/user/telescope.lua

local themes = require('telescope.themes') -- Make sure you have this line

-- V V V REPLACE YOUR OLD '<leader>fp' KEYMAP WITH THIS CORRECTED VERSION V V V
keymap("n", "<leader>fp", function()
    require("telescope").extensions.projects.projects({
        attach_mappings = function(prompt_bufnr, map)
            -- This function is called when the picker opens.

            -- This is the normal mode mapping, which works great.
            map("n", "b", function()
                local entry = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                require("telescope").extensions.file_browser.file_browser({
                    path = entry.value,
                })
            end)

            -- THIS IS THE FIX: We use "<C-b>" with angle brackets
            -- for the insert mode mapping.
            map("i", "<C-b>", function()
                local entry = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                require("telescope").extensions.file_browser.file_browser({
                    path = entry.value,
                })
            end)

            -- Return true to ensure other default mappings like 's', 'd', etc. still work.
            return true
        end,
    })
end, { desc = "Telescope Find Projects" })
-- ^ ^ ^ END OF THE REPLACEMENT ^ ^ ^:lua vim.notify("This is a test message!", "info")


-- in your init.lua or a keymaps file
-- A keymap to easily view notification history
vim.keymap.set('n', '<leader>N', ':Telescope notify<CR>', { desc = "View Notification History" })

-- Keymaps for the Quickfix List
vim.keymap.set('n', '<leader>fA', '<cmd>copen<cr>', { desc = "Open Quickfix List" })
