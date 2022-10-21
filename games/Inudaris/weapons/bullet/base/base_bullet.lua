function Bullet(weapon,x,y,z) 
	return {
        x = x,
	    y = y,
	    z = z,
	    ammo = weapon.bullet,
		collider = weapon.bullet.collider = world.world:add(weapon.bullet.shape, "dynamic", x, y, z),
		weapon.bullet.collider:setDensity(weapon.bullet.weight),

        Fire = function(self,weapon,player)
			self.x, self.y, self.z = self.collider:getPosition():unpack()
			if weapon.IsFireing then
				player.ax = (player.ax + math.cos(player.ry - math.pi / 2))
				player.az = (player.az + math.sin(player.ry - math.pi / 2))

				self.collider:applyForce(self.ax * weapon.bullet.energy, 0, self.az * weapon.bullet.energy)
			end
		end,

		draw = function(self, weapon)
			weapon.bullet.model:resetTransform() 
			weapon.bullet.model:scale(0.004)
			weapon.bullet.model:translate(self.x,self.y,self.z)
			weapon.bullet.model:rotateY(-1.5)
			if weapon.draw then
				dream:draw(weapon.bullet.model) 
			end
		end
	}
	
end

return Bullet

