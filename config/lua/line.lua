--[[
local function a(x, y)
    return {
        a = { bg = x, fg = '#ffffff', gui = 'bold' },
        b = { bg = y, fg = '#ffffff', gui = 'bold' },
        c = { bg = '#0c0c1f', fg = '#ffffff', gui = 'bold' },
        x = { bg = '#151525', fg = '#ffffff' },
        y = { bg = '#202030', fg = '#ffffff' },
        z = { bg = '#2a2a3a', fg = '#ffffff', gui = 'bold' }
    }
end

local my_theme = {
    normal = a('#3c3c3c', '#2c2c2c'),
    insert = a('#888800', '#777700'),
    visual = a('#32a852', '#219741'),
    command = a('#4287f5', '#0044aa'),
    replace = a('#ba34eb', '#9023da'),
    inactive = a('#555555', '#333333'),
}

require('lualine').setup {
    options = {
        theme = my_theme,
        disabled_filetypes = {
            'packer', 'NvimTree', 'toggleterm'
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {},
        lualine_x = {
            {
                'diagnostics',
                update_in_insert = true,
            },
            'encoding'
        },
    },
    --[[winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "fileformat"
            },
            {
                "filetype"
            },
            {
                "filename",
                path = 2,
            },
        },

        -- Right side
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                "buffers",
                buffers_color = {
                    active = { bg = "#555555", fg = "#ffffff" },
                    inactive = { bg = "#333333", fg = "#ffffff" },
                },
                symbols = {
                    alternate_file = '',
                }
            },
        },
    }
}
]]--

require("nvim-navic").setup({
    lsp = {
        auto_attach = true,
    },
})

require("barbecue").setup({})
local statusline = require('statusline')
statusline.lsp_diagnostics = true
statusline.tabline = false
require("bufferline").setup({
    options = {
        hover = {
            enabled = true,
            delay = 0,
            reveal = {'close'}
        },
        separator_style = "slant",
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
    }
})
