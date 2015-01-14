local timer = require 'libs.hump.timer'

local animations = {register={}}

function animations.__new(args)
  local base = {}
  for k, v in pairs(args) do
    base[k] = v
  end

  base.active = true
  base.paused = false
  base.timer = timer.new()

  function base:update(dt)
  	self.timer.update(dt)
  end

  function base:start() 
  	self.active = true
  	self.paused = false
  end
  
  function base:pause()
    self.paused = true
  end

  function base:resume()
    self.paused = false
  end

  function base:stop()
  	self.active = false
  	self.timer.cancel(self.timerHandle)
    animations.register[base.index] = nil
  end

  base:start()
  base.index = #animations.register + 1
  animations.register[base.index] = base

  return base
end

function animations.newPrimitiveRing(x, y, r, n, a)
  local anim = animations.__new({x=x, y=y, r=r, n=n, a=a})

  anim.r1 = {r=anim.r, a=255, angle=anim.a}
  anim.r2 = {r=anim.r, a=255, angle=anim.a}
  anim.r3 = {r=anim.r, a=255, angle=anim.a}
  anim.r4 = {r=anim.r, a=255, angle=anim.a}

	function anim:bounce(delay, time, subject, target)
	  local init = copy(subject)

	  local fn

	  fn = function()
	    update(subject, init)
	    self.timerHandle = self.timer.tween(time, subject, target, 'out-quad', fn)
		end
	  
	  if delay > 0 then
	  	self.timerHandle = self.timer.add(delay, fn)
	  else
	  	fn()
	  end
	end

  anim:bounce(0.0, 1.1, anim.r1, {r=anim.r * 100/60, a=40, angle=math.pi * 3/anim.n})
  anim:bounce(0.2, 1.1, anim.r2, {r=anim.r * 130/60, a=10, angle=math.pi * 3/anim.n})
  anim:bounce(0.4, 1.1, anim.r3, {r=anim.r * 110/60, a=30, angle=math.pi * 3/anim.n})
  anim:bounce(0.6, 1.1, anim.r4, {r=anim.r * 150/60, a=10, angle=math.pi * 3/anim.n})

  function anim:draw()
  	local r, g, b, _ = love.graphics.getColor()
  	love.graphics.setColor(r, g, b, 255)
	  Primitives.polygon('line', self.x, self.y, self.r, self.n, self.a)
	
	  love.graphics.setLineWidth(2)

		love.graphics.setColor(r, g, b, self.r1.a)
		Primitives.polygon('line', self.x, self.y, self.r1.r, self.n, self.a + self.r1.angle)

		love.graphics.setColor(r, g, b, self.r2.a)
		Primitives.polygon('line', self.x, self.y, self.r2.r, self.n, self.a + self.r2.angle)

		love.graphics.setColor(r, g, b, self.r3.a)
		Primitives.polygon('line', self.x, self.y, self.r3.r, self.n, self.a + self.r3.angle)

		love.graphics.setColor(r, g, b, self.r4.a)
		Primitives.polygon('line', self.x, self.y, self.r4.r, self.n, self.a + self.r4.angle)
  end


  return anim
end

function animations.update(dt) 
	for _, a in pairs(animations.register) do
		if a.active and not a.paused then
			a:update(dt)
		end
	end
end

function animations.draw() 
	for _, a in pairs(animations.register) do
		if a.active then
			a:draw()
		end
	end
end


function animations.clear()
	print("clear")
	animations.register = {}
end


function update(t, s)
  for k, v in pairs(s) do t[k] = v end
end

function copy(s)
  local t = {}
  for k, v in pairs(s) do t[k] = v end
  return t
end



return animations