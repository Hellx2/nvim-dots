local function a(x, y)
    return {
        a = { bg = x, fg = '#ffffff', gui = 'bold' },
        b = { bg = y, fg = '#ffffff', gui = 'bold' },
        c = { bg = '#0c0c1f', fg = '#ffffff', gui = 'bold' },
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
}
