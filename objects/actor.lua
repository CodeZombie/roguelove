Actor = Object:extends{
  objectType = "game_actor",
  solidGroup = {"game_wall", "game_player", "game_npc"},

}


function Actor:update(objectManager_)
  Actor.super.update(self, objectManager_)
  if self.velocity.x > 0 and self.velocity.y == 0 then
    self:setAnimationSequence("walk_right")
  elseif self.velocity.x > 0 and self.velocity.y > 0 then
    self:setAnimationSequence("walk_downright")
  elseif self.velocity.x > 0 and self.velocity.y < 0 then
    self:setAnimationSequence("walk_upright")
  elseif self.velocity.x < 0 and self.velocity.y == 0 then
    self:setAnimationSequence("walk_left")
  elseif self.velocity.x < 0 and self.velocity.y > 0 then
    self:setAnimationSequence("walk_downleft")
  elseif self.velocity.x < 0 and self.velocity.y < 0 then
    self:setAnimationSequence("walk_upleft")
  elseif self.velocity.x == 0 and self.velocity.y < 0 then
    self:setAnimationSequence("walk_up")
  elseif self.velocity.x == 0 and self.velocity.y > 0 then
    self:setAnimationSequence("walk_down")
  end

  if self.velocity.x == 0 and self.velocity.y == 0 then
    self:setAnimationSequence("idle")
  end
end
