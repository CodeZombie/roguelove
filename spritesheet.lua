Spritesheet = class{
  spritesheet = nil, -- variable holding the image data used by the love engine
  tileSize = 16, --default is 16
  filename = "", --the unique filename that this spritesheet describes
  quads = {}, --each indidual sprite in the spritesheet
	animationScenes = {}, --a data structure describing the different scenes of animation
  updatesPerAnimationFrame = 20 --the number of game updates in between animation frame-changes.
}

function Spritesheet:__init(filename_, tilesize_, id_)
  self.tileSize = tilesize_
  self.filename = filename_
	self.spritesheet = love.graphics.newImage(filename_)
	self.spritesheet:setFilter( "nearest", "nearest" ) --nearest neighbor interpolation (looks best when going for that pixel-look)
	local numberOfQuadsWidth = math.floor(self.spritesheet:getWidth() / tilesize_)
	local numberOfQuadsHeight = math.floor(self.spritesheet:getHeight() / tilesize_)

	for y = 0, numberOfQuadsHeight-1 do
		for x = 0, numberOfQuadsWidth-1 do
			table.insert(self.quads, love.graphics.newQuad(x * tilesize_, y * tilesize_, tilesize_, tilesize_, self.spritesheet:getDimensions()))
		end
	end
	print(table.getn(self.quads))
end

function Spritesheet:draw(quadIndex_, x_, y_, w_, h_, camera_)
  --index refers to the specific sprite, in order of appearance, in the spritesheet.
  --x_ and y_ refer to the position in the game world, in pixels
  --w_ and h_ refer to the width and height of the sprite to be drawn, in relation to the drawscale and camera scale
  --camera_ is obviously the in-game camera
	--love.graphics.draw(SpriteManager.spritesheet, SpriteManager.quads[index_], x_, y_, 0, Graphics.drawScale, Graphics.drawScale)
  if quadIndex_ > table.getn(self.quads) then --if the sprite index is not found:
    love.graphics.rectangle("fill", (x_ - camera_.position.x) * Graphics.drawScale, (y_ - camera_.position.y) * Graphics.drawScale, Graphics.drawScale * w_,  Graphics.drawScale * h_)
    love.graphics.setColor( 0, 0, 0, 255 )
    love.graphics.print(quadIndex_, (x_ - camera_.position.x) * Graphics.drawScale, (y_ - camera_.position.y) * Graphics.drawScale, 0, Graphics.drawScale / 3,  Graphics.drawScale / 3, 0, 0 )
    love.graphics.setColor( 255, 255, 255, 255 )
  else
	   love.graphics.draw(self.spritesheet, self.quads[quadIndex_], ((x_)-(camera_.position.x)) * Graphics.drawScale, ((y_) - (camera_.position.y)) * Graphics.drawScale, 0, Graphics.drawScale * (w_ / self.tileSize), Graphics.drawScale * (h_ / self.tileSize))
  end
end

function Spritesheet:addAnimationScenes(animationScenes_)
  for key, val in pairs(animationScenes_) do
    self.animationScenes[key] = val
  end
end
