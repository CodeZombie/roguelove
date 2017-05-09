InterfaceObject = class{
	id = 0,
  positionType = "absolute", --absolute or relative
  sizeType = "absolute", --absolute or relative
	position = {x=0, y=0}, --if positionType is absolute, these are pixels, if relative, these are between 0 and 1 within the parent bounds (if parent is nil, we use the screen)
  size = {w=32, h=32},--if sizeType is absolute, these are pixels, if relative, these are between 0 and 1 within the parent bounds (if parent is nil, we use the screen)
  type = "interfaceobject",
	subtype = "interface_generic",
  parent = nil,
  clickable = true
}

function InterfaceObject:__init(parent_, posType_, x_, y_, sizeType_,  w_, h_)
  self.parent = parent_
  self.positionType = posType_
  self.sizeType = sizeType_
	self.position.x, self.position.y = x_, y_
  self.size.w, self.size.h = w_, h_
end

function InterfaceObject:setClickable(b_)
  self.clickable = b_
end

function InterfaceObject:onClick(x_, y_, button_, istouch_)
		print(self.id)
end

function InterfaceObject:getAbsolutePosition(camera_)
  if self.positionType == "absolute" then
    return self.position --handle absolute positioning. Very easy :)
  end

  --determine parent position:
  if self.parent == nil then
    parentPos = {x = 0, y = 0}
    parentSize = {w = Graphics.windowWidth, h = Graphics.windowHeight}
  else
    if self.parent.type == "interfaceobject" then
      parentPos = self.parent:getAbsolutePosition(camera_)
      parentSize = self.parent:getAbsoluteSize(camera_)
    else
      parentPos = {x = (self.parent.position.x - camera_.position.x) * Graphics.drawScale, y = (self.parent.position.y - camera_.position.y) * Graphics.drawScale}
      parentSize = {w = self.parent.size.w * Graphics.drawScale, h = self.parent.size.h * Graphics.drawScale}
    end
  end

  return {x = parentPos.x + (self.position.x * parentSize.w), y = parentPos.y + (self.position.y * parentSize.h)}
end

function InterfaceObject:getAbsoluteSize(camera_)
  if self.sizeType == "absolute" then
    return self.size --handle absolute positioning. Very easy :)
  end

  --determine parent position:
  if self.parent == nil then
    parentSize = {w = Graphics.windowWidth, h = Graphics.windowHeight}
  else
    if self.parent.type == "interfaceobject" then
      parentSize = self.parent:getAbsoluteSize(camera_)
    else
      parentSize = {w = self.parent.size.w * Graphics.drawScale, h = self.parent.size.h * Graphics.drawScale}
    end
  end

  return {w = self.size.w * parentSize.w, h = self.size.h * parentSize.h}
end

function InterfaceObject:draw(camera_)
  --if parent is a gameObject (game_generic, game_npc, game_player, etc), then it needs to be bound to the camera
end
