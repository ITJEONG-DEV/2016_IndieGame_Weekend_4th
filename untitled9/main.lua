--your tastk
--[[
1. move left and right
2. jump up!
3. attack!!
4. char physics!!!
5. reboot collision!!!
---- android로 변경
---- trap! timeattack! stage별로 분할! physicsEditor 구매! 적용! 힘내렴.
---- jump > attack
---- setGravity >>> X4
---- flip
---- attack! < PhysicsEditor
---- left Move

-- 2번 맵부터 reboot 넣지 않고 있음
-- box배치는 3번 뱁까지
-- 몬스터 언제 넣니
]]--


--local list
local _W = display.contentWidth
local _H = display.contentHeight
local physics = require "physics"

--display.setDrawMode( "hybrid" )

--audioAsset
local crackRock = audio.loadSound( "/AudioAssets/effect_crackRock.wav" )
local footstep = audio.loadSound( "/AudioAssets/effect_footstep.wav" )
local gameOver = audio.loadSound( "/AudioAssets/effect_gameOver.wav" )
local hamHit = audio.loadSound( "/AudioAssets/effect_hmrHit.wav" )
local hamSwing = audio.loadSound( "/AudioAssets/effect_hmrSwing.wav" )
local jump = audio.loadSound( "/AudioAssets/effect_jump.wav" )
local moveMap = audio.loadSound( "/AudioAssets/effect_mapMove.wav" )
local damageMonster = audio.loadSound( "/AudioAssets/effect_monDamage.wav" )
local dieMonster = audio.loadSound( "/AudioAssets/effect_monDie.wav" )
local noise = audio.loadSound( "/AudioAssets/effect_noise.wav" )
local damagePlayer = audio.loadSound( "/AudioAssets/effect_playerDamage.wav" )
local diePlayer = audio.loadSound( "/AudioAssets/effect_playerDie.wav" )
local respawn = audio.loadSound( "/AudioAssets/effect_respawn.wav" )
local shutDown = audio.loadSound( "/AudioAssets/effect_shutdown.wav" )
local ui = audio.loadSound( "/AudioAssets/effect_ui.wav" ) --이건 무슨 음악인가.. 생각해보자-
local rebootm = audio.loadSound( "/AudioAssets/effect_reboot.wav" )

--function list
local getKey
local onKey
local stage0
local stage1
local over
local reboot
local shake
local reboot1
local reboot2
local reboot3
local flag1 = {}
local monMove

local endJump
local endAttack

local box1
local box2

local boxy = {}
local boxyMaxNum
local monMaxNum
local mon = {}
local monSheet = {}

--local list
local keyName
local onAnyKey
local isJump = false
local isAttack = false
local music
local BG =
{
	{
		--stage 1
		"/image/map/00.png",
		"/image/map/01.png",
		"/image/map/02.png",
		"/image/map/03.png",
		"/image/map/04.png",
		"/image/map/05.png",
		"/image/map/06.png",
		"/image/map/07.png",
		"/image/map/08.png",
		"/image/map/09.png",
		"/image/map/10.png",
		"/image/map/11.png",
		"/image/map/12.png",
		"/image/map/13.png",
		"/image/map/14.png",
		"/image/map/15.png",
	}
}

--
local space
local right
local left
local ctrl
--5
local v = 7.5

--mapList
local b01
local b02
local b03
local b04
local b05
local b06
local b07
local b08
local b09
local b10
local b11
local b12
local b13
local b14
local b15
local b16

local b01Data
local b02Data
local b03Data
local b04Data
local b05Data
local b06Data
local b07Data
local b08Data
local b09Data
local b10Data
local b11Data
local b12Data
local b13Data
local b14Data
local b15Data
local b16Data





--lifeSEt
local life = 1000
local life_t

local lifeText = function ( )
	life_t = display.newText(life, 1280*0.125, 780*0.075, native.newFont("정9체.ttf") )
	life_t.size = 50
end

local lifeCheck = function ( )
	if life == 1 then over()
	else
		life = life - 1
		life_t.text = life
	end
end


--imageSet
--1.char Sprite 100 * 64
local charData = 
{
	width = 100,
	height = 64,
	numFrames = 12,
	sheetContentWidth = 400,
	sheetContentHeight = 192,
}

local charSet =
{
	{ name = "normal", frames = { 1 }, time = 500,  lookCount = 0 },
	{ name = "walk", frames = { 2, 3, 4 }, time = 500, loopCount = 0 },
	{ name = "jump", frames = { 5, 6, 7 }, time = 500, loopCount = 1 },
	{ name = "attack", frames = { 9, 10, 11 }, time = 500, loopCount = 1 },
} 

--2.spier Sprite  --jump
local spiderData =
{
	width = 64,
	height = 50,
	numFrames = 3,
	sheetContentWidth = 192,
	sheetContentHeight = 50,
}

local spiderSet = 
{
	name = "walk",
	frames = { 1, 2, 3 },
	time = 500,
	loopCount = 0,
}

--3.slime Sprite --LR move 2
local slimeData = 
{
	width = 64,
	height = 64,
	numFrames = 3,
	sheetContentWidth = 192,
	sheetContentHeight = 64,
}

local slimeSet = 
{
	name = "walk",
	frames = { 1, 2, 3 },
	time = 500,
	loopCount = 0
}


--3. skeleton Sprite 1
local skeletonData = 
{
	width = 64,
	height = 115,
	numFrames = 3,
	sheetContentWidth = 192,
	sheetContentHeight = 115
}

local skeletonSet = 
{
	name = "walk",
	frames = { 1, 2, 3 },
	time = 500,
	loopCount = 0
}

--4.zombie Sprite 1
local zombieData =
{
	width = 64,
	height = 260,
	numFrames = 8,
	sheetContentWidth = 64,
	sheetContentHeight = 260
}

--5.dragon Sprite

--local charSheet = graphics.newImageSheet( "/image/char.png", charSet )
-- char = display.newSprite( charSheet, charData )

--music
BGM = function ( )
	media.playSound( music , BGM )
end

--moveSet
onAnyKey = function ( e )
	if e.phase == "down" then
		music = "AudioAssets/GameBGM2.mp3"
		stage1()
	end
end

getKey = function ( e )
	-- z : jump
	-- x : hammer
	-- left : left
	--right : right
	keyName = e.keyName

	if e.phase == "down" then
		if keyName == "x" then
			space = true
		end

		if keyName == "left" then
			left = true
		end

		if keyName == "right" then
			right = true
		end

		if keyName == "z" then
			ctrl = true
		end
	elseif e.phase == "up" then
		if keyName == "x" then
			space = false
		end

		if keyName == "left" then
			left = false
		end

		if keyName == "right" then
			right = false
		end

		if keyName == "z" then
			ctrl = false
		end
	end
end

onKey = function ( e )
	char.rotation = 0

	if ctrl then
		if not isAttack then
			if char.sequence == "attack" then
			else
				char:setSequence("attack")
				char:play()
			end
			isAttack = true
			audio.play(hamSwing)

			endAttack = function ( )
				isAttack = false
				char:setSequence("normal")
				char:play()
			end
			timer.performWithDelay( 501, endAttack, 1 )
		end
	end

	if space then
		if isJump == false then
			isJump = true
			audio.play(jump)
			char:setLinearVelocity( 0, -200 )

			if char.sequence == "attack" then
			else char:setSequence("jump") char:play()
			end

			endJump = function ( e )
				print ( e.object1.name )
				print( e.object2.name )
				print( e.y )
				print( char.y )
				if ( e.object1.name == "char" and e.object2.name == "b" ) or ( e.object1.name == "b" and e.object2.name == "char") then
					isJump = false
					char:setSequence( "normal" )
					Runtime:removeEventListener( "collision", endJump )
				end

--				if e.object1.name == "wall" then
--					isJump = false
--					Runtime:removeEventListener( "collision", endJump )
--				end
			end

			Runtime:addEventListener( "collision", endJump )

			
		end
	end

	if left then
		if char.sequence == "walk" then
		elseif char.sequence == "jump" then
		elseif char.sequence == "attack" then
		else char:setSequence("walk") char:play()
		end

		if ( char.x > _W * 0.5 - 50 ) and  ( char.x <= _W * 0.5 + 50 ) then
			if b14.x > _W * 0.5 then
				b01.x = b01.x + v
				b02.x = b02.x + v
				b03.x = b03.x + v
				b04.x = b04.x + v
				b05.x = b05.x + v
				b06.x = b06.x + v
				b07.x = b07.x + v
				b08.x = b08.x + v
				b09.x = b09.x + v
				b10.x = b10.x + v
				b11.x = b11.x + v
				b12.x = b12.x + v
				b13.x = b13.x + v
				b14.x = b14.x + v
				b15.x = b15.x + v
				b16.x = b16.x + v
				box1.x = box1.x + v
				box2.x = box2.x + v
				for i = 1, boxyMaxNum, 1 do
					boxy[i].x = boxy[i].x + v
				end
--				for i = 1, monMaxNum, 1 do
--					mon[i] = mon[i].x - v
--				end

			else
				if char.x - char.contentWidth * 0.5 - v < 0 then
					char.x = char.contentWidth * 0.5
				else
					char.x = char.x - v 
				end
			end
		else
			if char.x - char.contentWidth * 0.5 - v <= 0 then
				char.x = char.contentWidth * 0.5
			else
				char.x = char.x - v
			end
		end
	end

	if right then
		if char.sequence == "walk" then
		elseif char.sequence == "jump" then
		elseif char.sequence == "attack" then
		else char:setSequence("walk") char:play()
		end

		if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
			if b14.x > _W * 0.5 then
				b01.x = b01.x - v
				b02.x = b02.x - v
				b03.x = b03.x - v
				b04.x = b04.x - v
				b05.x = b05.x - v
				b06.x = b06.x - v
				b07.x = b07.x - v
				b08.x = b08.x - v
				b09.x = b09.x - v
				b10.x = b10.x - v
				b11.x = b11.x - v
				b12.x = b12.x - v
				b13.x = b13.x - v
				b14.x = b14.x - v
				b15.x = b15.x - v
				b16.x = b16.x - v
				box1.x = box1.x - v
				box2.x = box2.x - v
				for i = 1, boxyMaxNum, 1 do
					boxy[i].x = boxy[i].x - v
				end
--				for i = 1, monMaxNum, 1 do
--					mon[i] = mon[i].x - v
--				end
			else
				if char.x - char.contentWidth * 0.5 + v  > _W then
					char.x = _W - char.contentWidth * 0.5
				else
					char.x = char.x + v
				end
			end
		else
			if char.x + char.contentWidth * 0.5 + v >= _W then
				char.x = _W - char.contentWidth * 0.5
			else
				char.x = char.x + v
			end
		end
	end

	if ( not ctrl and not left ) and ( not right and not attack ) then
		char:setSequence("normal") 
		char:play()
	end
end


onJump = function ( )
	if not isJumping then
		audio.play(jump)
		char:setLinearVelocity( 0, -10 )
		isJumping = true
		char:setSequence("jump")
		-- jump :: 1.5~2.0
		physics.setGravity( 0, 100 )
	end
end

turnFalse = function ( event )
	if event.x <= char.x then
		isJumping = false
	end
end

changeWalk = function ( e )
	if char.setSequence == "jump" then
	elseif char.setSequence == "attack" then
	else char.setSequence("walk")
	end
end

changeHam = function ( e )
	if char.setSequence == "attack" then
	else
		if char.setSequence == "normal" then
		elseif char.setSequence == "jump" then
		elseif char.setSequence == "walk" then
		end
	end
end

changeNormal = function ( e )
	if char.setSequence == "normal" then
	else
		if char.setSequence == "attack" then
		elseif char.setSequence == "jump" then
		elseif char.setSequence == "walk" then
		end
	end
end

stage0 = function ()
	music = "AudioAssets/GameOpening.mp3"
	media.playSound( music , BGM )
	bg = display.newImage("/image/title.png")
	bg.anchorX, bg.anchorY = 0, 0
	bg.x, bg.y = 0, 0
	Runtime:addEventListener( "key", onAnyKey )
end

stage1 = function ( )
	Runtime:removeEventListener( "key", onAnyKey )
	bg:removeSelf()
	bg = display.newImage( "/image/bg.png", 0, 0 )
	bg.anchorX, bg.anchorY = 0, 0

	physics.start()

	do 	--make map
		b01 = display.newImage( BG[1][1], 1280*0, 144*3 )
		b01Data = ( require "image.map.00" ).physicsData(1.0)
		b01.anchorX = 0
		b01.name = "b"
		physics.addBody( b01, "static", b01Data:get("00") )

		b02 = display.newImage( BG[1][2], 1280*1, 144*3 )
		b02Data = ( require "image.map.01" ).physicsData(1.0)
		b02.anchorX = 0
		physics.addBody( b02, "static", b02Data:get("01") )
		b02.name = "b"

		b03 = display.newImage( BG[1][3], 1280*2, 144*3 )
		b03Data = ( require "image.map.02" ).physicsData(1.0)
		b03.anchorX = 0
		physics.addBody( b03, "static", b03Data:get("02") )
		b03.name = "b"

		b04 = display.newImage( BG[1][4], 1280*3, 144*3 )
		b04Data = ( require "image.map.03" ).physicsData(1.0)
		b04.anchorX = 0
		physics.addBody( b04, "static", b04Data:get("03") )
		b04.name = "b"

		b05 = display.newImage( BG[1][5], 1280*4, 144*3 )
		b05Data = ( require "image.map.04" ).physicsData(1.0)
		b05.anchorX = 0
		physics.addBody( b05, "static", b05Data:get("04") )
		b05.name = "b"

		b06 = display.newImage( BG[1][6], 1280*5, 144*3 )
		b06Data = ( require "image.map.05" ).physicsData(1.0)
		b06.anchorX = 0
		physics.addBody( b06, "static", b06Data:get("05") )
		b06.name = "b"

		b07 = display.newImage( BG[1][7], 1280*6, 144*3 )
		b07Data = ( require "image.map.06" ).physicsData(1.0)
		b07.anchorX = 0
		physics.addBody( b07, "static", b07Data:get("06") )
		b07.name = "b"
		
		b08 = display.newImage( BG[1][8], 1280*7, 144*3 )
		b08Data = ( require "image.map.07" ).physicsData(1.0)
		b08.anchorX = 0
		physics.addBody( b08, "static", b08Data:get("07") )
		b08.name = "b"
		
		b09 = display.newImage( BG[1][9], 1280*8, 144*3 )
		b09Data = ( require "image.map.08" ).physicsData(1.0)
		b09.anchorX = 0
		physics.addBody( b09, "static", b09Data:get("08") )
		b09.name = "b"

		b10 = display.newImage( BG[1][10], 1280*9, 144*3 )
		b10Data = ( require "image.map.09" ).physicsData(1.0)
		b10.anchorX = 0
		physics.addBody( b10, "static", b10Data:get("09") )
		b10.name = "b"
		
		b11 = display.newImage( BG[1][11], 1280*10, 144*3 )
		b11Data = ( require "image.map.10" ).physicsData(1.0)
		b11.anchorX = 0
		physics.addBody( b11, "static", b11Data:get("10") )
		b11.name = "b"

		b12 = display.newImage( BG[1][12], 1280*11, 144*3 )
		b12Data = ( require "image.map.11" ).physicsData(1.0)
		b12.anchorX = 0
		physics.addBody( b12, "static", b12Data:get("11") )
		b12.name = "b"

		b13 = display.newImage( BG[1][13], 1280*12, 144*3 )
		b13Data = ( require "image.map.12" ).physicsData(1.0)
		b13.anchorX = 0
		physics.addBody( b13, "static", b13Data:get("12") )
		b13.name = "b"

		b14 = display.newImage( BG[1][14], 1280*13, 144*3 )
		b14Data = ( require "image.map.13" ).physicsData(1.0)
		b14.anchorX = 0
		physics.addBody( b14, "static", b14Data:get("13") )
		b14.name = "b"

		b15 = display.newImage( BG[1][15], 1280*14, 144*3 )
		b15Data = ( require "image.map.14" ).physicsData(1.0)
		b15.anchorX = 0
		physics.addBody( b15, "static", b15Data:get("14") )
		b15.name = "b"

		b16 = display.newImage( BG[1][15], 1280*15, 144*3 )
		b16Data = ( require "image.map.15" ).physicsData(1.0)
		b16.anchorX = 0
		physics.addBody( b16, "static", b16Data:get("15") )
	end

	lifeText()

	--reboot
	box1 = display.newRect(500,675,64,64)
	box1.alpha = 0
	box2 = display.newRect(960+1280*1, 675, 64, 64)
	box2.alpha = 0
	boxy[1] = display.newImage("/image/box.png",192+1280*2, 436)
	physics.addBody( boxy[1], "static", { friction = 2.0, density = 10.0 } )
	boxy[1].name = "b"

	boxy[2] = display.newImage("/image/box.png",128+1280*2, 500)
	physics.addBody( boxy[2], "static", { friction = 2.0, density = 10.0 } )
	boxy[2].name = "b"

	boxy[3] = display.newImage("/image/box.png",192+1280*2, 500)
	physics.addBody( boxy[3], "static", { friction = 2.0, density = 10.0 } )
	boxy[3].name = "b"

	boxy[4] = display.newImage("/image/box.png",384+1280*2, 500)
	physics.addBody( boxy[4], "static", { friction = 2.0, density = 10.0 } )
	boxy[4].name = "b"

	boxy[5] = display.newImage("/image/box.png",384+1280*2, 436)
	physics.addBody( boxy[5], "static", { friction = 2.0, density = 10.0 } )
	boxy[5].name = "b"

	boxy[6] = display.newImage("/image/box.png",448+1280*2, 500)
	physics.addBody( boxy[6], "static", { friction = 2.0, density = 10.0 } )
	boxy[6].name = "b"

	boxy[7] = display.newImage("/image/box.png",448+1280*2, 436)
	physics.addBody( boxy[7], "static", { friction = 2.0, density = 10.0 } )
	boxy[7].name = "b"

	boxy[8] = display.newImage("/image/box.png",512+1280*2, 500)
	physics.addBody( boxy[8], "static", { friction = 2.0, density = 10.0 } )
	boxy[8].name = "b"

	boxy[9] = display.newImage("/image/box.png",512+1280*2, 436)
	physics.addBody( boxy[9], "static", { friction = 2.0, density = 10.0 } )
	boxy[9].name = "b"

	boxy[10] = display.newImage("/image/box.png",576+1280*2, 500)
	physics.addBody( boxy[10], "static", { friction = 2.0, density = 10.0 } )
	boxy[10].name = "b"

	boxy[11] = display.newImage("/image/box.png",576+1280*2, 436)
	physics.addBody( boxy[11], "static", { friction = 2.0, density = 10.0 } )
	boxy[11].name = "b"

	boxy[12] = display.newImage("/image/box.png",542+1280*3, 628)
	physics.addBody( boxy[1], "static", { friction = 2.0, density = 10.0 } )

	for i = 1, 12, 1 do
		boxy[i].y = boxy[i].y - 3
	end

	boxyMaxNum = 12
	monMaxNum = 1

--	monMove = function ( min, max, xORy, num )
--		moveMon = function ( )
--			if xORy == true then
--				if mon[num].x < max - 1 then
--					mon[num].x = mon[num].x + 1
--				else
--					mon[num].x = mon[num].x - 1
--				end
--			else
--					mon[num].y = mon[num].y + 1
--				else
--					mon[num].y = mon[num].y - 1
--				end
--			end
--		end
--
--		Runtime:addEventListener("enterFrame", moveMon)
--
--	end
--
--	monSheet[1] = graphics.newImageSheet( "/image/char1.png", spiderData )
--	mon[1] = display.newSprite( monSheet[1], spiderSet )
--	mon[1].x, mon[1].y = 926 + 1280*3, 628
--	monMove( 926+1280*3, 1280+1280*3, true, 1 )
	--char

	charSheet1 = graphics.newImageSheet( "/image/char.png", charData )	
	char = display.newSprite( charSheet1, charSet )

	char.x, char.y = _W*0.1, _H*0.8750
	char.name = "char"
	char:play()
	physics.addBody( char, "dynamic", { friction = 2.0, density = 10.0 } )

	Runtime:addEventListener( "key", getKey )
	Runtime:addEventListener( "enterFrame", onKey )
	Runtime:addEventListener( "enterFrame", reboot1 )
	-- reboot : collision

end

over = function ( )
	--over!
	audio.play(gameOver)
end

shake = function ( ob )
	transition.to( ob, { x = ob.x + 3, y = ob.y - 3, time = 75 } )
	transition.to( ob, { x = ob.x - 6, y = ob.y + 6, time = 75, delay = 76 } )
	transition.to( ob, { x = ob.x + 9, y = ob.y - 9, time = 75, delay = 152 } )
	transition.to( ob, { x = ob.x - 12, y = ob.y + 12, time = 75, delay = 223 } )
	transition.to( ob, { x = ob.x , y = ob.y, time = 75, delay = 304 } )
 end

reboot = function ( )
	local rect = display.newRect(0,0,_W,_H)
	rect.alpha = 0
	rect.anchorX, rect.anchorY = 0, 0
	audio.play(rebootm)
	transition.to( rect, { alpha = 1.0, time = 150 } )
	transition.to( rect, { alpha = 0.0, time = 150, delay = 150 } )
	char.x = _W * 0.1
	b01.x = 1280*0
	b02.x = 1280*1
	b03.x = 1280*2
	b04.x = 1280*3
	b05.x = 1280*4
	b06.x = 1280*5
	b07.x = 1280*6
	b08.x = 1280*7
	b09.x = 1280*8
	b10.x = 1280*9 
	b11.x = 1280*10
	b12.x = 1280*11
	b13.x = 1280*12
	b14.x = 1280*13 
	b15.x = 1280*14
	b16.x = 1280*15
	box1.x = 500
	box2.x = 960 + 1280 * 1
	boxy[1].x = 192+1280*2
	boxy[2].x = 128+1280*2
	boxy[3].x = 192+1280*2
	boxy[4].x = 384+1280*2
	boxy[5].x = 384+1280*2
	boxy[6].x = 448+1280*2
	boxy[7].x = 448+1280*2
	boxy[8].x = 512+1280*2
	boxy[9].x = 512+1280*2
	boxy[10].x = 576+1280*2
	boxy[11].x = 576+1280*2
	boxy[12].x = 512+1280*3
--	mon[1].x = 926 + 1280*3

	lifeCheck()
	shake(bg)
	shake(b01)
	shake(b02)
	shake(b03)
	shake(b04)
	shake(b05)
	shake(b06)
	shake(b07)
	shake(b08)
	shake(b09)
	shake(b10)
	shake(b11)
	shake(b12)
	shake(b13)
	shake(b14)
	shake(b15)
	shake(b16)
	shake(life_t)

	
end
reboot1 = function ( )
	print("char.x : " .. char.x )
	print("char.y : " .. char.y )
	if ( char.x >= box1.x - 20 ) and ( char.x <= box1.x + 20 ) then
		if ( char.y <= 630 ) and ( char.y >= 600 ) then	
			reboot()
		end
	end
	if ( char.x >= box2.x - 20 ) and ( char.x <= box2.x + 20 ) then
		if ( char.y <= 580 ) and ( char.y >= 550 ) then
			reboot()
		end
	end
end

reboot2 = function ( )
end

reboot3 = function ( )
end

--start here
stage0()