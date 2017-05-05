class = require '30log'
require 'gamemath'
require 'gamestate'
require 'spriteManager'
require 'camera'
require 'graphics'
require 'objectmanager'
require 'interfacemanager'
require 'interfaceobject'
require 'interfacecontainer'

require 'object'
require 'objects/npc'
require 'objects/player'

require 'scene'
require 'scenes/gamescene'
require 'scenes/mainmenuscene'



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

function checkKeyboard()
	local keys = {"w", "a", "s", "d", " ", "r", "escape"}

	for _,key_ in ipairs(keys) do
		if love.keyboard.isDown(key_) then
			CurrentScene:keyPress(key_)
			if key_ == "r" then
				CurrentScene = nil
				CurrentScene = GameScene:new()
			end
		end
	end
end

function love.mousepressed(x, y, button, istouch)
	CurrentScene:mousePress(x, y, button, istouch)
end

function love.update(dt)
	_ACCUMULATOR = _ACCUMULATOR + math.ceil(dt*100000)
	while _ACCUMULATOR >= math.ceil(100000/UPDATES_PER_SECOND) do
		checkKeyboard()
		CurrentScene:update()
		_ACCUMULATOR = _ACCUMULATOR - math.ceil(100000/UPDATES_PER_SECOND)
	end
end

function love.draw()
	CurrentScene:draw()
end
