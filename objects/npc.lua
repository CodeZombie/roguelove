NPC = Actor:extends{
	dead = false,
	objectType = "game_npc",
	solidGroup = {"game_wall", "game_player", "game_npc"},
	reactsToCollision = true
}

function NPC:__init(x,y)
	NPC.super.__init(self, x,y)
end

function NPC:update(objectManager_)
	NPC.super.update(self, objectManager_)

 --[[
	if love.math.random() >= 0.99 then
		rn = math.floor(love.math.random(0,2)) -1
		self.xVel = rn
		rn = math.floor(love.math.random(0,2)) -1
		self.yVel = rn
	end
	self:addVelocity((self.xVel), (self.yVel))--]]
end

function NPC:kill()
	self.dead = true
	--drop loot, or something
end

function NPC:draw(camera_)
	NPC.super.draw(self, camera_)
end
