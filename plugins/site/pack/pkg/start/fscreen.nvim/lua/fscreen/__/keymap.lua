local M = {}

local buffer_id
local keymaps = {}

local function apply_keymap(keymap, buffnr)
	vim.keymap.set({ "n", "i", "v" }, keymap.lhs, keymap.rhs, {
		buffer = buffnr,
		noremap = false,
	})
end

local function revoke_keymap(keymap, buffnr)
	pcall(function()
		vim.keymap.del({ "n", "i", "v" }, keymap.lhs, {
			buffer = buffnr,
		})
	end)
end

M.create_keymap = function(lhs, rhs)
	local keymap = { lhs = lhs, rhs = rhs }
	table.insert(keymaps, keymap)

	if vim.api.nvim_buf_is_valid(buffer_id) then
		apply_keymap(keymap, buffer_id)
	end
end

M.set_buffer = function(buffnr)
	if vim.api.nvim_buf_is_valid(buffer_id) then
		for _, keymap in pairs(keymaps) do
			revoke_keymap(keymap, buffer_id)
		end
	end
	buffer_id = buffnr
	if not vim.api.nvim_buf_is_valid(buffer_id) then
		return
	end
	for _, keymap in pairs(keymaps) do
		apply_keymap(keymap, buffer_id)
	end
end

return {
	setup = function(buffnr)
		buffer_id = buffnr
		return M
	end,
}
