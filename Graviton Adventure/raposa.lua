local function raposa()	
	
	local group = display.newGroup()
	
	local dadosRaposa = {width = 153, height = 139, numFrames= 28 }

	local sheetRaposa = graphics.newImageSheet("raposa.png", dadosRaposa)

	local sequenciaRaposa =
	{
		{name = "moveLeft", start = 1, count = 28, time = 1000, loopCount = 0},
	
	}

	local raposa = display.newSprite(sheetRaposa, sequenciaRaposa)
	raposa.id = 3
	
	raposa:setSequence("moveLeft")
	raposa:play()
	
	group:insert( raposa, true )
	raposa.dispGroup = group
	
	return {group=group}
end
return raposa