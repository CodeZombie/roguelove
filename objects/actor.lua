Actor = Object:extends{
  objectType = "game_actor",
  solidGroup = {"game_wall", "game_player", "game_npc"},

}


function Actor:update(objectManager_)
  Actor.super.update(self, objectManager_)

  --update movement animation:
  if self.direction == Game.direction.down then
    self:setAnimationSequence("walk_down")
  elseif self.direction == Game.direction.up then
    self:setAnimationSequence("walk_up")
  elseif self.direction == Game.direction.right then
    self:setAnimationSequence("walk_right")
  elseif self.direction == Game.direction.left then
    self:setAnimationSequence("walk_left")
  end

  if self.velocity == 0 then
    self:setAnimationSequence("idle")
  end
end
