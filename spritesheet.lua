Spritesheet = class{
  spritesheet = nil, -- variable holding the image data used by the love engine
  --tileSize = 16, --default is 16
  tilesize = {w = 16, h = 16},
  filename = "", --the unique filename that this spritesheet describes
  quads = {}, --each indidual sprite in the spritesheet
	animationSequences = {}, --a data structure describing the different scenes of animation
  defaultSequence = nil,
  updatesPerAnimationFrame = 10 --the number of game updates in between animation frame-changes.
}

function Spritesheet:__init(filename_, tilesize_, id_)
  self.tileSize = tilesize_
  self.filename = filename_
	self.spritesheet = love.graphics.newImage(filename_)
	self.spritesheet:setFilter( "nearest", "nearest" ) --nearest neighbor interpolation (looks best when going for that pixel-look)
	local numberOfQuadsWidth = math.floor(self.spritesheet:getWidth() / tilesize_.w)
	local numberOfQuadsHeight = math.floor(self.spritesheet:getHeight() / tilesize_.h)

	for y = 0, numberOfQuadsHeight-1 do
		for x = 0, numberOfQuadsWidth-1 do
			table.insert(self.quads, love.graphics.newQuad(x * tilesize_.w, y * tilesize_.h, tilesize_.w, tilesize_.h, self.spritesheet:getDimensions()))
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
    love.graphics.rectangle("fill", (x_ - camera_.position.x) * camera_.zoomLevel, (y_ - camera_.position.y) * camera_.zoomLevel, camera_.zoomLevel * w_,  camera_.zoomLevel * h_)
    love.graphics.setColor( 0, 0, 0, 255 )
    love.graphics.print(quadIndex_, (x_ - camera_.position.x) * camera_.zoomLevel, (y_ - camera_.position.y) * camera_.zoomLevel, 0, Graphics.drawScale / 3,  camera_.zoomLevel / 3, 0, 0 )
    love.graphics.setColor( 255, 255, 255, 255 )
  else

	   --love.graphics.draw(self.spritesheet, self.quads[quadIndex_], ((x_)-(camera_.position.x)) * camera_.zoomLevel, ((y_) - (camera_.position.y)) * camera_.zoomLevel, 0, camera_.zoomLevel * (w_ / self.tileSize.w), camera_.zoomLevel * (h_ / self.tileSize.h))
     love.graphics.draw(self.spritesheet,  self.quads[quadIndex_],
                                            ((x_)-(camera_.position.x)) * camera_.zoomLevel, ((y_) - (camera_.position.y)) * camera_.zoomLevel,
                                            0,
                                            camera_.zoomLevel * (w_ / self.tileSize.w),
                                            camera_.zoomLevel * (h_ / self.tileSize.h))
  end
end

function Spritesheet:addAnimationSequence(animationSequences_)
  for key, val in pairs(animationSequences_) do
    self.animationSequences[key] = val
  end
end
