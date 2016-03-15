NPC = Being:extends{
	dead = false,
	objectType = "npc"
}
function NPC:__init(x,y)
	NPC.super.__init(self, x,y)
	
	self:setSymbol(110)
end

function NPC:update()
	NPC.super.update(self)
end

function NPC:startTurn()
	NPC.super.startTurn(self)
	
	local rand = love.math.random()
	
	if rand < .25 then
		self:move("up")
	elseif rand < .5 then
		self:move("down")
	elseif rand < .75 then
		self:move("left")
	elseif rand < 1 then
		self:move("right")
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