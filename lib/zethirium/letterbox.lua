-- letterbox.lua

local gfx = love.graphics
local mathFloor = math.floor

local targetWidth = 1920
local targetHeight = 1080
local centerX = 0
local centerY = 0
local scale = 1

local letterbox = {}

-- call to set the logical resolution
function letterbox:setSize( width, height, options )
  targetWidth = width or targetWidth
  targetHeight = height or targetHeight

  self:resize( gfx.getWidth(), gfx.getHeight() )

  if options ~= nil and options.resizable ~= nil then
    love.window.setMode( targetWidth, targetHeight, { resizable = true } )
  end
end

function letterbox:getSize( )
  return targetWidth, targetHeight
end

-- call in love.draw() before you draw your scene objects
function letterbox:beginScene( )
  gfx.push()
  gfx.setScissor( centerX, centerY, gfx.getWidth() - 2 * centerX, gfx.getHeight() - 2 * centerY )
  gfx.translate( centerX, centerY )
  gfx.scale( scale, scale )
end

-- call in love.draw() after you have drawn your scene objects
function letterbox:endScene( )
  gfx.setScissor()
  gfx.pop()
end

-- must be called by love.resize callback to ensure letterboxing values are updated
function letterbox:resize( width, height )
  local sx = width / targetWidth
  local sy = height / targetHeight
  if sx > sy then
    scale = sy
    centerX = ( width - targetWidth * scale ) / 2
    centerY = 0
  else
    scale = sx
    centerX = 0
    centerY = ( height - targetHeight * scale ) / 2
  end
end

-- checks if coordinates are inside the letterboxed display
function letterbox:contains( x, y )
  local a = x >= centerX
  local b = x < gfx.getWidth() - centerX
  local c = y >= centerY
  local d = y < gfx.getHeight() - centerY
  return a and b and c and d
end

-- maps screen coordinates to scaled display coordinates
function letterbox:map( x, y )
  local invScale = 1 / scale
  local tx = mathFloor( ( x - centerX ) * invScale )
  local ty = mathFloor( ( y - centerY ) * invScale )
  return tx, ty
end

return letterbox
