local M = {}
M.round = function(n)
	return math.floor((math.floor(n * 2) + 1) / 2)
end
-- convert 2d array indexing to 1d
M.two2oneD = function(x, y, w)
	return y * w + x + 1
end

M.clamp = function(val, min, max)
	return math.min(max, math.max(val, min))
end

M.centerval = function(val1, val2)
	return math.floor(val1 / 2 - val2 / 2)
end

M.is_out_of_bound = function(x, y, w, h, scr_w, scr_h)
	return x > scr_w or y > scr_h or x + w < 0 or y + h < 0
end

M.checkbuf = function(buffer)
	return vim.api.nvim_buf_is_valid(buffer)
end

M.inbetween2 = function(val, min, max)
	return val >= min and val <= max
end

M.get_hl_name = function(state)
	return "fscreen" .. state
end

M.create_id = function()
	return math.random(10000, 1000)
end

return M
