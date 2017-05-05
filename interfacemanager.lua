InterfaceManager = class{
	interfaces = {},
	numberOfInterfaces = 0,
	maxInterfaces = 2048,
	idCounter = 0,
}

function InterfaceManager:__init()

end

function InterfaceManager:onClick(x_, y_, button_, istouch_, camera_)
  for n=self.numberOfInterfaces, 1, -1 do --traverse backward to hit the top level elements first
    if self.interfaces[n].clickable == true then
      --check to see if the mouse clicked inside the bounds of this item:
      local p = self.interfaces[n]:getAbsolutePosition(camera_)
      local s = self.interfaces[n]:getAbsoluteSize(camera_)
      if x_ >= p.x and y_ >= p.y and x_ <= p.x + s.w and y_ <= p.y + s.h then
		      self.interfaces[n]:onClick(x_, y_, button_, istouch_)
          return --we only want to click on one element at a time. None of that clicking through to stuff underneath bullshit.
      end
    end
	end
end

function InterfaceManager:addInterface(interface_)
	self.idCounter = self.idCounter + 1
	table.insert(self.interfaces, interface_)
	self.numberOfInterfaces = self.numberOfInterfaces + 1
	interface_.id = self.idCounter
	return interface_
end

function InterfaceManager:draw(spriteManager_, camera_)
	for n=1, self.numberOfInterfaces do
		self.interfaces[n]:draw(spriteManager_, camera_)
	end
end
