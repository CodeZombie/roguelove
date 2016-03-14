SpriteManager = {
	spritesheet = nil,
	quads = {}
}

function SpriteManager.load(filename_)
	SpriteManager.spritesheet = love.graphics.newImage(filename_)
	SpriteManager.spritesheet:setFilter( "nearest", "nearest" )
	local numberOfQuadsWidth = math.floor(SpriteManager.spritesheet:getWidth() / Map.tileSize) 
	local numberOfQuadsHeight = math.floor(SpriteManager.spritesheet:getHeight() / Map.tileSize)
	
	for y = 0, numberOfQuadsHeight do
		for x = 0, numberOfQuadsWidth do
			table.insert(SpriteManager.quads, love.graphics.newQuad(x*Map.tileSize, y*Map.tileSize, Map.tileSize, Map.tileSize, SpriteManager.spritesheet:getDimensions()))
		end
	end
	
	
	--generate indexes and offsets and all that
end

function SpriteManager.draw(index_, x_, y_)
	love.graphics.draw(SpriteManager.spritesheet, SpriteManager.quads[index_], ((x_ * Map.tileSize)-(Camera.position.x)) * DRAWSCALE, ((y_ * Map.tileSize) - (Camera.position.y)) * DRAWSCALE, 0, DRAWSCALE, DRAWSCALE)
end
