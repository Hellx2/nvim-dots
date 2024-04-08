vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true


require("nvim-tree").setup {
    view = {
        side = "left",
        width = 30,
        --auto_resize = true
    },
    sort = {
        sorter = "case_sensitive",
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}

--[[ Open on startup
vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
    callback = function(args)
        vim.cmd "noautocmd LspStart"
        if vim.fn.expand "%:p" ~= "" then
            vim.api.nvim_del_autocmd(args.id)
            vim.cmd "noautocmd NvimTreeOpen"
            --vim.cmd "noautocmd wincmd p"
        end
    end,
})
]]

vim.schedule(function()
  vim.cmd "wincmd p"
end)

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd "quit"
        end
    end
})
