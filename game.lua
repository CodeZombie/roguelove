--self.spriteManager:loadSpriteSheet("images/spritesheet.png", 16)

Game = {
  currentScene = nil
}

function Game.loadResources()
  print("loading resources...")
  SpritesheetManager.newSpritesheet("images/spritesheet.png", 16)

  local ss = SpritesheetManager.newSpritesheet("images/characters-1.png", 16)
  ss:addAnimationScenes({["idle"] = {2}})
  ss:addAnimationScenes({["walk_down"] = {1, 2, 3, 2}})
  ss:addAnimationScenes({["walk_left"] = {13, 14, 15, 14}})
  ss:addAnimationScenes({["walk_right"] = {25, 26, 27, 26}})
  ss:addAnimationScenes({["walk_up"] = {37, 38, 39, 38}})

  SpritesheetManager.newSpritesheet("images/map_dungeon.png", 16)
end

function Game.init()
  print("initializing game...")
  love.graphics.setFont(love.graphics.newFont("fonts/pixel.ttf", 16))
  Graphics.disableSmoothing()
  print("starting game...")
  Game.currentScene = GameScene:new()
end

function Game.mousePress(x, y, button, istouch)
  Game.currentScene:mousePress(x, y, button, istouch)
end

function Game.keyPress(key_)
  Game.currentScene:keyPress(key_)
  if key_ == "o" then
    Graphics.drawScale = Graphics.drawScale - 1
  end

  if key_ == "p" then
    Graphics.drawScale = Graphics.drawScale + 1
  end
end

function Game.update()
  Game.currentScene:update()
end

function Game.draw()
  Game.currentScene:draw()
end

function Game.deinit()
  print("de-initializing game...")
end
