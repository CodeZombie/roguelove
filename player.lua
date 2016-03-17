Player = Being:extends{
	objectType = "player",
	spriteIndex = 119
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
end

function Player:update()
	Player.super.update(self)
	
end

function Player:checkInput(key, map_)
	if key == "w" then
		self:move("up", map_)
	elseif key == "s" then
		self:move("down", map_)
	elseif key == "a" then
		self:move("left", map_)
	elseif key == "d" then
		self:move("right", map_)
	end
end

function Player:checkMouseInput(x_, y_, button_, map_, camera_)
	if button_ == 1 then
		
		--generate the screen-relative position of the player
		local centerX = (self.position.x - camera_.position.x + (map_.tileSize/2)) * Graphics.drawScale
		local centerY = (self.position.y - camera_.position.y + (map_.tileSize/2)) * Graphics.drawScale

		--check which triangle the mouse is in...
		if GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = Graphics.windowWidth, y = 0}, {x = centerX, y = centerY}) then
			self:move("up", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("down", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("left", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:move("right", map_)
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

function Player:onMoved()
	Player.super.onMoved(self)
end
	
	
function Player:move(direction_, map_)
	Player.super.move(self, direction_, map_)
	
end
	
function Player:draw(spriteManager_, camera_)
	Player.super.draw(self, spriteManager_, camera_)
	
end