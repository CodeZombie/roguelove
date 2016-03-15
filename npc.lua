NPC = Being:extends{
	dead = false,
	objectType = "npc",
	spriteIndex = 110
}
function NPC:__init(x,y)
	NPC.super.__init(self, x,y)
end

function NPC:update()
	NPC.super.update(self)
end

function NPC:startTurn(map_)
	NPC.super.startTurn(self)
	
	local rand = love.math.random()
	
	if rand < .25 then
		self:move("up", map_)
	elseif rand < .5 then
		self:move("down", map_)
	elseif rand < .75 then
		self:move("left", map_)
	elseif rand < 1 then
		self:move("right", map_)
	else
		self.finishedTurn = true -- we dont want to move :(
	end	
end

function NPC:onMoved()
	NPC.super.onMoved(self)
end

function NPC:onMoveFailed()
	NPC.super.onMoveFailed(self)
	self.finishedTurn = true
end

function NPC:kill()
	self.dead = true
	--drop loot, or something
end

function NPC:draw(spriteManager_, camera_)
	NPC.super.draw(self, spriteManager_, camera_)
end