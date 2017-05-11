Map = class{
	mapData = {},
	mapDrawData = {},
	rooms = {}, -- {x, y, width, height}
	mapWidth = 128, --default
	mapHeight = 128, --default
	tileSize = 16,
	spritesheet = nil
}

function Map:__init(w_, h_, minRooms_, maxRooms_) 	-- minRooms, maxRooms, minRoomSize, maxRoomSize
													-- fill mapData with 0s based on the dimensions maxRooms * maxRoomSize
													-- cut the map into squares, and put rooms in these squares using a similar algo as below
													-- we must garauntee that minRooms will be placed in the map.
													-- Gridding up the map into squares garauntees that enough rooms will be placed.
	self.mapWidth = w_
	self.mapHeight = h_

	-----------------------
	-- Zero the entire map:
	-----------------------
	for y = 1, self.mapHeight do
		table.insert(self.mapData, {})
		table.insert(self.mapDrawData, {})
		for x = 1, self.mapWidth do
			--zero the map
			table.insert(self.mapData[y], 1)
			table.insert(self.mapDrawData[y],14)
		end
	end

	---------------------------
	-- Define helper functions:
	---------------------------
	local getRandomRect = function(maxRectWidth_, maxRectHeight, parent_, distance_)
		local randX = 0
		local randY = 0

		local randWidth = love.math.random(4, maxRectWidth_) --4 being the smallest possible size
		local randHeight = love.math.random(4, maxRectHeight)

		if parent_ == nil then
			randX = love.math.random(1, self.mapWidth - randWidth)--subtraction so rects dont end up off the map
			randY = love.math.random(1, self.mapHeight - randHeight)
		else
			--FIX THIS FUNCTION SO THAT THE ROOMS CAN ONLY BE PLACED INWARD OF 1 TILE IN THE MAP (to make space for walls)
			if love.math.random(0,1) == 1 then
				randY = GameMath.max(parent_.y - love.math.random(0, distance_) - randHeight, 1)
			else
				randY = GameMath.min(parent_.y + parent_.height + love.math.random(0, distance_) + randHeight, self.mapHeight) - randHeight
			end

			if love.math.random(0,1) == 1 then
				randX = GameMath.max(parent_.x - love.math.random(0, distance_) - randWidth, 1)
			else
				randX = GameMath.min(parent_.x + parent_.width + love.math.random(0, distance_) + randWidth, self.mapWidth) - randWidth
			end
		end
		return randX, randY, randWidth, randHeight
	end

	local makePermanentAndGeneratePath = function(x_, y_, w_, h_, parent_)
		--get the map tiles in there
		for y=1, h_ do
			for x=1, w_ do
				self.mapData[y+y_][x+x_] = 0
				self.mapDrawData[y+y_][x+x_] = 0
			end
		end

		if parent_ ~= nil then --gen pathlink
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

	--------------------
	-- Define variables:
	--------------------
	local depth = 0
	local maxDepth =  32 --upper limit to how many times the while loop can iterate. You really don't want it going much larger than this anyway.

	local currentGeneration = {} --holds references to the rooms that are being processed
	local nextGeneration = {} --refs to the rooms that are to be processed next

	--------------------------------------
	-- Define vars used in the while loop:
	--------------------------------------
	local numOfChildren = 0 --temp var used to hold the number of children a specific room will have
	local rx, ry, rw, rh = 0,0,0,0 --temp vars used to describe the position/size of a room as it's processed
	local positionOkay = false
	local positionGenRetries = 0
	----------------------
	-- Generate root room:
	----------------------
	local rootx, rooty, rootwidth, rootheight = math.floor(self.mapWidth/4), math.floor(self.mapHeight/4), 6, 6
	table.insert(currentGeneration, {x=rootx, y=rooty, width=rootwidth, height=rootheight}) --insert the root at 16x16
	table.insert(self.rooms, {x=rootx, y=rooty, width=rootwidth, height=rootheight}) --insert the root into the self.rooms table
	makePermanentAndGeneratePath(rootx, rooty, rootwidth, rootheight, nil, nil)--insert it into mapdata

	---------------------
	-- Generate the room:
	---------------------
	while depth <= maxDepth do
		for k in pairs(currentGeneration) do

			numOfChildren = love.math.random(0,2)

			if minRooms_ > table.getn(self.rooms) then
				numOfChildren = love.math.random(1,2) --force the game to generate at least minNum amount of rooms
			end

			for n = 1, numOfChildren do --generate children
				if table.getn(self.rooms) >= maxRooms_ then --if we've generate the max amount of rooms
					break --dont generate any more!
				end

				positionOkay = false
				positionGenRetries = 0

				while positionOkay == false and positionGenRetries < 16 do

					rx, ry, rw, rh = getRandomRect(8,8, currentGeneration[k], 8) --generates a rectangle close to the parent

					for k,v in pairs(self.rooms) do --check to see if this rectangle is touching any other
						if v.x < rx + rw + 1
						and v.x + v.width + 1 > rx
						and v.y < ry + rh + 1
						and v.y + v.height +1 > ry then --if it is, try again
							positionOkay = false
							positionGenRetries = positionGenRetries + 1
							break
						else
							positionOkay = true --if it's not, continue
						end
					end
				end
				if positionOkay == true then
					table.insert(nextGeneration, {x=rx, y=ry, width=rw, height=rh})
					table.insert(self.rooms, {x=rx, y=ry, width=rw, height=rh})
					makePermanentAndGeneratePath(rx, ry, rw, rh, currentGeneration[k])
				end
			end
		end

		currentGeneration = nextGeneration
		nextGeneration = {}

		depth = depth + 1
		if table.getn(self.rooms) >= maxRooms_ then
			break
		end
	end

	---------------------------------
	-- Generate the detailed drawMap:
	---------------------------------
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

				if self.mapData[y-1] ~= nil and self.mapData[y-1][x] == 1 and self.mapData[y][x+1] ~= nil and self.mapData[y][x+1] == 1 then --wall right and above
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

function Map:getRooms()
	return self.rooms
end

function Map:setSize(w_, h_)
	self.mapWidth = w_
	self.mapHeight = h_
end

function Map:setSpritesheet(ss_)
	self.spritesheet = ss_
end

function Map:draw(camera_)
	if SpritesheetManager.spritesheets[self.spritesheet] == nil then
		print("ERROR: Map has no/invalid spritesheet!")
	end
	for y = 1, self.mapHeight do
		for x = 1, self.mapWidth do
			if self.mapDrawData[y][x] ~= 0 then
				SpritesheetManager.spritesheets[self.spritesheet]:draw(self.mapDrawData[y][x], x * self.tileSize, y * self.tileSize, self.tileSize, self.tileSize, camera_)
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

function Map:drawIndividualRooms()
	for k,v in pairs(self.rooms) do
		love.graphics.setColor( love.math.random(0,255), love.math.random(0,255), love.math.random(0,255), 255 )
		love.graphics.rectangle( "fill", v.x*3, v.y*3, v.width*3, v.height*3 )
	end


	love.graphics.setColor( 255, 255, 255, 255 )
end
