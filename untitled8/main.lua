local c = require "commonSet"
local physics = require "physics"

local _W = display.contentWidth
local _H = display.contentHeight

local boxOpen = audio.loadSound( "/AudioAssets/effect_boxOpen.wav" )
local crackRock = audio.loadSound( "/AudioAssets/effect_crackRock.wav" )
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

--big flow
local start

--need io system
local getKey
local onKey
local onAnyKey
local BGM
local a -- nusic
local b = "/image/bg.png"
local v = 5
local a = 0.1
local BG = { "/image/00.png", "/image/01.png", "/image/02.png", "/image/03.png", "/image/04.png", "/image/05.png", "/image/06.png", "/image/07.png", "/image/08.png", "/image/09.png", "/image/10.png", "/image/11.png", "/image/12.png", "/image/13.png" }

physics.start()
--local
local bg = display.newImage("/image/bg.png",0,0)
bg.anchorX, bg.anchorY = 0, 0

local b00 = display.newGroup()

local b01Data = ( require "image.00").physicsData(1.0)
local b01 = display.newImage(BG[1],1280*0,144*3)
b01.anchorX = 0
physics.addBody( b01, "static", b01Data:get("00") )
b00:insert(b01)

local b02Data = ( require "image.01").physicsData(1.0)
local b02 = display.newImage(BG[2],1280*1,144*3)
b02.anchorX = 0
physics.addBody( b02, "static", b02Data:get("01") ) 
b00:insert(b02)

local b03Data = ( require "image.02").physicsData(1.0)
local b03 = display.newImage(BG[3],1280*2,144*3)
b03.anchorX = 0
physics.addBody( b03, "static", b03Data:get("02") )
b00:insert(b03)

local b04Data = ( require "image.03").physicsData(1.0)
local b04 = display.newImage(BG[4],1280*3,144*3)
b04.anchorX = 0
physics.addBody( b04, "static", b04Data:get("03") )
b00:insert(b04)


local b05Data = ( require "image.04").physicsData(1.0)
local b05 = display.newImage(BG[5],1280*4,144*3)
b05.anchorX = 0
physics.addBody( b05, "static", b05Data:get("04") )
b00:insert(b05)

local b06Data = ( require "image.05").physicsData(1.0)
local b06 = display.newImage(BG[6],1280*5,144*3)
b06.anchorX = 0
physics.addBody( b06, "static", b06Data:get("05") )
b00:insert(b06)


local b07Data = ( require "image.06").physicsData(1.0)
local b07 = display.newImage(BG[6],1280*5,144*3)
b06.anchorX = 0
physics.addBody( b07, "static", b07Data:get("06") )
b00:insert(b07)


local b08Data = ( require "image.07").physicsData(1.0)
local b08 = display.newImage(BG[7],1280*6,144*3)
b07.anchorX = 0
physics.addBody( b08, "static", b08Data:get("07") )
b00:insert(b08)


local b09Data = ( require "image.08").physicsData(1.0)
local b09 = display.newImage(BG[8],1280*7,144*3)
b08.anchorX = 0
physics.addBody( b09, "static", b09Data:get("08") )
b00:insert(b09)


local b10Data = ( require "image.09").physicsData(1.0)
local b10 = display.newImage(BG[9],1280*8,144*3)
b09.anchorX = 0
physics.addBody( b10, "static", b10Data:get("09") )
b00:insert(b10)



local b11Data = ( require "image.10").physicsData(1.0)
local b11 = display.newImage(BG[10],1280*9,144*3)
b10.anchorX = 0
physics.addBody( b11, "static", b11Data:get("10") )
b00:insert(b11)


local b12Data = ( require "image.11").physicsData(1.0)
local b12 = display.newImage(BG[11],1280*10,144*3)
b11.anchorX = 0
physics.addBody( b12, "static", b12Data:get("11") )
b00:insert(b12)


local b13Data = ( require "image.12").physicsData(1.0)
local b13 = display.newImage(BG[12],1280*11,144*3)
b12.anchorX = 0
physics.addBody( b13, "static", b13Data:get("12") )
b00:insert(b13)


local b14Data = ( require "image.13").physicsData(1.0)
local b14 = display.newImage(BG[13],1280*12,144*3)
b13.anchorX = 0
physics.addBody( b14, "static", b14Data:get("13") )
b00:insert(b14)




--local b15Data = ( require "image.14").physicsData(1.0)
--local b14 = display.newImage(BG[13],1280*13,144*3)
--b14.anchorX = 0 
--physics.addBody( b15, "static", b15Data:get("14") )


local keyName
local left
local right
local space
local isJump = false
local text
local isClear = false

display.setDrawMode( "hybrid" )
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


getKey = function ( e )
	keyName = e.keyName
	if e.phase == "down" then
		if keyName == "left" then
			left = true
			changeWalk()
		end
		if keyName == "right" then
			right = true
			changeWalk()
		end
		if KeyName == "space" then
			space = true
			changeJump()
		end
	elseif e.phase == "up" then
		if keyName == "left" then
			left = false
			if space then
				 changeJump()
			else
				changeNormal()
			end
		end
		if keyName == "right" then
			right = false
			changeNormal()
		end
		if KeyName == "space" then
			space = false
			if right or left then
				changeWalk()
			else
				changeNormal()
			end
		end
	end
end

onKey = function ( e )
	if space then
		onJump()
	end

	if left then
		if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
			if BG.x < 0 then
				BG.x = BG.x + v
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
		if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
			if BG.x + BG.contentWidth > _W then
				b00.x = b00.x - v
		--		BG.x = BG.x - v
			else
				if char.x + char.contentWidth * 0.5 + v > _W then
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
end

onJump = function ( )
	if isJump == false then
		audio.play(jump)
		char:setLinearVelocity( 0, -150 )
		isJump = true
	end
end

turnFalse = function ( e )
	if e.x <= char.x then
		isJumping = false
	end
end

onAnyKey = function ( e )
	if e.phase == "down" then
		a = "AudioAssets/GameBGM2.mp3"
		stage0()
	end
end

BGM = function ( )
	media.playSound(a, BGM)
end



start = function ( )
	a = "AudioAssets/GameOpening.mp3"
	BGM()
	text = display.newText("Press Any Key", _W * 0.5, _H * 0.5, native.newFont("정9체.ttf"))
	text.size = 48
	Runtime:addEventListener( "key", onAnyKey )
end

--==================================================================================

stage0_com = function ( )
	if char.x  >= _W * 0.9 then
	end

end

stage0 = function ( )

	Runtime:removeEventListener( "key", onAnyKey )	

	isClear = true

	physics.start()


	BG = display.newImage( b, 0, 0 )
	BG.anchorX, BG.anchorY = 0, 0

	c.setLife()
	c.lifeText()

	
	char = display.newSprite( sheet1, sheetData1 )

	char.x, char.y = _W * 0.1, _H * 0.875
	char:play()
	physics.addBody( char, "dynamic", { friction = 2.0, density = 10.0 } )


	Runtime:addEventListener( "key", getKey )
	Runtime:addEventListener( "enterFrame", onKey )

	Runtime:addEventListener( "collision", turnFalse )
end

start()