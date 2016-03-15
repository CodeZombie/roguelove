class = require '30log'
require 'gamemath'
require 'gamestate'
require 'map'
require 'spriteManager'
require 'camera'
require 'graphics'
require 'object'
require 'being'
require 'object'
require 'npc'
require 'npcmanager'
require 'player'

--generate map
--fill map with monsters
--fill map with loot
--place player in map
--give player some random stats/weapon/abilities


--object will be the class that everything is based around. NPC will be pretty much just like the player, but with ai logic

_ACCUMULATOR = 0
UPDATES_PER_SECOND = 60

function love.load()
	SpriteManager.load("images/spritesheet.png")
	onCreate()
end

function onCreate()
	Map.generate()
	NPCManager.populate()
	player = Player:new(24,24)
	Camera.setObjectToFollow(player)
	Graphics.disableSmoothing()
	
	-----------------------------------------------------------------------
	-- this is the turn-manager
	-- it works by starting the players turn
	-- then it waits for the player to finish their turn
	-- then it starts the NPCmanager turn
	-- then it waits for the NPCmanager to finish it's turn, then restarts
	-----------------------------------------------------------------------
	GameState.addState(	function()
							player:startTurn()
							GameState.advance()
						end)
						
	GameState.addState(	function() 
							if player.finishedTurn then
								GameState.advance() 
							end
						end)
						
	GameState.addState(	function() 
							NPCManager.startTurn()
							GameState.advance() 
						end)
						
	GameState.addState(	function() 
							if NPCManager.finishedTurn then
								GameState.advance() 
							end 
						end)
end

function love.keypressed(key)
	if GameState.state == 2 then --if it's the players turn...
		player:checkInput(key)
	end
	
	if key == "escape" then
		love.event.push('quit')
	end
end

function love.mousepressed(x, y, button, istouch)
	if GameState.state == 2 then
		player:checkMouseInput(x, y, button)
	end
end

function love.update(dt)
	_ACCUMULATOR = _ACCUMULATOR + math.ceil(dt*100000)
	while _ACCUMULATOR >= math.ceil(100000/UPDATES_PER_SECOND) do
		updateGame()
		_ACCUMULATOR = _ACCUMULATOR - math.ceil(100000/UPDATES_PER_SECOND)
	end
end

function updateGame()
	player:update()
	--if GameState.state == 4 then
		NPCManager.update()
	--end
	Camera.update()	
	GameState.update()
end

function love.draw()
	--(Camera.objectToFollow.position.x) - (400/Graphics.drawScale) + (Map.tileSize/2)
	Map.draw()
	NPCManager.draw()
	player:draw()
	--love.graphics.print("Player moves: " .. string.format("%i",player.moves), 16, 32) -- draw bools onscren
	--love.graphics.print("NPC moves: " .. string.format("%i",NPCManager.NPCs[1].moves), 16, 48) -- draw bools onscren
end