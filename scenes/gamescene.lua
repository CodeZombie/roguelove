GameScene = Scene:extends{
	player = nil,
	gameState = nil,
	map = nil,
	npcManager = nil,
	camera = nil,
	spriteManager = nil
}

function GameScene:__init()
	love.graphics.setBackgroundColor( 0,0,0 )
	self.spriteManager = SpriteManager:new()
	self.map = Map:new(128, 96)
	self.map:newGen()
	self.map:detail()
	print(table.getn(self.map.rooms))
	self.spriteManager:loadSpriteSheet("images/spritesheet.png", self.map.tileSize)
	
	self.gameState = GameState:new()
	
	self.npcManager = NPCManager:new()
	
	self.player = Player:new(64,48)
	self.camera = Camera:new(self.player)
	--GameState.init()
	--Map.generate()
	--NPCManager.populate()
	--GameScene.player = Player:new(24,24)
	
	
	
	--Camera.setObjectToFollow(GameScene.player)

	
	self.gameState:addState(function()
								self.player:startTurn()
								self.gameState:advance()
							end)
						
	self.gameState:addState(function() 
								if self.player.finishedTurn then
									self.gameState:advance() 
								end
							end)
						
	self.gameState:addState(function() 
								self.npcManager:startTurn(self.map)
								self.gameState:advance() 
							end)
						
	self.gameState:addState(function() 
								if self.npcManager.finishedTurn then
									self.gameState:advance() 
								end 
							end)
end

function GameScene:keyPress(key)
	if self.gameState.state == 2 then --if it's the players turn...
		self.player:checkInput(key, self.map)
	end
	
	if key == "escape" then
		love.event.push('quit')
	end
end

function GameScene:mousePress(x, y, button, istouch)
	if self.gameState.state == 2 then
		self.player:checkMouseInput(x, y, button, self.map, self.camera)
	end
end

function GameScene:update()
	self.player:update()
	self.npcManager:update()
	self.camera:update(self.map)	
	self.gameState:update()
end

function GameScene:draw()
	--(Camera.objectToFollow.position.x) - (400/Graphics.drawScale) + (Map.tileSize/2)
	self.map:draw(self.spriteManager, self.camera)
	self.npcManager:draw(self.spriteManager, self.camera)
	self.player:draw(self.spriteManager, self.camera)
	love.graphics.print("DUNGEON - LEVEL 1", 256+48, 48)
	--love.graphics.print("Player moves: " .. string.format("%i",player.moves), 16, 32) -- draw bools onscren
	--love.graphics.print("NPC moves: " .. string.format("%i",NPCManager.NPCs[1].moves), 16, 48) -- draw bools onscren
end