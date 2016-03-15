Being = Object:extends{
	finishedTurn = false,
	moves = 0
}


function Being:__init(x,y)
	Being.super.__init(self, x,y)
end

function Being:attack(other_)
	--or something like this...
end	

function Being:startTurn()
	self.finishedTurn = false
end

function Being:onMoved() --after moving
	Being.super.onMoved(self)
	self.finishedTurn = true -- this should ideally be placed in a function that gets called after you move OR perform a turn action
	self.moves = self.moves + 1
end

function Being:onMoveFailed()
	Being.super.onMoveFailed(self)
	self.moves = self.moves + 1
end
	
	
function Being:draw(spriteManager_, camera_)
	Being.super.draw(self, spriteManager_, camera_)
end