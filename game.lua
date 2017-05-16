Game = {
  direction = { up = 1, right = 2, down = 3, left = 4, upright = 5, upleft = 6, downright = 7, downleft = 8},
  debug = true,
  currentScene = nil,
  timeTicker = 1,
  loopTime = 60
}

function Game.loadResources()
  print("loading resources...")

  local chars = {"images/man.png", "images/woman.png", "images/bat.png", "images/ghost.png", "images/skeleton.png", "images/slime.png", "images/spider.png"}

  for _,v in pairs(chars) do
    local ss = SpritesheetManager.newSpritesheet(v, {w=16, h=16})
    ss:addAnimationSequence({["idle"] = {frames = {2}, framerate = 0}})
    ss:addAnimationSequence({["walk_down"] = {frames = {1, 2, 3, 2}, framerate = 5}})
    ss:addAnimationSequence({["walk_left"] = {frames = {4, 5, 6, 5}, framerate = 5}})
    ss:addAnimationSequence({["walk_right"] = {frames = {7, 8, 9, 8}, framerate = 5}})
    ss:addAnimationSequence({["walk_up"] = {frames = {10, 11, 12, 11}, framerate = 5}})
    ss:addAnimationSequence({["dance"] = {frames = {2, 5, 11, 8}, next="idle", framerate = 3}})
  end

  local tp = SpritesheetManager.newSpritesheet("images/tallplayer.png", {w=16,h=32})
  tp:addAnimationSequence({["idle"] = {frames = {7}, framerate = 0}})
  tp:addAnimationSequence({["walk_down"] = {frames = {7}, framerate = 0}})
  tp:addAnimationSequence({["walk_left"] = {frames = {3}, framerate = 0}})
  tp:addAnimationSequence({["walk_right"] = {frames = {1}, framerate = 0}})
  tp:addAnimationSequence({["walk_up"] = {frames = {5}, framerate = 0}})
  tp:addAnimationSequence({["dance"] = {frames = {1,2,3,4,5,6,7,8}, next="idle", framerate = 5}})

  SpritesheetManager.newSpritesheet("images/map_dungeon.png", {w=16, h=16})
  local mem = SpritesheetManager.newSpritesheet("images/spritesheet.png", {w=16, h=16})
  mem:addAnimationSequence({["wall"] = {frames = {22}}})
end

function Game.logError(msg_)
  if Game.debug == true then
    print("ERROR: " .. msg_)
  end
end

function Game.init()
  print("initializing game...")
  love.graphics.setFont(love.graphics.newFont("fonts/pixel.ttf", 16))
  Graphics.disableSmoothing()
  Graphics.createWindow()
  print("starting game...")
  Game.currentScene = GameScene:new()
end

function Game.mousePress(x, y, button, istouch)
  Game.currentScene:mousePress(x, y, button, istouch)
end

function Game.keyPress(key_)
  Game.currentScene:keyPress(key_)
end

function Game.keyReleased(key_)
  Game.currentScene:keyReleased(key_)
end

function Game.resize(width_, height_)
  Graphics.resize(width_, height_)
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

function Game.quit()
  print("de-initializing game...")
end
