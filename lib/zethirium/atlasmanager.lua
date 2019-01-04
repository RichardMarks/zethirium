local atlasManager = {}
local atlases = {}

-- local inspect = require( "lib.inspect" )

function atlasManager:load( id, atlasPath, imagePath )
  if atlases[ id ] ~= nil then
    return atlases[ id ]
  end

  local sheetInfo = require( atlasPath )
  local sheetWidth = sheetInfo.sheet.sheetContentWidth
  local sheetHeight = sheetInfo.sheet.sheetContentHeight
  local frames = sheetInfo.sheet.frames
  local frameLookup = sheetInfo.frameIndex

  local quads = {}

  for i=1,#frames do
    local frame = frames[ i ]
    local x = frame.x
    local y = frame.y
    local width = frame.width
    local height = frame.height
    local quad = love.graphics.newQuad( x, y, width, height, sheetWidth, sheetHeight )
    quads[ #quads + 1 ] = quad
  end

  local atlas = {
    id = id,
    image = love.graphics.newImage( imagePath ),
    width = sheetWidth,
    height = sheetHeight,
    quads = quads,
    quadFor = function( self, frameId )
      local frameIndex = frameLookup[ frameId ]
      local quad = quads[ frameIndex ]
      return quad
    end
  }

  atlases[ id ] = atlas

  return atlas
end

function atlasManager:getFrame( atlasId, frameId )
  local atlas = atlases[ atlasId ]
  if atlas ~= nil then
    local quad = atlas:quadFor( frameId )
    if quad ~= nil then
      local _, _, w, h = quad:getViewport()
      local frame = {
        image = atlas.image,
        quad = quad,
        width = w,
        height = h
      }
      return frame
    end
  end
  return nil
end

return atlasManager
