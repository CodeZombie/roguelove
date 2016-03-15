NPCManager = {
	NPCs = {},
	finishedTurn = false,
	maxNPCs = 256
}

function NPCManager.populate()
	for n = 1, NPCManager.maxNPCs do
		table.insert(NPCManager.NPCs, NPC:new(16,16))
		NPCManager.NPCs[n].symbol = math.ceil(love.math.random()*128)
	end
end

function NPCManager.update()
	local finishedAnimating = true
	
	for n=1, NPCManager.maxNPCs do
		NPCManager.NPCs[n]:update()
		if NPCManager.NPCs[n].finishedTurn ~= true then
			finishedAnimating = false
		end
	end
	
	if finishedAnimating then
		NPCManager.finishedTurn = true
	end
	
end

function NPCManager.startTurn()
	for n=1, NPCManager.maxNPCs do
		NPCManager.NPCs[n]:startTurn()
	end
	NPCManager.finishedTurn = false
end

function NPCManager.draw()
	for n=1, NPCManager.maxNPCs do
		NPCManager.NPCs[n]:draw()
	end
end