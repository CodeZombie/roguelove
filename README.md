# roguelove
2d RPG game engine built from scratch with Love2d

### features
 * Object-oriented with [30log](https://github.com/Yonaba/30log)
 * Expressive entity system
 * On-screen logging system
 * Fixed [Timestep](http://vodacek.zvb.cz/archiv/681.html)
 * Easy to use animation system
 * User-interface system based on tree-graph nodes
 * Built-in dungeon generator, with several dynamic properties.
 * Scene manager
 
![Screenshot](https://i.imgur.com/jUXS1D2.png)
 
### Entities
Create a new class that extends Actor or Object inside the /objects folder.  
Behavior can be programmed into this new entity through several functions called by roguelove:  

`function NewEntity:update(objectManager_)`  
`function NewEntity:keyPress(key_)`  
`function NewEntity:onClick(x_, y_, button_, map_, camera_)`  
`function NewEntity:kill()`  
`function Player:draw(camera_)`  

### Dungeon Generator
Dungeons can be generated as maps and inserted directly into the game.  
Dungeons will have a programmer-specified number of rooms, each connected by some path.  

Inside your scene initializer, instantiate a new map:

`self.map = Map:new(32, 64, 5, 6)`  

pass it a spritesheet so it can draw...   
`self.map:setSpritesheet("images/map_dungeon.png")`   

Individual rooms within the map can be accessed programmatically with:  
`local playerRoom = self.map:getRooms()[1]`  
where `1` is any value between `1` and `table.getn(self.map:getRooms())`  

### Scenes

Create a new class that extends `Scene` inside /scenes.  
The following inherited methods will allow the scene to perform actions:

`function NewScene:keyPress(key_)`  
`function NewScene.onUpdate()`  
`function NewScene.mousePress(x, y, button, istouch)`  
`function NewScene.draw()`  
`function NewScene.close()`  





