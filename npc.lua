NPC = Being:extends{
	dead = false
}
function NPC:__init(x,y)
	NPC.super.__init(self, x,y)
	
	self:setSymbol(56)
end

function NPC:update()

	NPC.super.update(self)
	
end

function NPC:kill()
	self.dead = true
	
	--drop loot, or something
end