local Functions = require("games/Inudaris/primitives/main_functions")
local Loader = require("games/Inudaris/loader")

if game.state["loading"] then
	function love.load()
		Loader:load()
	end
	function love.draw()
		Loader:draw()
	end
end

if game.state["running"] then
	function love.draw()
		Functions:draw()
	end
	function love.update(dt)
		Functions:update(dt)
		dream:update()
	end
	function love.keypressed(key)
		Functions:key(key)
	end
end
