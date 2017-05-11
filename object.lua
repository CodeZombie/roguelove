Object = class{
	id = 0,
	position = {x=0, y=0},
	velocity = {x=0, y=0},
	maxVelocity = {x=3, y=3},
	solidGroup = {},
	friction = .5,
	objectType = "gameobject",
	reactsToCollision = false,
	spritesheet = nil, --ID'd by filename
	animationState = nil, --string representing the spritesheet's animation states. If nil, we do not animate, and spriteIndex remains static
	animationFrameCounter = 0, --keeps track of the time in between each frame
	animationFrameIterator = 1, --keeps track of which frame we're on inside the animation
	spriteIndex = 1, --individual sprite within the spritesheet
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

function Object:setAnimationState(state_)
	--determine if this state is valid...
	if state_ == nil then
		--print("Error: Attempting to set animation state of NIL")
		return
	end

	if self.spritesheet == nil then
		--print("Error: Attempting to apply animation state to object that has no spritesheet")
		return
	end

	if SpritesheetManager.spritesheets[self.spritesheet].animationScenes[state_] == nil then
			--print("Error: Attempting to use animationState '" .. state_ .. "' to spritesheet that contains no such animation state")
			return
	end

	if self.animationState ~= state_ then
		self.animationState = state_
		--self.animationFrameIterator = 1
		if self.animationFrameIterator <= table.getn(SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState]) then
			self.spriteIndex = SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState][self.animationFrameIterator]
		else
			self.animationFrameIterator = 1
			self.spriteIndex = SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState][self.animationFrameIterator]
		end
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
	SpritesheetManager.draw(self.spritesheet, self.spriteIndex, self.position.x , self.position.y, self.size.w, self.size.h, camera_)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y)
end

function Object:updateAnimation()
	if self.animationState ~= nil and self.spritesheet ~= nil then --if we are supposed to be animating, and have a spritesheet
		if SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState] ~= nil then --if our current animation scene exists in the spritesheet
			if self.animationFrameCounter >= SpritesheetManager.spritesheets[self.spritesheet].updatesPerAnimationFrame then --and if it's time to update our frame
				self.animationFrameCounter = 0
			--determine which frame in the cycle we're in. If we're not in any, set us to the first frame and break:
				self.spriteIndex = SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState][self.animationFrameIterator]

				local numFrames = table.getn(SpritesheetManager.spritesheets[self.spritesheet].animationScenes[self.animationState]) -- number of frames

				if self.animationFrameIterator >= numFrames then
					self.animationFrameIterator = 1
				else
					self.animationFrameIterator = self.animationFrameIterator + 1
				end
			end
				self.animationFrameCounter = self.animationFrameCounter + 1
		end
	end
end

function Object:update(objectManager_)
	--update movement animation:
	if self.velocity.y > 0 then
		self:setAnimationState("walk_down")
	elseif self.velocity.y < 0 then
		self:setAnimationState("walk_up")
	end

	if self.velocity.x > 0 then
		self:setAnimationState("walk_right")
	elseif self.velocity.x < 0 then
		self:setAnimationState("walk_left")
	end

	if self.velocity.x == 0 and self.velocity.y == 0 then
		self:setAnimationState("idle")
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
	self:updateAnimation()
end
