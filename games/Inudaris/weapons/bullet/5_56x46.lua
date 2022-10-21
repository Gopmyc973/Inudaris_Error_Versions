local bullet = {}
bullet.__index = bullet

model_bullet = dream:loadObject("games/Inudaris/assets/objects/bullet")
--model_socket = dream:loadObject("games/Inudaris/assets/objects/socket")
local bullet = {
	name = "5_56x46",
	model = model_bullet,
	IsFireing = false,
	weight = 0.256,
	energy = 1670,
    shape = physics:newCylinder(0.1, 0.1, 0.1),
    collider = nil,
    weight_socket = 0.234,
	number = nil,
	maxSpeed = 152,
}

return bullet