Player = Being:extends{

}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setSymbol(5) --119
end

function Player:update()
	Player.super.update(self)
	
end

function Player:checkInput(key)
	--if self.finishedTurn == false then
		if key == "w" then
			self:move("up")
		elseif key == "s" then
			self:move("down")
		elseif key == "a" then
			self:move("left")
		elseif key == "d" then
			self:move("right")
		end
	--end
end

function Player:checkMouseInput(x_, y_, button_)
	if button_ == 1 then
		--check which triangle the mouse is in...
		local centerX = (player.position.x - Camera.position.x + (Map.tileSize/2)) * Graphics.drawScale
		local centerY = (player.position.y - Camera.position.y + (Map.tileSize/2)) * Graphics.drawScale
		if GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = Graphics.windowWidth, y = 0}, {x = centerX, y = centerY}) then
			self:move("up")
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("down")
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("left")
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("right")
		end 
		
	end
end

function Player:kill()
	--game restarts
end

function Player:startTurn()
	Player.super.startTurn(self)
end

function Player:onMoveFailed()
	Player.super.onMoveFailed(self)
	self.moves = self.moves - 1
end
	