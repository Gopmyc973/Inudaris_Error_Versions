function Bullet(player) 
	player.weapon.bullet.collider = world.world:add(player.weapon.bullet.shape, "dynamic", x, y, z)
	return {
        x = player.x,
	    y = player.y,
	    z = player.z,
		ax = player.ax,
		az = player.az,
	    ammo = player.weapon.bullet,
		collider = player.weapon.bullet.collider,
		player.weapon.bullet.collider:setDensity(player.weapon.bullet.weight),

        Fire = function(self,player)
			self.x, self.y, self.z = self.collider:getPosition():unpack()
			if player.weapon.IsFireing then
				self.ax = (player.ax + math.cos(player.ry - math.pi / 2))
				self.az = (player.az + math.sin(player.ry - math.pi / 2))

				local a = math.sqrt(self.ax ^ 2 + self.az ^ 2)
				if a > 0 then
					local v = self.collider:getVelocity()
                	self.ax = self.ax / a
                	self.az = self.az / a
                	local speed = vec3(v.x, 0, v.z):length()
					local maxSpeed = player.weapon.bullet.maxSpeed
					local dot = speed > 0 and (self.ax * v.x / speed + self.az * v.z / speed) or 0
                	local accel = 1000 * math.max(0, 1 - speed / maxSpeed * math.abs(dot))
					self.collider:applyForce(self.ax * player.weapon.bullet.energy, 0, self.az * player.weapon.bullet.energy)
				end
			end
		end,

		draw = function(self, player)
			Player.weapon.bullet.model:resetTransform() 
			Player.weapon.bullet.model:scale(0.004)
			Player.weapon.bullet.model:translate(self.x,self.y,self.z)
			Player.weapon.bullet.model:rotateY(-1.5)
			dream:addNewLight("point", vec3(self.x, self.y, self.z), vec3(1.0, 0.75, 0.1), 5.0 + love.math.noise(love.timer.getTime()*2))
			dream:draw(player.weapon.bullet.model) 
		end
	}
	
end

return Bullet

