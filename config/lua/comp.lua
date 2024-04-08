--------------------
-- Autocompletion --
--------------------

local luasnip = require('luasnip')

luasnip.config.setup {}

local cmp = require 'cmp'

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    completion = {
        keyword_length = 1,
    },
    mapping = cmp.mapping.preset.insert ({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<s-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select=true }),
    }),
    sources = {
        { name = "nvim_lsp", keyword_length = 1, },
        { name = "luasnip", keyword_length = 1, },
	},
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
        }),
    }
})
