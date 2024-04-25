---@class EventType
---@field name string
---@field trigger string[]

---@class EventListener
---@field autocmd_ids number[]
---@field callback string

---@class EventPrivate
---@field events EventType[]
---@field event_listener EventListener[][]

---@class Event
---@field buffer_id number|nil
---@field private __ EventPrivate
local Event = {
	buffer_id = nil,
	__ = {
		events = {},
		event_listener = {},
	},
}

---Creata a fuckin event manager
---@param buffer_id number
---@return Event
function Event:new(buffer_id)
	local newSelf = setmetatable({}, self)
	self.__index = self
	self.buffer_id = buffer_id
	return newSelf
end

function Event:create_event(trigger, name)
	self.__.events[name] = { trigger = trigger, name = trigger }
end

function Event:listen(name, callback)
	if self.__.events[name] == nil then
		return
	end

	local autocmd_ids = {}
	for _, event in pairs(self.__.events[name].trigger) do
		local autocmd_id = vim.api.nvim_create_autocmd(event, {
			buffer = self.buffer_id,
			callback = callback,
		})
		table.insert(autocmd_ids, autocmd_id)
	end

	if self.__.event_listener[name] == nil then
		self.__.event_listener[name] = {}
	end

	table.insert(self.__.event_listener[name], {
		callback = callback,
		autocmd_ids = autocmd_ids,
	})
end

function Event:fire(event_name)
	for _, listenr in pairs(self.__.event_listener[event_name] or {}) do
		listenr.callback()
	end
end

function Event:set_buffer(buf_id)
	if buf_id == self.buffer_id then
		return
	end
	for event_name, event_listeners in pairs(self.__.event_listener) do
		for listener_idx, listener in pairs(event_listeners) do
			for _, autocmd_id in pairs(listener.autocmd_ids) do
				vim.api.nvim_del_autocmd(autocmd_id)
			end
			local autocmd_ids = {}
			for _, trigger in pairs(self.__.events[event_name].trigger) do
				local autocmd_id = vim.api.nvim_create_autocmd(trigger, {
					buffer = buf_id,
					callback = listener.callback,
				})
				table.insert(autocmd_ids, autocmd_id)
			end
			self.__.event_listener[event_name][listener_idx].autocmd_ids = autocmd_ids
		end
	end
	self.buffer_id = buf_id
end

function Event:clean()
	for _, event_listeners in pairs(self.__.event_listener) do
		for _, listener in pairs(event_listeners) do
			for _, auto_cmd_id in pairs(listener.autocmd_ids) do
				pcall(function()
					vim.api.nvim_del_autocmd(auto_cmd_id)
				end)
			end
		end
	end

	self.__.events = {}
	self.__.event_listener = {}
end

return Event
