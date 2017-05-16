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
require 'objects/actor'
require 'objects/npc'
require 'objects/player'
require 'objects/wall'

require 'scene'
require 'scenes/gamescene'
require 'scenes/mainmenuscene'

_ACCUMULATOR = 0
UPDATES_PER_SECOND = 60
pressedKeys = {} --array containing pressed keys, in the order they were pressed NOTE NOTE NOTE: move this shit into game.lua

function love.load()
	Game.loadResources()
	Game.init()
end

function tableContains(table_, element_)
	for _,v in ipairs(table_) do
		if v == element_ then
			return true
		end
	end
	return false
end

function love.resize(w_, h_)
	Game.resize(w_, h_)
end

function checkKeyboard()
	local keys = {"w", "s", "a", "d", " ", "r", "o", "p", "escape"} --eventually this will be handled a little neater. (config file or something)

	for _,key_ in ipairs(keys) do
		if love.keyboard.isDown(key_) then --if a key is pressed
			if tableContains(pressedKeys, key_) == false then --if this key is not already being pressed
				table.insert(pressedKeys, key_) --add it to array of pressed keys
			end
		end
	end

	for _,v in ipairs(pressedKeys) do --for each key pressed, in the order they are pressed
		Game.keyPress(v)
	end
end

function love.keyreleased(key_)
	for i,v in ipairs(pressedKeys) do
		if v == key_ then
			table.remove(pressedKeys, i)
		end
	end

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
		collectgarbage()
		_ACCUMULATOR = _ACCUMULATOR - math.ceil(100000/UPDATES_PER_SECOND)
	end
end

function love.draw()
	Game.draw()
end

function love.quit()
	Game.quit()
end
