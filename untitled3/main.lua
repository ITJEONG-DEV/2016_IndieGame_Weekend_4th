--[[

-- Called when a key event has been received
local left
local right
local up

local function onKeyEvent( event )
	local keyName = event.keyName
    if event.phase == "down" then
    	if keyName == "left" then left = true end
    	if keyName == "right" then right = true end
    	if keyName == "up" then up = true end
    elseif event.phase == "up" then
    	if keyName == "left" then left = false end
    	if keyName == "right" then right = false end
    	if keyName == "up" then up = false end
    end
    return false
end

local function transi( event )
	if left and up then print("left+up")
	elseif right and up then print("right+up")
	elseif left then print("only left")
	elseif right then print("only right")
	elseif up then print("only up")
	end
end

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "enterFrame", transi )
]]--

--function list
local startMenu
local stage1
local onKeyEvent -- only press button
local timeAttack -- 시간 재기
local onKeyTag -- key가 눌려 있는지 아닌지 검사
local jumping -- jump하는 모션을 넣어보자 up
local jumping2 -- jump down
local jumping3 -- jump end
local swapNormal
local swapWalk
local swapJump
local playBGM
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

local backImage
local stage1_Image = "image/backImage.jpg"
local wallImage
local char
local keyName
local keyTag = false
local onJump = false
local v = 5 -- 속도
local a = 0 -- 가속도

--sound list
local boxOpen = audio.loadSound( "/AudioAssets/effect_boxOpen.wav" )
local gameOver = audio.loadSound( "/AudioAssets/effect_gaemOver.wav" )
local jump = audio.loadSound( "/AudioAssets/effect_jump.wav" )
local mondamage = audio.loadSound( "/AudioAssets/effect_monDamage.wav" )
local playerDamage = audio.loadSound( "/AudioAssets/effect_playerDamage.wav")
local ui = audio.loadSound("/AudioAssets/effect_ui.wav")
local bgm = audio.loadSound("/AudioAssets/GameBGM.mp3")
playBGM = function ( e )
	media.playSound("/AudioAssets/GameBGM2.mp3", playBGM)
end

--display.setDrawMode( "hybrid" )

--sprite list
local everyData =
{
   width = 64, 
   height = 64,
   numFrames = 4,
   sheetContentWidth = 256,
   sheetContentHeight = 64
}
local sheetData =
{
	{ name = "normal", frames = { 1 }, time = 500, loopcount = 0 },
	{ name = "walk", frames = { 1, 2, 3, 4 }, time = 500, loopCount = 0}, 
--   {name = "jump", frames = { 7 }, time = 500, loopCount = 0 }
}

local sheet = graphics.newImageSheet("/image/player/player_00.png", everyData )

swapWalk = function ( )
	char:setSequence( "walk" )
	char:play()
end

swapNormal = function ( )
	char:setSequence( "normal" )
	char:play()
end

swapJump = function ( )
	char:setSequence( "normal" )
	char:play()
end

-- 1. easing.inQuad --2. easing.inQuart
jumping = function ( e )
	audio.play(jump)
	transition.to( char, { y = char.y - 70, transition = easing.inQuad, time = 400, onComplete = jumping2 } )
end

jumping2 = function ( e )
	transition.to( char, { y = char.y + 70, transition = easing.outQuad, time = 400, onComplete = jumping3 })
end

jumping3 = function ( e )
	onJump = false
end

onKeyTag = function ( e )
	if e.phase == "down" then
		keyTag = true
		keyName = e.keyName
		if keyName == "left" or "right" then
			swapWalk()
		end
		if keyName == "up" then
			swapJump()
		end
		if onJump == false then
			if keyName == "up" then
				onJump = true
				jumping()
			end
		else
		end
	elseif e.phase == "up" then
		swapJump()
		keyTag = false
	end
end

onKeyEvent = function ( )
	-- if ended // else moved
	if keyTag == true then
		if keyName == "left" then -- move left
			if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
				if backImage.x < 0 then
					backImage.x = backImage.x + ( v + a )
				else
					if char.x - char.contentWidth*0.5 - v < 0 then
						char.x = char.contentWidth*0.5
					else
						char.x = char.x - ( v + a )
					end
				end
			else
				if char.x - char.contentWidth*0.5 - v <= 0 then
					char.x = char.contentWidth*0.5
				else
					char.x = char.x - ( v + a )
				end
			end
		elseif keyName == "right" then -- move right
			if ( char.x >= _W * 0.5 - 50 ) and ( char.x <= _W * 0.5 + 50 ) then
				if backImage.x + backImage.contentWidth > _W then
					backImage.x = backImage.x - ( v + a )
				else
					if char.x + char.contentWidth*0.5 + ( v + a ) > _W then
						char.x = _W - char.contentWidth*0.5
					else
						char.x = char.x + ( v + a )
					end
				end
			else
				if char.x + char.contentWidth*0.5 + v >= _W then
					char.x = _W - char.contentWidth*0.5
				else
					char.x = char.x + ( v + a )
				end
			end
		else
		end
	else
	end
	return false
end

--stage
stage1 = function ( )
	physics.start( )

	--draw backImage
	backImage = display.newImage(stage1_Image)
	backImage.anchorX, backImage.anchorY = 0, 0
	backImage.width, backImage.height = 2 * _W, _H

	--draw wallImage
	wallImage = display.newRect(0, _H*0.8,  _W, _H*0.2)
	wallImage:setFillColor( CC("66ff00") )
	wallImage.anchorX, wallImage.anchorY = 0, 0
	physics.addBody( wallImage, "static", { } )

	--draw char
	char = display.newSprite( sheet, sheetData)
	char.x, char.y = _W * 0.1, _H - wallImage.contentHeight*1.25
	physics.addBody( char, "static", { } )
	char:setSequence( "normal" )
	char:play()

end

--start code here
media.playSound("/AudioAssets/GameBGM.mp3", playBGM)
Runtime:addEventListener( "enterFrame", onKeyEvent )
Runtime:addEventListener( "key", onKeyTag )
stage1()