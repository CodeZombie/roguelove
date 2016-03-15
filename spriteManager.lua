SpriteManager = class{
	spritesheet = nil,
	quads = {}
}

function SpriteManager:__init()

end

function SpriteManager:loadSpriteSheet(filename_, tileSize_)
	self.spritesheet = love.graphics.newImage(filename_)
	self.spritesheet:setFilter( "nearest", "nearest" )
	local numberOfQuadsWidth = math.floor(self.spritesheet:getWidth() / tileSize_) 
	local numberOfQuadsHeight = math.floor(self.spritesheet:getHeight() / tileSize_)
	
	for y = 0, numberOfQuadsHeight do
		for x = 0, numberOfQuadsWidth do
			table.insert(self.quads, love.graphics.newQuad(x * tileSize_, y * tileSize_, tileSize_, tileSize_, self.spritesheet:getDimensions()))
		end
	end
	
	print(table.getn(self.quads))

end

function SpriteManager:draw(index_, x_, y_, camera_)
	--love.graphics.draw(SpriteManager.spritesheet, SpriteManager.quads[index_], x_, y_, 0, Graphics.drawScale, Graphics.drawScale)
	love.graphics.draw(self.spritesheet, self.quads[index_], ((x_)-(camera_.position.x)) * Graphics.drawScale, ((y_) - (camera_.position.y)) * Graphics.drawScale, 0, Graphics.drawScale, Graphics.drawScale)
end
