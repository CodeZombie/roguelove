GameScene = Scene:extends{
	map = nil
}

function GameScene:__init()
	--self.gameState = GameState:new()
	self.interfaceManager = InterfaceManager:new()

	self.objectManager = ObjectManager:new()

	--generate map:
	self.map = Map:new(128, 128, 5, 10)
	self.map:setSpritesheet("images/map_dungeon.png")

	--find a random room to spawn our player:
	local playerRoom = self.map:getRooms()[math.floor(love.math.random() * table.getn(self.map:getRooms()))]

	local player = self.objectManager:addObject(Player:new((playerRoom.x + math.floor(love.math.random() * playerRoom.width))*16, (playerRoom.y + math.floor(love.math.random() * playerRoom.height))*16))
	player:setSpritesheet("images/characters-1.png")
	player:setAnimationState("blank_idle")
	self.camera = Camera:new(player)

	--fill objectManager up with NPCS:
	for n=1, 128 do
		--local npc = self.objectManager:addObject(NPC:new(64,64))
		local npc = self.objectManager:addObject(NPC:new(16 * math.floor((love.math.random()*(self.mapWidth))/16), 16 * math.floor((love.math.random()*(self.mapWidth))/16)))
		npc:setSpritesheet("images/spritesheet.png")
		npc:setSpriteIndex(math.ceil(love.math.random()*128))
	end

	--fill objectManager up with walls:
	--for n=1, 128 do
	--	local wall = self.objectManager:addObject(Wall:new(16 * math.floor((love.math.random()*self.mapWidth)/16), 16 * math.floor((love.math.random()*self.mapWidth)/16)))
		--	wall:setSpritesheet("images/spritesheet.png")
	--end


	--GameState.init()
	--Map.generate()
	--NPCManager.populate()
	--GameScene.player = Player:new(24,24)

	--Camera.setObjectToFollow(GameScene.player)

	local healthbar = self.interfaceManager:addInterface(InterfaceContainer:new(player, "relative", 0, -.2, "relative", 1, .2))
	healthbar:setClickable(false)
	healthbar:setFillColor({255,0,0})

	local fuck = self.interfaceManager:addInterface(InterfaceContainer:new(nil, "relative", .1, .8, "relative",  .8, .15))
	local fuckTwo = self.interfaceManager:addInterface(InterfaceContainer:new(fuck, "relative", .01, .1, "relative",  .1, .8))
	fuckTwo:setFillColor({0,255,0})
	fuck:setClickable(true)
	fuckTwo:setClickable(true)
end

function GameScene:keyPress(key)
	self.super.keyPress(self,key)

	self.objectManager:keyPress(key)

	if key == "escape" then
		love.event.push('quit')
	end
end

function GameScene:mousePress(x_, y_, button_, istouch_)
	--self.player:checkMouseInput(x, y, button, self.map, self.camera)
	self.interfaceManager:onClick(x_, y_, button_, istouch_, self.camera)
end

function GameScene:update()

	self.objectManager:update()
	self.objectManager:checkCollisions()
	self.camera:update(self.mapWidth, self.mapHeight)
	--self.gameState:update()
end

function GameScene:draw()
	self.map:draw(self.camera)
	--(Camera.objectToFollow.position.x) - (400/Graphics.drawScale) + (Map.tileSize/2)
	self.objectManager:draw(self.camera)

	love.graphics.print("DUNGEON - LEVEL 1", 256+48, 48)
	self.interfaceManager:draw(self.camera)
end
