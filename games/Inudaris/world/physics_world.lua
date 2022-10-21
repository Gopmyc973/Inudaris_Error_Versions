dream = require("3DreamEngine")
utils = require("extensions/utils")
physics = require("extensions/physics/init")
local World = {}
World.__index = World

function World:Init(scene)
	local self = setmetatable({}, World)
	self.scene = scene

	self.world = physics:newWorld()
	self.world:add(physics:newPhysicsObject(scene))
	self.shape = physics:newObject(scene)
	self.collider = self.world:add(self.shape, "static")

	return self
end
function World:airResistance(dt, x)
	x = x * (1 - dt * 5)
	return x
end

function World:draw()
	dream:draw(scene)
end

return World
