local Window = require("fscreen.window")
local window = Window:new({ width = 20, height = 20 })
local tests = {}
local function createtest(callback, duration)
	table.insert(tests, { duration = duration, callback = callback })
end

vim.notify(window:get_hl_name(10))
local timer = vim.loop.new_timer()
local function runtest()
	local iteration = 1
	local function testschedule()
		if tests[iteration] then
			timer:start(
				tests[iteration].duration,
				0,
				vim.schedule_wrap(function()
					tests[iteration].callback()
					iteration = iteration + 1
					if tests[iteration] then
						return timer:start(tests[iteration].duration, 0, vim.schedule_wrap(testschedule))
					end
				end)
			)
		end
	end
	testschedule()
end

window:subscribe("on_open", function()
	vim.notify("on_open fired")
end)

window:subscribe("on_close", function()
	vim.notify("on_close fired")
end)

createtest(function()
	window:open()
end, 300)
--
-- createtest(function()
-- 	window:set_keymap("k", function()
-- 		vim.notify("K?")
-- 	end)
-- end, 300)
--
createtest(function()
	vim.cmd([[q]])
end, 300)
--
createtest(function()
	window:open()
end, 300)
--
createtest(function()
	window:close()
end, 300)

-- createtest(function()
-- 	vim.cmd("hi " .. window:get_hl_name(1) .. " guibg=#FFFFFF")
-- 	vim.cmd("hi " .. window:get_hl_name(4) .. " guibg=#FF0000")
-- 	window:rect(10, 10, 10, 10, 1)
-- 	window:rect(10, 10, -5, -5, 4)
-- 	window:rect(10, 10, 15, -5, 4)
-- 	window:rect(10, 10, -5, 15, 4)
-- 	window:render()
-- end, 300)
--
-- createtest(function()
-- 	window:line(0, 0, 20, 30, 2)
-- 	window:render()
-- end, 300)
--
-- createtest(function()
-- 	vim.cmd("hi " .. window:get_hl_name(2) .. " guibg=#FFFF00")
-- 	local imgtest = {
-- 		{ 3, 3, 3, 3, 3, 3, 3 },
-- 		{ 3, 0, 0, 0, 0, 0, 3 },
-- 		{ 3, 3, 3, 3, 3, 0, 3 },
-- 		{ 3, 3, 3, 3, 3, 0, 3 },
-- 		{ 3, 0, 0, 0, 0, 0, 3 },
-- 		{ 3, 0, 0, 0, 0, 0, 3 },
-- 		{ 3, 0, 0, 0, 0, 0, 3 },
-- 		{ 3, 0, 0, 3, 0, 0, 3 },
-- 		{ 3, 3, 3, 3, 3, 3, 3 },
-- 	}
-- 	window:draw(#imgtest[1], #imgtest, 0, 0, imgtest)
-- 	vim.cmd("hi " .. window:get_hl_name(3) .. " guibg=#FF0FFF")
-- 	window:render()
-- end, 300)
--
-- createtest(function()
-- 	vim.cmd("hi " .. window:get_hl_name(4) .. " guibg=#FF0000 ")
-- 	vim.cmd("hi " .. window:get_hl_name(5) .. " guibg=#FFF000 ")
-- 	vim.cmd("hi " .. window:get_hl_name(6) .. " guibg=#00FF00 ")
-- 	vim.cmd("hi " .. window:get_hl_name(7) .. " guibg=#F66066 ")
-- 	local text4 = window:create_text("xxx", 5, 10, 4)
-- 	local text = window:create_text("test-text", 7, 8, 5)
-- 	local text2 = window:create_text("ccc", 4, 10, 6)
-- 	local text3 = window:create_text("yy", 1, 10, 7)
-- 	if text4 ~= nil then
-- 		window:render_text(text4)
-- 	end
-- 	if text ~= nil then
-- 		window:render_text(text)
-- 	end
-- 	if text2 ~= nil then
-- 		window:render_text(text2)
-- 	end
-- 	if text3 ~= nil then
-- 		window:render_text(text3)
-- 	end
-- 	window:render()
-- end, 300)

runtest()
