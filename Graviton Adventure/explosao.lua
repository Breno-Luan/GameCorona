local function explosao(x, y)	
	
	local group = display.newGroup()
	
	local dadosExplosao = {width = 24, height = 23, numFrames= 8 }

	local sheetExplosao = graphics.newImageSheet("explosao.png", dadosExplosao)

	local sequenciaExplosao =
	{
		{name = "explodindo", start = 1, count = 8, time = 1000, loopCount = 1},
	
	}

	local explosao = display.newSprite(sheetExplosao, sequenciaExplosao)
		explosao.x = x
		explosao.y = y
	
	explosao:setSequence("explodindo")
	explosao:play()
	
	group:insert( explosao, true )
	explosao.dispGroup = group
	
	return {group=group}
end
return explosao