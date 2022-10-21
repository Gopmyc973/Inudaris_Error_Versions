local Components = {}
Components.__index = Components

ww = love.graphics.getWidth()
wh = love.graphics.getHeight()
function lerp(a,b,t) return a * (1-t) + b * t end

function Components:print()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Gopmyc Launcher", font02, (ww/2)+font02:getWidth("Gopmyc Launcher")*0.7, wh*0.05)
	love.graphics.print("My games", font02, ww*0.2, wh*0.4)
end

function Components:graphic()
	love.graphics.setColor(0.4, 0.4, 0.4, 0.1)
		love.graphics.rectangle("fill", -1, wh*1.126, ww*2, 150)
	love.graphics.setColor(1, 1, 1, 1)
end

function Components:button(text, x, y, w, h, font, image)
	love.graphics.push("all")
	--checks for hover
	local hover = false
	local width = font:getWidth(text)
	local height = font:getHeight(text)
	local scale = math.min(1.0, (w-20) / width)
	local baseline = font:getBaseline() * scale
	local mx, my = love.mouse.getPosition()
	local r, g, b = 0.6, 0.6, 0.6

	if mx > x and mx < x + w and my > y and my < y + h then
		r, g, b = 0.75, 0.75, 0.75
		hover = true
	else
		r, g, b = 0.6, 0.6, 0.6
	end
	
	--button
	love.graphics.setColor(r, g, b)
		love.graphics.rectangle("fill", x, y, w, h, 25)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setColor(0.4, 0.4, 0.4)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle("line", x, y, w, h, 25)
	love.graphics.setColor(1, 1, 1)
	--text
	love.graphics.setFont(font)
	love.graphics.setColor(0.1, 0.1, 0.1)
		love.graphics.print(text, x+((w/2)), y+((h/2)-height/2), 0, scale)
		love.graphics.pop()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw( image, x+((w/2)-width*1.8), y+((h/2)-height), 0, image:getWidth()/75, image:getHeight()/75)
	return hover
end

return Components

	
