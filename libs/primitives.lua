Primitives = {}

function Primitives.hex(mode, x, y, r, angleOffset)
  Primitives.polygon(mode, x, y, r, 6, angleOffset)
end

function Primitives.triangle(mode, x, y, r, angleOffset)
  Primitives.polygon(mode, x, y, r, 3, angleOffset)
end

function Primitives.polygon(mode, x, y, r, n, angleOffset)
	local pts = {}
	local offset = angleOffset or 0
	for i=1,n do
		local angle = 2 * math.pi / n * (i + 0.5)
		pts[#pts + 1] = x + r * math.cos(angle + angleOffset)
		pts[#pts + 1] = y + r * math.sin(angle + angleOffset)
	end

  -- for i=1, #pts, 2 do
  --   local x, y = pts[i], pts[i+1]
  --   love.graphics.print(((i+1)/2) .. ":" .. math.floor(x) .. "," .. math.floor(y), x, y)
  -- end

  if mode == 'line' then
    pts[#pts + 1] = pts[1]
    pts[#pts + 1] = pts[2]

    love.graphics.line(unpack(pts))
  else
  	love.graphics.polygon(mode, unpack(pts))
  end
end


function Primitives.rectangleWithXs(x, y, w, h, ss)
  love.graphics.rectangle('line', x, y, w, h)
  local s = ss or 16
  for i=0,math.floor(w/s) do
  	for j=0,math.floor(h/s) do
  	  love.graphics.line(x + i*s, y + j*s, x + math.min(w, (i+1)*s), y + math.min(h, (j+1)*s))
  	  love.graphics.line(x + math.min(w, (i+1)*s), y + j*s, x + i*s, y + math.min(h, (j+1)*s))
  	end
  end
end

function Primitives.dashedLine(x1, y1, x2, y2)
  -- love.graphics.line(x1, y1, x2, y2)
  if x1 == x2 then

    local skip = false
    local xp, yp = x1, y1
    for i=1, 30 do
      x = x1
      local y = y1 + i*(y2-y1)/30
      if not skip then
        love.graphics.line(xp, yp, x, y)
      end
      skip = not skip
      xp, yp = x, y
    end

    return  
  end

  local a = (y1-y2) / (x1 - x2)
  local b = y1-a*x1

  local skip = false
  local xp, yp = x1, y1
  for i=1, 30 do
    x = x1 + i*(x2-x1)/30
    local y = a*x + b
    if not skip then
      love.graphics.line(xp, yp, x, y)
    end
    skip = not skip
    xp, yp = x, y
  end
end

local thunderboltPts = {
   2,   0, 
  27,   1, 
  23,  88, 
  60,  52, 
  33, 211, 
  33, 111, 
  10, 129,
   2,   0}
local thunderboltCanvases = {}

function Primitives.thunderbolt(x, y, w, h, r)
  r = r or 0
  local pts = {}
  local wRatio = w/60
  local hRatio = h/211
  local sin, cos = math.sin(r), math.cos(r)
  local sx, sy = w/2, h/2

  for i=1,#thunderboltPts, 2 do
    pts[i] =  thunderboltPts[i] * wRatio
    pts[i+1] = thunderboltPts[i+1] * hRatio

    px = pts[i]
    py = pts[i+1]

    pts[i] = x+ cos * (px-sx) - sin * (py-sy)
    pts[i+1] = y+ sin * (px-sx) + cos * (py-sy)
  end

  love.graphics.line(pts)


end
