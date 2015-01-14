local animations = require 'libs/animations'
require 'libs/primitives'

local primitiveRing = nil

local x, y = love.mouse.getPosition()
local nodes = 7

function love.load( )
  primitiveRing = animations.newPrimitiveRing(x, y, 30, nodes, math.pi/6)
end

function love.update( dt )
	primitiveRing.x, primitiveRing.y = love.mouse.getPosition()
	animations.update(dt)
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Mouse button to pin animation. Delete to clear animations.", 10, 10)
	love.graphics.print("Nodes: " .. nodes, 10, 30)
	

	love.graphics.setColor(255, 255, 155, 255)
	animations.draw()
end

function love.mousepressed(mx, my, button)
	if button == 'l' then 
	  primitiveRing = animations.newPrimitiveRing(mx, my, 30, nodes, math.pi/6)
	end

	if button == "wu" then
		nodes = nodes + 1
	end

	if button == "wd" then
		nodes = math.max(3, nodes - 1)
	end

end

function love.keypressed( key )
	if key == 'escape' then
		love.event.quit()
		return
	end

	if key == " " then
		if primitiveRing.paused then
	  	primitiveRing:resume()
		else
			primitiveRing:pause()
		end
	end

	if key == "delete" then
	  animations.clear()
	end


end