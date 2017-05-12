class = require '30log'
require 'gamemath'
require 'game'
require 'gamestate'
require 'spritesheet'
require 'spritesheetManager'
require 'map'
require 'camera'
require 'graphics'
require 'objectmanager'
require 'interfacemanager'
require 'interfaceobject'
require 'interfacecontainer'

require 'object'
require 'objects/npc'
require 'objects/player'
require 'objects/wall'

require 'scene'
require 'scenes/gamescene'
require 'scenes/mainmenuscene'

_ACCUMULATOR = 0
UPDATES_PER_SECOND = 60

function love.load()
	Game.loadResources()
	Game.init()
end

function checkKeyboard()
	local keys = {"w", "s", "a", "d", " ", "r", "o", "p", "escape"} --eventually this will be handled a little neater. (config file or something)

	for _,key_ in ipairs(keys) do
		if love.keyboard.isDown(key_) then
			Game.keyPress(key_)
		end
	end
end

function love.keyreleased(key_)
	Game.keyReleased(key_)
end

function love.mousepressed(x, y, button, istouch)
	Game.mousePress(x, y, button, istouch)
end

function love.update(dt)
	_ACCUMULATOR = _ACCUMULATOR + math.ceil(dt*100000)
	while _ACCUMULATOR >= math.ceil(100000/UPDATES_PER_SECOND) do
		checkKeyboard()
		Game.update()
		_ACCUMULATOR = _ACCUMULATOR - math.ceil(100000/UPDATES_PER_SECOND)
	end
end

function love.draw()
	Game.draw()
end
