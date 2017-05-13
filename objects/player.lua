Player = Object:extends{
	objectType = "game_player",
	reactsToCollision = true,
	solidGroup = {"game_wall", "game_npc"},
	size = {w=16,h=16},
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setAnimationSequence("idle")
end

function Player:keyPress(key_)
	Player.super.keyPress(self, key_)

	if key_ == "w" then
		self:setDirection(Game.direction.up)
		self:addVelocity(1)
	elseif key_ == "s" then
		self:setDirection(Game.direction.down)
		self:addVelocity(1)
	elseif key_ == "a" then
		self:setDirection(Game.direction.left)
		self:addVelocity(1)
	elseif key_ == "d" then
		self:setDirection(Game.direction.right)
		self:addVelocity(1)
	end

	if key_ == "r" then
		self:setAnimationSequence("dance")
	end
end

function Player:onClick(x_, y_, button_, map_, camera_)
	if button_ == 1 then

		--generate the screen-relative position of the player
		local centerX = (self.position.x - camera_.position.x + (self.size.w/2)) * Graphics.drawScale
		local centerY = (self.position.y - camera_.position.y + (self.size.h/2)) * Graphics.drawScale

		--check which triangle the mouse is in...
		if GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = Graphics.windowWidth, y = 0}, {x = centerX, y = centerY}) then
			self:setDirection(Game.direction.up)
			self:addVelocity(1)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:setDirection(Game.direction.down)
			self:addVelocity(1)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:setDirection(Game.direction.left)
			self:addVelocity(1)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			self:setDirection(Game.direction.right)
			self:addVelocity(1)
		end
	end
end

function Player:kill()
	--game restarts
end

function Player:draw(camera_)
	Player.super.draw(self, camera_)
end
