--[[
require("dressing").setup({
	input = {
		enabled = true,
		default_prompt = "Input",
		trim_prompt = true,
		title_pos = "left",
		insert_only = true,
		start_in_insert = true,
		border = "rounded",
		relative = "cursor",
		prefer_width = 40,
		width = nil,
		max_width = { 140, 0.9 },
		min_width = { 20, 0.2 },
		buf_options = {},
		win_options = {
			wrap = false,
			list = true,
			listchars = "precedes:…,extends:…",
			sidescrolloff = 0,
		},

		mappings = {
			n = {
				["<Esc>"] = "Close",
				["<CR>"] = "Confirm",
			},
			i = {
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
				["<Up>"] = "HistoryPrev",
				["<Down>"] = "HistoryNext",
			},
		},

		override = function(conf)
			return conf
		end,
		get_config = nil,
	},
	select = {
		enabled = true,
		backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
		trim_prompt = true,
		telescope = nil,
		fzf = {
			window = {
				width = 0.5,
				height = 0.4,
			},
		},
		fzf_lua = {},
		nui = {
			position = "50%",
			size = nil,
			relative = "editor",
			border = {
				style = "rounded",
			},
			buf_options = {
				swapfile = false,
				filetype = "DressingSelect",
			},
			win_options = {
				winblend = 0,
			},
			max_width = 80,
			max_height = 40,
			min_width = 40,
			min_height = 10,
		},
		builtin = {
			show_numbers = true,
			border = "rounded",
			relative = "editor",

			buf_options = {},
			win_options = {
				cursorline = true,
				cursorlineopt = "both",
			},
			width = nil,
			max_width = { 140, 0.8 },
			min_width = { 40, 0.2 },
			height = nil,
			max_height = 0.9,
			min_height = { 10, 0.2 },
			mappings = {
				["<Esc>"] = "Close",
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
			},

			override = function(conf)
				return conf
			end,
		},
		format_item_override = {},
		get_config = nil,
	},
})
]]
--

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
		signature = {
			enabled = false,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

vim.cmd([[
    hi Function gui=italic
    hi @keyword.return gui=italic
    hi Repeat gui=italic
    hi Keyword gui=italic
    hi String gui=italic
    hi Type gui=italic
    hi DiagnosticUnderlineError gui=undercurl
    hi DiagnosticUnderlineWarn gui=undercurl
    hi CmpItemAbbrMatch guifg=#ffffff gui=italic
    hi CmpItemAbbr guifg=#5c5c5c gui=italic
    hi @variable.builtin guifg=#eeab3d
]]) --[[
    hi @lsp.type.function guifg=#eeee88
    hi @lsp.type.struct guifg=#2eafd9
    hi @lsp.type.class guifg=#2eafd9
    hi @lsp.type.interface guifg=#ff5555
]] --
