Object = class{
	id = 0,
	position = {x=0, y=0},
	velocity = {x=0, y=0},
	maxVelocity = {x=3, y=3},
	solidGroup = {},
	friction = .5,
	type = "gameobject",
	subtype = "game_generic",
	reactsToCollision = false,
	spriteIndex = 1,
	size = {w=16, h=16}
}

function Object:__init(x_, y_)
	self.position.x, self.position.y = x_, y_

end

function Object:setObjectType(t_)
	self.objectType = t_
end

function Object:setSpriteIndex(s_)
	self.spriteIndex = s_
end

function Object:keyPress(key_)

end

function Object:onCollision(other_)
end

function Object:checkCollision(other_)
	if 	self.position.x < other_.position.x + other_.size.w and
		self.position.x + self.size.w > other_.position.x and
		self.position.y < other_.position.y + other_.size.h and
		self.position.y + self.size.h > other_.position.y then
			return true
		end
		return false
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

function Object:draw(spriteManager_, camera_)
	spriteManager_:draw(self.spriteIndex, self.position.x , self.position.y, self.size.w, self.size.h, camera_)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y)
end

function Object:update(objectManager_)
	--generic object update logic

	--apply friction
	if self.velocity.x ~= 0 then
		self.velocity.x = self.velocity.x - (self.friction * GameMath.sign(self.velocity.x))
	end
	if self.velocity.y ~= 0 then
		self.velocity.y = self.velocity.y - (self.friction * GameMath.sign(self.velocity.y))
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
