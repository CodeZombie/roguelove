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

require 'scene'
require 'scenes/gamescene'
require 'scenes/mainmenuscene'

--generate map
--fill map with monsters
--fill map with loot
--place player in map
--give player some random stats/weapon/abilities


--object will be the class that everything is based around. NPC will be pretty much just like the player, but with ai logic

_ACCUMULATOR = 0
UPDATES_PER_SECOND = 60

pixelFont = nil
CurrentScene = nil

function love.load()
	--load data that will persist across scenes:
	
	--SpriteManager.load("images/spritesheet.png")
	love.graphics.setFont(love.graphics.newFont("fonts/pixel.ttf", 16))
	Graphics.disableSmoothing()
	
	CurrentScene = GameScene:new()
end

function love.keypressed(key)
	CurrentScene:keyPress(key)
	
	if key=="r" then
		CurrentScene = nil
		CurrentScene = GameScene:new()
	end
end

function love.mousepressed(x, y, button, istouch)
	CurrentScene:mousePress(x, y, button, istouch)
end

function love.update(dt)
	_ACCUMULATOR = _ACCUMULATOR + math.ceil(dt*100000)
	while _ACCUMULATOR >= math.ceil(100000/UPDATES_PER_SECOND) do
		CurrentScene:update()
		_ACCUMULATOR = _ACCUMULATOR - math.ceil(100000/UPDATES_PER_SECOND)
	end
end

function love.draw()
	CurrentScene:draw()
end