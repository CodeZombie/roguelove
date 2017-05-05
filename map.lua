Map = class{
	mapData = {},
	mapWidth = 32,
	mapHeight = 32,
	tileSize = 16
}

function Map:__init(w_, h_)
	
	self.mapWidth = w_
	self.mapHeight = h_

	for y = 1, self.mapHeight do
		table.insert(self.mapData, {})
		--Map.mapData[y] = {}
		for x = 1, self.mapWidth do
			if love.math.random() >= .75 then
				table.insert(self.mapData[y], 1)
				--Map.mapData[y][x] = 1
			else 
				table.insert(self.mapData[y], 0)
				--Map.mapData[y][x] = 0
			end
		end
	end
end

function Map:checkCollision(x_, y_, w_, h_)
	--check to see if any of our 4 points reside within a tile...
	data = {tl=0, tr=0, bl=0, br=0}
	
	xx = math.floor(x_ / 32)
	yy = math.floor(y_ / 32)
	data.tl = self.mapData[yy][xx]
	if data.tl == 1 then
		print(xx)
	end
	--data.tr = self.mapData[(y_ / 32)+1][((x_ + w_) / 32)+1]
	--data.bl = self.mapData[((y_ + h_) /32)+1][(x_ / 32)+1]
	--data.br = self.mapData[((y_ + h_) / 32)+1][((x_ + w_) / 32)+1]
	
	return data
	
	--return a detailed table showing which points are touching what
end

function Map:setSize(w_, h_)
	self.mapWidth = w_
	self.mapHeight = h_
end

function Map:draw(spriteManager_, camera_)
	--draw the map
	for y = 1, self.mapHeight do
		for x = 1, self.mapWidth do
			if self.mapData[y][x] == 1 then
				spriteManager_:draw(61, x * self.tileSize, y * self.tileSize, camera_)
				--Graphics.drawTextOnGrid("(" .. x .. ", " .. y .. ")", x, y) 
			end
		end
	end
end