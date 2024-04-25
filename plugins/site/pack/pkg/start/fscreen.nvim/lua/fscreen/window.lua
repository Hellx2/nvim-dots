---@module "fscreen.window"
local utils = require("fscreen.__.utils")

---Render screen pixel as highlights.
---this function take the screen, process individual pixel state and generate the highlights.
---@param scr_width number: screen width
---@param scr_height number: screen height
---@param screen number[]: screen array
---@param pixel_len number: individual pixel string length
---@param callback fun(hlstart:number, hlend:number,state:number,line:number): nil that handle the highlighting
---@return nil
local function renderHighlights(scr_width, scr_height, screen, pixel_len, callback)
	for y = 0, scr_height - 1 do
		local ystart = y * scr_width
		local yend = ystart + scr_width

		local hlstart = 0
		local hlstate = screen[ystart + 1]

		for x = ystart + 1, yend do
			local state = screen[x]
			local xlocal = x - ystart
			if hlstate ~= state then
				local hlend = (xlocal - 1) * pixel_len
				callback(hlstart, hlend, hlstate, y)
				hlstart = hlend
				hlstate = state
			end
		end
		callback(hlstart, scr_width * pixel_len, hlstate, y)
	end
end

--- create screen array
---@param width number
---@param height number
---@return number[]
local function create_screen_array(width, height)
	local scr = {}
	for _ = 1, width, 1 do
		for _ = 1, height, 1 do
			table.insert(scr, 0)
		end
	end
	return scr
end

---@class TextData
---@field str string: the string itself
---@field y number: where the text sit in the y axis
---@field text_start number: where in the x axis the text is started
---@field text_end number: where in the x axis the text is finished
---@field state number: text state (for highlighting)

---@class WindowData
---@field win_opts table: window options for nvim_win_open
---@field screen number[]: screen pixel state data
---@field xscalar number: scalar for width
---@field pixel_len number: the length of pixel string (for rendering purpose)
---@field texts TextData[][]: list of text to be rendered
---@field line_str string: just a cache so we dont have to generate it again
---@field namespace number: highlight namespace from nvim_create_namespace
---@field eventhandler table: eventhandler from fscreen/events
---@field controller table: keymap manager from fscreen/keymap
---@field exited boolean: status for... IS THE WINDOW BEEN EXITED? i make difference on exiting and closing window

---@class Window
---@field buf_id number|nil: buffer id currently used
---@field win_id number|nil: window id currently used
---@field x number: window position on x axis
---@field y number: window position on y axis
---@field width number: window width
---@field height number: window height
---@field private __ WindowData: private variables
local Window = {
	buf_id = nil,
	win_id = nil,
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	__ = {
		win_opts = {},
		screen = {},
		xscalar = 0,
		pixel_len = 0,
		texts = {},
		line_str = "",
		namespace = 0,
		eventhandler = {},
		controller = {},
		exited = false,
	},
}

---@class WindowOptions
---@field width number: screen width
---@field height number: screen height
---@field xscalar? number: scalre value for x axis
---@field x? number: Window psition on x axis
---@field y? number: Window position on y axis
---@field pixel? string: string for individual pixel

---Window constructer
---@param opts WindowOptions: options
---@return Window
function Window:new(opts)
	local newSelf = setmetatable({}, self)
	self.__index = self
	local namespace = vim.api.nvim_create_namespace("fscreen")
	local buf_id = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf_id, "buftype", "nofile")

	local eventhandler = require("fscreen.__.events"):new(buf_id)
	-- TODO: create fscreen/event.lua

	eventhandler:create_event({ "BufWinEnter" }, "on_open")
	eventhandler:create_event({ "BufWinLeave" }, "on_close")

	local controller = require("fscreen.__.keymap").setup(buf_id)

	local xscalar = opts.xscalar or 2
	local s_width = xscalar * opts.width
	local pixel = opts.pixel or "  "

	local win_option = {
		style = "minimal",
		width = s_width,
		height = opts.height,
		relative = "win",
		border = "single",
		noautocmd = true,
		col = opts.x or utils.centerval(vim.go.columns, s_width),
		row = opts.y or utils.centerval(vim.go.lines, opts.height),
	}

	local linestr = ""
	for _ = 1, opts.width, 1 do
		linestr = linestr .. pixel
	end

	self.x = win_option.col
	self.y = win_option.row
	self.width = opts.width
	self.height = opts.height
	self.buf_id = buf_id
	self.__ = {
		screen = create_screen_array(opts.width, opts.height),
		namespace = namespace,
		line_str = linestr,
		controller = controller,
		eventhandler = eventhandler,
		win_opts = win_option,
		xscalar = xscalar,
		pixel_len = #pixel,
		texts = {},
		exited = false,
	}
	return newSelf
end

local function lockbuffer(lock, buf_id)
	vim.api.nvim_buf_set_option(buf_id, "readonly", lock)
	vim.api.nvim_buf_set_option(buf_id, "modifiable", not lock)
end

---Create a proper data to render text on given arguments.
---arguments are self explanatory
---@param str string
---@param x number
---@param y number
---@param state number
---@return TextData | nil
function Window:create_text(str, x, y, state)
	if not str then
		return
	end
	if type(str) ~= "string" then
		return
	end
	if x > self.width or y > self.height or x + #str < 0 then
		return
	end

	local xstart = utils.clamp(x, 0, self.width)
	local xend = utils.clamp(x + #str, 0, self.width)
	local xoffset = xstart - x

	return {
		str = string.sub(str, xoffset),
		y = y,
		text_start = xstart,
		text_end = xend,
		state = state,
	}
end

---Set pixel state on given position.
---arguments are self explanatory
---@param x number
---@param y number
---@param state number
function Window:set_pixel(x, y, state)
	if x >= self.width or y >= self.height or x < 0 or y < 0 then
		return
	end
	self.__.screen[utils.two2oneD(utils.round(x), utils.round(y), self.width)] = state
end

---@private
function Window:__init_buffer_screen()
	self.buf_id = vim.api.nvim_create_buf(false, true)
	lockbuffer(false, self.buf_id)
	self.__.screen = create_screen_array(self.width, self.height)
	for y = 1, self.height, 1 do
		vim.fn.setbufline(self.buf_id, y, self.__.line_str)
	end
	lockbuffer(true, self.buf_id)
end

---Clear the screen
function Window:clear()
	self.__.screen = create_screen_array(self.width, self.height)
	if #self.__.texts > 0 then
		lockbuffer(false, self.buf_id)
		for _, text_list in pairs(self.__.texts) do
			vim.fn.setbufline(self.buf_id, text_list[1].y, self.__.line_str)
		end
		lockbuffer(true, self.buf_id)
	end
	self.__.texts = {}
end

---@private
function Window:__render_text()
	lockbuffer(false, self.buf_id)
	for _, text_list in pairs(self.__.texts) do
		if #text_list > 0 then
			local ylevel = text_list[1].y
			table.sort(text_list, function(a, b)
				return a.text_start < b.text_start
			end)
			local xstart = text_list[1].text_start
			local finalstr = string.sub(self.__.line_str, 1, xstart)
			for i, text in ipairs(text_list) do
				local extra = ""
				if text_list[i - 1] then
					extra = string.sub(self.__.line_str, 1, text.text_start - text_list[i - 1].text_end)
				end
				finalstr = finalstr .. extra .. text.str
			end
			finalstr = finalstr .. string.sub(self.__.line_str, #finalstr + 1)
			vim.fn.setbufline(self.buf_id, ylevel, finalstr)
			for _, _text in pairs(text_list) do
				vim.highlight.range(
					self.buf_id,
					self.__.namespace,
					utils.get_hl_name(_text.state),
					{ ylevel - 1, _text.text_start },
					{ ylevel - 1, _text.text_end },
					{ priority = 350 }
				)
			end
		end
	end
	lockbuffer(true, self.buf_id)
end

---Render current screen to the buffer (doesnt clean the screen afterwards)
function Window:render()
	vim.api.nvim_buf_clear_namespace(self.buf_id, -1, 0, -1)
	self:__render_text()
	renderHighlights(self.width, self.height, self.__.screen, self.__.pixel_len, function(hlstart, hlend, state, y)
		vim.highlight.range(self.buf_id, self.__.namespace, utils.get_hl_name(state), { y, hlstart }, { y, hlend }, {
			priority = 300,
		})
	end)
end

---Draw a line from (x1,y1) to (x2,y2) to the screen with the specified state.
---Arguments are self-explanatory
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param state number
function Window:line(x1, y1, x2, y2, state)
	local dx = x2 - x1
	local dy = y2 - y1

	local absdx = math.abs(dx)
	local absdy = math.abs(dy)

	local steps = absdy

	if absdx > absdy then
		steps = absdx
	end

	local xinc = dx / steps
	local yinc = dy / steps
	local currentPixel = { x1, y1 }

	for _ = 0, steps, 1 do
		Window:set_pixel(currentPixel[1], currentPixel[2], state)

		currentPixel[1] = currentPixel[1] + xinc
		currentPixel[2] = currentPixel[2] + yinc
	end
end

---Draw a (width)x(height) rectange at (x,y) with the specified state.
---Arguments are self-explanatory
---@param width number
---@param height number
---@param x number
---@param y number
---@param state number
function Window:rect(width, height, x, y, state)
	if utils.is_out_of_bound(x, y, width, height, self.width, self.height) then
		return
	end
	local xstart = utils.clamp(x, 0, self.width - 1)
	local xend = utils.clamp(x + width - 1, 0, self.width - 1)

	local ystart = utils.clamp(y, 0, self.height - 1)
	local yend = utils.clamp(y + height - 1, 0, self.height - 1)

	for ypos = ystart, yend do
		local yindex = ypos * self.width + 1
		for xpos = xstart, xend do
			self.__.screen[yindex + xpos] = state
		end
	end
end

--- Open the window. cant open if the window is exited.
function Window:open()
	if self.__.exited then
		return
	end
	if self.win_id == nil or not vim.api.nvim_win_is_valid(self.win_id) then
		local prev_buf = self.buf_id
		self:__init_buffer_screen()
		self.__.controller.set_buffer(self.buf_id)
		self.__.eventhandler:set_buffer(self.buf_id)
		if prev_buf and (vim.api.nvim_buf_is_valid(prev_buf) or vim.api.nvim_buf_is_loaded(prev_buf)) then
			vim.api.nvim_buf_delete(prev_buf, {
				force = true,
			})
		end

		self.win_id = vim.api.nvim_open_win(self.buf_id, true, self.__.win_opts)
		-- self.__.eventhandler:revoke()
		self.__.eventhandler:fire("on_open")
	end
end

---Close the window, can open again later
function Window:close()
	if self.win_id ~= nil and vim.api.nvim_win_is_valid(self.win_id) then
		-- vim.api.nvim_buf_delete(self.buf_id, { force = true })
		vim.api.nvim_win_close(self.win_id, true)
		self.win_id = nil
	end
end

---Get pixel state at (x,y)
---Arguments are self-explanatory
---@param x number
---@param y number
---@return number
function Window:get_state(x, y)
	return self.__.screen[utils.two2oneD(x, y, self.width)]
end

---Render the specified TextData to the scren
---@param text TextData
function Window:render_text(text)
	local texts_on_the_same_y = self.__.texts[text.y]

	if texts_on_the_same_y == nil or vim.tbl_isempty(texts_on_the_same_y) then
		self.__.texts[text.y] = { text }
		return
	end

	for i, _text in ipairs(texts_on_the_same_y) do
		if utils.inbetween2(text.text_start, _text.text_start, _text.text_end) then
			table.remove(self.__.texts[text.y], i)
			local strend = text.text_start - _text.text_start
			if strend > 0 then
				local new_text =
					self:create_text(string.sub(_text.str, 1, strend), _text.text_start, _text.y, _text.state)
				table.insert(self.__.texts[text.y], new_text)
			end
			if #text.str < #_text.str then
				local remaining_new_text = self:create_text(
					string.sub(_text.str, text.text_end - _text.text_start + 1),
					text.text_end,
					_text.y,
					_text.state
				)
				table.insert(self.__.texts[text.y], remaining_new_text)
			end
		elseif _text.text_start >= text.text_start and _text.text_end <= text.text_end then
			table.remove(self.__.texts[text.y], i)
		elseif utils.inbetween2(_text.text_start, text.text_start, text.text_end) then
			table.insert(
				self.__.texts[text.y],
				self:create_text(
					string.sub(_text.str, text.text_end - _text.text_start + 1),
					text.text_end,
					text.y,
					_text.state
				)
			)
			table.remove(self.__.texts[text.y], i)
		end
	end
	table.insert(self.__.texts[text.y], text)
end

---Draw 2d state array to the screen.
---states array length MUST BE consistent
---@param width number
---@param height number
---@param x number
---@param y number
---@param states number[][]
function Window:draw(width, height, x, y, states)
	if utils.is_out_of_bound(x, y, width, height, self.width, self.height) then
		return
	end
	x = x + 1
	local xstart = utils.clamp(x, 0, self.width)
	local xend = utils.clamp(x + width, 0, self.width)
	local ystart = utils.clamp(y, 0, self.height)
	local yend = utils.clamp(y + height, 0, self.height)
	local xoffset = xstart - x + 1
	local yoffset = ystart - y + 1

	local _y = ystart

	while _y < yend do
		local _x = xstart
		local _y_index = _y * self.width
		local st_yindex = _y - ystart + yoffset
		while _x < xend do
			local st_xindex = _x - xstart + xoffset
			local val = states[st_yindex][st_xindex]
			if val ~= 0 then
				self.__.screen[_y_index + _x] = val
			end
			_x = _x + 1
		end
		_y = _y + 1
	end
end

---Exit window will delete everything, cant open after exit
function Window:exit()
	self.__.exited = true
	vim.schedule(function()
		self.__.eventhandler:clean()
		pcall(function()
			vim.api.nvim_win_close(self.win_id, true)
			vim.api.nvim_buf_delete(self.buf_id, {
				force = true,
			})
		end)
	end)
	self.rendered_text = {}
	self.__.screen = {}
end

--TODO: add @see and create event lists.

---Subscribe to an event
---@param event string
---@param callback fun():nil
function Window:subscribe(event, callback)
	return self.__.eventhandler:listen(event, callback)
end

function Window:set_keymap(lhs, rhs)
	self.__.controller.create_keymap(lhs, rhs)
end

--- Get highlight name
---@param state number
---@return string
function Window:get_hl_name(state)
	return "fscreen" .. state
end

return Window
