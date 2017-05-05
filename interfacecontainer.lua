InterfaceContainer = InterfaceObject:extends{
  fillColor = {0, 0, 0}
}

function InterfaceContainer:__init(parent_, posType_, x_, y_, sizeType_,  w_, h_)
	InterfaceContainer.super.__init(self, parent_, posType_, x_, y_, sizeType_,  w_, h_)
  self.fillColor = {128, 20, 250}
end

function InterfaceContainer:setFillColor(color_)
  self.fillColor = color_
end

function InterfaceContainer:draw(spriteManager_, camera_)
  InterfaceContainer.super.draw(self, spriteManager_, camera_)
  --generate absolute pos/size
  p = self:getAbsolutePosition(camera_)
  s = self:getAbsoluteSize(camera_)
  Graphics.drawRectangle("fill", p.x, p.y, s.w, s.h, 0, 0, 0, self.fillColor)
end
