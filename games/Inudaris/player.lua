weap_pistol = require("games/Inudaris/weapons/pistol")
weap_rifle = require("games/Inudaris/weapons/assault_rifle")

function Player(x,y,z,speed) 
	return {
        vectorMeta = {},
        x = x,
	    y = y,
	    z = z,
	    ax = 0,
	    ay = 0,
	    az = 0,
	    rx = 0,
	    ry = 0,
        speed = speed,
        maxSpeed = 152,
        minSpeed = 72,
        state = true, -- true:alive, false:dead
        shape = physics:newCylinder(0.175, 0.5, -10),
        collider = nil,
        pos = setmetatable({x,y,z}, vectorMeta),
        weapon = weap_rifle,
        switch = 0,
        health = 100,

        Equipement = {
            { weap = weap_rifle, hash = 0},
            { weap = weap_pistol, hash = 1}
        },

        movement = function(self,dt)
            dt = math.min(dt, 1 / 20)

            self.x, self.y, self.z = self.collider:getPosition():unpack()

            --accelerate
            local d = love.keyboard.isDown
            self.ax, self.az = 0, 0
            if d("z") then
                self.ax = (self.ax + math.cos(self.ry - math.pi / 2))*self.speed
                self.az = (self.az + math.sin(self.ry - math.pi / 2))*self.speed
            end
            if d("s") then
                self.ax = (self.ax + math.cos(self.ry + math.pi - math.pi / 2))*self.speed
                self.az = (self.az + math.sin(self.ry + math.pi - math.pi / 2))*self.speed
            end
            if d("q") then
                self.ax = (self.ax + math.cos(self.ry - math.pi / 2 - math.pi / 2))*self.speed
                self.az = (self.az + math.sin(self.ry - math.pi / 2 - math.pi / 2))*self.speed
            end
            if d("d") then
                self.ax = (self.ax + math.cos(self.ry + math.pi / 2 - math.pi / 2))*self.speed
                self.az = (self.az + math.sin(self.ry + math.pi / 2 - math.pi / 2))*self.speed
            end
        
            --dash
            if self.collider.touchedFloor and love.keyboard.isDown("e") then
                --self.ax = (self.ax + math.cos(self.ry - math.pi / 2))*self.speed
                --self.az = (self.az + math.sin(self.ry - math.pi / 2))*self.speed
                --self.collider:applyForce(self.ax * 5, 0, self.az * 5)
                --self.collider:setPos(self.ax + 50, 0, self.az + 50)
            end
        
            local a = math.sqrt(self.ax ^ 2 + self.az ^ 2)
            if a > 0 then
                --accelerate, but gradually slows down when reaching max speed
                local v = self.collider:getVelocity()
                self.ax = self.ax / a
                self.az = self.az / a
                local speed = vec3(v.x, 0, v.z):length()
                local maxSpeed = love.keyboard.isDown("a") and self.maxSpeed or self.minSpeed
                local dot = speed > 0 and (self.ax * v.x / speed + self.az * v.z / speed) or 0
                local accel = 1000 * math.max(0, 1 - speed / maxSpeed * math.abs(dot))
                if self.collider.touchedFloor then
                    self.collider:applyForce(self.ax * accel, 0, self.az * accel)
                else
                    self.collider:applyForce(self.ax * (accel/2), 0, self.az * (accel/2))
                end
            end
        
            --jump
            if self.collider.touchedFloor and love.keyboard.isDown("space") then
                self.collider.ay = 8
            elseif self.collider.touchedFloor and love.keyboard.isDown("lalt") then
                self.shape = physics:newCylinder(0.175, 0.5, -5)
                self.y = self.y - 2
                self.speed = self.speed/2
            else
                self.shape = physics:newCylinder(0.175, 0.5, -10)
                self.speed = self.speed
            end

        end,
        
        mouseMoved = function(self,x,y)
            local speedH = 0.005
            local speedV = 0.005
            self.ry = self.ry + x * speedH
            self.rx = math.max(-math.pi/2 + 0.01, math.min(math.pi/2 - 0.01, self.rx - y * speedV))
        end,
        
        setCamera = function(self,cam)
            cam:resetTransform()
            cam:translate(self.x, self.y, self.z)
            cam:rotateY(self.ry)
            cam:rotateX(self.rx)
        end,
        
        lookAt = function(self,cam, position, distance)
            self.x = position.x
            self.y = position.y
            self.z = position.z
            
            cam:resetTransform()
            cam:translate(position)
            cam:rotateY(self.ry)
            cam:rotateX(self.rx)
            cam:translate(0, 0, distance)
        end,
        
        switch = function(self,dt)
            function love.wheelmoved(x, y)
                if y > 0 then
                    -- Mouse wheel moved up
                    if self.switch >= 0 and self.switch <= 1 then
                       self.switch = self.switch + 1
                    else
                        self.switch = 0
                    end
                    for i = 1, #self.Equipement do
                        if self.switch == self.Equipement[i].hash then
                            self.weapon = self.Equipement[i].weap
                        end
                    end
                elseif y < 0 then
                    -- Mouse wheel moved down
                    if self.switch >= 0 and self.switch <= 1 then
                        self.switch = self.switch - 1
                    else
                        self.switch = 1
                    end
                    for i = 1, #self.Equipement do
                        if self.switch == self.Equipement[i].hash then
                            self.weapon = self.Equipement[i].weap
                        end
                    end
                end
            end
        end,

        hud = function(self)
            love.graphics.setColor(love.math.colorFromBytes(46, 46, 46))
                love.graphics.rectangle("fill", 20, love.graphics.getHeight() - 50, 360, 35)
            love.graphics.setColor(1, 1, 1)
            if self.health >= 0 then
                love.graphics.setColor(love.math.colorFromBytes(220, 20, 60))
                    love.graphics.rectangle("fill", 25, love.graphics.getHeight() - 45, self.health * 3.5, 25)
                love.graphics.setColor(1, 1, 1)
            end
        end,
        
        state = function(self)
            if self.health <= 0 then
                self.state = false
            end
        end,
        
        update = function(self,dt)
            self:movement(dt)
            self:switch(dt) --todo nooo
            self:state()
        end,
        
        draw = function(self)
            self:hud()
        end
	}
	
end

return Player
