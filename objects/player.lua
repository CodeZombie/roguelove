Player = Actor:extends{
	objectType = "game_player",
	reactsToCollision = true,
	solidGroup = {"game_wall", "game_npc"},
	collisionbox = {x=3, y=22, w=10, h=10},
	size = {w=16,h=32},
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setSpritesheet("images/femwarrior.png")
	self:setAnimationSequence("idle")
end

function Player:keyPress(key_)
	Player.super.keyPress(self, key_)

	if key_ == "w" then
		self:addVelocity(nil, -self.acceleration.y)
	elseif key_ == "s" then
		self:addVelocity(nil, self.acceleration.y)
	elseif key_ == "a" then
		self:addVelocity(-self.acceleration.x, nil)
	elseif key_ == "d" then
		self:addVelocity(self.acceleration.x, nil)
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
			--up
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--down
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--left
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--right
		end
	end
end

function Player:kill()
	--game restarts
end

function Player:draw(camera_)
	Player.super.draw(self, camera_)
	love.graphics.print("vel.x: " .. tostring(self.velocity.x), 16, 16)
	love.graphics.print("vel.y: " .. tostring(self.velocity.y), 16, 32)
	love.graphics.print("pos.x: " .. tostring(self.position.x), 16, 48)
	love.graphics.print("pos.y: " .. tostring(self.position.y), 16, 64)
end
