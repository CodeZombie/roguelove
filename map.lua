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