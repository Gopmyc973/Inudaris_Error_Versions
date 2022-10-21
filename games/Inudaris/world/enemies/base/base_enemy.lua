function Enemy(x,y,z,speed,model)
    return {
        x = x,
        y = y,
        z = z,
        ax = 0,
	    ay = 0,
	    az = 0,
        speed = speed,
        model = dream:loadObject("games/Inudaris/assets/objects/cube"),
        state = true, -- true: alive, false: dead
        shape = physics:newCylinder(0.175, 0.5, -10),
        weapon = nil,
        health = 100,

        init =  function(self)
            collider = world.world:add(self.shape, "dynamic", x, y, z)
            collider:setDensity(165.347)
        end,

        move = function(self, dt)
            if self.state then
                dt = math.min(dt, 1 / 20)

                self.x, self.y, self.z = collider:getPosition():unpack()
                local ax, az = 0, 0
                --if player.x - self.x > 0 then
                    --ax = ax + math.cos(self.ry + math.pi / 2 - math.pi / 2)
                    --az = az + math.sin(self.ry + math.pi / 2 - math.pi / 2)
                --elseif player.x - self.x < 0 then
                    --ax = ax + math.cos(self.ry - math.pi / 2 - math.pi / 2)
                    --az = az + math.sin(self.ry - math.pi / 2 - math.pi / 2)
                --end
                --if player.y - self.y > 0 then
                    --ax = ax + math.cos(self.ry - math.pi / 2)
                    --az = az + math.sin(self.ry - math.pi / 2)
                --elseif player.y - self.y < 0 then
                    --ax = ax + math.cos(self.ry + math.pi - math.pi / 2)
                    --az = az + math.sin(self.ry + math.pi - math.pi / 2)
                --end
                --a = math.sqrt(ax ^ 2 + az ^ 2)
                --if a > 0 then
                --    --accelerate, but gradually slows down when reaching max speed
                --    local v = collider:getVelocity()
                --    ax = ax / a
                --    az = az / a
                --    local speed = vec3(v.x, 0, v.z):length()
                --    local maxSpeed = 36
                --    local dot = speed > 0 and (ax * v.x / speed + az * v.z / speed) or 0
                --    local accel = 1000 * math.max(0, 1 - speed / maxSpeed * math.abs(dot))
                --    collider:applyForce(ax * accel, 0, az * accel)
                --end
            end
        end,

        draw = function(self)
            if self.state then 
                self.model:resetTransform() 
                self.model:scale(0.004)
                self.model:translate(self.x, self.y, self.z)
                dream:draw(self.model)
            end
        end, 

        damage = function(self)
            function car(a)
                b = a*a
                return b
            end
            function dist(x1, y1, x2, y2)
                dist = math.sqrt(car(x1 - x2) + car(y1 - y2)) -- = ||x-x'||
                return dist
            end
            --if dist(player.x, player.y, self.x, self.y) < 10 then
            --    newHealth = player.health = player .health - 5
            --end
            --return newHealth
        end,

        state =  function(self)
            if self.health <= 0 then
                self.state = false
            end
        end
    }
end

return Enemy