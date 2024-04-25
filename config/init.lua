vim.cmd([[
    set expandtab
    set number
    set tabstop=4
    set shiftwidth=4
    syntax on
    set termguicolors
    set updatetime=300
]])

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.notify = require("notify")
vim.notify.setup({
	fps = 60,
	stages = "fade",
	level = 2,
	minimum_width = 50,
	timeout = 2000,
	top_down = false,
})

vim.cmd.colorscheme("catppuccin-mocha")

require("plugins")
require("lspsetup")
require("keybinds")
require("comp")
require("tsit")
require("line")
require("tscope")
require("tgterm")
require("styles")
require("eaglesetup")
require("sidebarsetup")
require("format")
--require("startup-screen")
--require("dbg")

--[[
TODO: Collaborative editing, https://github.com/jbyuki/instant.nvim
]]
--
