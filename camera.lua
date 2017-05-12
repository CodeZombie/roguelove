Camera = class{
	position = {x=0,y=0},
	objectToFollow = nil,
	boundMap = nil
}

function Camera:__init()
end

function Camera:setObjectToFollow(object_)
	self.objectToFollow = object_
end

function Camera:update()
	if self.objectToFollow ~= nil then
		local tempx = (self.objectToFollow.position.x) - ((Graphics.windowWidth/2)/Graphics.drawScale) + (self.objectToFollow.size.w/2)
		local tempy = (self.objectToFollow.position.y) - ((Graphics.windowHeight/2)/Graphics.drawScale) + (self.objectToFollow.size.h/2)
		if self.boundMap ~= nil then
			if tempx >= 0 and tempx <= (mapWidth_ - ((Graphics.windowWidth)/Graphics.drawScale)) then
				self.position.x = math.floor(tempx)
			elseif tempx < 0 then
				self.position.x = 0
			else
				self.position.x = math.floor(mapWidth_ - ((Graphics.windowWidth)/Graphics.drawScale))
			end

			if tempy >= 0 and tempy <= (mapHeight_ - ((Graphics.windowHeight)/Graphics.drawScale)) then
				self.position.y = math.floor(tempy)
			elseif tempy < 0 then
				self.position.y = 0
			else
				self.position.y = math.floor(mapHeight_ - ((Graphics.windowHeight)/Graphics.drawScale))
			end
		else
			self.position.x = tempx
			self.position.y = tempy
		end
	end
end
