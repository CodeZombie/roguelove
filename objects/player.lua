Player = Object:extends{
	objectType = "game_player",
	reactsToCollision = true,
	solidGroup = {"game_wall", "game_npc"},
	size = {w=16,h=16},
	--directionStack = {first = Game.direction.up, second = 0, third = 0, fourth = 0}
	directionStack = {} --stacks movement to keep track of which keys are pressed and in what order to make keymovement as natural as possible
}
function Player:__init(x,y)
	Player.super.__init(self, x,y)
	self:setAnimationSequence("idle")
end

function Player:addDirectionToStack(dir_)
	for i,_ in pairs(self.directionStack) do
		if self.directionStack[i] == dir_ then
			return
		end
	end
	local dslen = table.getn(self.directionStack)
	table.insert(self.directionStack, dir_)
end

function Player:removeDirectionFromStack(dir_)
	for i,_ in pairs(self.directionStack) do
		if self.directionStack[i] == dir_ then
			table.remove(self.directionStack, i)
		end
	end
end

function Player:update(objectManager_)
	Player.super.update(self, objectManager_)
	if table.getn(self.directionStack) > 0 then
		self:addVelocity(self.directionStack[table.getn(self.directionStack)], 1)
	end
end

function Player:keyPress(key_)
	Player.super.keyPress(self, key_)

	if key_ == "w" then
		self:addDirectionToStack(Game.direction.up)
	elseif key_ == "s" then
		self:addDirectionToStack(Game.direction.down)
	elseif key_ == "a" then
		self:addDirectionToStack(Game.direction.left)
	elseif key_ == "d" then
		self:addDirectionToStack(Game.direction.right)
	end

	if key_ == "r" then
		self:setAnimationSequence("dance")
	end
end

function Player:keyReleased(key_)
	Player.super.keyReleased(self, key_)
	if key_ == "w" then
		self:removeDirectionFromStack(Game.direction.up)
	elseif key_ == "s" then
		self:removeDirectionFromStack(Game.direction.down)
	elseif key_ == "a" then
		self:removeDirectionFromStack(Game.direction.left)
	elseif key_ == "d" then
		self:removeDirectionFromStack(Game.direction.right)
	end
end

function Player:onCollision(other_)
	Player.super.onCollision(self, other_)
end

function Player:checkMouseInput(x_, y_, button_, map_, camera_)
	if button_ == 1 then

		--generate the screen-relative position of the player
		local centerX = (self.position.x - camera_.position.x + (map_.tileSize/2)) * Graphics.drawScale
		local centerY = (self.position.y - camera_.position.y + (map_.tileSize/2)) * Graphics.drawScale

		--check which triangle the mouse is in...
		if GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = Graphics.windowWidth, y = 0}, {x = centerX, y = centerY}) then
			--self:move("up", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = Graphics.windowHeight}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("down", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = 0, y = 0}, {x = 0, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("left", map_)
		elseif GameMath.pointInTriangle({x=x_,y=y_}, {x = Graphics.windowWidth, y = 0}, {x = Graphics.windowWidth, y = Graphics.windowHeight}, {x = centerX, y = centerY}) then
			--self:move("right", map_)
		end
	end
end

function Player:kill()
	--game restarts
end

function Player:draw(spriteManager_, camera_)
	Player.super.draw(self, spriteManager_, camera_)
end
