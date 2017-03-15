local startMenu
local stage
local stage1
local stage1_reboot
local playBGM
local onKey
local leftMove
local rightMove
local onJump
local jumpEnded
local changeWalk
local changeNormal
local changeJump
local stage0_Col
local commonSet
local life
local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16) / 255
	local g = tonumber( hex:sub(3,4), 16) / 255
	local b = tonumber( hex:sub(5,6), 16) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7,8), 16) / 255 end
	return r,g,b,a
end

--local list
local _W = display.contentWidth
local _H = display.contentHeight
local physics = require "physics"

local backGroundImage
local isClear0
local isClear1
local isClaer2--
local back_Image = "image/bg.png"
local stage0_Image = "image/map00.png"
local stage1_Image = "image/map01.png"
local floorImage --
local char
local keyName
local keyTag = false
local v = 5 -- 속도
local a = 0 -- 가속도
local scaleFactor = 1.0
local left
local right
local ctrl
local space
local onJump = false
local isJumping
local rebootArea
local time
local endArea
local life = 1000
local life_t


--sound list
local boxOpen = audio.loadSound( "/AudioAssets/effect_boxOpen.wav" )
local crackRock = audio.loadSound( "/AudioAssets/effect_crackRock.wav" )
local footStep = audio.loadSound( "/AudioAssets/effect_footstep.wav" )
local gameOver = audio.loadSound( "/AudioAssets/effect_gameOver.wav" )
local hmrHit = audio.loadSound( "/AudioAssets/effect_hmrHit.wav" )
local jump = audio.loadSound( "/AudioAssets/effect_jump.wav" )
local mondamage = audio.loadSound( "/AudioAssets/effect_monDamage.wav" )
local mapMove = audio.loadSound( "/AudioAssets/effect_mapMove.wav" )
local monDie = audio.loadSound( "/AudioAssets/effect_monDie.wav" )
local noise = audio.loadSound("/AudioAssets/effect_noise.wav" )
local playerDamage = audio.loadSound( "/AudioAssets/effect_playerDamage.wav" )
local reboot = audio.loadSound( "/AudioAssets/effect_reboot.wav" )
local respawn = audio.loadSound( "/AudioAssets/effect_respawn.wav" )
local shutdown = audio.loadSound( "/AudioAssets/effect_shutdown.wav" )
local ui = audio.loadSound("/AudioAssets/effect_ui.wav")
local opening = audio.loadSound("/AudioAssets/GameOpening.mp3")

playBGM = function ( e )
	media.playSound("/AudioAssets/GameBGM2.mp3", playBGM)
end

--display.setDrawMode( "hybrid" )

commonSet = function ( event )
	life_t = display.newText(life,0,0, native.nweFont("정9체"))
	life_t.x, life_t.y = _W * 0.2, _H * 0.2
	life_t.size = 500
	life_t.align = "left"
end


--sprite list
local sheet1Data =
{
   width = 64, 
   height = 64,
   numFrames = 30,
   sheetContentWidth = 384,
   sheetContentHeight = 320
}

local sheet2Data =
{
	width = 82,
	height = 62,
	numFrames = 4,
	sheetContentWidth = 328,
	sheetContentHeight = 62
}

local sheetData1 =
{
	{ name = "normal", frames = { 1 }, time = 500, loopcount = 0 },
	{ name = "walk", frames = { 1, 2, 3, 4 }, time = 500, loopcount = 0 },
	{ name = "jump", frames = { 25, 26, 27, 28, 27, 26, 25 }, time = 1100, loopcount = 1   },
	{ name = "rockB", frames = { 5, 11, 17 }, time = 500, loopcount = 1 },
	{ name = "rock", frames = { 16 }, time = 500, loopcount = 0 },
	{ name = "slaim", frames = { 23, 24, 29 }, time = 500, loopcount = 0 },
}

local sheetData2 = 
{
	{ name = "attack", frames = { 1, 2, 3, 4 }, time = 500, loopcount = 1 },
}


local sheet1 = graphics.newImageSheet("/image/player_00.png", sheet1Data )
local sheet2 = graphics.newImageSheet( "/image/attack.png", sheet2Data )

changeNormal = function ( e )
	if char.setSequence == "attack" then
		char = display.newSprite( sheet1, sheetData1 )
		char:setSequence("normal")
		char:play()
	elseif char.setSequence ~= "normal" then
		char:setSequence("normal")
		char:play()
	end
end

changeWalk = function ( e )
	if char.setSequence == "attack" then
		char = display.newSprite( sheet1, sheetData1 )
		char:setSequence("walk")
		char:play()
	elseif char.setSequence ~= "walk" then
		char:setSequence("walk")
		char:play()
	end
end

changeJump = function ( e )
	if char.setSequence == "attack" then
		char = display.newSprite( sheet1, sheetData1 )
		char:setSequence("jump")
		char:play()
	elseif char.setSequence ~= "jump" then
		char:setSequence("jump")
		char:play()
	end
end

changeHam = function ( e )
	print(char.setSequence)
	if char.setSequence ~= "attack" then
		print('Not')
		char = display.newSprite( sheet2, sheetData2 )
		char:setSequence("attack")
		char:play()
	end
end

--for movenig
getKey = function ( e )
	--space : jump
	--ctrl : hammer
	--left : left
	--right : right 
	keyName = e.keyName
	if e.phase == "down" then
		if keyName == "space" then
			space = true
			changeJump()
		else
			if keyName == "left" then
				left = true
				changeWalk()
			end
			if keyName == "right" then
				right = true
				changeWalk()
			end
		end
		if keyName == "ctrl" then
			ctrl = true
			changeHam()
		end
	elseif e.phase == "up" then
		if keyName == "space" then
			space = false
			changeNormal()
		else
			if keyName == "left" then
				left = false
				if right then changeWalk() end
				if space then changeJump() end
				if ctrl then changeHam() end
			end
			if keyName == "right" then
				right = false
				changeNormal()
			end
			if keyName == "space" then
				space = false
				changeNormal()
			end
			if keyName == "ctrl" then
				ctrl = false
				changeNormal()
			end
		end
	end
end


--for moving
onKey = function ( )
	stage0_Col()
	char.rotation = 0
	if space then onJump() end
	if left then leftMove() end
	if right then rightMove() end
	if ctrl then end
end

onJump = function ( )
	if not isJumping then
		audio.play(jump)
		char:setLinearVelocity( 0, -150 )
		isJumping = true
	end
end

turnFalse = function ( event )
	if event.x <= char.x then
		isJumping = false
	end
end
 
leftMove = function ( e )
	if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
		if backGroundImage.x < 0 then
			backGroundImage.x = backGroundImage.x + v + a
		else
			if char.x - char.contentWidth * 0.5 - v < 0 then
				char.x = char.contentWidth * 0.5
			else
				char.x = char.x - v - a
			end
		end
	else
		if char.x - char.contentWidth * 0.5 - v <= 0 then
			char.x = char.contentWidth * 0.5
		else
			char.x = char.x - v - a
		end
	end
end

rightMove = function ( e )
	if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
		if backGroundImage.x + backGroundImage.contentWidth > _W then
			backGroundImage.x = backGroundImage.x - v - a
		else
			if char.x + char.contentWidth * 0.5 + v + a > _W then
				char.x = _W - char.contentWidth * 0.5
			else
				char.x = char.x + v + a
			end
		end
	else
		if char.x + char.contentWidth * 0.5 + v >= _W then
			char.x = _W - char.contentWidth * 0.5
		else
			char.x = char.x + v + a
		end
	end
end

--commonSet
commonSet = function ( e )
end

stage0_Col = function ( e )
	if char.x >= _W * 0.95 then
		media.stopSound( "/AudioAssets/GameBGM.mp3" )
		if isClear0 then
			physics.removeBody( floorImage )
			physics.removeBody( char )
			stage1()
		else 
			audio.play(reboot)
			Runtime:addEventListener( "key", getKey )
			Runtime:addEventListener( "enterFrame", onKey )
			physics.removeBody( floorImage )
			physics.removeBody( char )
			stage0()
		end
	end
end

--stage0 ( tuto )
stage0 = function ( )
	isClear0 = true
	media.playSound("/AudioAssets/GameBGM.mp3", playBGM )

	physics.start()
	--backGround Image
	backGroundImage = display.newImage(back_Image,0,0)
	backGroundImage.width, backGroundImage.height = 1280, 720
	backGroundImage.anchorX, backGroundImage.anchorY = 0, 0

	commonSet()

	--floor Image
	physicsData = ( require "image.map0" ).physicsData(1.0)
	floorImage = display.newImage(stage0_Image,0,0)
	floorImage.anchorX, floorImage.anchorY = 0, floorImage.contentHeight
	floorImage.x, floorImage.y = 0, _W - floorImage.contentHeight * 0.9725
	physics.addBody( floorImage, "static", physicsData:get("map00") )

	--reboot Point

	--end Point

	--character Image
	char = display.newSprite( sheet1, sheetData1  )
	char.obj = "char"
	--0.1 / 0.7
	char.x, char.y = _W*0.1, _H*0.875
	char:play()
	physics.addBody( char, "dynamic", { friction = 2.0, density = 10.0 } )
	--char:applyForce( 50, 200, char.x, char.y)

	Runtime:addEventListener( "key", getKey )
	Runtime:addEventListener( "enterFrame", onKey )

	changeNormal()



end

--stage1

stage1_Col = function ( e )
	if char.x >= _W * 0.95 then
		media.stopSound( "/AudioAssets/GameBGM.mp3" )
		if isClear1 then
			physics.removeBody( floorImage )
			physics.removeBody( char )
			physics.removeBody( endArea )
			stage1()
		else 
			audio.play(reboot)
			physics.removeBody( floorImage )
			physics.removeBody( char )
			stage2()
		end
	end
end


stage1 = function ( )

	isClear1 = true

	media.playSound("/AudioAssets/GameBGM.mp3", playBGM)

	physics.start()
	--backGround Image
	backGroundImage = display.newImage(back_Image,0,0)
	backGroundImage.width, backGroundImage.height = 1280, 720
	backGroundImage.anchorX, backGroundImage.anchorY = 0, 0

	--floor Image
	physicsData = ( require "image.map1" ).physicsData(1.0)
	floorImage = display.newImage(stage1_Image,0,0)
	floorImage.anchorX, floorImage.anchorY = 0, floorImage.contentHeight
	floorImage.x, floorImage.y = 0, _W - floorImage.contentHeight * 0.9725
	physics.addBody( floorImage, "static", physicsData:get("map01") )

	--reboot Point
	rebootArea = display.newRect(0,0,64,10)
	rebootArea.anchorX, rebootArea.anchorY = 0, 0
	rebootArea.x, rebootArea.y = _W * 0.75, _H * 0.9
	rebootArea.alpha = 0.0001
	rebootArea.isVisible = true

	physics.addBody( rebootArea, static, { friction = 2.0, density = 10.0 })


	--character Image
	char = display.newSprite( sheet1, sheetData1 )
	--0.1 / 0.7
	char.x, char.y = _W*0.1, _H*0.875
	char:play()
	physics.addBody( char, "dynamic", { friction = 2.0, density = 10.0 } )
	--char:applyForce( 50, 200, char.x, char.y)

	changeNormal()

	Runtime:addEventListener( "collision", turnFalse )
	rebootArea:addEventListener( "collision", stage1_reboot )

end


stage1_reboot = function ( e )
	return false
end
-- reboot


--start code here
life = 1000
life_t = display.newText(life, 1280*0.125, 720*0.08, native.newFont( "정9체.ttf" ) )
life_t.size = 50
stage0
