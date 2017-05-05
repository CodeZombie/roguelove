GameScene = Scene:extends{
}

function GameScene:__init()
	self.spriteManager = SpriteManager:new()

	self.spriteManager:loadSpriteSheet("images/spritesheet.png", 16)

	--self.gameState = GameState:new()
	self.interfaceManager = InterfaceManager:new()

	self.objectManager = ObjectManager:new()

	local player = self.objectManager:addObject(Player:new(128,128))
	self.camera = Camera:new(player)

	--fill objectManager up with NPCS:
	for n=1, 24 do
		local npc = self.objectManager:addObject(NPC:new(64,64))
		npc:setSpriteIndex(math.ceil(love.math.random()*128))
	end

	--fill objectManager up with walls:
	for n=1, 128 do
		local wall = self.objectManager:addObject(NPC:new(16 * math.floor((love.math.random()*self.mapWidth)/16), 16 * math.floor((love.math.random()*self.mapWidth)/16)))
		wall:setSpriteIndex(61)
		wall:setObjectType("wall")
	end


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
	--(Camera.objectToFollow.position.x) - (400/Graphics.drawScale) + (Map.tileSize/2)
	self.objectManager:draw(self.spriteManager, self.camera)

	love.graphics.print("DUNGEON - LEVEL 1", 256+48, 48)
	self.interfaceManager:draw(self.spriteManager, self.camera)
end
