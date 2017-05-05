Wall = Object:extends{
	objectType = "game_wall",
	reactsToCollision = false,
	spriteIndex = 61
}
function Wall:__init(x,y)
	Wall.super.__init(self, x,y)
end

function Wall:update(objectManager_)
	Wall.super.update(self, objectManager_)
end

function Wall:kill()
end

function Wall:draw(spriteManager_, camera_)
	Wall.super.draw(self, spriteManager_, camera_)
end
