class = require '30log'
require 'map'
require 'spriteManager'
require 'camera'
require 'graphics'
require 'object'
require 'being'
require 'object'
require 'npc'
require 'player'

--generate map
--fill map with monsters
--fill map with loot
--place player in map
--give player some random stats/weapon/abilities


--object will be the class that everything is based around. NPC will be pretty much just like the player, but with ai logic

DRAWSCALE = 2
TURN = 0 --0 = players turn, 1 = NPC turn


function love.load()
	SpriteManager.load("images/spritesheet.png")
	onCreate()
end

function onCreate()
	Map.generate()
	dude = NPC:new(16, 16)
	player = Player:new(16,16)
	Camera.setObjectToFollow(player)
end

function love.keypressed(key)
	if TURN == 0 then
		player:checkInput(key)
	end
end

function love.update(dt)
	Camera.update()
end

function love.draw()
	love.graphics.setDefaultFilter( "nearest" , "nearest" )
	Map.draw()
	dude:draw()
	player:draw()
end