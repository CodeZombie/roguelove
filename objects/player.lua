Player = Actor:extends{
	objectType = "game_player",
	reactsToCollision = true,
	solidGroup = {"game_wall", "game_npc"},
	collisionbox = {x=3, y=22, w=10, h=10},
	size = {w=16,h=32},
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setSpritesheet("images/tallplayer.png")
	self:setAnimationSequence("idle")
end

function Player:keyPress(key_)
	Player.super.keyPress(self, key_)

	if key_ == "w" then
		if love.keyboard.isDown("d") then
			self:setDirection(Game.direction.upright)
		elseif love.keyboard.isDown("a") then
			self:setDirection(Game.direction.upleft)
		else
			self:setDirection(Game.direction.up)
		end
		self:addVelocity(1)

	elseif key_ == "s" then
		if love.keyboard.isDown("d") then
			self:setDirection(Game.direction.downright)
		elseif love.keyboard.isDown("a") then
			self:setDirection(Game.direction.downleft)
		else
			self:setDirection(Game.direction.down)
		end
		self:addVelocity(1)

	elseif key_ == "a" then
		if love.keyboard.isDown("w") then
			self:setDirection(Game.direction.upleft)
		elseif love.keyboard.isDown("s") then
			self:setDirection(Game.direction.downleft)
		else
			self:setDirection(Game.direction.left)
		end
		self:addVelocity(1)

	elseif key_ == "d" then
		if love.keyboard.isDown("w") then
			self:setDirection(Game.direction.upright)
		elseif love.keyboard.isDown("s") then
			self:setDirection(Game.direction.downright)
		else
			self:setDirection(Game.direction.right)
		end
		self:addVelocity(1)
	end

	if key_ == "r" then
		self:setAnimationSequence("dance")
	end
end

function Player:onClick(x_, y_, button_, map_, camera_)
	if button_ == 1 then

		--generate the screen-relative position of the player
		local centerX = (self.position.x - camera_.position.x + (self.size.w/2)) * camera_.zoomLevel
		local centerY = (self.position.y - camera_.position.y + (self.size.h/2)) * camera_.zoomLevel

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
