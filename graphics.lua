Graphics = {}

function Graphics.drawTextOnGrid(t_, x_, y_) 
	love.graphics.print(t_, ((x_ * Map.tileSize) - Camera.position.x ) * DRAWSCALE, ((y_ * Map.tileSize) - Camera.position.y)  * DRAWSCALE)
end
