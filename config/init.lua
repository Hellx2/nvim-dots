vim.cmd [[
    set expandtab
    set number
    set tabstop=4
    set shiftwidth=4
    syntax on
    set termguicolors
]]

vim.notify = require("notify")
vim.notify.setup({
    fps = 60,
    stages = "fade",
    level = 2,
    minimum_width = 50,
    timeout = 2000,
})

require("lspsetup")
require("keybinds")
require("comp")
require("tsit")
require("tree")
require("line")
require("tscope")
require("tgterm")
require("styles")
--require("dbg")

vim.cmd.colorscheme("catppuccin-mocha")
