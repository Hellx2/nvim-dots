local sidebar = require("sidebar-nvim")

sidebar.setup({
    open = true,

    sections = {
        "buffers",
        "git",
        "diagnostics",
        "todos",
        "files",
    },

    todos = {
        icon = "",
        ignored_paths = {'~'}, -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
        initially_closed = false, -- whether the groups should be initially closed on start. You can manually open/close groups later.
    },
})
