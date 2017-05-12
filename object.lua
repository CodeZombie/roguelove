Object = class{
	id = 0,
	position = {x=0, y=0},
	velocity = {x=0, y=0},
	maxVelocity = {x=3, y=3},
	solidGroup = {}, --the group of things to collide with
	friction = .5,
	objectType = "gameobject",
	reactsToCollision = false, --NOTE NOTE NOTE: I'm fairly sure this property doesnt do anything. Look into removing it.
	spritesheet = nil, --ID'd by filename
	animationSequence = nil, --formerly AnimationState --string representing the spritesheet's animation states. If nil, we do not animate, and spriteIndex remains static
	animationFrame = 1, --keeps track of which frame we're on inside the animation
	size = {w=16, h=16},
	quadTreeX = 0, --used to partition all objects into squares for checking collisions
	quadTreeY = 0
}

function Object:__init(x_, y_)
	self.position.x, self.position.y = x_, y_
	self.quadTreeX = math.floor(self.position.x / 64) --fake quadtree
	self.quadTreeY = math.floor(self.position.y / 64) --fake quadtree
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

function Object:onCollision(other_)
end

function Object:checkCollision(other_)
	if other_.quadTreeX >= self.quadTreeX - 1 and other_.quadTreeX <= self.quadTreeX + 1 then
		if other_.quadTreeY >= self.quadTreeY - 1 and other_.quadTreeY <= self.quadTreeY + 1 then
			if 	self.position.x < other_.position.x + other_.size.w and
				self.position.x + self.size.w > other_.position.x and
				self.position.y < other_.position.y + other_.size.h and
				self.position.y + self.size.h > other_.position.y then
					self:onCollision(other_)
					return true
				end
			end
		end
	return false
end

function Object:checkMapWallCollision(Map_) --check if we're colliding with a map wall

end

function Object:addVelocity(x_, y_)
	if math.abs(self.velocity.x) < math.abs(self.maxVelocity.x) then
		self.velocity.x = self.velocity.x + x_
	else
		self.velocity.x = self.maxVelocity.x * GameMath.sign(self.velocity.x)
	end

	if math.abs(self.velocity.y) < math.abs(self.maxVelocity.y) then
		self.velocity.y = self.velocity.y + y_
	else
		self.velocity.y = self.maxVelocity.y * GameMath.sign(self.velocity.y)
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

	if SpritesheetManager.spritesheets[self.spritesheet].animationSequences[self.animationSequence].framerate == 0 then -- the framerate is 0, indicating no animation necessary
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
	--update movement animation:
	if self.velocity.y > 0 then
		self:setAnimationSequence("walk_down")
	elseif self.velocity.y < 0 then
		self:setAnimationSequence("walk_up")
	end

	if self.velocity.x > 0 then
		self:setAnimationSequence("walk_right")
	elseif self.velocity.x < 0 then
		self:setAnimationSequence("walk_left")
	end

	if self.velocity.x == 0 and self.velocity.y == 0 then
	--	self:setAnimationSequence("idle")
	end

	--apply friction
	if self.velocity.x ~= 0 then
		self.velocity.x = self.velocity.x - (self.friction * GameMath.sign(self.velocity.x))
		self.quadTreeX = math.floor(self.position.x / 64) --fake quadtree
	end
	if self.velocity.y ~= 0 then
		self.velocity.y = self.velocity.y - (self.friction * GameMath.sign(self.velocity.y))
		self.quadTreeY = math.floor(self.position.y / 64) --fake quadtree
	end

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
	end
end
