Object = class{
	position = {x=0, y=0},
	objectType = "generic",
	symbol = 1
}

function Object:__init(x,y)
	self.position.x, self.position.y = x, y
end

function Object:setObjectType(t)
	self.objectType = t
end

function Object:setSymbol(s_)
	self.symbol = s_
end

function Object:move(direction_)
	if direction_ == "up" then
		--check collision
		if Map.mapData[self.position.y - 1] ~= nil and Map.mapData[self.position.y - 1][self.position.x] == 0 then
			self.position.y = self.position.y - 1
		end
	elseif direction_ == "down" then
		if Map.mapData[self.position.y + 1] ~= nil and Map.mapData[self.position.y + 1][self.position.x] == 0 and self.position.y <= Map.mapHeight then
			self.position.y = self.position.y + 1
		end
	elseif direction_ == "left" then
		if Map.mapData[self.position.y][self.position.x - 1] ~= nil and Map.mapData[self.position.y][self.position.x - 1] == 0 then
			self.position.x = self.position.x - 1
		end
	elseif direction_ == "right" then
		if Map.mapData[self.position.y][self.position.x + 1] ~= nil and Map.mapData[self.position.y][self.position.x + 1] == 0 and self.position.x <= Map.mapWidth then
			self.position.x = self.position.x + 1
		end
	end
end

function Object:draw()

	SpriteManager.draw(self.symbol, self.position.x  , self.position.y)
	--Graphics.drawTextOnGrid("(" .. self.position.x .. ", " .. self.position.y .. ")", self.position.x, self.position.y) 
end

function Object:update()
	--generic object update logic
end

function Object:animate()
	--loops until it returns 0. Each loop, it changes its keyframe, and is redrawn by love.draw()
	--a special flag will be used in the object members to determine if an animation is to be started.
end