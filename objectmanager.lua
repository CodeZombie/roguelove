ObjectManager = class{
	objects = {},
	numberOfObjects = 0,
	maxObjects = 2048,
	idCounter = 1,
}

function ObjectManager:__init()
	self.NPCs = {}

	--for n = 1, self.maxNPCs do
	--	table.insert(self.NPCs, NPC:new(16,16))
	--	self.NPCs[n]:setSpriteIndex(math.ceil(love.math.random()*128))
	--	self.NPCs[n]:setObjectType("NPC")
	--end
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

function ObjectManager:addObject(object_)
	self.idCounter = self.idCounter + 1
	table.insert(self.objects, object_)
	self.numberOfObjects = self.numberOfObjects + 1
	object_.id = self.idCounter
	return object_
end

function ObjectManager:update()
	for n=1, self.numberOfObjects do
		self.objects[n]:update(self)
	end
end

function ObjectManager:draw(spriteManager_, camera_)
	for n=1, self.numberOfObjects do
		self.objects[n]:draw(spriteManager_, camera_)
	end
end
