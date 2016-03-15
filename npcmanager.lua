NPCManager = class{
	NPCs = {},
	finishedTurn = false,
	maxNPCs = 24
}

function NPCManager:__init()
	self.NPCs = {}
	self.finishedTurn = false
	
	for n = 1, self.maxNPCs do
		table.insert(self.NPCs, NPC:new(16,16))
		self.NPCs[n]:setSpriteIndex(math.ceil(love.math.random()*128))
		self.NPCs[n]:setObjectType("NPC")
	end
end

function NPCManager:update()

	local finishedAnimating = true
	
	for n=1, NPCManager.maxNPCs do
		self.NPCs[n]:update()
		if self.NPCs[n].finishedTurn ~= true then
			finishedAnimating = false
		end
	end
	
	if finishedAnimating then
		self.finishedTurn = true
	end
	
end

function NPCManager:startTurn(map_)
	for n=1, self.maxNPCs do
		self.NPCs[n]:startTurn(map_)
	end
	self.finishedTurn = false
end

function NPCManager:draw(spriteManager_, camera_)
	for n=1, self.maxNPCs do
		self.NPCs[n]:draw(spriteManager_, camera_)
	end
end