dream = require("3DreamEngine")
Functions = {}
Functions.__index = Functions
local players = {}

function Functions:load()
	dream = require("3DreamEngine")
	love.window.setTitle("Inudaris")
	love.mouse.setRelativeMode(true)	
	time = 0
	rain = 0.0
	isRaining = false
	mist = 0.0
	animateTime = true
	loadingBarSleepingTime = 0 --todo
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:timer(timer, speed, dt)
   timer = timer + (dt * speed) % 1
end

function Functions:settings()
	dream:init()
	dream:setFogHeight(0.0, 150.0)
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:load_object()
	scene = dream:loadObject("games/Inudaris/assets/objects/scene")
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:extensions()
	sky = require("extensions/sky")
	sun = dream:newLight("sun")
	utils = require("extensions/utils")
	physics = require("extensions/physics/init")
	sun:addShadow()
	dream:setSky(sky.render)
	sky:setDaytime(sun, 0.4)
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:load_material()
	dream:loadMaterialLibrary("games/Inudaris/assets/materials")
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:load_world()
	World = require("games/Inudaris/world/physics_world")
	world = World:Init(scene)
end

function Functions:load_player()
	player = require("games/Inudaris/player")
	table.insert(players, 1, player(8,80,100,60))
	for i = 1, #players do
		players[i].collider = world.world:add(players[i].shape, "dynamic", players[i].x, players[i].y, players[i].z)
		players[i].collider:setDensity(165.347)
	end
	function love.mousemoved(_, _, x, y)
		for i = 1, #players do
			players[i]:mouseMoved(x,y)
		end
	end
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:load_weapons()
	Weapons = require("games/Inudaris/weapons/base/base_weapons")
	for i = 1, #players do
		Weapons:Init(players[i])
	end
	love.timer.sleep(loadingBarSleepingTime)
end

function Functions:load_enemy()
	Enemy = require("games/Inudaris/world/enemies/base/base_enemy")
	enemies = {}
	table.insert(enemies, 1, Enemy(8,80,60,15,nil))
	for i = 1, #enemies do
		enemies[i]:init()
	end
end

function Functions:developer()
	local delta = love.timer.getAverageDelta()
	if game.state["developer"] then
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
   		love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * delta), 10, 30)
		love.graphics.print('Memory actually used (in MB): ' .. (collectgarbage('count')/1000), 10,50)
	end
end

function Functions:draw()
	dream:prepare()
	for i = 1, #enemies do
		enemies[i]:draw()
	end
	for i = 1, #players do
		players[i]:setCamera(dream.camera)
		Weapons:draw(players[i].weapon)
	end
	dream:draw(scene)
	dream:present()
	Functions:developer()
	for i = 1, #players do
		players[i]:draw()
		Weapons:hud(players[i].weapon)
	end
end

function Functions:update(dt)
	dt = math.min(dt, 1 / 20)

	--update the physics
	world.world:update(dt)

	if animateTime then
		time = time + dt * 0.02
	end
	if isRaining then
		rain = math.min(1, rain + dt * 0.25)
		mist = math.min(1, mist + dt * 0.1)
		rainbow = math.min(1, mist + dt * 0.1)
	else
		rain = math.max(0, rain - dt * 0.25)
		mist = math.max(0, mist - dt * 0.05)
		rainbow = math.max(0, mist - dt * 0.01)
	end
	sky:setSkyColor(rain)
	sky:setRainbow(math.max(0, rainbow - rain))
	dream:setFog(0.05 * mist, sky.skyColor, 1.0)
	for i = 1, #players do
		players[i]:update(dt)
		Weapons:fire(players[i].weapon, dt)
	end

	for i = 1, #enemies do
		enemies[i]:move(dt)
		enemies[i]:damage()
	end
end

function Functions:key(key)
	
end

return Functions
