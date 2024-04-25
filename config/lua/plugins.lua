require("ufo").setup({
	provider_selector = function(_, _, _)
		return { "treesitter", "indent" }
	end,
})

require("nvim-toggler").setup({
	remove_default_keybinds = true,
})

require("autoclose").setup({})

require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
	},
})
require("leetcode").setup({})
require("sudoku").setup({})
require("snake").setup({})
require("crates").setup({})
require("lsp_signature").setup({})
require("outline").setup({})
require("lsp-lens").setup({})
require("lsp_lines").setup({})
require("auto-save").setup({})
require("goto-preview").setup({})

require("licenses").setup({
	copyright_holder = "Hellx2",
	email = "hellx20923@gmail.com",
	license = "MIT",
})
