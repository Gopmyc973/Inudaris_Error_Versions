local Weapons = {}
Weapons.__index = Weapons

function lerp(a,b,t) return a * (1-t) + b * t end

function Weapons:Init(player)
	local bullets = {}
	bullet = require("games/Inudaris/weapons/bullet/base/base_bullet")
	table.insert(bullets, 1, bullet(player.weapon,player.x,player.y,player.z))
end

function Weapons:Fire(weapon, dt)
	if weapon.IsFireing then
		if weapon.ammo > 0 then
			weapon.ammo = weapon.ammo - 1
			weapon.delay = 1
			weapon.delay = weapon.delay - 1
			weapon.sound:setVolume(weapon.volume)
			weapon.sound:play()
			weapon.sound_socket:setVolume(0.3)
			weapon.sound_socket:play()
			for i = 1, #bullets do
				bullets[i]:Fire()
			end
		else
			weapon.IsFireing = false
			weapon.sound_empty:setVolume(0.5)
			weapon.sound_empty:play()
			weapon.delay = 1
			weapon.delay = weapon.delay - 1
		end
	end
	weapon.IsFireing = false
end

function Weapons:hud(weapon)
	width, height, flags = love.window.getMode()
	love.graphics.print("Ammo:"..weapon.ammo.."/"..weapon.maxCapacity, 10, 100)
	love.graphics.print("Charger:"..weapon.charger, 10, 200)
end

function Weapons:reload(weapon)
	if love.keyboard.isDown("r") then
		if weapon.delay > 20 and weapon.charger > 0 and weapon.ammo ~= weapon.maxCapacity then
			weapon.draw = false
			weapon.charger = weapon.charger - 1
			weapon.ammo = weapon.maxCapacity
			weapon.draw = true
			weapon.delay = 1
			weapon.delay = weapon.delay - 10
			weapon.sound_reload:setVolume(0.4)
			weapon.sound_reload:play()
		end
	end
end

function Weapons:scope(weapon)
	if love.mouse.isDown(2) then
		weapon.scope = true
	else
		weapon.scope = false
	end
end

function Weapons:fire(weapon, dt)	
	if weapon.class == 1 then
		weapon.IsFireing = false
    	if love.mouse.isDown(1) then
			if weapon.delay > 1.5 then
				Weapons:Fire(weapon)
			else 
				weapon.IsFireing = false
			end
		end
	elseif weapon.class == 0 then
		weapon.IsFireing = false
		if love.mouse.isDown(1) then
			if weapon.delay > 15 then
				Weapons:Fire(weapon)
			else 
				weapon.IsFireing = false
			end
		end
	end
	Weapons:reload(weapon)
	Weapons:scope(weapon)
	weapon.delay = weapon.delay + dt * weapon.delay_speed
end

function Weapons:scope_draw(weapon)
	if weapon.scope then
		if weapon.class == 1 then
			x = dream.camera.normal.x + 1
			y = dream.camera.normal.y - 6
			z = 5
		elseif weapon.class == 0 then
			x = dream.camera.normal.x + 1
			y = dream.camera.normal.y - 6
			z = 0
		end
	else
		x = dream.camera.normal.x + 9
		y = dream.camera.normal.y - 9
		z = 0
	end
	return x,y,z
end

function Weapons:recoil(weapon)
	local weapon_posX, weapon_posY, weapon_posZ = Weapons:scope_draw(weapon)
	local recoil
	if weapon.IsFireing then
		recoil = weapon.model:translate(weapon_posX, weapon_posY, lerp(dream.camera.normal.z - 15,dream.camera.normal.z - (15 - weapon.recoil),0.7) - weapon_posZ)
	else
		recoil = weapon.model:translate(weapon_posX, weapon_posY, lerp(dream.camera.normal.z - (15 - weapon.recoil),dream.camera.normal.z - 15,0.7) - weapon_posZ)
	end
	return recoil
end

function Weapons:draw(weapon)
	weapon.model:resetTransform() 
	weapon.model:setTransform(dream.camera:getTransform())
	weapon.model:scale(0.004)
	Weapons:recoil(weapon)
	weapon.model:rotateY(-1.5)
	if weapon.draw then
		dream:draw(weapon.model) 
	end
	for i = 1, #bullets do
		bullets[i]:draw()
	end
end

function Weapons:read_file()
    -- data read 
end

return Weapons
