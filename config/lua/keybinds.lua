--------------------------
-- Insert mode keybinds --
--------------------------
local function i(x)
    vim.cmd.imap(x)
end

-- Basic keybinds
i({"<C-s>", "<cmd>w!<cr><cmd>lua vim.notify('The current file has been saved.', 'info', { title = 'Saved' })<cr>"}) -- Save
i({"<C-x>", "<cmd>wq!<cr>"}) -- Save and quit

i({"<C-q>", "<cmd>wqa!<cr>"}) -- Save and quit all windows
i({"<C-S-x>", "<cmd>q!<cr>"}) -- Forcefully quit without saving
i({ "<C-S-q>", "<cmd>qa!<cr>" }) -- Forcefully quit all windows without saving

-- Moving windows
i({ "<M-left>", "<cmd>wincmd H<cr>i<right>" }) -- Move window to far left
i({ "<M-right>", "<cmd>wincmd L<cr>i<right>" }) -- Move window to far right
i({ "<M-up>", "<cmd>wincmd K<cr>i<right>" }) -- Move window to top
i({ "<M-down>", "<cmd>wincmd J<cr>i<right>" }) -- Move window to bottom

-- Switching windows
i({ "<C-M-left>", "<cmd>wincmd h<cr>" }) -- Switch to window to the left
i({ "<C-M-right>", "<cmd>wincmd l<cr>" }) -- Switch to window to the right
i({ "<C-M-up>", "<cmd>wincmd k<cr>" }) -- Switch to window above
i({ "<C-M-down>", "<cmd>wincmd j<cr>" }) -- Switch to window below

-- Opening windows
--i({ "<C-e>", "<esc>:NvimTreeToggle<cr>:wincmd p<enter>i<right>" }) -- Open the file explorer
--i({ "<C-t>", "<C-\\>" }) -- Open the terminal
i({ "<C-d>", "<cmd>NvimTreeToggle<cr><cmd>wincmd p<cr>" })

-- Swapping lines
i({ "<M-S-up>", "<esc>dd<up>$pi" })
i({ "<M-S-down>", "<esc>vdd<down>$pi" })

-- Copying and pasting
i({ "<C-v>", "<esc>pi" })
i({ "<C-z>", "<esc>ui" })
i({ "<C-y>", "<esc><C-r>i" })
i({ "<C-a>", "<esc><C-home>v<C-end>" })

-- Telescope
i({ "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>" }) -- Find in current buffer
i({ "<C-S-f>", "<cmd>Telescope find_files<cr>" }) -- Find files
i({ "<C-e>", "<cmd>Telescope diagnostics<cr>" }) -- Show errors and warnings
i({ "<C-t>", "<cmd>Telescope filetypes<cr>" }) -- Switch filetype
i({ "<C-M-f>", "<cmd>Telescope lsp_references<cr>" }) -- Find references for variable/function
i({ "<C-h>", "<cmd>Telescope man_pages<cr>" }) -- Search through help/manual pages
i({ "<C-S-h>", "<cmd>Telescope oldfiles<cr>" }) -- File history
-- NOTE: Might need to add keybind for `:Telescope treesitter` and `:Telescope vim_options`

--------------------------
-- Normal mode keybinds --
--------------------------
local function n(x)
    vim.cmd.nmap(x)
end

-- Basic keybinds
n({ "<C-s>", "<cmd>w!<cr><cmd>lua vim.notify('The current file has been saved.', 'info', { title = 'Saved' })<cr>" }) -- Save
n({ "<C-x>", "<cmd>wq!<cr>" }) -- Save and quit window
n({ "<C-q>", "<cmd>wqa!<cr>" }) -- Save and quit all windows
n({ "<C-S-x>", "<cmd>q!<cr>" }) -- Forcefully quit without saving
n({ "<C-S-q>", "<cmd>qa!<cr>" }) -- Forcefully quit all windows without saving

-- Moving windows
n({ "<M-left>", "<cmd>wincmd H<cr>" }) -- Move window to far left
n({ "<M-right>", "<cmd>wincmd L<cr>" }) -- Move window to far right
n({ "<M-up>", "<cmd>wincmd K<cr>" }) -- Move window to top
n({ "<M-down>", "<cmd>wincmd J<cr>" }) -- Move window to bottom

-- Switching windows
n({ "<C-M-left>", "<cmd>wincmd h<cr>" }) -- Switch to window to the left
n({ "<C-M-right>", "<cmd>wincmd l<cr>" }) -- Switch to window to the right
n({ "<C-M-up>", "<cmd>wincmd k<cr>" }) -- Switch to window above
n({ "<C-M-down>", "<cmd>wincmd j<cr>" }) -- Switch to window below

-- Opening windows
--n({ "<C-e>", ":NvimTreeToggle<cr>:wincmd p<enter>" }) -- Open the file explorer
--n({ "<C-t>", ":ToggleTerm<cr>" })
n({ "<C-d>", "<cmd>NvimTreeToggle<cr><cmd>wincmd p<cr>" })

n({ "<backspace>", "i<backspace>" })

-- Swapping lines
n({ "<M-S-down>", "^v$d<down>i<cr><up><esc>p<down><backspace><esc>" })
n({ "<M-S-up>", "^v$d<up>i<cr><up><esc>p<down><backspace><esc>" })

-- Copying and pasting
n({ "<C-v>", "p" })
n({ "<C-z>", "u" })
n({ "<C-y>", "<C-r>" })
n({ "<C-a>", "<C-home>v<C-end>" })

-- Telescope
n({ "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>" }) -- Find in current buffer
n({ "<C-S-f>", "<cmd>Telescope find_files<cr>" }) -- Find files
n({ "<C-e>", "<cmd>Telescope diagnostics<cr>" }) -- Show errors and warnings
n({ "<C-t>", "<cmd>Telescope filetypes<cr>" }) -- Switch filetype
n({ "<C-M-f>", "<cmd>Telescope lsp_references<cr>" }) -- Find references for variable/function
n({ "<C-h>", "<cmd>Telescope man_pages<cr>" }) -- Search through help/manual pages
n({ "<C-S-h>", "<cmd>Telescope oldfiles<cr>" }) -- File history
-- NOTE: Might need to add keybind for `:Telescope treesitter` and `:Telescope vim_options`

local function t(x)
    vim.cmd.tmap(x)
end

t({ "<C-x>", "<C-\\>" }) -- For some reason the keybind consumes the character after <C-c>, and so a character such as \n is in place
t({ "<C-t>", "<C-\\>" })
t({ "<C-q>", "<C-\\><esc><cmd>qa!<cr>" })
