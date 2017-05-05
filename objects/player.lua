Player = Object:extends{
	objectType = "game_player",
	reactsToCollision = true,
	spriteIndex = 119,
	solidGroup = {"game_wall", "game_npc"},
	size = {w=16,h=16}
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
end

function Player:update(objectManager_)
	Player.super.update(self, objectManager_)
	self.spriteIndex = 119
end

function Player:keyPress(key_)
	Player.super.keyPress(self, key_)

	if key_ == "w" then
		self:addVelocity(0,-1)
	elseif key_ == "s" then
		self:addVelocity(0,1)
	elseif key_ == "a" then
		self:addVelocity(-1,0)
	elseif key_ == "d" then
		self:addVelocity(1,0)
	end
end

function Player:onCollision(other_)
	Player.super.onCollision(self, other_)

end

function Player:checkMouseInput(x_, y_, button_, map_, camera_)
	if button_ == 1 then

		--generate the screen-relative position of the player
		local centerX = (self.position.x - camera_.position.x + (map_.tileSize/2)) * Graphics.drawScale
		local centerY = (self.position.y - camera_.position.y + (map_.tileSize/2)) * Graphics.drawScale

		--check which triangle the mouse is in...
		if GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = Graphics.windowWidth, y = 0}, {x = centerX, y = centerY}) then
			--self:move("up", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("down", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("left", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("right", map_)
		end
	end
end

function Player:kill()
	--game restarts
end

function Player:draw(spriteManager_, camera_)
	Player.super.draw(self, spriteManager_, camera_)
end
