Object = class{
	position = {x=0, y=0},
	destinationPosition = {x=0, y=0},
	objectType = "generic",
	spriteIndex = 1,
	animationState = 0, --1 = Walking. 
	speed = 4 --4 is quick enough as to not hold the player up if they wanna move quickly, but also slow enough to show the animation
}

function Object:__init(x,y)
	self.position.x, self.position.y = x * Map.tileSize, y * Map.tileSize
	self.destinationPosition.x = self.position.x
	self.destinationPosition.y = self.position.y
end

function Object:setObjectType(t)
	self.objectType = t
end

function Object:setSpriteIndex(s_)
	self.spriteIndex = s_
end

function Object:onMoved()
	--automatically called after a succesful move
end

function Object:onMoveFailed()
	--automatically called if the object fails to move in the desired direction
end


function Object:move(direction_, map_)
	local playerTileX = math.floor(self.position.x / map_.tileSize)
	local playerTileY = math.floor(self.position.y / map_.tileSize)
	if self.animationState == 0 then
		if direction_ == "up" then
			if map_.mapData[playerTileY - 1] ~= nil and map_.mapData[playerTileY - 1][playerTileX] == 0 then
				self.destinationPosition.y = math.floor(self.position.y - map_.tileSize)
				self.animationState = 1
			else
				self:onMoveFailed()
			end
		elseif direction_ == "down" then
			if map_.mapData[playerTileY + 1] ~= nil and map_.mapData[playerTileY + 1][playerTileX] == 0 and playerTileY <= map_.mapHeight * map_.tileSize then
				self.destinationPosition.y = math.floor(self.position.y + map_.tileSize)
				self.animationState = 1
			else
				self:onMoveFailed()
			end
		elseif direction_ == "left" then
			if map_.mapData[playerTileY][playerTileX - 1] ~= nil and map_.mapData[playerTileY][playerTileX - 1] == 0 then
				self.destinationPosition.x = math.floor(self.position.x - map_.tileSize)
				self.animationState = 1
			else
				self:onMoveFailed()
			end
		elseif direction_ == "right" then
			if map_.mapData[playerTileY][playerTileX + 1] ~= nil and map_.mapData[playerTileY][playerTileX + 1] == 0 and playerTileX <= map_.mapWidth * map_.tileSize then
				self.destinationPosition.x = math.floor(self.position.x + map_.tileSize)
				self.animationState = 1
			else
				self:onMoveFailed()
			end
		end
	end
end

function Object:draw(spriteManager_, camera_)
	spriteManager_:draw(self.spriteIndex, self.position.x , self.position.y, camera_)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y) 
end

function Object:update()
	--generic object update logic
	if self.animationState ~= 0 then
		self:animate()
	end
end

function Object:animate()
	if self.animationState == 1 then
		if math.abs(self.position.x - self.destinationPosition.x) >= self.speed or math.abs(self.position.y - self.destinationPosition.y) >= self.speed then
			if self.position.x > self.destinationPosition.x then
				self.position.x = self.position.x - math.ceil((self.speed) * (math.abs(self.position.x - self.destinationPosition.x)/8))
			elseif self.position.x < self.destinationPosition.x then
				self.position.x = self.position.x + math.ceil((self.speed) * (math.abs(self.position.x - self.destinationPosition.x)/8))
			end
			
			if self.position.y > self.destinationPosition.y then
				self.position.y = self.position.y - math.ceil((self.speed) * (math.abs(self.position.y - self.destinationPosition.y)/8))
			elseif self.position.y < self.destinationPosition.y then
				self.position.y = self.position.y + math.ceil((self.speed) * (math.abs(self.position.y - self.destinationPosition.y)/8))
			end
		else
			self.position.x = self.destinationPosition.x
			self.position.y = self.destinationPosition.y
			self.animationState = 0
			self:onMoved()
		end
	end
	--loops until it returns 0. Each loop, it changes its keyframe, and is redrawn by love.draw()
	--a special flag will be used in the object members to determine if an animation is to be started.
end