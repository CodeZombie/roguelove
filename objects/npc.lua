NPC = Object:extends{
	dead = false,
	subtype = "game_npc",
	reactsToCollision = true,
	spriteIndex = 110
}
function NPC:__init(x,y)
	NPC.super.__init(self, x,y)
end

function NPC:update(objectManager_)
	NPC.super.update(self, objectManager_)
end


function NPC:kill()
	self.dead = true
	--drop loot, or something
end

function NPC:draw(spriteManager_, camera_)
	NPC.super.draw(self, spriteManager_, camera_)
end
