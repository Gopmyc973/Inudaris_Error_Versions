local Weapons = {}
Weapons.__index = Weapons

function lerp(a,b,t) return a * (1-t) + b * t end

function Weapons:Init(player)
	bullets = {}
	bullet = require("games/Inudaris/weapons/bullet/base/base_bullet")
	table.insert(bullets, 1, bullet(player,player.weapon,player.x,player.y,player.z))
	player.weapon.bullet.number = 0
end

function Weapons:shoot(player, dt)
	if player.weapon.IsFireing then
		if player.weapon.ammo > 0 then
			player.weapon.ammo = player.weapon.ammo - 1
			player.weapon.delay = 1
			player.weapon.delay = player.weapon.delay - 1
			player.weapon.sound:setVolume(player.weapon.volume)
			player.weapon.sound:play()
			player.weapon.sound_socket:setVolume(0.3)
			player.weapon.sound_socket:play()
			player.weapon.bullet.number = player.weapon.bullet.number + 1
			for i = player.weapon.bullet.number, #bullets do
				bullets[i]:Fire(player)
			end
		else
			player.weapon.IsFireing = false
			player.weapon.sound_empty:setVolume(0.5)
			player.weapon.sound_empty:play()
			player.weapon.delay = 1
			player.weapon.delay = player.weapon.delay - 1
		end
	end
end

function Weapons:hud(player)
	width, height, flags = love.window.getMode()
	love.graphics.print("Ammo:"..player.weapon.ammo.."/"..player.weapon.maxCapacity, 10, 100)
	love.graphics.print("Charger:"..player.weapon.charger, 10, 200)
end

function Weapons:reload(player)
	if love.keyboard.isDown("r") then
		if player.weapon.delay > 20 and player.weapon.charger > 0 and player.weapon.ammo ~= player.weapon.maxCapacity then
			player.weapon.draw = false
			player.weapon.charger = player.weapon.charger - 1
			player.weapon.ammo = player.weapon.maxCapacity
			player.weapon.draw = true
			player.weapon.delay = 1
			player.weapon.delay = player.weapon.delay - 10
			player.weapon.sound_reload:setVolume(0.4)
			player.weapon.sound_reload:play()
		end
	end
end

function Weapons:scope(player)
	if love.mouse.isDown(2) then
		player.weapon.scope = true
	else
		player.weapon.scope = false
	end
end

function Weapons:fire(player, dt)	
	if player.weapon.class == 1 then
		player.weapon.IsFireing = false
    	if love.mouse.isDown(1) then
			if player.weapon.delay > 1.5 then
				player.weapon.IsFireing = true
				Weapons:shoot(player, weapon, dt)
			else 
				player.weapon.IsFireing = false
			end
		end
	elseif player.weapon.class == 0 then
		player.weapon.IsFireing = false
		if love.mouse.isDown(1) then
			if player.weapon.delay > 15 then
				player.weapon.IsFireing = true
				Weapons:shoot(player, weapon, dt)
			else 
				player.weapon.IsFireing = false
			end
		end
	end
	Weapons:reload(player)
	Weapons:scope(player)
	player.weapon.delay = player.weapon.delay + dt * player.weapon.delay_speed
end

function Weapons:scope_draw(player)
	if player.weapon.scope then
		if player.weapon.class == 1 then
			x = dream.camera.normal.x + 1
			y = dream.camera.normal.y - 6
			z = 5
		elseif player.weapon.class == 0 then
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

function Weapons:recoil(player)
	local weapon_posX, weapon_posY, weapon_posZ = Weapons:scope_draw(player)
	local recoil
	if player.weapon.IsFireing then
		recoil = player.weapon.model:translate(weapon_posX, weapon_posY, lerp(dream.camera.normal.z - 15,dream.camera.normal.z - (15 - player.weapon.recoil),0.7) - weapon_posZ)
	else
		recoil = player.weapon.model:translate(weapon_posX, weapon_posY, lerp(dream.camera.normal.z - (15 - player.weapon.recoil),dream.camera.normal.z - 15,0.7) - weapon_posZ)
	end
	return recoil
end

function Weapons:draw(player)
	player.weapon.model:resetTransform() 
	player.weapon.model:setTransform(dream.camera:getTransform())
	player.weapon.model:scale(0.004)
	Weapons:recoil(player)
	player.weapon.model:rotateY(-1.5)
	if player.weapon.draw then
		dream:draw(player.weapon.model) 
		if player.weapon.bullet.number ~= nil then
			for i = 60, #bullets do
				bullets[i]:draw(player)
			end
		end
	end
end

function Weapons:read_file()
    -- data read 
end

return Weapons
