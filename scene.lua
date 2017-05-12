Scene = class{
  objectManager = nil,
  interfaceManager = nil,
  gameState = nil,
  camera = nil,
  mapWidth = 512,
  mapHeight = 512
}

function Scene:__init()
  self.interfaceManager = InterfaceManager:new()

	self.objectManager = ObjectManager:new()

  self.camera = Camera:new()
end

function Scene:keyPress(key)
  self.objectManager:keyPress(key)
end

function Scene:keyReleased(key_)
  self.objectManager:keyReleased(key_)
end

function Scene:mousePress(x_, y_, button_, istouch_)
  self.interfaceManager:onClick(x_, y_, button_, istouch_, self.camera)
end

function Scene:update(time_)
  self.objectManager:update()
	self.objectManager:checkCollisions()
	self.objectManager:updateAnimation(time_)
  self.camera:update()
end

function Scene:draw()
	self.objectManager:draw(self.camera)
	self.interfaceManager:draw(self.camera)
end
