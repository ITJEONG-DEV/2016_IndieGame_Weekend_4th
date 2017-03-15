display.setStatusBar( display.HiddenStatusBar )

local physics, widget, json = require "physics", require "widget", require "json"

local _W, _H = display.contentWidth, display.contentHeight

local CC = function(hex)
	local r = tonumber( hex:sub(1, 2), 16 ) / 255
	local g = tonumber( hex:sub(3, 4), 16 ) / 255
	local b = tonumber( hex:sub(5, 6), 16 ) / 255
	local a = 255 / 255
	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end
	return r,g,b,a
end

local alertMessage = function(text)
	local rect, texts, delete

	delete = function( )
		rect:removeSelf()
		texts:removeSelf()
		delete = nil
	end

	rect = display.newRoundedRect( _W*0.5, _H*0.45, _W*0.8, _H*0.1, 20 )
	rect:setFillColor( CC("555555") )
	rect.alpha = 0

	texts = display.newText( text, _W*0.5, _H*0.45, native.newFont("정9체.ttf"))
	texts.size = 35
	texts.aligh = "center"
	texts:setFillColor( CC("ffffff") )
	texts.alpha = 0

	transition.to( rect, { alpha = 1.0, time = 350 })
	transition.to( texts, { alpha = 1.0, time = 350 })
	transition.to( rect, { alpha = 0.0, time = 500, delay = 1250 } )
	transition.to( texts, { alpha = 0.0, time = 500, delay = 1250, onComplete = delete } )
end

local path
local BGM = function( )
	media.playSound( path, BGM )
end

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
	["runningTime"] = 0
}
local themeName = { "드넓은 초원", "포근한 집", "좋은 노트북" }

local saveData = function( )
	local path = system.pathForFile("Data.txt", system.DocumentsDirectory)
	local encoded = json.encode( myData )
	print( "encoded : " .. encoded )

	local file, errorString = io.open( path, "w" )

	if not file then
		alertMessage("File error : " .. errorString )
	else
		file:write( encoded )

		io.close( file )
		alertMessage("Save data successful.")
	end


	file = nil
end

local loadData = function( )
	local path = system.pathForFile("Data.txt", system.DocumentsDirectory)
	local file, errorString = io.open( path, "r" )

	if not file then
		alertMessage("File error : " .. errorString )
	else
		local decoded, pos, msg = json.docdedFile( path )

		if not decoded then
			print("decode failed at" .. tostring(pos).. " : "..tostring(msg))
		else
			theme = decoded.theme
			stage = decoded.stage
			savePoint = decoded.savePoint
			runningTime = decoded.runningTime

			alertMessage("Load data successful.")
		end

		io.close( file )
	end

	file = nil
end

--theme
local start, selectTheme, selectStage, inStage

start = function( )
	local createUI, newTouch, loadTouch, effection, remove
	local bg, new, load, curser
	local ui = audio.loadSound( "AudioAssets/effect_ui.wav" )


	createUI = function( )
		bg = display.newImage( "image/title/bg.png" )
		bg.anchorX, bg.anchorY = 0, 0

		new = display.newImage( "image/title/new.png", _W*0.1, _H*0.8 )
		new.anchorX, new.anchorY = 0, 0

		load = display.newImage( "image/title/load.png", _W*0.1, _H*0.89 )
		load.anchorX, load.anchorY = 0, 0

		curser = display.newImage( "image/title/curser.png" )
		curser.anchorX, curser.anchorY = 0, 0
		curser.alpha = 0

		load:addEventListener( "touch", loadTouch )
		new:addEventListener( "touch", newTouch )
	end

	newTouch = function( )
		system.vibrate( )
		curser.x, curser.y = _W * 0.07, _H * 0.795
		curser.alpha = 1
		new:removeEventListener( "touch", newTouch )
		load:removeEventListener( "touch", loadTouch )
		audio.play(ui)
		saveData()
		load.alpha = 0
		effection( new )
	end

	loadTouch = function( )
		system.vibrate( )
		curser.x, curser.y = _W * 0.07, _H * 0.885
		curser.alpha = 1
		new:removeEventListener( "touch", newTouch )
		load:removeEventListener( "touch", loadTouch )
		audio.play(ui)
		loadData()
		new.alpha = 0
		effection( load )
	end

	effection = function( obj )
		local hi
		hi = function( )
			if obj.alpha == 0 then
				obj.alpha = 1
				curser.alpha = 1
			else
				obj.alpha = 0
				curser.alpha = 0
			end
		end

		timer.performWithDelay( 300, hi, 4 )
		transition.to( bg, { alpha = 1, time = 450, delay = 1201, onComplete = remove })
	end

	remove = function( )
		bg:removeSelf()
		new:removeSelf()
		load:removeSelf()
		curser:removeSelf()
		newTouch = nil
		loadTouch = nil
		effection = nil
		ui = nil
		remove = nil

		selectTheme()
	end

	media.stopSound()
	path = "AudioAssets/GameOpening.mp3"
	BGM( )

	createUI()
end

selectTheme = function( )
	local createUI, themeTouch
	local bg, floor
	local ui = audio.loadSound( "AudioAssets/effect_ui.wav" )
	local themeButton, themeText = { }, { }

	createUI = function( )
		bg = display.newImage( "image/stage/chapter.png" )
		bg.anchorX, bg.anchorY = 0, 0
		bg:setFillColor( CC("E3F6FF") )

		floor = display.newImage( "image/stage/floor.png", 0, _H )
		floor.anchorX, floor.anchorY = 0, floor.contentHeight

		for i = 1, 3, 1 do
			if myData.theme > i then
				themeButton[i] = display.newImage( "image/stage/clear.png" )
			elseif myData.theme == i then
				themeButton[i] = display.newImage( "image/stage/unlock.png" )
			else
				themeButton[i] = display.newImage( "image/stage/locked.png" )
			end
			themeButton[i].x, themeButton[i].y = _W*0.175 + 410*(i-1), _H*0.3875
			themeButton[i].name = i
			themeButton[i]:addEventListener( "touch", themeTouch )


			themeText[i] = display.newText( themeName[i], 0, 0, native.newFont( "정9체.ttf" ) )
			themeText[i].size = 60
			themeText[i].x, themeText[i].y = themeButton[i].x, themeButton[i].y + themeButton[i].contentHeight * 1.3
			themeText[i]:setFillColor( CC( "000000" ) )
		end
	end 

	themeTouch = function( e )
		local n = e.target.name

		if myData.theme >= n then
			selectData.theme = n
			audio.play(ui)

			bg:removeSelf()
			floor:removeSelf()
			for i = 1, 3, 1 do
				themeButton[i]:removeSelf()
				themeButton[i]:removeEventListener( "touch", themeTouch )
				themeText[i]:removeSelf()
				themeButton[i] = nil
				themeText[i] = nil
			end

			bg = nil
			floor = nil
			ui = nil
			createUI = nil
			n = nil
			themeButton = nil
			themeText = nil

			themeTouch = nil

			selectStage( )
		else
			alertMessage( "아직 열리지 않은 테마입니다." )
		end
	end

	createUI()
end

selectStage = function( )
	local createUI, stageTouch
	local bg, floor, themeShow, themeShowText
	local ui = audio.loadSound( "AudioAssets/effect_ui.wav" )
	local stageButton, stageText = { }, { }

	createUI = function( )
		bg = display.newImage( "image/stage/chapter.png" )
		bg.anchorX, bg.anchorY = 0, 0

		floor = display.newImage( "image/stage/floor.png", 0, _H )
		floor.anchorX, floor.anchorY = 0, floor.contentHeight

		themeShow = display.newImage( "image/stage/titleBar.png" )
		themeShow.anchorX, themeShow.anchorY = 0, 0

		themeShowText = display.newText( themeName[selectData.theme], _W*0.0875, _H*0.05, native.newFont( "정9체.ttf") )
		themeShowText.aligh = "left"

		for i = 1, 2, 1 do
			for j = 1, 3, 1 do
				if ( ( myData.theme > selectData.theme ) or ( myData.theme == selectData.theme ) and ( myData.stage > 3*(i-1) + j ) ) then
					stageButton[10*i+j] = display.newImage( "image/stage/clear.png", _W*0.25 + 250*(j-1), _H*0.2 + 275*(i-1) )
				elseif ( myData.theme == selectData.theme ) and ( myData.stage == 3*(i-1) + j ) then
					stageButton[10*i+j] = display.newImage( "image/stage/unlock.png", _W*0.25 + 250*(j-1), _H*0.2 + 275*(i-1) )
				else
					stageButton[10*i+j] = display.newImage( "image/stage/locked.png", _W*0.25 + 250*(j-1), _H*0.2 + 275*(i-1) )
				end
				stageButton[10*i+j].anchorX, stageButton[10*i+j].anchorY = 0, 0
				stageButton[10*i+j].name = (i-1)+j
				stageButton[10*i+j]:addEventListener( "tap", stageTouch )

				stageText[10*i+j] = display.newText( selectData.theme .. "-" .. 3*(i-1)+j, 0, 0, native.newFont( "정9체.ttf" ) )
				stageText[10*i+j].size = 60
				stageText[10*i+j].x, stageText[10*i+j].y = stageButton[10*i+j].x + stageButton[10*i+j].contentWidth * 0.5, stageButton[10*i+j].y + stageButton[10*i+j].contentHeight * 1.3
				stageText[10*i+j]:setFillColor( CC("000000") )
			end
		end
	end

	stageTouch = function( e )
		local n = e.target.name

		if ( myData.theme > selectData.theme ) or ( myData.theme == selectData.stage ) then
			audio.play( ui )
			selectData.stage = n

			bg:removeSelf()
			floor:removeSelf()
			themeShow:removeSelf()
			themeShowText:removeSelf()

			for i = 1, 2, 1 do
				for j = 1, 3, 1 do
					stageButton[10*i+j]:removeSelf()
					stageButton[10*i+j]:removeEventListener( "tap", stageTouch )
					stageText[10*i+j]:removeSelf()
					stageButton[10*i+j] = nil
					stageText[10*i+j] = nil
				end
			end 

			bg = nil
			floor = nil
			themeShow = nil
			themeShowText = nil
			ui = nil
			n = nil
			stageButton = nil
			stageText = nil
			createUI = nil

			stageTouch = nil

			inStage()	
		end
	end

	createUI()
end

inStage = function( )
	local createUI, UIset, characterSet, effectSet, buttonSet
	local onButton, gameOver
	local bg, floor
	local timerUI, timerUI2, timerText, rebootUI
	local charData, charSet, charSheet, char, charPhysics
	local effectData, effectSet, effectSheet
	local attackButton, jumpButton, upButton, downButton, leftButton

	UIset = function( )
		--UI set
		timerUI = display.newImage( "image/UI/time.png", _W*0.351, _H*0.052 )
		timerUI2 = display.newImage( "image/UI/timeGuage.png", _W*0.379, _H*0.028 )
		timerText = display.newText( "99:99", _W*0.438, _H*0.085, native.newFont("정9체.ttf") )
		timerText.size = 55
		rebootUI = display.newImage( "image/UI/quest.png", _W*0.634, _H*0.051 )
	end

	characterSet = function( )
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
	end

	effectSet = function( )
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
	end

	buttonSet = function( )
		--button set
		attackButton = display.newImage("image/UI/hammerb.png", _W*0.921, _H*0.864 )
		attackButton.name = "attack"
		attackButton:addEventListener( "touch", onButton )

		jumpButton = display.newImage("image/UI/jumpb.png", _W*0.8, _H*0.907)
		jumpButton.name = "jump"	
		jumpButton:addEventListener( "touch", onButton )

		upButton = widget.newButton({
			left = _W * 0.1,
			top = _H * 0.7,
			defaultFile = "image/UI/upIdle.png",
			overFile = "image/UI/upPush.png",
			onEvent = onButton
		})
		upButton.name = "up"

		
		downButton = widget.newButton({
			left = _W * 0.1,
			top = _H * 0.8,
			defaultFile = "image/UI/downIdle.png",
			overFile = "image/UI/downPush.png",
			onEvent = onButton
		})
		downButton.name = "down"

		leftButton = widget.newButton({
			left = _W * 0.064,
			top = _H * 0.766,
			defaultFile = "image/UI/leftIdle.png",
			overFile = "image/UI/leftPush.png",
			onEvent = onButton
			})
		leftButton.name = "left"

		rightButton = widget.newButton({
			left = _W * 0.12,
			top = _H * 0.766,
			defaultFile = "image/UI/rightIdle.png",
			overFile = "image/UI/rightPush.png",
			onEvent = onButton
		})
		rightButton.name = "right"
	end

	createUI = function( )
		bg = display.newImage( "image/UI/bg.png" )
		bg.anchorX, bg.anchorY = 0, 0

		floor = display.newImage( "image/stage/floor.png" )
		floor.anchorX, floor.anchorY = 0, 0
		floor.y = _H - floor.contentHeight

		UIset()
		characterSet()
		effectSet()
		buttonSet()

		char = display.newSprite( charSheet, charSet )
		char.name = "char"
		char.x, char.y = _W/2, floor.y - floor.contentHeight/2
		char:play()

		--text set
		life = 3
		life_t = display.newText(life, _W*0.1, _H * 0.08, native.newFont( "정9체.ttf" ))
		life_t.size = 50
	end

	onButton = function( e )
		bn = e.target.name
		if e.phase == "began" then
			if bn == "attack" then
				char:setSequence(bn)
				char:play()
			elseif bn == "jump" then
				char:setSequence(bn)
				char:play()
			elseif bn == "up" then
			elseif bn == "down" then
			elseif bn == "left" then
				char:setSequence( "walkL" )
				if char.xScale == 1 then char:scale(-1,1) end
				char:play()
			elseif bn == "right" then
				char:setSequence( "walkR" )
				if char.xScale == -1 then char:scale(-1,1) end
				char:play()
			end
		elseif e.phase == "ended" then
			if bn == "up" then
			elseif bn == "down" then
			elseif bn == "left" then
				char:setSequence( "normal" )
				char:play()
			elseif bn == "right" then
				char:setSequence( "normal" )
				char:play()
			end
		end
	end

	gameOver = function( )
		local deleteStage, createUI2, createButton
		local bg1, bgPop
		local replayB, exitB, t1, t2

		deleteStage = function( )
			attackButton:removeEventListener( "touch", onButton )
			jumpButton:removeEventListener( "touch", onButton )
			upButton:removeEventListener( "touch", onButton )
			downButton:removeEventListener( "touch", onButton )
			leftButton:removeEventListener( "touch", onButton )
			rightButton:removeEventListener( "touch", onButton )

			bg:removeSelf()
			floor:removeSelf()
			timerUI:removeSelf()
			timerUI2:removeSelf()
			timerText:removeSelf()
			rebootUI:removeSelf()
			char:removeSelf()
			life_t:removeSelf()
			attackButton:removeSelf()
			jumpButton:removeSelf()
			upButton:removeSelf()
			downButton:removeSelf()
			leftButton:removeSelf()
			rightButton:removeSelf()

			bg = nil
			floor = nil
			UIset = nil
			characterSet = nil
			effectSet = nil
			buttonSet = nil
			timerUI = nil
			timerUI2 = nil
			timerText = nil
			rebootUI = nil
			char = nil
			charData = nil
			charSet = nil
			charSheet = nil
			life = nil
			life_t = nil
			effectData = nil
			effectSet = nil
			effectSheet = nil
			attackButton = nil
			jumpButton = nil
			upButton = nil
			downButton = nil
			leftButton = nil
			rightButton = nil

			deleteStage = nil
		end

		createButton = function( )
			replayB = widget.newButton({
			left = _W * 0.1,
			top = _H * 0.7,
			defaultFile = "image/UI/ntnIdle.png",

			overFile = "image/UI/ntnPush.png",
			onEvent = replay
			})

			exitB = widget.newButton({
				left = _W * 0.65,
				top = _H * 0.7,
				defaultFile = "image/UI/ntnIdle.png",
				overFile = "image/UI/ntnPush.png",
				onEvent = exit
			})

			t1 = display.newText( "다시하기", _W*0.235, _H*0.8, native.newFont( "정9체.ttf" ) )
			t1:setFillColor( CC("000000") )
			t1.align = "center"
			t1.size = 60

			t2 = display.newText( "나가기", _W*0.785, _H*0.8, native.newFont( "정9체.ttf" ) )
			t2:setFillColor( CC("000000") )
			t2.align = "center"
			t2.size = 60
		end

		createUI2 = function( )
			bg1 = display.newRect( 0, 0, _W, _H )
			bg1.anchorX, bg1.anchorY = 0, 0

			bgPop = display.newImage( "image/UI/gameOver.png", _W*0.5, _H*0.3 )

			timer.performWithDelay( 500, createButton, 1 )
		end

		--physics.stop()

		deleteStage()
		deleteStage = nil

		media.stopSound( )
		media.playSound( "AudioAssets/effect_playerDie.wav", 1 )
		media.playSound( "AudioAssets/effect_gameOver.wav", 1 )

		createUI2()

	end

	media.stopSound( )
	path = "AudioAssets/GameBGM2.mp3"
	BGM()

	createUI()
	gameOver()
end

--call here
start()
--inStage()