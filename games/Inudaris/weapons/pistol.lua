local weapon = {}
weapon.__index = weapon

model_pistol = dream:loadObject("games/Inudaris/assets/objects/pistol")
local weapon = {
	name = "Pistol",
	model = model_pistol,
	sound = love.audio.newSource("games/Inudaris/assets/audio/pistol/pistol.wav", "static"),
	sound_socket = love.audio.newSource("games/Inudaris/assets/audio/socket_9mm[01].wav", "static"),
	sound_reload = love.audio.newSource("games/Inudaris/assets/audio/pistol/reload.wav", "static"),
	sound_empty = love.audio.newSource("games/Inudaris/assets/audio/pistol/empty.wav", "static"),
	volume = 0.5,
	IsFireing = false,
	delay = 0,
	delay_speed = 20,
	recoil = 10,
	class = 0, -- 1 = automatic, 0 = semi-automatic
	maxCapacity = 5,
	ammo = 5,
	charger = 3,
	scope = false,
	draw = true
}

return weapon
