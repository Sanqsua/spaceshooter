Object = require 'libraries/classic/classic'
local Circle = Object:extend()
function Circle:new(x,y,radius)
	print("circle made")
	self.x = x
	self.y = y
	self.radius = radius
	self.creation_time = love.timer.getTime()
end

function Circle:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.circle("fill",self.x,self.y,self.radius)
end

function Circle:update(dt)

end
return Circle
