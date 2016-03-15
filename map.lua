Map = {
	mapData = {},
	mapWidth = 32,
	mapHeight = 32,
	tileSize = 16
}

function Map.generate()
	
	for y = 1, Map.mapHeight do
		table.insert(Map.mapData, {})
		--Map.mapData[y] = {}
		for x = 1, Map.mapWidth do
			if love.math.random() >= .75 then
				table.insert(Map.mapData[y], 1)
				--Map.mapData[y][x] = 1
			else 
				table.insert(Map.mapData[y], 0)
				--Map.mapData[y][x] = 0
			end
		end
	end
end

function Map.setSize(w_, h_)
	Map.mapWidth = w_
	Map.mapHeight = h_
end

function Map.draw()
	--draw the map
	for y = 1, Map.mapHeight do
		for x = 1, Map.mapWidth do
			if Map.mapData[y][x] == 1 then
				SpriteManager.draw(61, x * Map.tileSize, y * Map.tileSize)
				--Graphics.drawTextOnGrid("(" .. x .. ", " .. y .. ")", x, y) 
			end
		end
	end
end