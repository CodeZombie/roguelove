--self.spriteManager:loadSpriteSheet("images/spritesheet.png", 16)

Game = {
  currentScene = nil,
  timeTicker = 1,
  loopTime = 60
}

function Game.loadResources()
  print("loading resources...")

  local chars = {"images/man.png", "images/woman.png", "images/bat.png", "images/ghost.png", "images/skeleton.png", "images/slime.png", "images/spider.png"}

  for _,v in pairs(chars) do
    local ss = SpritesheetManager.newSpritesheet(v, 16)
    ss:addAnimationSequence({["idle"] = {frames = {2}, framerate = 0}})
    ss:addAnimationSequence({["walk_down"] = {frames = {1, 2, 3, 2}, framerate = 5}})
    ss:addAnimationSequence({["walk_left"] = {frames = {4, 5, 6, 5}, framerate = 5}})
    ss:addAnimationSequence({["walk_right"] = {frames = {7, 8, 9, 8}, framerate = 5}})
    ss:addAnimationSequence({["walk_up"] = {frames = {10, 11, 12, 11}, framerate = 5}})
    ss:addAnimationSequence({["dance"] = {frames = {2, 5, 11, 8}, next="idle", framerate = 3}})
  end

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
  Game.timeTicker = Game.timeTicker + 1
  if Game.timeTicker > Game.loopTime then
    Game.timeTicker = 1
  end
  Game.currentScene:update(Game.timeTicker)
end

function Game.draw()
  Game.currentScene:draw()
end

function Game.deinit()
  print("de-initializing game...")
end
