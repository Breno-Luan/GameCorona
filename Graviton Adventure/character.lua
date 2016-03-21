local function character()	
	
	local group = display.newGroup()
	
	local dadosPain = {width = 45.25, height = 64, numFrames= 16 }

	local sheetPain = graphics.newImageSheet("pain.png", dadosPain)

	local sequenciaPain =
	{
		{name = "Stop", start = 9, count = 1, time = 1000, loopCount = 1},
		{name = "moveRight", start = 9, count = 4, time = 1000, loopCount = 0},
		{name = "moveUp", start = 5, count = 4, time = 1000, loopCount = 0},
	}


	pain = display.newSprite(sheetPain, sequenciaPain)
	pain.gravid = 0
	pain.id = 2
	pain.vivo = true
	
	pain:setSequence("Stop")
	pain:play()
	
	group:insert( pain, true )
	pain.dispGroup = group
	
	return {group=group}
end
return character