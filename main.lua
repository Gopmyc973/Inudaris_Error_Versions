require("menu/run")
Init = require("menu/init")
Game = require("stats/game")
game = Game:load()

if game.state["menu"] then
	Init:Primary()

	--load default project
	function love.load()
		Init:settings()
	end

	function love.draw()
		Init:menu()
	end

	function love.update(dt)
		Init:update(dt)
	end

	Init:mouse(x, y, b)
end