SpritesheetManager = {
	spritesheets = {}
}

function SpritesheetManager.newSpritesheet(filename_, tileSize_)
	if(SpritesheetManager.spritesheets[filename_] ~= nil) then
		--error, sprite already exists
		return -1
	end
	local ss = Spritesheet:new(filename_, tileSize_, idIterator)
	--error check here please!
	SpritesheetManager.spritesheets[filename_] = ss
	return ss
end

function SpritesheetManager.draw(filename_, quadIndex_, x_, y_, w_, h_, camera_)
	if SpritesheetManager.spritesheets[filename_] == nil then
		--error, invalid spritesheet
		print("Error, invalid spritesheet filename")
		return -1
	end
	SpritesheetManager.spritesheets[filename_]:draw(quadIndex_, x_, y_, w_, h_, camera_)
end
