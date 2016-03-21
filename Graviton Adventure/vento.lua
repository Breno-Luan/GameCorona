local function vento()	
	
	local group = display.newGroup()
	
	local options = { width=80, height=300, numFrames=6, sheetContentWidth=480, sheetContentHeight=300 }
	local ventSheet = graphics.newImageSheet( "vento.png", options )
	local seqs = { { name="main1", start=1, count=6, time=200 },
					{ name="main2", frames={4,5,6,1,2,3}, time=160 } }
					
	local vento = display.newSprite( ventSheet, seqs )
	--physics.addBody(vent1, "kinematic", { isSensor=true, filter=passaroColisao } )
	vento.isVent = true
	--vent.x = 200
	--vent.y = 300
	vento.id = 4

	vento:setSequence("main2")
	vento:play()
	
	group:insert( vento, true )
	vento.dispGroup = group
	
	return {group=group}
end
return vento