Camera = class{
	position = {x=0,y=0},
	objectToFollow = nil
}

function Camera:__init(object_)
	self.objectToFollow = object_
end

function Camera:update(map_)
	if self.objectToFollow ~= nil then
		local tempx = (self.objectToFollow.position.x) - ((Graphics.windowWidth/2)/Graphics.drawScale) + (map_.tileSize/2)
		local tempy = (self.objectToFollow.position.y) - ((Graphics.windowHeight/2)/Graphics.drawScale) + (map_.tileSize/2)
		--if tempx > map_.tileSize then
			self.position.x = tempx
		--else
		--	self.position.x = map_.tileSize
		--end
		
		--if tempy > map_.tileSize then
			self.position.y = tempy
		--else
		--	self.position.y = map_.tileSize
		--end
	end
end
