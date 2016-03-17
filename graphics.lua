Graphics = {
	drawScale = 1,
	windowWidth = 800,
	windowHeight = 600
}

function Graphics.drawTextOnGrid(t_, x_, y_, map_, camera_) 
	love.graphics.print(t_, ((x_ * map_.tileSize) - camera_.position.x ) * Graphics.drawScale, ((y_ * map_.tileSize) - camera_.position.y)  * Graphics.drawScale)
end

function Graphics.drawRectOnGrid(color_, mode_, x_, y_, width_, height_, camera_, map_)
	love.graphics.setColor( color_[1], color_[2], color_[3], 255 )
	love.graphics.rectangle("fill", ((x_)-(camera_.position.x)) * Graphics.drawScale, ((y_) - (camera_.position.y)) * Graphics.drawScale, map_.tileSize * Graphics.drawScale, map_.tileSize * Graphics.drawScale)
	love.graphics.setColor( 255, 255, 255, 255 )
end

function Graphics.disableSmoothing()
	love.graphics.setDefaultFilter( "nearest" , "nearest" )
end