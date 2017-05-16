GameScene = Scene:extends{
	map = nil
}

function GameScene:__init()
	self.super.__init(self)

	--generate map:
	self.map = Map:new(32, 64, 5, 6)
	self.map:setSpritesheet("images/map_dungeon.png")

	--find a random room to spawn our player:
	local playerRoom = self.map:getRooms()[1]

	local player = self.objectManager:addObject(Player:new((playerRoom.x + math.floor(love.math.random() * playerRoom.width))*16, (playerRoom.y + math.floor(love.math.random() * playerRoom.height))*16))
	--local player = self.objectManager:addObject(Player:new(0, 0))
	self.camera:setObjectToFollow(player)


	--fill objectManager up with NPCS:
	for n=1, 128 do
		--local npc = self.objectManager:addObject(NPC:new(16 * math.floor((love.math.random()*(self.mapWidth))/16), 16 * math.floor((love.math.random()*(self.mapWidth))/16)))
		local npc = self.objectManager:addObject(NPC:new(love.math.random()*256,love.math.random()*256))
		npc:setSpritesheet("images/slime.png")
		npc:setAnimationSequence("idle")
	end


	--fill objectManager up with walls:
	for n=1, 128 do
		local wall = self.objectManager:addObject(Wall:new(16 * math.floor((love.math.random()*self.mapWidth)/16), 16 * math.floor((love.math.random()*self.mapWidth)/16)))
		end


	local healthbar = self.interfaceManager:addInterface(InterfaceContainer:new(player, "relative", 0, -.2, "relative", 1, .2))
	healthbar:setClickable(false)
	healthbar:setFillColor({255,0,0})

	local fuck = self.interfaceManager:addInterface(InterfaceContainer:new(nil, "relative", .1, .8, "relative",  .8, .15))
	local fuckTwo = self.interfaceManager:addInterface(InterfaceContainer:new(fuck, "relative", .01, .1, "relative",  .1, .8))
	fuckTwo:setFillColor({0,255,0})
	fuck:setClickable(true)
	fuckTwo:setClickable(true)
end

function GameScene:keyPress(key_)
	self.super.keyPress(self,key_)
	if key_ == "escape" then
		love.event.push('quit')
	end

	if key_ == "o" then
		self.camera.zoomLevel = self.camera.zoomLevel - .1
	end

	if key_ == "p" then
		self.camera.zoomLevel = self.camera.zoomLevel + .1
	end

end

function GameScene:mousePress(x_, y_, button_, istouch_)
	self.super.mousePress(self, x_, y_, button_, istouch_)
end

function GameScene:update(time_)
	self.super.update(self, time_)
end

function GameScene:draw()
	self.map:draw(self.camera)

	self.super.draw(self)
	love.graphics.print("DUNGEON - LEVEL 1", 256+48, 48)
end
