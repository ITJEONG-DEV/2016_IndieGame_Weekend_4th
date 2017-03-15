-- to do list
--[[
0. save
1. slider
2. start -> theme -> stage -> map
]]--
--effect = display.newSprite( effectSheet, effectSet )
-- local list
display.setStatusBar( display.HiddenStatusBar )
local _W = display.contentWidth
local _H = display.contentHeight
local physcis = require "physics"
local widget = require "widget"
local json = require "json"


--Conver Color
local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16) / 255
	local g = tonumber( hex:sub(3,4), 16) / 255
	local b = tonumber( hex:sub(5,6), 16) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7,8), 16) / 255 end
	return r,g,b,a
end

--audioAsset List
local crackRock = audio.loadSound( "AudioAssets/effect_crackRock.wav" )
local footstep = audio.loadSound( "AudioAssets/effect_footstep.wav" )
local hamHit = audio.loadSound( "AudioAssets/effect_hmrHit.wav" )
local hamSwing = audio.loadSound( "AudioAssets/effect_hmrSwing.wav" )
local jump = audio.loadSound( "AudioAssets/effect_jump.wav" )
local moveMap = audio.loadSound( "AudioAssets/effect_mapMove.wav" )
local damageMonster = audio.loadSound( "AudioAssets/effect_monDamage.wav" )
local dieMonster = audio.loadSound( "AudioAssets/effect_monDie.wav" )
local noise = audio.loadSound( "AudioAssets/effect_noise.wav" )
local damagePlayer = audio.loadSound( "AudioAssets/effect_playerDamage.wav" )
local diePlayer = audio.loadSound( "AudioAssets/effect_playerDie.wav" )
local respawn = audio.loadSound( "AudioAssets/effect_respawn.wav" )
local shutDown = audio.loadSound( "AudioAssets/effect_shutdown.wav" )
local ui = audio.loadSound( "AudioAssets/effect_ui.wav" ) --이건 무슨 음악인가.. 생각해보자-
local rebootm = audio.loadSound( "AudioAssets/effect_reboot.wav" )

--data
local path = system.pathForFile( "Data.txt" , system.DocumentsDirectory )
local theme
local stage
local savePoint
local runningTime

local myData = 
{
	["theme"] = 1,
	["stage"] = 1,
	["savePoint"] = 1,
	["runningTime"] = 0
}
local selectData = 
{
	["theme"] = 1,
	["stage"] = 1,
	["savePoint"] = 1,
	["runingTime"] = 0
}

local saveData = function ( )
	-- w : 덮어쓰기. 전 내용은 사라짐.
	local encoded = json.encode( myData )
	--print( "encoded : " .. encoded )

	local file, errorString = io.open( path, "w" )

	if not file then
		--print( "File error : ".. errorString )
	else
		file:write( encoded )

		io.close( file )
	end

	file = nil
end

local loadData = function ( )
	local file, errorString = io.open( path, "r" )


	if not file then
		--print( "File error: " .. errorString )
	else
		local decoded, pos, msg  = json.decodeFile( path )

		if not decoded then
			--print( "decode failed at".. tostring(pos)..": "..tostring(msg))
		else
			theme = decoded.theme
			stage = decoded.stage
			savePoint = decoded.savePoint
			runningTime = decoded.runningTime

		end

		io.close ( file )
	end

	file = nil
end


--function list
local start
local selectTheme
local selectStage
local stage
local turnSelectTheme
local turnSelectStage
local turnStage
local newTouch
local localTouch
local themeTouch
local inGame

local BGM

BGM = function ( path )
	media.playSound( path, BGM )
end


--local list
local bg
local bgPhysics = {}
local bgData = {}
local floor
local isTouch = false
local alertBox
local alertBox_t

local dissolveFunc

--start
local load = nil
local new = nil
local curser = nil

--theme
local themeButton = {}
local themeRock = {}
local themeText = {}
local themeName = { "드넓은 초원", "포근한 집", "좋은 노트북" }
local themeT

--stage
local stageButton = {}
local stageRock = {}
local stageText = {}
local themeShow
local themeShow_t

--inGame
local life = 3
local life_t

local rebootBox

local isClear
local char
local charSet
local charData
local charSheet

local effect
local effectData
local effectSet
local effectSheet

local box = {}
local boxNum
local boxEvent

local checkerNum = 0
local checker = {}

--move
local moveLeft
local moveRight
local moveJump
local moveAttack

local leftID
local rightID
local jumpID
local attackID

local leftNum
local rightNum
local attackNum
local jumpNum

local checkPoint = {}

local isJumping = false

local downC


--reboot
local reboot11

local source_jump


---game Over&Clear
local gameOvered
local gameCleared

local over

local replay
local exit
local replayb
local exitb

local charRotation = function ( )
	char.rotation = 0

	if ( char.y + char.contentHeight * 0.5 ) > _H then
		if source_jump ~= nil then timer.cancel( source_jump ) end
		reboot11()
	end

	if ( char.x + 32 >= box[1].x ) and ( char.x - 32 <= box[1].anchorX + box[1].x ) then
		--print("x okay")
		--if ( char.y - 32 <= box[1].y + 64 ) and ( char.y + 32 >= box[1].y ) then
		if ( char.y + 32 <= box[1].y ) then
			print("reboot!")
			reboot11()
		else
			--make check!!!
			if checkerNum == 0 then
				checkerNum = 1
				checker[1] = display.newImage("image/UI/ui_quest_check.png", 0, 0)
				checker[1].x, checker[1].y = _W * 0.6125 , _H * 0.0748

			elseif checkerNum == 1 then
				checkerNum = 2
				checker[2] = display.newImage("image/UI/ui_quest_check.png", 0, 0)
				checker[2].x, checker[2].y = _W * 0.644 , _H * 0.0748

			elseif checkerNum == 2 then
				checkerNum = 3
				checker[3] = display.newImage("image/UI/ui_quest_check.png", 0, 0)
				checker[3].x, checker[3].y = _W * 0.6755 , _H * 0.0748

			elseif checkerNum == 3 then
				checkerNum = 4
				checker[4] = display.newImage("image/UI/ui_quest_check.png", 0, 0)
				checker[4].x, checker[4].y = _W * 0.707 , _H * 0.0748
			end

		end
	end
end

--character list


--function start

--transition func.
dissolveFunc = function ( obj )
	local obj2 = obj
	local onTimer = function ( )
		if obj2.alpha == 1 then obj2.alpha = 0
		else obj2.alpha = 1
		end
	end

	timer.performWithDelay( 300, onTimer, 3 )
end

--touch event
turnSelectTheme = function ( )
	selectTheme( )
end

turnSelectStage = function ( n )
	for i = 1, 3, 1 do
		if i ~= n then
			themeButton[i]:removeEventListener( "tap", themeTouch )

			themeButton[i]:removeSelf()

			themeText[i]:removeSelf()
		end
	end

	transition.to( bg, { alpha = 1, time = 300, onStart = selectStage } )
end

turnStage = function ( )
	for i = 1, 2, 1 do
		for j = 1, 3, 1 do
			stageButton[10*i+j]:removeEventListener( "tap", stageTouch )
			stageButton[10*i+j]:removeSelf()
			stageText[10*i+j]:removeSelf()
		end
	end
	bg:removeSelf()
	floor:removeSelf()
	themeShow:removeSelf()
	themeShow_t:removeSelf()
	inGame()
end

--start menu option
newTouch = function ( )
	system.vibrate( )
	curser.x, curser.y = _W * 0.07, _H * 0.795
	curser.alpha = 1
	new:removeEventListener( "touch", newTouch )
	load:removeEventListener( "touch", loadTouch )
	audio.play(ui)
	saveData()
	load.alpha = 0

	function toDark ( )
		if curser.alpha == 0 then curser.alpha = 1
		else curser.alpha = 0
		end

		if new.alpha == 0 then new.alpha = 1
		else new.alpha = 0
		end
	end

	timer.performWithDelay( 300, toDark, 4 )

	transition.to( bg, { alpha = 1, time = 450, delay = 901, onStart = turnSelectTheme } )

end

loadTouch = function ( )
	system.vibrate( )
	curser.x, curser.y = _W * 0.07, _H * 0.885
	curser.alpha = 1
	new:removeEventListener( "touch", newTouch )
	load:removeEventListener( "touch", loadTouch )
	audio.play(ui)
	loadData( )
	new.alpha = 0

	function toDark ( )
		if curser.alpha == 0 then curser.alpha = 1
		else curser.alpha = 0
		end

		if load.alpha == 0 then load.alpha = 1
		else load.alpha = 0
		end
	end

	timer.performWithDelay( 300, toDark, 4 )

	transition.to( bg, { alpha = 1, time = 450, delay = 901, onStart = turnSelectTheme } )

end

--theme option
themeTouch = function ( e )
	local n = e.target.name

	if myData.theme >= n then
		selectData.theme = n
		turnSelectStage(n)
		audio.play(ui)
	end
end

--stage option
stageTouch = function ( e )
	local n = e.target.name
	selectData.stage = n

	if ( myData.theme > selectData.theme ) or ( myData.theme == selectData.theme and myData.stage >= selectData.stage ) then
		audio.play(ui)
		selectData.stage = n
		turnStage(n)
	end
end

--ingame option
buttonTouch = function ( e )
	local n = e.target.name
	--print( "name : " .. n .. "   phase : " .. e.phase )
	if e.phase == "began" then
		physics.removeBody(char)

		if n == "attack" then
			audio.play(hamSwing)
			physics.addBody( char, "dynamic", charPhysics:get("attack_01"))
			char:setSequence("attack")
			char:play()
		elseif n == "jump" then
			physics.addBody( char, "dynamic", charPhysics:get("jump_02"))
			char:setSequence("jump")
			char:play()
			moveJump() 
		elseif n == "right" then
			physics.addBody( char, "dynamic", charPhysics:get("walk_01"))
			char:setSequence("walkR")
			char.xScale = 1
			char:play()
			Runtime:addEventListener( "enterFrame", moveRight )
		elseif n == "left" then
			physics.addBody( char, "dynamic", charPhysics:get("walk_01"))
			char:setSequence("walkL")
			char.xScale = -1
			char:play()
			Runtime:addEventListener("enterFrame", moveLeft )
		end
	elseif e.phase == "moved" then
		if n == "attack" then
		elseif n == "jump" then
		elseif n == "right" then
		elseif n == "left" then
		else
			Runtime:removeEventListener( "enterFrame", moveRight )
			Runtime:removeEventListener( "enterFrame", moveLeft )
			physics.removeBody( char )
			physcis.addBody( char, "dynamic", charPhysics:get("normal"))
		end

	elseif e.phase == "ended" then
		if n == "attack" then
			physics.removeBody( char )
			physics.addBody( char, "dynamic", charPhysics:get("normal"))
			char:setSequence("normal")
			char:play()
		elseif n == "jump" then
		elseif n == "right" then
			Runtime:removeEventListener( "enterFrame", moveRight )
			physics.removeBody( char )
			physics.addBody( char, "dynamic", charPhysics:get("normal"))
			char:setSequence("normal")
			char:play()
		elseif n == "left" then
			Runtime:removeEventListener( "enterFrame", moveLeft )
			physics.removeBody( char )
			physics.addBody( char, "dynamic", charPhysics:get("normal"))
			char:setSequence("normal")
			char:play()
		else
			Runtime:removeEventListener( "enterFrame", moveRight )
			Runtime:removeEventListener( "enterFrame", moveLeft )
			physics.removeBody( char )
			physcis.addBody( char, "dynamic", charPhysics:get("normal"))
		end
			

	end
end



--event.other

--screen
start = function ( )
	media.stopSound( )
	media.playSound( "AudioAssets/GameOpening.mp3", BGM )

	bg = display.newImage("image/title/bg.png")
	bg.anchorX, bg.anchorY = 0, 0

	new = display.newImage("image/title/new.png")
	new.anchorX, new.anchorY = 0, 0
	new.x, new.y = _W * 0.1, _H * 0.8
	new.name = "new"

	load = display.newImage("image/title/load.png")
	load.anchorX, load.anchorY = 0, 0
	load.x, load.y = _W * 0.1 , _H * 0.89
	load.name = "load"

	curser = display.newImage("image/title/curser.png")
	curser.anchorX, curser.anchorY = 0, 0
	curser.alpha = 0

	load:addEventListener( "touch", loadTouch )
	new:addEventListener( "touch", newTouch )

end

selectTheme = function ( )
	bg:removeSelf( )
	new:removeSelf( )
	load:removeSelf( )
	curser:removeSelf( )
	bg = display.newImage("image/stage/chapter.png",0,0)
	bg.anchorX, bg.anchorY = 0, 0
	bg:setFillColor( CC("E3F6FF" ))
	floor = display.newImage("image/stage/floor.png",0,_H)
	floor.anchorX, floor.anchorY = 0, floor.contentHeight

	for i = 1, 3, 1 do
		if myData.theme > i then
			themeButton[i] = display.newImage("image/stage/clear.png", _W*0.15 + 4101*(i-1), _H*0.3875 )
		elseif myData.theme == i then
			themeButton[i] = display.newImage("image/stage/unlock.png", _W*0.15 + 410*(i-1), _H*0.3875 )
		else
			themeButton[i] = display.newImage("image/stage/locked.png", _W*0.15 + 410*(i-1), _H*0.3875)
		end
		themeButton[i].anchorX, themeButton[i].anchorY = 0, 0
		themeButton[i].name = i

		themeButton[i]:addEventListener( "tap", themeTouch )

		themeText[i] = display.newText( themeName[i], 0, 0, native.newFont( "정9체.ttf" ) )
		themeText[i].size = 60
		themeText[i].x, themeText[i].y = themeButton[i].x + themeButton[i].contentWidth * 0.5 , themeButton[i].y + themeButton[i].contentHeight * 1.3
		themeText[i]:setFillColor( CC("000000"))
	end

end

selectStage = function ( )
	themeButton[selectData.theme]:removeSelf()
	bg:removeSelf()
	floor:removeSelf()
	bg = display.newImage("image/stage/chapter.png", 0, 0)
	bg.anchorX, bg.anchorY = 0, 0
	floor = display.newImage("image/stage/floor.png",0,_H)
	floor.anchorX, floor.anchorY = 0, floor.contentHeight
	themeShow = display.newImage("image/stage/titleBar.png",0,0)
	themeShow.anchorX, themeShow.anchorY = 0, 0
	themeShow_t = display.newText(themeName[selectData.theme], _W*0.0875, _H*0.05, native.newFont("정9체.ttf") )
	themeShow_t.align = "left"

	for i = 1, 2, 1 do
		for j = 1, 3, 1 do
			if ( myData.theme > selectData.theme ) or ( ( myData.theme == selectData.theme ) and ( myData.stage > 3*(i-1)+j ) ) then
				stageButton[10*i+j] = display.newImage("image/stage/clear.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			elseif ( myData.theme == selectData.theme ) and ( myData.stage == 3*(i-1)+j ) then
				stageButton[10*i+j] = display.newImage("image/stage/unlock.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			else
				stageButton[10*i+j] = display.newImage("image/stage/locked.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			end
			stageButton[10*i+j].anchorX, stageButton[10*i+j].anchorY = 0, 0
			stageButton[10*i+j].name = (i-1)+j
			stageButton[10*i+j]:addEventListener( "tap", stageTouch )

			stageText[10*i+j] = display.newText( selectData.theme .. "-" .. 3*(i-1)+j, 0, 0, native.newFont("정9체.ttf") )
			stageText[10*i+j].size = 60
			stageText[10*i+j].x, stageText[10*i+j].y = stageButton[10*i+j].x + stageButton[10*i+j].contentWidth * 0.5, stageButton[10*i+j].y + stageButton[10*i+j].contentHeight * 1.3
			stageText[10*i+j]:setFillColor( CC("000000") )
		end
	end

end

inGame = function ( )
	--game settings
	media.stopSound( )
	media.playSound("AudioAssets/GameBGM2.mp3", BGM )

	physics.start()

--	display.setDrawMode( "hybrid" )

	local th = selectData.theme
	local st = selectData.stage
	local physicsName = {}

	bg = display.newImage("image/UI/bg.png", 0, 0 )
--	bg = display.newImage("/image/UI/sample2.png", 0, 0)

	if th == 1 then
		if st == 1 then
			bgPhysics[1] = display.newImage("image/map/00.png", 0, 0)
			bgData[1] = ( require "image.map.00").physicsData(1,0)
			physicsName[1] = "00"

			bgPhysics[2] = display.newImage("image/map/01.png", 0, 0)
			bgData[2] = ( require "image.map.01").physicsData(1,0)
			physicsName[2] = "01"

			bgPhysics[3] = display.newImage("image/map/02.png", 0, 0)
			bgData[3] = ( require "image.map.02").physicsData(1,0)
			physicsName[3] = "02"

			bgPhysics[4] = display.newImage("image/map/03.png", 0, 0)
			bgData[4] = ( require "image.map.03").physicsData(1,0)
			physicsName[4] = "03"

		elseif st == 2 then
		elseif st == 3 then
		elseif st == 4 then
		elseif st == 5 then
		elseif st == 6 then
		end
	else
	end
	bg.anchorX, bg.anchorY = 0, 0

	for i = 1, 4, 1 do
		bgPhysics[i].x, bgPhysics[i].y = _W*(i-1), _H
		bgPhysics[i].anchorX, bgPhysics[i].anchorY = 0, bgPhysics[i].contentHeight
		bgPhysics[i].name = "map"
		physics.addBody( bgPhysics[i], "static", bgData[i]:get(physicsName[i]))
	end

	--UI Settings
	local timerUI = display.newImage("image/UI/time.png", 0,0)
	timerUI.x, timerUI.y = _W * 0.351, _H * 0.052

	local timerUI2 = display.newImage("image/UI/timeGuage.png",0,0)
	timerUI2.x, timerUI2.y = _W * 0.379, _H * 0.028

	local timerText = display.newText( "99:99", 0,0, native.newFont("정9체.ttf"))
	timerText.size = 55
	timerText.x, timerText.y = _W * 0.438, _H * 0.085

	local rebootUI = display.newImage("image/UI/quest.png",0,0)
	rebootUI.x, rebootUI.y = _W * 0.634, _H * 0.051

	--char set
	charData = 
	{
		width = 100,
		height = 64,
		numFrames = 12,
		sheetContentWidth = 400 ,
		sheetContentHeight = 192 ,
	}
	charSet = 
	{
		{ name = "normal", frames = { 1 }, loopCount = 0 },
		{ name = "walkL", frames = { 1,2, 3, 4 }, time = 400, loopCount = 0 },
		{ name = "walkR", frames = { 1,2, 3, 4 }, time = 400, loopCount = 0 },
		{ name = "jump", frames = { 5, 6, 7 }, time = 300, loopCount = 1 },
		{ name = "attack", frames = { 1, 9, 10, 11, 11 }, time = 500, loopCount = 0 },
	}

	charSheet = graphics.newImageSheet( "image/char.png", charData )
	char = display.newSprite( charSheet, charSet )
	charPhysics = ( require "image.char").physicsData(1.0)

	char.x, char.y = _W * 0.3, _H - bgPhysics[1].contentHeight*1.5
	char.name = "char"
	char:play()
	physics.addBody( char, "static", charPhysics:get("normal") )

	--effect set
	effectData =
	{
		width = 64,
		height = 64,
		numFrames = 8,
		sheetContentWidth = 128,
		sheetContentHeight = 256
	}
	effectSet =
	{
		{ name = "boxE", frames = { 1, 3, 5, 7 }, time = 400, loopCount = 1 },
		{ name = "E", frames = { 1, 3, 5, 7 }, time = 400, loopcount = 1 },
	}

	effectSheet = graphics.newImageSheet( "image/effect.png", effectData )


	--button
	attackButton = display.newImage("image/UI/hammerb.png",0,0)
	attackButton.x, attackButton.y = _W * 0.921, _H * 0.864
	attackButton.name = "attack"
	attackButton:addEventListener( "touch", buttonTouch )

	jumpButton = display.newImage("image/UI/jumpb.png",0,0)
	jumpButton.x, jumpButton.y = _W * 0.8, _H * 0.907
	jumpButton.name = "jump"	
	jumpButton:addEventListener( "touch", buttonTouch )

	upButton = widget.newButton({
		left = _W * 0.1,
		top = _H * 0.7,
		defaultFile = "image/UI/upIdle.png",
		overFile = "image/UI/upPush.png",
		onEvent = buttonTouch
	})
	upButton.name = "up"

	
	downButton = widget.newButton({
		left = _W * 0.1,
		top = _H * 0.8,
		defaultFile = "image/UI/downIdle.png",
		overFile = "image/UI/downPush.png",
		onEvent = buttonTouch
	})
	downButton.name = "down"

	leftButton = widget.newButton({
		left = _W * 0.064,
		top = _H * 0.766,
		defaultFile = "image/UI/leftIdle.png",
		overFile = "image/UI/leftPush.png",
		onEvent = buttonTouch
		})
	leftButton.name = "left"

	rightButton = widget.newButton({
		left = _W * 0.12,
		top = _H * 0.766,
		defaultFile = "image/UI/rightIdle.png",
		overFile = "image/UI/rightPush.png",
		onEvent = buttonTouch
	})
	rightButton.name = "right"

	Runtime:addEventListener( "enterFrame", charRotation )

	--text settings

	life = 3
	life_t = display.newText(life, _W*0.1, _H * 0.08, native.newFont( "정9체.ttf" ))
	life_t.size = 50

	--reboot settings

	box[1] = display.newRect( 64*10, _H - 64*2, 64, 64 )
	box[2] = display.newRect( 64*20, _H - 64*4, 64, 64 )
	box[3] = display.newRect( 64*30, _H - 64*6, 64, 64 )
	box[4] = display.newRect( 64*35, _H - 64*8, 64, 64 )

	-- box settings
	box[5] = display.newImage("image/box.png", 64*38, _H-64*3 )
	box[6] = display.newImage("image/box.png", 64*39, _H-64*4 )
	box[7] = display.newImage("image/box.png", 64*39, _H-64*3 )
	box[8] = display.newImage("image/box.png", 64*40, _H-64*3 )
	box[9] = display.newImage("image/box.png", 64*40, _H-64*4 )
	box[10]= display.newImage("image/box.png", 64*40, _H-64*5 )
	box[11] = display.newImage("image/box.png", 64*43, _H-64*5 )
	box[12] = display.newImage("image/box.png", 64*43, _H-64*4 )
	box[13] = display.newImage("image/box.png", 64*44, _H-64*5 )
	box[14] = display.newImage("image/box.png", 64*44, _H-64*4 )
	box[15] = display.newImage("image/box.png", 64*45, _H-64*5 )
	box[16] = display.newImage("image/box.png", 64*45, _H-64*4 )
	box[17] = display.newImage("image/box.png", 64*46, _H-64*5 )
	box[18] = display.newImage("image/box.png", 64*46, _H-64*4 )
	box[19] = display.newImage("image/box.png", 64*47, _H-64*5 )
	box[20] = display.newImage("image/box.png", 64*47, _H-64*4 )
	box[21] = display.newImage("image/box.png", 64*48, _H-64*5 )
	box[22] = display.newImage("image/box.png", 64*48, _H-64*4 )
	box[23] = display.newImage("image/box.png", 64*49, _H-64*5 )
	box[24] = display.newImage("image/box.png", 64*49, _H-64*4 )

	boxNum = 24

	for i = 1, boxNum, 1 do
		box[i].anchorX, box[i].anchorY = 0, 0
		box[i].alpha = 1
		if i>=5 then
			physics.addBody(box[i], "static", { })
		end
	end

	--start Game

end

--move
local s = 7.5
moveLeft = function ( )
	if ( char.x - 32 - s > 0 ) then
		if ( bgPhysics[1].x < 0 ) then
			if (char.x < _W*0.5 - 64 and char.x < _W*0.45 + 64 ) then
				for i = 1, 4, 1 do
					bgPhysics[i].x = bgPhysics[i].x + s
				end
				for i = 1, boxNum, 1 do
					box[i].x = box[i].x + s
				end
			else
				for i = 1, 4, 1 do
					bgPhysics[i].x = bgPhysics[i].x + s * 0.5
				end
				for i = 1, boxNum, 1 do
					box[i].x = box[i].x + s * 0.5
				end
				char.x = char.x - s * 0.5
			end
		else
			char.x = char.x - s
		end
	else
		char.x = 32
	end
end

moveRight = function ( )
	if ( char.x + 32 + s <= _W ) then
		if ( bgPhysics[4].x >= _W ) then
			if ( char.x < _W * 0.5 - 64 and char.x < _W * 0.5 + 64 ) then
				for i = 1, 4, 1 do
					bgPhysics[i].x = bgPhysics[i].x - s
				end
				for i = 1, boxNum, 1 do
					box[i].x = box[i].x - s
				end
			else
				for i = 1, 4, 1 do
					bgPhysics[i].x = bgPhysics[i].x - s * 0.5
				end
				for i = 1, boxNum, 1 do
					box[i].x = box[i].x - s * 0.5
				end
				char.x = char.x + s * 0.5
			end
		else
			char.x = char.x + s
		end
	else
		char.x = _W - 32
	end
end


collisionWithMap = function ( self, e )
--	print(e.target.name)
--	print(e.other.name)
	--char:setLinearVelocity( 0, 500 )
	if e.target.name == "char" and e.other.name == "map" then
--		print("target : "..e.target.name.." other : " .. e.other.name)
		char:removeEventListener( "collision" , collisionWithMap)
		isJumping = false
		char:setSequence("normal")
		char:play()
	end
end

moveJump = function ( )
	if not isJumping then
		isJumping = true
		audio.play(jump)
		char:setSequence("jump")
		char:play()
		char:setLinearVelocity( 0, -1000 )
		char.collision = collisionWithMap
		char:addEventListener( "collision" )

		downC = function ( e )
			sorce_jump = e.source
			char:setLinearVelocity( 0, 500 )
		end
		timer.performWithDelay( 200, downC, 1 )
	end
end

--reboot function
reboot11 = function ( e )
	checkerNum = 0
	life = life - 1
	life_t.text = life
	if life == 0 then
		gameOvered()
	else
		local rect = display.newRect( 0, 0, _W, _H )
		rect.alpha = 0
		rect.anchorX, rect.anchorY = 0, 0
		audio.play( rebootm )
		transition.to( rect, { alpha = 1.0, time = 1 } )
		transition.to( rect, { alpha = 0.0, time = 1, delay = 500 } )
		char.x = _W * 0.3
		char.y = _H * 0.8750
		
		for i = 1, 4, 1 do
			bgPhysics[i].x = _W * ( i - 1 )
		end

		local boxX = { 64*10, 64*20, 64*30, 64*35, 64*38, 
					   64*39, 64*39, 64*40, 64*40, 64*40,
					   64*43, 64*43, 64*44, 64*44, 64*45,
					   64*45, 64*46, 64*46, 64*47, 64*47,
					   64*48, 64*48, 64*49, 64*49,
					 }
		for i = 1, boxNum, 1 do
			box[i].x = boxX[i]
		end
	end
end

-- gameOver
replay = function ( e )

	local function f1( )
		bg:removeSelf()
		replayb:removeEventListener( "touch", replay )
		exitb:removeEventListener( "touch", exit )
		replayb:removeSelf()
		exitb:removeSelf()
		over:removeSelf()
	
		inGame()
	end

	timer.performWithDelay( 50, f1, 1 )
end

exit = function ( e )

	local function f1( )
		bg:removeSelf()
		replayb:removeEventListener( "touch", replay )
		exitb:removeEventListener( "touch", exit )
		replayb:removeSelf()
		exitb:removeSelf()
		over:removeSelf()

		start()
	end

	timer.performWithDelay( 50, f1, 1 )

end

gameOvered = function ( e )
	physics.stop()
	media.stopSound( )
	media.playSound( "AudioAssets/effect_playerDie.wav", 1 )
	media.playSound( "AudioAssets/effect_gameOver.wav", 1 )
	--remove
	Runtime:removeEventListener( "enterFrame", charRotation )
	attackButton:removeEventListener( "touch", buttonTouch )
	jumpButton:removeEventListener( "touch", buttonTouch )
	upButton:removeEventListener( "touch", buttonTouch )
	downButton:removeEventListener( "touch", buttonTouch )
	leftButton:removeEventListener( "touch", buttonTouch )
	rightButton:removeEventListener( "touch", buttonTouch )

	Runtime:removeEventListener( "enterFrame", moveRight )
	Runtime:removeEventListener( "enterFrame", moveLeft )

	bg:removeSelf()
	life_t:removeSelf()
	attackButton:removeSelf()
	jumpButton:removeSelf()
	upButton:removeSelf()
	downButton:removeSelf()
	leftButton:removeSelf()
	rightButton:removeSelf()

	physics.removeBody( char )
	physics.removeBody( bgPhysics[1] )
	char:removeSelf()


	bg = display.newRect( 0, 0, _W, _H )
	bg.anchorX, bg.anchorY = 0, 0
	over = display.newImage("image/UI/gameOver.png")
	over.x, over.y = _W *0.5 , _H * 0.35

	local makeButton = function ( )
		replayb = widget.newButton({
			left = _W * 0.1,
			top = _H * 0.65,
			defaultFile = "image/UI/ntnIdle.png",

			overFile = "image/UI/ntnPush.png",
			onEvent = replay
		})

		exitb = widget.newButton({
			left = _W * 0.65,
			top = _H * 0.65,
			defaultFile = "image/UI/ntnIdle.png",
			overFile = "image/UI/ntnPush.png",
			onEvent = exit
		})


		local text1 = display.newText("다시하기", 0, 0, native.newFont("정9체.ttf"))
		text1.size = 70
		text1.x, text1.y = _W * 0.235 , _H * 0.75
		text1:setFillColor( CC("000000") )
		text1.align = "center"

		local text2 = display.newText("나가기", 0, 0, native.newFont("정9체.ttf"))
		text2.size = 70
		text2.x, text2.y = _W * 0.785, _H * 0.75
		text2:setFillColor( CC("000000") )
		text2.align = "center"
	end

	timer.performWithDelay( 150, makeButton, 1 )

end

--start()
inGame()	
--gameOver()	-- careful removeSelf