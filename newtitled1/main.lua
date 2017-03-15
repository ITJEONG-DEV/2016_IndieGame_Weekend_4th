-->local list

-->Global Local
local _W = display.contentWidth
local _H = display.contentHeight
local physics = require "physics"
local widget = require "widget"
local json = require "json"

-->Theme Local

-->Stage Local

-->Ingame Local
local blockData = {}

-->Auido Asset list
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

-->Convert Color
local function CC (hex)
	local r = tonumber( hex:sub(1, 2), 16 ) / 255
	local g = tonumber( hex:sub(3, 4), 16 ) / 255
	local b = tonumber( hex:sub(5, 6), 16 ) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7, 8), 16 ) / 255 end
	return r,g,b,a
end


-->Alert Message
local function alertMessage(text)
	local rect = display.newRect( _W * 0.5, _H * 0.45, _W * 0.8, _H * 0.1 )
	rect:setFillColor( CC("252525") )
	rect.alpha = 0

	local texts = display.newText( text, _W * 0.5, _H * 0.45, native.newFont("정9체.ttf") )
	texts.size = 35
	texts.align = "center"
	texts:setFillColor( CC("999999") )
	texts.alpha = 0

	transition.to( rect, { alpha = 1.0, time = 350 } )
	transition.to( texts, { alpha = 1.0, time = 350 } )
	transition.to( rect, { alpha = 0.0, time = 500, delay = 1000 } )
	transition.to( texts, { alpha = 0.0, time = 500, delay = 1000 } )

end


-->File I/O
local theme
local stage
local savePoint
local runingTime

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


--> Json I/O
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

--> Map Data I/O
local loadMap = function( fileName )
	local path = "C:/Users/derba/Desktop/IGWE/newtitled1/" .. fileName
--	local path = system.pathForFile( fileName, system.DocumentsDirectory )
	local file, errorString = io.open( path, "r")

	local num

	if not file then
		alertMessage("File error : " .. errorString )
--		print("File error : " .. errorString )
	else
		for i = 1, 9, 1 do
			for j = 1, 20, 1 do
				num = file:read( "*n")
				print(20*(i-1)+j .. " : " .. num)
                                                
				if num == 0 then
				elseif num == 1 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_01.png")
				elseif num == 2 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_02.png")
				elseif num == 3 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_03.png")
				elseif num == 4 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_04.png")
				elseif num == 5 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_05.png")
				elseif num == 6 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_06.png")
				elseif num == 7 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_07.png")
				elseif num == 8 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_08.png")
				elseif num == 9 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_09.png")
				elseif num == 10 then
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_10.png")
				elseif num == 11 then 
					blockData[20*(i-1) + j] = display.newImage("/resource/block/block_11.png")
				end
				blockData.x, blockData.y = 32 + 64*(j-1), 32 + 64*(i-1)	
			end
		end

	end
end

loadMap("map01.txt")