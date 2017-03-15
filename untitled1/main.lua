display.setStatusBar( display.HiddenStatusBar )
_statusBarHeight = 0
math.randomseed(os.time())
_W = display.contentWidth
_H = display.contentHeight
_aW = display.actualContentWidth
_aH = display.actualContentHeight
_isSimulator = system.getInfo("environment") == "simulator"
_scaleFactor = 0.5
_setScaleFactor = function ( obj, ratio )
	ratio = ratio or __scaleFactor
	obj.width, obj.heigt = math.round(obj.width * ratio), math.round( obj.height * ratio )
end
local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16) / 255
	local g = tonumber( hex:sub(3,4), 16) / 255
	local b = tonumber( hex:sub(5,6), 16) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7,8), 16) / 255 end
	return r,g,b,a
end

local physics = require "physics"
physics.setDrawMode( "hybrid" )

--function list
local start
local timeAttack

--local list
local time

--start function
start = function ( e )
	time = display.newText("Hi",0,0)
	time.x = _W * 0.80
	time.y = _H * 0.10
	Runtime:addEventListener( "enterFrame", timeAttack )
end

timeAttack = function ( e )
	time.text = "running time : " .. e.time/1000
end

local function on_SystemEvent(e)
	local _type = e.type
	if _type == "applicationStart" then -- 앱이 시작될 때
		
		local isResized = false -- 리사이즈 함수 실행 여부
		
		local function onResized(e1)
			Runtime:removeEventListener("resize", onResized)
			isResized = true

			---여기서부터 함수 시작!!
			start()
		end
		
		--======== 안드로이드 풀 스크린 적용(수정 불필요) Begin ========--
		if system.getInfo("environment") == "simulator" or string.lower(system.getInfo("platformName")) ~= "android" or isAndroidFullScreen == false then
			onResized(nil)
		else -- 안드로이드이면서 풀 스크린 모드일 경우
			Runtime:addEventListener("resize", onResized)
			native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
			
			-- 소프트키 바가 없는 경우
			local function on_Timer(e2)
				if not isResized then onResized(nil) end
			end
			timer.performWithDelay(200, on_Timer, 1)
		end
		--======== 안드로이드 풀 스크린 적용(수정 불필요) End ========--
		
	elseif _type == "applicationExit" then -- 앱이 완전히 종료될 때
	elseif _type == "applicationSuspend" then -- 전화를 받거나 홈 버튼 등을 눌러서 앱을 빠져나갈 때
	elseif _type == "applicationResume" then -- Suspend 후 다시 돌아왔을 때
		if system.getInfo("environment") == "simulator" or string.lower(system.getInfo("platformName")) ~= "android" or isAndroidFullScreen == false then
		else -- 안드로이드이면서 풀 스크린 모드일 경우
			native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
		end
	end
end
Runtime:addEventListener("system", on_SystemEvent)

--print(display.contentWidth)
--print(display.contentHeight)
--print(display.actualContentWidth)
--print(display.actualContentHeight)