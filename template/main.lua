local Z = require( "lib.zethirium.zethirium" )
local letterbox = Z.letterbox

local app = require( "app.app" )
local cfg = require( "app.configuration" )

function love.focus( hasFocus )
  if hasFocus then
    -- window has gained focus
  else
    -- window has lost focus
  end
end

function love.mousefocus( hasFocus )
  if hasFocus then
    -- window has gained mouse focus
  else
    -- window has lost mouse focus
  end
end

function love.visible( isVisible )
  if isVisible then
    -- window is maximized/restored to normal
  else
    -- window is minimized/hidden
  end
end

function love.mousemoved( x, y, dx, dy, isTouch )
  -- x: number - mouse x position
  -- y: number - mouse y position
  -- dx: number - amount mouse moved along x since last call
  -- dy: number - amount mouse moved along y since last call
  -- isTouch: boolean - true is press is from touchscreen
end

function love.mousepressed( x, y, button, isTouch )
end

function love.mousereleased( x, y, button, isTouch )
  if letterbox:contains( x, y ) then
    local mx, my = letterbox:map( x, y )
    app:click( mx, my )
  end
end

function love.wheelmoved( x, y )
  -- x: number - amount of horizontal wheel movement positive is to the right
  -- y: number - amount of vertical movement positive is upward
end

function love.load( cmdLineArgs )
  letterbox:setSize( cfg.logicalWidth, cfg.logicalHeight )
  app:create()
end

function love.resize( w, h )
  -- window has been resized
  letterbox:resize( w, h )
end

function love.draw( )
  local color = cfg.backgroundColor
  love.graphics.clear( color.r, color.g, color.b )
  letterbox:beginScene()
  app:draw()
  letterbox:endScene()
end

function love.keypressed( key )
  app:keypressed( key )
end

function love.update( dt )
  app:update( dt )
end
