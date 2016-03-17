Map = class{
	mapData = {},
	mapDrawData = {},
	rooms = {}, -- {x, y, width, height}
	mapWidth = 128, --default
	mapHeight = 128, --default
	tileSize = 16
}

function Map:newGen()
	--remember, tiles start at 1,1, not 0,0
	
	--helper:
	local getRandomRect = function(maxRectWidth_, maxRectHeight, etc_)
		--etc will hold the parent object, plus a maxDistance object} pass nil if you dont care about proximity
		local randX = 0
		local randY = 0
		
		local randWidth = love.math.random(4,maxRectWidth_) --4 being the smallest possible size
		local randHeight = love.math.random(4,maxRectHeight)
		
		if etc_ == nil then
			randX = love.math.random(1,self.mapWidth-randWidth)--subtraction so rects dont end up off the map
			randY = love.math.random(1,self.mapHeight-randHeight)
		else
			if love.math.random(0,1) == 1 then
				randY = GameMath.max(etc_[1].y - love.math.random(0,etc_[2]) - randHeight, 1)
			else
				randY = GameMath.min(etc_[1].y + etc_[1].height + love.math.random(0,etc_[2]) + randHeight, self.mapHeight) - randHeight
			end
			
			if love.math.random(0,1) == 1 then
				randX = GameMath.max(etc_[1].x - love.math.random(0,etc_[2]) - randWidth, 1)
			else
				randX = GameMath.min(etc_[1].x + etc_[1].width + love.math.random(0,etc_[2]) + randWidth, self.mapWidth) - randWidth
			end
		end
		
		return randX, randY, randWidth, randHeight
	end
	
	local createRoomInMapData = function(x_, y_, w_, h_, parent_)
		--get the map tiles in there
		for y=1, h_ do
			for x=1, w_ do
				self.mapData[y+y_][x+x_] = 0
				self.mapDrawData[y+y_][x+x_] = 0
			end
		end
		
		if parent_ ~= nil then
			--then draw the pathlink
			local origCenterX = math.floor(w_/2) + x_
			local origCenterY = math.floor(h_/2) + y_
			
			local destCenterX = math.floor(parent_.width/2) + parent_.x
			local destCenterY = math.floor(parent_.height/2) + parent_.y

			for x=GameMath.min(origCenterX, destCenterX), GameMath.max(origCenterX, destCenterX) do
				self.mapData[destCenterY][x] = 0
				self.mapDrawData[destCenterY][x] = 0
			end

			for y=GameMath.min(origCenterY, destCenterY), GameMath.max(origCenterY, destCenterY) do
				self.mapData[y][origCenterX] = 0
				self.mapDrawData[y][origCenterX] = 0
			end
		end
	end
	
		
	--helper vars:
	local depth = 0
	local maxDepth = 4
	local minimumRooms = 4
	
	--reusable locals
	local numOfChildren = 0
	local rx, ry, rw, rh = 0,0,0,0
	local childrenThisGeneration = 0
	
	local currentGeneration = {} --holds references to the macroTiles that are being processed
	local nextGeneration = {} --refs to the macrotiles that are to be processed next
	
	--generate the root room...
	--local rootx, rooty, rootwidth, rootheight = getRandomRect(4,4, nil)
	local rootx, rooty, rootwidth, rootheight = math.floor(self.mapWidth/2), math.floor(self.mapHeight/2), 6, 6
	table.insert(currentGeneration, {x=rootx, y=rooty, width=rootwidth, height=rootheight}) --insert the root at 16x16
	createRoomInMapData(rootx, rooty, rootwidth, rootheight, nil)--insert it into mapdata
	
	while depth <= maxDepth do
		for k in pairs(currentGeneration) do
			numOfChildren = love.math.random(0,3)
			if depth == 0 then
				numOfChildren = 2
			end
			
			for n = 1, numOfChildren do --generate children
				rx, ry, rw, rh = getRandomRect(8,8, {currentGeneration[k], 8})
				table.insert(nextGeneration, {x=rx, y=ry, width=rw, height=rh})
				table.insert(self.rooms, {x=rx, y=ry, width=rw, height=rh})
				createRoomInMapData(rx, ry, rw, rh, currentGeneration[k])
				--generate links from parent room to this room.
			end
		end
		
		currentGeneration = nextGeneration
		nextGeneration = {}
		
		depth = depth + 1
	end
end

function Map:detail()
	for y = 1, self.mapHeight do
		for x = 1, self.mapWidth do
			if self.mapData[y][x] == 0 then --floor
				self.mapDrawData[y][x] = 20
				
				if self.mapData[y-1] ~= nil and self.mapData[y-1][x] == 1 then --theres a wall above
					self.mapDrawData[y][x] = 18
				end
				if self.mapData[y][x-1] ~= nil and self.mapData[y][x-1] == 1 then --theres a wall left
					self.mapDrawData[y][x] = 10
				end
				if self.mapData[y][x+1] ~= nil and self.mapData[y][x+1] == 1 then --theres a wall right
					self.mapDrawData[y][x] = 8
				end
				
				if self.mapData[y-1] ~= nil and self.mapData[y-1][x] == 1 and self.mapData[y][x-1] ~= nil and self.mapData[y][x-1] == 1 then --wall left and above
					self.mapDrawData[y][x] = 19
				end
				
				if self.mapData[y-1] ~= nil and self.mapData[y-1][x] == 1 and self.mapData[y][x+1] ~= nil and self.mapData[y][x+1] == 1 then
					self.mapDrawData[y][x] = 17
				end
				
			elseif self.mapData[y][x] == 1 then --wall
				if self.mapData[y+1] ~= nil and self.mapData[y+1][x] == 0 
				or self.mapData[y+2] ~= nil and self.mapData[y+2][x] == 0 
				or self.mapData[y-1] ~= nil and self.mapData[y-1][x] == 0 
				or self.mapData[y][x-1] ~= nil and self.mapData[y][x-1] == 0 
				or self.mapData[y][x+1] ~= nil and self.mapData[y][x+1] == 0 
				or self.mapData[y-1] ~= nil and self.mapData[y-1][x-1] and self.mapData[y-1][x-1] == 0
				or self.mapData[y-1] ~= nil and self.mapData[y-1][x+1] and self.mapData[y-1][x+1] == 0 
				or self.mapData[y+1] ~= nil and self.mapData[y+1][x+1] and self.mapData[y+1][x+1] == 0 
				or self.mapData[y+1] ~= nil and self.mapData[y+1][x-1] and self.mapData[y+1][x-1] == 0 
				or self.mapData[y+2] ~= nil and self.mapData[y+2][x-1] and self.mapData[y+2][x-1] == 0 
				or self.mapData[y+2] ~= nil and self.mapData[y+2][x+1] and self.mapData[y+2][x+1] == 0 
				then --floor anywhere around us
					self.mapDrawData[y][x] = 15
				end
				if self.mapData[y+1] ~= nil and self.mapData[y+1][x] == 0  then --specifically floor below us
					self.mapDrawData[y][x] = 9
				end
			end
		end
	end	
end

function Map:__init(w_, h_)
	
	self.mapWidth = w_
	self.mapHeight = h_
	

	for y = 1, self.mapHeight do
		table.insert(self.mapData, {})
		table.insert(self.mapDrawData, {})
		for x = 1, self.mapWidth do
			--zero the map
			table.insert(self.mapData[y], 1)
			table.insert(self.mapDrawData[y],14)
		end
	end
end

function Map:setSize(w_, h_)
	self.mapWidth = w_
	self.mapHeight = h_
end

function Map:draw(spriteManager_, camera_)
	--draw the map
	for y = 1, self.mapHeight do
		for x = 1, self.mapWidth do
			if self.mapDrawData[y][x] ~= 0 then
				spriteManager_:draw(self.mapDrawData[y][x], x * self.tileSize, y * self.tileSize, camera_)
			else
				Graphics.drawRectOnGrid({0,0,0}, mode_, x * self.tileSize, y * self.tileSize, self.tileSize, self.tileSize, camera_, self)
			end
			--if self.mapData[y][x] == 1 then
				--spriteManager_:draw(61, x * self.tileSize, y * self.tileSize, camera_)
				--Graphics.drawTextOnGrid("(" .. x .. ", " .. y .. ")", x, y) 
			--else
				--spriteManager_:draw(1, x * self.tileSize, y * self.tileSize, camera_)
				---Graphics.drawRectOnGrid({0,0,0}, mode_, x * self.tileSize, y * self.tileSize, self.tileSize, self.tileSize, camera_, self)
			--end
		end
	end
end