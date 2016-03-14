Player = Being:extends{

}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setSymbol(57)
end

function Player:update()

	Player.super.update(self)
end

function Player:checkInput(key)
	if key == "up" then
		self:move("up")
	elseif key == "down" then
		self:move("down")
	elseif key == "left" then
		self:move("left")
	elseif key == "right" then
		self:move("right")
	end
end

function Player:kill()
	--game restarts
end