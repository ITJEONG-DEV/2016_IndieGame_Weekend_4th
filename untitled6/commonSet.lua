Class = {}

local life
local life_t

Class.lostLife = function ( )
	life = life - 1
end

Class.getLife = function ( )
	return life
end

Class.setLife = function ( )
	life = 1000
end

Class.lifeText = function ( )
	life_t = display.newText(life, 1280*0.125, 720*0.08, native.newFont( "정9체.ttf" ))
	life_t.size = 50
end

return Class