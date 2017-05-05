Graphics = {
	drawScale = 3,
	windowWidth = 800,
	windowHeight = 600
}

function Graphics.drawTextOnGrid(t_, x_, y_)
	love.graphics.print(t_, ((x_ * Map.tileSize) - Camera.position.x ) * Graphics.drawScale, ((y_ * Map.tileSize) - Camera.position.y)  * Graphics.drawScale)
end

function Graphics.disableSmoothing()
	love.graphics.setDefaultFilter( "nearest" , "nearest" )
end

function Graphics.drawRectangle(mode_, x_, y_, w_, h_, rx_, ry_, segs_, color_)
	love.graphics.setColor(color_[1], color_[2], color_[3], 255)

	if rx_ == 0 and ry_ == 0 then
		love.graphics.rectangle(mode_, x_, y_, w_, h_)
	else
		love.graphics.rectangle(mode_, x_, y_, w_, h_, rx_, ry_, segs_)
	end

	love.graphics.setColor(255, 255, 255, 255)
end
