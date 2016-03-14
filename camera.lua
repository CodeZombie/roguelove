Camera = {
	position = {},
	objectToFollow = nil
}

function Camera.update()
	if Camera.objectToFollow ~= nil then
		local tempx = (Camera.objectToFollow.position.x * Map.tileSize) - (400/DRAWSCALE) + (Map.tileSize/2)
		local tempy = (Camera.objectToFollow.position.y * Map.tileSize) - (300/DRAWSCALE) + (Map.tileSize/2)
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
	--Camera.position.x = o_.position.x*Map.tileSize-100
	--Camera.position.y = o_.position.y*Map.tileSize-100
	--print(Camera.position.x)
end