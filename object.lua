Object = class{
	position = {x=0, y=0},
	destinationPosition = {x=0, y=0},
	objectType = "generic",
	symbol = 1,
	animationState = 0,
	speed = 2
}

function Object:__init(x,y)
	self.position.x, self.position.y = x * Map.tileSize, y * Map.tileSize
	self.destinationPosition.x = self.position.x
	self.destinationPosition.y = self.position.y
end

function Object:setObjectType(t)
	self.objectType = t
end

function Object:setSymbol(s_)
	self.symbol = s_
end

function Object:onMoved()
	--automatically called after a succesful move
end

function Object:onMoveFailed()
	--automatically called if the object fails to move in the desired direction
end


function Object:move(direction_)
	local playerTileX = math.floor(self.position.x / Map.tileSize)
	local playerTileY = math.floor(self.position.y / Map.tileSize)
	
	if self.animationState == 0 then
		if direction_ == "up" then
			if Map.mapData[playerTileY - 1] ~= nil and Map.mapData[playerTileY - 1][playerTileX] == 0 then
				self.destinationPosition.y = math.floor(self.position.y - Map.tileSize)
			else
				self:onMoveFailed()
			end
		elseif direction_ == "down" then
			if Map.mapData[playerTileY + 1] ~= nil and Map.mapData[playerTileY + 1][playerTileX] == 0 and playerTileY <= Map.mapHeight * Map.tileSize then
				self.destinationPosition.y = math.floor(self.position.y + Map.tileSize)
			else
				self:onMoveFailed()
			end
		elseif direction_ == "left" then
			if Map.mapData[playerTileY][playerTileX - 1] ~= nil and Map.mapData[playerTileY][playerTileX - 1] == 0 then
				self.destinationPosition.x = math.floor(self.position.x - Map.tileSize)
			else
				self:onMoveFailed()
			end
		elseif direction_ == "right" then
			if Map.mapData[playerTileY][playerTileX + 1] ~= nil and Map.mapData[playerTileY][playerTileX + 1] == 0 and playerTileX <= Map.mapWidth * Map.tileSize then
				self.destinationPosition.x = math.floor(self.position.x + Map.tileSize)
			else
				self:onMoveFailed()
			end
		end
	end
end

function Object:draw()
	SpriteManager.draw(self.symbol, self.position.x , self.position.y)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y) 
end

function Object:update()
	--generic object update logic
	self:animate()
end

function Object:animate()
	if math.abs(self.position.x - self.destinationPosition.x) >= self.speed or math.abs(self.position.y - self.destinationPosition.y) >= self.speed then
		if self.position.x > self.destinationPosition.x then
			self.position.x = self.position.x - self.speed
		elseif self.position.x < self.destinationPosition.x then
			self.position.x = self.position.x + self.speed
		end
		
		if self.position.y > self.destinationPosition.y then
			self.position.y = self.position.y - self.speed
		elseif self.position.y < self.destinationPosition.y then
			self.position.y = self.position.y + self.speed
		end		
		self.animationState = 1
	elseif self.animationState == 1 then
		self.position.x = self.destinationPosition.x
		self.position.y = self.destinationPosition.y
		self.animationState = 0
		self:onMoved()
	end
	--loops until it returns 0. Each loop, it changes its keyframe, and is redrawn by love.draw()
	--a special flag will be used in the object members to determine if an animation is to be started.
end