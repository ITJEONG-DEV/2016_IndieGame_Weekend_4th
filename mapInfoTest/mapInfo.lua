local mapInfo = {}

local physcis = require "physics"

local _W = display.contentWidth
local _H = display.contentHeight

local map = {}

-- 9 * 80
local map11=
{
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-6,0,0,0,0,10,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,3,1,1,1,1,2,0,3,1,2,0,3,1,1,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1,1,2,0,0,0,0,0,0,0,0,0,0,0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,2,0,0,0,0,0,0,0,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1,1,1,1,2,0,0,0,3,1,2,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,6,10,0,0,0,0,0,0,0,0,0,0,0,0},
	{1,1,1,1,1,1,1,2,0,3,1,1,2,0,3,1,1,1,1,1,1,2,0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
}


mapInfo.makeMap = function ( num )
	local a
	if num == 11 then obj = map11
	elseif num == 12 then obj = map12
	end

	for i = 1, 9, 1 do
		for j = 1, 80, 1 do
			a = obj[i][j]
			if a == 0 then
				--none
			elseif math.abs(a) == 1 then
				map[20*(i-1)+j] = display.newImage("image/floor_2.png", 32+64*(j-1), 32+64*(i-1) )
				physics.addBody( map[20*(i-1)+j], "static" )
			elseif math.abs(a) == 2 then
				map[20*(i-1)+j] = display.newImage("image/floor_3.png", 32+64*(j-1), 32+64*(i-1) )
				physics.addBody( map[20*(i-1)+j], "static" )
			elseif math.abs(a) == 3 then
				map[20*(i-1)+j] = display.newImage("image/floor_1.png", 32+64*(j-1), 32+64*(i-1) )
				physics.addBody( map[20*(i-1)+j], "static" )
			elseif math.abs(a) == 4 then
				map[20*(i-1)+j] = display.newImage("image/floor_4.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 5 then
				map[20*(i-1)+j] = display.newImage("image/floor_5.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 6 then
				map[20*(i-1)+j] = display.newImage("image/box.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 7 then
				map[20*(i-1)+j] = display.newImage("image/wool_7.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 8 then
				map[20*(i-1)+j] = display.newImage("image/wool_8.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 9 then
				map[20*(i-1)+j] = display.newImage("image/wool_9.png", 32+64*(j-1), 32+64*(i-1) )
			elseif math.abs(a) == 10 then
			else
				-- minuse part
			end
--			map[100*(i-1)+j] = 
		end
	end
	return map
end

mapInfo.applyMap = function ( )
	moveMap = function ( e )
		local moveX = function ( n )
			for i = 1, 9, 1 do
				for j = 1, 80, 1 do
					if map[20*(i-1)+j] ~= nil then map[20*(i-1)+j].x = map[20*(i-1)+j].x + n end
				end
			end
		end
	
		if e.x >= _W*0.5 then moveX(-5)
		else moveX(5)
		end
	end
	Runtime:addEventListener( "touch", moveMap )
end

mapInfo.hi = function ( )
	for i = 1, 10, 1 do
		return i
	end
end

return mapInfo