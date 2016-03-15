Camera = {
	position = {},
	objectToFollow = nil
}

function Camera.update()
	if Camera.objectToFollow ~= nil then
		local tempx = (Camera.objectToFollow.position.x) - ((Graphics.windowWidth/2)/Graphics.drawScale) + (Map.tileSize/2)
		local tempy = (Camera.objectToFollow.position.y) - ((Graphics.windowHeight/2)/Graphics.drawScale) + (Map.tileSize/2)
		if tempx > Map.tileSize then
			Camera.position.x = tempx
		else
			Camera.position.x = Map.tileSize
		end
		
		if tempy > Map.tileSize then
			Camera.position.y = tempy
		else
			Camera.position.y = Map.tileSize
		end
	end
end

function Camera.setObjectToFollow(o_)
	Camera.objectToFollow = o_
	Camera.update()
end