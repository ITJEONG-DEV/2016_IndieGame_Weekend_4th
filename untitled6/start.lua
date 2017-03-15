local composer = require "composer"

local scene = composer.newScene( )

local _W = display.contentWidth
local _H = display.contentHeight

local onkey
local playBGM = function ( e ) media.playSound("/AudioAssets/GameOpening.mp3", playBGM) end
local text
local transi1
local transi2


function scene:creat( event )
	local sceneGroup = self.view
	--초기화. 기본 UI, 이벤트 리스너 추가

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		--화면에 보여지기 직전
		onKey = function ( )
			media.stopSound( "/AudioAssets/GameOpening.mp3" )
			local currentScene = composer.getSceneName("current")
			composer.removeScene(currentScene)
			composer.gotoScene("stage0", option)
		end
	elseif phase == "did" then
		--타이머, 음악, 애니메이션 재시작
		text = display.newText("Press Any Key", _W*0.5, _H*0.8, native.newFont("정9체.ttf"))
		text.size = 40
		transi1 = function ( )
			transition.to( text, { time = 400, alpha = 0.2, onComplete = transi2 } )
		end
		transi2 = function ( )
			transition.to( text, { time = 400, alpha = 1.0, onComplete = transi1 } )
		end
		transi1()
		media.playSound("/AudioAssets/GameOpening.mp3", playBGM)
		Runtime:addEventListener( "key", onKey )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		--화면에 사라지기 직전
		--타이머, 음악, 애니메이션 일시 정지
		media.stopSound("AudioAssets/GameOpening.mp3", playBGM)
		BG:removeSelf()
	elseif phase == "did" then
		--화면에서 사라짐과 동시에 실행
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	--제거되기 직전에 실행
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene