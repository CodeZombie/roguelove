Object = class{
	id = 0,
	position = {x=0, y=0},
	size = {w=16, h=16},
	--visible position/size
	--collisionbox position.size
	collisionbox = {x = 0, y = 0, w = 16, h = 16},
	solidGroup = {}, --the group of things to collide with
	friction = .5,
	objectType = "gameobject",
	spritesheet = nil, --ID'd by filename
	animationSequence = nil, --formerly AnimationState --string representing the spritesheet's animation states. If nil, we do not animate, and spriteIndex remains static
	animationFrame = 1, --keeps track of which frame we're on inside the animation
	direction = Game.direction.up,
	velocity = 0,
	maxVelocity = 3
}

function Object:__init(x_, y_)
	self.position.x, self.position.y = x_, y_
end

function Object:setObjectType(t_)
	self.objectType = t_
end

function Object:setSpritesheet(ss_)
	self.spritesheet = ss_
end

function Object:setAnimationSequence(sequence_)
	if sequence_ == nil then
		--print("Error: Attempting to set animation sequence of NIL")
		return
	end

	if self.spritesheet == nil then
		--print("Error: Attempting to apply animation sequence to object that has no spritesheet")
		return
	end

	if SpritesheetManager.spritesheets[self.spritesheet] == nil then
		return
	end

	if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[sequence_] == nil then
			--print("Error: Attempting to use animation sequence '" .. sequence_ .. "' from spritesheet that contains no such animation sequence")
			return
	end

	if self.animationSequence ~= sequence_ then
		self.animationSequence = sequence_
		self.animationFrame = 1
	end
end

function Object:setSpriteIndex(s_)
	self.spriteIndex = s_
end

function Object:keyPress(key_)
end

function Object:keyReleased(key_)
end

function Object:onClick(x_, y_, button_, isTouch_, camera_)
end

function Object:onCollision(other_)
end

function Object:checkCollision(other_)
	if (self.position.x + self.collisionbox.x) < (other_.position.x + other_.collisionbox.x) + other_.collisionbox.w and
		 (self.position.x + self.collisionbox.x) + self.collisionbox.w > (other_.position.x + other_.collisionbox.x) and
		 (self.position.y + self.collisionbox.y) < (other_.position.y + other_.collisionbox.y) + other_.collisionbox.h and
		 (self.position.y + self.collisionbox.y) + self.collisionbox.h > (other_.position.y + other_.collisionbox.y) then
			self:onCollision(other_)
			return true
		end
return false
end

function Object:setDirection(direction_)
	self.direction = direction_
end

function Object:addVelocity(speed_)
	self.velocity = self.velocity + speed_

	if self.velocity > self.maxVelocity then
		self.velocity = self.maxVelocity
	end
end

function Object:draw(camera_)
	if 	self.spritesheet == nil then
		return
	end
	if 	SpritesheetManager.spritesheets[self.spritesheet] == nil or
			self.animationSequence == nil or
			SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence] == nil or
			SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].frames[self.animationFrame] == nil then
				--print("bogus")
		return
	end
	if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].frames[self.animationFrame] == nil then

		return
	end
	SpritesheetManager.draw(self.spritesheet, SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].frames[self.animationFrame], self.position.x , self.position.y, self.size.w, self.size.h, camera_)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y)
end

function Object:updateAnimation(time_)
	if self.animationSequence == nil or self.spritesheet == nil then --no animation sequence defined, or no spritesheet
		return
	end
	if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence] == nil then --if the animationSequence is undefined in the spritesheet
		--this should be treated as a warning
		return
	end


	if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].framerate == nil or
	 	 SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].framerate == 0 then -- the framerate is 0, indicating no animation necessary
		return
	end

	if time_ % math.floor(60/SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].framerate) == 0 then --if it's time to update
		if self.animationFrame >= table.getn(SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].frames) then
			if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].next ~= nil then
				self:setAnimationSequence( SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].next)
			end
			self.animationFrame = 1
		else
			self.animationFrame = self.animationFrame + 1
		end
	end
end

function Object:update(objectManager_)

	--apply friction
	if self.velocity > 0 then
		self.velocity = self.velocity - self.friction
	end

	local xx, yy = 0, 0

	if self.direction == Game.direction.up or self.direction == Game.direction.upleft or self.direction == Game.direction.upright then
		yy = self.velocity * -1
	end
	if self.direction == Game.direction.down or self.direction == Game.direction.downleft or self.direction == Game.direction.downright  then
		yy = self.velocity
	end
	if self.direction == Game.direction.left or self.direction == Game.direction.upleft or self.direction == Game.direction.downleft  then
		xx = self.velocity * -1
	end
	if self.direction == Game.direction.right or self.direction == Game.direction.upright or self.direction == Game.direction.downright  then
		xx = self.velocity
	end

	self.position.x = GameMath.round(self.position.x + xx)
	self.position.y = GameMath.round(self.position.y + yy)

	while objectManager_:isColliding(self, self.solidGroup) do
		if xx == 0 and yy == 0 then --if we have no implied direction to move in
			--FIXME: be a little smarter than this. This fix sucks:
			self.position.x = self.position.x - 1 --move left until we're outta the way
		else
			if xx ~= 0 then
				self.position.x = self.position.x - GameMath.sign(xx)-- *.5
			end
			if yy ~= 0 then
				self.position.y = self.position.y - GameMath.sign(yy)-- * .5
			end
		end


	end

	--[[
	--apply velocity
	self.position.x = math.floor(self.position.x + self.velocity.x)
	--correct movement if collision with any object of the solidGroup
	if self.velocity.x ~= 0 then
		while objectManager_:isColliding(self, self.solidGroup) do
			self.position.x = math.floor(self.position.x - GameMath.sign(self.velocity.x))
		end
	end

	self.position.y = math.floor(self.position.y + self.velocity.y)
	if self.velocity.y ~= 0 then
		while objectManager_:isColliding(self, self.solidGroup) do
			self.position.y = math.floor(self.position.y - GameMath.sign(self.velocity.y))
		end
	end--]]
end
