Components = require("menu/libs/menu_components")
local Init = {}
Init.__index = Init

local _, _, flags = love.window.getMode()
local pcX, pcY = love.window.getDesktopDimensions(flags.display)

function Init:Primary()
	local hover
	ww = love.graphics.getWidth()
	wh = love.graphics.getHeight()
	font02 = love.graphics.newFont(32)
	mousereleased = false
	games = love.filesystem.getDirectoryItems("games")
	for i = #games, 1, -1 do
		if not love.filesystem.getInfo("games/" .. games[i] .. "/main.lua", "file") then
			table.remove(games, i)
		end
	end
	play_button = love.graphics.newImage("assets/menu/button/play.png")
	love.graphics.setBackgroundColor(0.10, 0.10, 0.10)
	local font01 = love.graphics.newFont(24)
	local font_small = love.graphics.newFont(16)
end

function Init:mouse(x, y, b)
	function love.mousereleased(x, y, b)
		mousereleased = true
	end
end

function Init:settings()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setTitle("Inudaris")
    love.window.setMode(pcX/1.7, pcY/1.75, {fullscreen = false, vsync = true, minwidth = 800, minheight = 600, borderless = true})
end

function Init:inudaris()
	Game:loading()
	for d,s in ipairs(games) do
		require("games/" .. s .. "/main")
	end
end

function Init:menu()
	hover = Components:button("Play", ww*1.5, wh*1.2, 225, 75, love.graphics.newFont(24), play_button)
	Components:print()
	Components:graphic()
end

function Init:update(dt)
	function love.mousepressed(x, y, button, istouch)
		if button == 1 and hover then 
			Init:inudaris()
		end
	 end
end

return Init

	
