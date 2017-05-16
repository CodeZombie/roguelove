Camera = class{
	position = {x=0,y=0},
	objectToFollow = nil,
	boundMap = nil,
	zoomLevel = 3 --zoom level, 1 is no zoom at all
}

function Camera:__init()
end

function Camera:setObjectToFollow(object_)
	self.objectToFollow = object_
end

function Camera:update()
	if self.objectToFollow ~= nil then
		local tempx = (self.objectToFollow.position.x) - ((Graphics.windowWidth/2)/self.zoomLevel) + (self.objectToFollow.size.w/2)
		local tempy = (self.objectToFollow.position.y) - ((Graphics.windowHeight/2)/self.zoomLevel) + (self.objectToFollow.size.h/2)
		if self.boundMap ~= nil then
			if tempx >= 0 and tempx <= (mapWidth_ - ((Graphics.windowWidth)/self.zoomLevel)) then
				self.position.x = math.floor(tempx)
			elseif tempx < 0 then
				self.position.x = 0
			else
				self.position.x = math.floor(mapWidth_ - ((Graphics.windowWidth)/self.zoomLevel))
			end

			if tempy >= 0 and tempy <= (mapHeight_ - ((Graphics.windowHeight)/self.zoomLevel)) then
				self.position.y = math.floor(tempy)
			elseif tempy < 0 then
				self.position.y = 0
			else
				self.position.y = math.floor(mapHeight_ - ((Graphics.windowHeight)/self.zoomLevel))
			end
		else
			self.position.x = tempx
			self.position.y = tempy
		end
	end
end
