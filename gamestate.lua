GameState = class{
	state = 1,
	functions = {}
}

function GameState:__init()

end

function GameState:advance()
	self.state = self.state + 1
	
	if self.state > table.getn(self.functions) then
		self.state = 1
	end
end

function GameState:update()
	self.functions[self.state]()
end

function GameState:addState(f_)
	table.insert(self.functions, f_)
end