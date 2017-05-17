Object = class{
	id = 0,
	position = {x=0, y=0},
	size = {w=16, h=16},
	acceleration = {x=.75, y=.75},
	velocity = {x=0, y=0},
	maxVelocity = {x=2, y=2},

	collisionbox = {x = 0, y = 0, w = 16, h = 16},
	solidGroup = {}, --the group of things to collide with
	friction = .6, --between 0 and 1. 0 == no friction, 1 == totally immovable
	objectType = "gameobject",
	spritesheet = nil, --ID'd by filename
	animationSequence = nil, --formerly AnimationState --string representing the spritesheet's animation states. If nil, we do not animate, and spriteIndex remains static
	animationFrame = 1 --keeps track of which frame we're on inside the animation
	--direction = Game.direction.up,
	--velocity = 0,
	--maxVelocity = 3
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

function Object:addVelocity(x_, y_)
	if x_ ~= nil then
		self.velocity.x = math.min(math.abs(self.velocity.x + (x_ * self.acceleration.x)), self.maxVelocity.x) * GameMath.sign(self.velocity.x + (x_ * self.acceleration.x))
	end
	if y_ ~= nil then
		self.velocity.y = math.min(math.abs(self.velocity.y + (y_ * self.acceleration.y)), self.maxVelocity.y) * GameMath.sign(self.velocity.y + (y_ * self.acceleration.y))
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

	if self.velocity.x ~= 0 or self.velocity.y ~= 0 then

		if math.abs(self.velocity.x) < (self.friction * self.acceleration.x) then
			self.velocity.x = 0
			self.position.x = GameMath.round(self.position.x)
		end

		if math.abs(self.velocity.y) < (self.friction * self.acceleration.y) then
			self.velocity.y = 0
			self.position.y = GameMath.round(self.position.y)
		end

		--friction
		if self.velocity.x ~= 0 then
			self.velocity.x = self.velocity.x - (GameMath.sign(self.velocity.x) * (self.friction * self.acceleration.x))
		end
		if self.velocity.y ~= 0 then
			self.velocity.y = self.velocity.y - (GameMath.sign(self.velocity.y) * (self.friction * self.acceleration.y))
		end


		--apply movement & correct for collisions
		self.position.x = GameMath.round(self.position.x + self.velocity.x)
		while objectManager_:isColliding(self, self.solidGroup) do
			self.position.x = GameMath.round(self.position.x - GameMath.sign(self.velocity.x))
			--self.velocity.y =  self.velocity.y * (1 - (self.friction/8)) --add a bit of friction to our horizontal movement, slowing us down as we run into shit
		end

		self.position.y = GameMath.round(self.position.y + self.velocity.y)
		while objectManager_:isColliding(self, self.solidGroup) do
			self.position.y = GameMath.round(self.position.y - GameMath.sign(self.velocity.y))
			--self.velocity.x =  self.velocity.x * (1 - (self.friction/8)) --add a bit of friction to our horizontal movement, slowing us down as we run into shit
		end

	end

	--TODO: each frame, precompute collisions and store them in a table for lookup later.


	while objectManager_:isColliding(self, self.solidGroup) do
		if self.velocity.x == 0 and self.velocity.y == 0 then --if we have no implied direction to move in
			--FIXME: be a little smarter than this. This fix sucks:
			self.position.x = self.position.x - 1 --move left until we're outta the way
		end
	end

end
