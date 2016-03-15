GameState = {
	state = 1,
	functions = {}
}

function GameState.advance()
	GameState.state = GameState.state + 1
	
	if GameState.state > table.getn(GameState.functions) then
		GameState.state = 1
	end
end

function GameState.update()
	GameState.functions[GameState.state]()
end

function GameState.addState(f_)
	table.insert(GameState.functions, f_)
end