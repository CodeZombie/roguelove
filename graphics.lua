Graphics = {
	windowWidth = 1024,
	windowHeight = 768
}

function Graphics.drawRectOnGrid(color_, mode_, x_, y_, width_, height_, camera_, map_)
	love.graphics.setColor(color_[1], color_[2], color_[3], 255)
	love.graphics.rectangle("fill", ((x_)-(camera_.position.x)) * camera_.zoomLevel, ((y_) - (camera_.position.y)) * camera_.zoomLevel, map_.tileSize * Graphics.drawScale, map_.tileSize * camera_.zoomLevel)
	love.graphics.setColor(255, 255, 255, 255)
end

function Graphics.createWindow()
	love.window.setMode( Graphics.windowWidth, Graphics.windowHeight, {resizable=true, vsync=false, minwidth=400, minheight=300} )
end

function Graphics.disableSmoothing()
	love.graphics.setDefaultFilter( "nearest" , "nearest" )
end

function Graphics.resize(w_, h_)
	Graphics.windowWidth = w_
	Graphics.windowHeight = h_
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
