local tilemap = {}

-- local tm = tilemap:newTilemap( "assets.data.maps.test_map" )
-- tm.tileWidth
-- tm.tileHeight
-- tm.width
-- tm.height
-- tm.rawLayerData

-- tm:getTileId( layerId, column, row )
-- tm:setTileId( layerId, column, row, tileId )

function tilemap:newTilemap( mapDataPath )
  local mapData = require( mapDataPath )
  local tm = {
    tileWidth = mapData.tileWidth,
    tileHeight = mapData.tileHeight,
    width = mapData.width,
    height = mapData.height,
    rawLayerData = mapData.layerData
  }

  function tm:getTileId( layerId, column, row )
    local index = 1 + ( column + ( row * self.width ) )
    local layer = self.rawLayerData[ layerId ]
    if layer ~= nil then
      return layer[ index ]
    end
    return nil
  end

  function tm:setTileId( layerId, column, row, tileId )
    local index = 1 + ( column + ( row * self.width ) )
    local layer = self.rawLayerData[ layerId ]
    if layer ~= nil then
      if index <= #layer then
        layer[ index ] = tileId
        return true
      end
    end
    return nil
  end

  return tm
end

-- tc = tilemap:newTilemapCamera( cameraWidth, cameraHeight, tm.width, tm.height )
-- tc:moveTo( column, row )

function tilemap:newTilemapCamera( cameraWidth, cameraHeight, mapWidth, mapHeight )
  local tc = {
    x = 0,
    y = 0,
    width = cameraWidth,
    height = cameraHeight
  }

  function tc:moveTo( column, row )
  end

  return tc
end

-- local ts = tilemap:newTileset( "assets/textures/tilesets/test_tiles.png", tm.tileWidth, tm.tileHeight )

function tilemap:newTileset( imagePath, tileWidth, tileHeight )
  local image = love.graphics.newImage( imagePath )
  local imageWidth = image:getWidth()
  local imageHeight = image:getHeight()
  local tilesAcross = imageWidth / tileWidth
  local tilesDown = imageHeight / tileHeight
  local tileCount = tilesAcross * tilesDown
  local quads = {}

  for row=0,tilesDown-1 do
    local y = row * tileHeight
    for column=1,tilesAcross-1 do
      local x = column * tileWidth
      local quad = love.graphics.newQuad( x, y, tileWidth, tileHeight, imageWidth, imageHeight )
      quads[ #quads + 1 ] = quad
    end
  end

  local ts = {
    source = imagePath,
    image = image,
    tileCount = tileCount,
    tileWidth = tileWidth,
    tileHeight = tileHeight,
    quads = quads
  }

  return ts
end

function tilemap:newTilemapRenderer( tm, ts, tc )
  local tr = {
    map = tm,
    tileset = ts,
    camera = tc,
    time = 0
  }

  local batch = love.graphics.newSpriteBatch( ts.image )

  function tr:changeCamera( tc )
    self.camera = tc
  end

  function tr:changeTileset( ts )
    self.tileset = ts
    batch:setTexture( ts.image )
  end

  function tr:changeMap( tm )
    self.map = tm
    batch:clear()
  end

  function tr:update( dt )
    self.time = self.time + dt
    if self.time > 5 then
      self.time = 0
    end
  end

  function tr:drawLayer( layerId, x, y )
  end

  return tr
end

-- local tr = tilemap:newTilemapRenderer( tm, ts, tc )
-- tr:changeCamera( tc )
-- tr:changeTileset( ts )
-- tr:changeMap( tm )
-- tr:update( dt )
-- tr:drawLayer( layerId, x, y )


return tilemap
