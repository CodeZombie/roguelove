ObjectManager = class{
	objects = {},
	numberOfObjects = 0,
	maxObjects = 2048,
	idCounter = 1,
}

function ObjectManager:__init()

end

function ObjectManager:isColliding(object_, otherTypes_)
	for n=1, self.numberOfObjects do
		if object_.id ~= self.objects[n].id then
			for _, val in ipairs(otherTypes_) do
				if self.objects[n].objectType == val then
					if object_:checkCollision(self.objects[n]) then
						return true
					end
				end
			end
		end
	end
	return false
end

function ObjectManager:checkCollisions()
	for n=1, self.numberOfObjects do
		for nn=n+1, self.numberOfObjects do
			if self.objects[n]:checkCollision(self.objects[nn]) then
				self.objects[n]:onCollision(self.objects[nn])
				self.objects[nn]:onCollision(self.objects[n])
			end
		end
	end
end

function ObjectManager:keyPress(key_)
	for n=1, self.numberOfObjects do
		self.objects[n]:keyPress(key_)
	end
end

function ObjectManager:keyReleased(key_)
	for n=1, self.numberOfObjects do
		self.objects[n]:keyReleased(key_)
	end
end

function ObjectManager:onClick(x_, y_, button_, isTouch_, camera_)
	for n=1, self.numberOfObjects do
		self.objects[n]:onClick(x_, y_, button_, isTouch_, camera_)
	end
end

function ObjectManager:addObject(object_)
	self.idCounter = self.idCounter + 1
	table.insert(self.objects, object_)
	self.numberOfObjects = self.numberOfObjects + 1
	object_.id = self.idCounter
	return object_
end

function ObjectManager:updateAnimation(time_)
	for n=1, self.numberOfObjects do
		self.objects[n]:updateAnimation(time_)
	end
end

function ObjectManager:update()
	for n=1, self.numberOfObjects do
		self.objects[n]:update(self)
	end

	--y-sorting:
	table.sort( self.objects, function( a, b ) return (a.position.y + a.size.h) < (b.position.y + b.size.h) end)
end

function ObjectManager:draw(camera_)
	for n=1, self.numberOfObjects do
		self.objects[n]:draw(camera_)
	end
end
