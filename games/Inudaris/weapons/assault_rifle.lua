local weapon = {}
weapon.__index = weapon

model_rifle = dream:loadObject("games/Inudaris/assets/objects/m4")
_bullet = require("games/Inudaris/weapons/bullet/5_56x46")
local weapon = {
	name = "Rifle",
	model = model_rifle,
	sound = love.audio.newSource("games/Inudaris/assets/audio/assault_rifle/assault_rifle.wav", "static"),
	sound_socket = love.audio.newSource("games/Inudaris/assets/audio/socket_556[01].wav", "static"),
	sound_reload = love.audio.newSource("games/Inudaris/assets/audio/assault_rifle/reload.wav", "static"),
	sound_empty = love.audio.newSource("games/Inudaris/assets/audio/assault_rifle/empty.wav", "static"),
	volume = 0.5,
	IsFireing = false,
	delay = 0,
	delay_speed = 20,
	recoil = 10,
	class = 1, -- 1 = automatic, 0 = semi-automatic
	maxCapacity = 25,
	ammo = 25,
	charger = 3,
	scope = false,
	bullet = _bullet,
	draw = true,
}

return weapon
