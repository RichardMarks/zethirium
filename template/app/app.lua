local Z = require( "lib.zethirium.zethirium" )
local cfg = require( "app.configuration" )

local sceneManager = Z.scenemanager

local app = {}

function app:create( )
  -- if you want pixel art rendering, uncomment this line
  -- love.graphics.setDefaultFilter( "nearest", "nearest" )

  -- register scenes
  sceneManager:register( "title", "app.scenes.title" )
  sceneManager:register( "credits", "app.scenes.credits" )
  sceneManager:register( "game", "app.scenes.game" )

  -- push the title scene
  sceneManager:push( "title" )
end

function app:update( dt )
  -- when there are no scenes, the game will quit
  if sceneManager:top() == nil then
    Z:quitToOS()
    return
  end
  sceneManager:callback( "update", dt )
end

function app:draw( )
  sceneManager:callback( "draw" )
end

function app:click( x, y )
  sceneManager:callback( "click", x, y )
end

function app:keypressed( key )
  sceneManager:callback( "keypressed", key )
  -- pressing f19 will quit the game
  -- this is so that you can use the escape key in your game logic
  if key == "f19" then
    Z:quitToOS()
  end
end

return app
