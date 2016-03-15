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