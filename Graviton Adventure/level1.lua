-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------


local perspective = require("perspective")
local function forcesByAngle(totalForce, angle) 
local forces = {}
local radians = -math.rad(angle) 
forces.x = math.cos(radians) * totalForce 
forces.y = math.sin(radians) * totalForce 
return forces
end

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()


--local character = require( "character" )
local raposa = require( "raposa" )
local explosao = require( "explosao" )
local vento = require( "vento" )

local painColisao = {categoryBits=1, maskBits=15}
local tetoChaoColisao = {categoryBits=2, maskBits=1}
local passaroColisao = {categoryBits=4, maskBits=1}
local ventoColisao = {categoryBits=8, maskBits=1}

-------Sprite Pain
local dadosPain = {width = 45.25, height = 64, numFrames= 16 }

	local sheetPain = graphics.newImageSheet("pain.png", dadosPain)

	local sequenciaPain =
	{
		{name = "Stop", start = 9, count = 1, time = 1000, loopCount = 1},
		{name = "moveRight", start = 9, count = 4, time = 1000, loopCount = 0},
		{name = "moveUp", start = 5, count = 4, time = 1000, loopCount = 0},
	}
	
local camera --= perspective.createView()

local m = {}


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	

	--camera = perspective.createView()
	-- Character
	pain = display.newSprite(sheetPain, sequenciaPain)
	
	
	physics.addBody(pain, "static", {density=1, friction=1, bounce=.2, filter= painColisao})
	pain.x = 100
	pain.y = 200
	pain.gravidade = 0
	pain.moveSpeed = 0                 -- Current movement speed
	pain.linearDamping = 00             -- Linear damping rate
	pain.linearAcceleration = 1.05     -- Linear acceleration rate
	pain.linearMax = 8                -- Max linear velocity
	
	-----------------	
	
	pain:setSequence("Stop")
	pain:play()
	
	
	camera = perspective.createView()
	
	
	camera:add(pain, 1)
	

	background1 = display.newImage("background.jpg")
	background1.x = 1800
	background1.y = 150
	camera:add(background1, math.random(2, camera:layerCount()))
	
	
------------------
	
	--pain.group:setSequence("Stop")
	--pain.group:play()
	
	--Enemy
	
	raposa = raposa()
	physics.addBody(raposa.group, "static", {density=1, friction=1, bounce=.2, filter=passaroColisao})
	raposa.group.x = 800
	raposa.group.y = 260
	
	vento = vento()
	physics.addBody(vento.group, "kinematic", { isSensor=true, filter=passaroColisao } )
	vento.group.x = 600
	vento.group.y = 300
	
	
	
	-----------
	m.result = "none"
	m.rotate = {}


	m.up = display.newImage("botao.png")
	m.up.rotation = -90
	m.up.x = display.contentWidth - display.screenOriginX - m.up.contentWidth + 80
	m.up.y = display.contentHeight - m.up.contentHeight + 150
	m.up.result = "up"

	m.forward = display.newImage("botao.png")
	m.forward.x = display.contentCenterX
	m.forward.y = display.contentHeight - m.forward.contentHeight + 80
	m.forward.result = "move"
	
	
	
	---
	camera:add(pain, 1)
	camera:add(background1, math.random(2, camera:layerCount()))
	
	-- all display objects must be inserted into group
	--sceneGroup:insert( background1 )
	
	--sceneGroup:insert( pain )
	--scene.view:insert( raposa )
	--scene.view:insert( vento )
	--sceneGroup:insert( pain )
	--sceneGroup:insert( chao )
	--sceneGroup:insert( teto )
	--sceneGroup:insert( m.up )
	--sceneGroup:insert( m.forward )
end

	


function m.touch(event)
	local t = event.target

	if "began" == event.phase then
		display.getCurrentStage():setFocus(t)
		t.isFocus = true
		m.result = t.result

		if t.result == "up" then 
		print("Touch")
			if pain.gravidade == 0 then
				physics.setGravity(0, -6.8)
				pain:applyForce(0, -40, pain.x, pain.y)
				pain.gravidade = 1
				print("Subindo")
				pain:setSequence("moveUp")
				pain.rotation = 180
				pain:play()
				
			else
				physics.setGravity(0, 6.8)
				pain:applyForce(0, 20, pain.x, pain.y)
				print("Descendo")
				pain.gravidade = 0
				pain:setSequence("moveRight")
				pain.rotation = 360
				pain:play()
			end
		elseif t.result == "move" then
			pain:setSequence("moveRight")
			pain:play()
			pain.moveSpeed = 2
		end
	elseif t.isFocus then
		if "moved" == event.phase then
		
		elseif "ended" == event.phase then
			display.getCurrentStage():setFocus(nil)
			t.isFocus = false
			m.result = "none"
			pain:setSequence("Stop")
			pain:play()
		end
	end
end

local function enterFrame(event)
	if m.result == "up" then
		
	elseif m.result == "move" then
		pain.moveSpeed = pain.moveSpeed * pain.linearAcceleration
		pain.moveSpeed = math.min(pain.moveSpeed, pain.linearMax)
		
	elseif m.result == "none" then
		pain.moveSpeed = pain.moveSpeed * pain.linearDamping
	end

	local forces = forcesByAngle(pain.moveSpeed, 360 - pain.rotation)
	pain:translate(forces.x, forces.y)
	
	--pain:rotate(pain.angularVelocity)
end





function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		
		camera.damping = 10 -- A bit more fluid tracking
		camera:setFocus(pain) -- Set the focus to the player
		camera:track() -- Begin auto-tracking
		
		--pain.group.touch = gravidade
		--Runtime:addEventListener("touch", pain.group)
		
		--background1.enterFrame = movimentoParalax
		--Runtime:addEventListener("enterFrame", background1)
	
		--background2.enterFrame = movimentoParalax
		--Runtime:addEventListener("enterFrame", background2)
		
		--raposa.group.enterFrame = movimentoParalax
		--Runtime:addEventListener("enterFrame", raposa.group)
		
		--pain.collision = colisao
		--Runtime:addEventListener("collision", colisao)
		
		--vento.group.enterFrame = movimentoParalax
		--Runtime:addEventListener("enterFrame", vento.group)
		
		
		m.up:addEventListener("touch", m.touch)
		m.forward:addEventListener("touch", m.touch)
		
		
		Runtime:addEventListener("enterFrame", enterFrame)
		
		
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end		
end

function colisao(event)
	print(event.object1.id)
	print(event.object2.id)
	if (event.phase == "began") then
	
		if(event.object2.id == 3) then
			local explosao = explosao(event.object1.x, event.object1.y)
			--explosao.x = event.object1.x
			--explosao.y = event.object1.y
			
			--Runtime:removeEventListener("touch", pain)
			--pain.group.vivo = false
			--event.object1:removeSelf()
			
			--explosao:setSequence("explodindo")
			--explosao:play()
			print("Colidiu 2")
		elseif(event.object2.id == 4) then
				--fisica.setGravity(0, -6.8)
		
		end	
					
	elseif ( event.phase == "ended") then
		if(event.object2.id == 1) then
				--fisica.setGravity(0, -6.8)	
		else
			composer.gotoScene( "gameOver", "fade", 500 )
		end
			
				
		
	end
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil

	print("Saindo")
	Runtime:removeEventListener("enterFrame", background1)
	
	Runtime:removeEventListener("enterFrame", background2)
			
	Runtime:addEventListener("enterFrame", raposa.group)
		
	physics.start()
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene