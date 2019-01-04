-- local inspect = require( "lib.inspect" )

local pattern = '[%z\1-\127\194-\244][\128-\191]*'

local function relativePosition( position, length )
  if position < 0 then
    position = length + position + 1
  end
  return position
end

local utf8 = {}

function utf8:map( s, f, no_subs )
  local i = 0
  if no_subs then
    for b, e in s:gmatch( '()' .. pattern .. '()' ) do
      i = i + 1
      local c = e - b
      f( i, c, b )
    end
  else
    for b, c in s:gmatch( '()(' .. pattern .. ')' ) do
      i = i + 1
      f( i, c, b )
    end
  end
end

function utf8:chars( s, no_subs )
  return coroutine.wrap(
    function( )
      return utf8:map( s, coroutine.yield, no_subs )
    end
  )
end

function utf8:len( s )
  return select( 2, s:gsub( '[^\128-\193]', '' ) )
end

function utf8:replace( s, mapping )
  return s:gsub( pattern, mapping )
end

function utf8:reverse( s )
  s = s:gsub(
    pattern,
    function( c )
      return #c > 1 and c:reverse()
    end
  )
  return s:reverse()
end

function utf8:strip( s )
  return s:gsub(
    pattern,
    function( c )
      return #c > 1 and ''
    end
  )
end

function utf8:sub( s, i, j )
  local l = utf8:len( s )
  i = relativePosition( i, l )
  j = j and relativePosition( j, l ) or l
  if i < 1 then
    i = 1
  end
  if j > l then
    j = l
  end
  if i > j then
    return ''
  end
  local diff = j - i
  local iter = utf8:chars( s, true )
  for _ = 1, i - 1 do
    iter()
  end
  local c, b = select( 2, iter() )
  if diff == 0 then
    return string.sub( s, b, b + c - 1 )
  end
  i = b
  for _ = 1, diff - 1 do
    iter()
  end
  c, b = select( 2, iter() )
  return string.sub( s, i, b + c - 1 )
end

function utf8:charBytes( s, i )
  i = i or 1
  local c = string.byte( s, i )
  if c > 0 and c <= 127 then
    -- UTF8-1
    return 1
  elseif c >= 194 and c <= 223 then
    -- UTF8-2
    -- local c2 = string.byte( s, i + 1 )
    return 2
  elseif c >= 224 and c <= 239 then
    -- UTF8-3
    -- local c2 = s:byte( i + 1 )
    -- local c3 = s:byte( i + 2 )
    return 3
  elseif c >= 240 and c <= 244 then
    -- UTF8-4
    -- local c2 = s:byte( i + 1 )
    -- local c3 = s:byte( i + 2 )
    -- local c4 = s:byte( i + 3 )
    return 4
  end
end

function utf8:unicodeValue( s, i )
  i = i or 1
  local c = string.byte( s, i )
  if c > 0 and c <= 127 then
    -- UTF8-1
    return c
  elseif c >= 194 and c <= 223 then
    -- UTF8-2
    c = (c % 32 ) * 64
    c = c + ( string.byte( s, i + 1 ) % 64 )
    return c
  elseif c >= 224 and c <= 239 then
    -- UTF8-3
    c = ( c % 16 ) * 4096
    c = c + ( string.byte( s, i + 1 ) % 64 ) * 64
    c = c + ( string.byte( s, i + 2 ) % 64 )
    return c
  elseif c >= 240 and c <= 244 then
    -- UTF8-4
    c = ( c % 8 ) * 262144
    c = c + ( string.byte( s, i + 1 ) % 64 ) * 4096
    c = c + ( string.byte( s, i + 2 ) % 64 ) * 64
    c = c + ( string.byte( s, i + 3 ) % 64 )
    return c
  end
end

local bmf = {}
local fontCache = {}
function bmf:load( dataPath, imagePath )
  local key = "font_" .. dataPath .. imagePath
  if fontCache[ key ] ~= nil then
    return fontCache[ key ]
  end
  local fontImage = love.graphics.newImage( imagePath )
  local sheetWidth, sheetHeight = fontImage:getWidth(), fontImage:getHeight()
  local fontData = require( dataPath )

  local frames = fontData.frames
  local frameLookup = fontData.mapping
  local kernings = fontData.kernings or {}
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

  local font = {
    image = fontImage,
    info = fontData.info,
    quads = quads,
    stringCache = {}
  }

  function font:newString( text )
    if self.stringCache[ text ] ~= nil then
      return self.stringCache[ text ]
    end
    local batch = love.graphics.newSpriteBatch( self.image )

    local unicode = 0
    local unicodeStr = ""
    local x = 0
    local y = 0
    local xMax = 0
    local yMax = self.info.lineHeight
    local last = 0
    local lastFrame = nil
    local lastAdvance = 0
    for i, c, b in utf8:chars( text ) do
      unicode = utf8:unicodeValue( c )
      unicodeStr = tostring( unicode )

      local frameIndex = frameLookup[ unicodeStr ]
      local frame = frames[ tonumber( frameIndex ) ]

      if c == '\n' then
        -- newline
        x = 0
        y = y + self.info.lineHeight
        if y >= yMax then
          yMax = y + self.info.lineHeight
        end
      elseif frame then
        if 0 + frame.width > 0 and 0 + frame.height > 0 then
          if last ~= 0 then
            local kern = kernings[ tostring( last ) .. "," .. unicodeStr ]
            if kern then
              x = x + kern
            end
          end
          local quad = quads[ frameIndex ]
          batch:add(
            quad,
            x + frame.xoffset,
            y + frame.yoffset
          )
          last = unicode
          lastAdvance = frame.xadvance
        end
        x = x + frame.xadvance
        if x >= xMax then
          xMax = x + frame.xadvance
        end
      end
    end

    local bmfText = {
      batch = batch,
      x = 0,
      y = 0,
      width = xMax - lastAdvance,
      height = yMax,
      scaleX = 1,
      scaleY = 1
    }

    function bmfText:draw( bg )
      if bg then
        r, g, b, a = love.graphics.getColor( )
        love.graphics.setColor( bg.red, bg.green, bg.blue )
        love.graphics.rectangle('fill', self.x, self.y, self.width * self.scaleX, self.height * self.scaleY )
        love.graphics.setColor( r, g, b, a )
      end
      love.graphics.draw( self.batch, self.x, self.y, 0, self.scaleX, self.scaleY )
    end

    self.stringCache[ text ] = bmfText

    function bmfText:uncache( text )
      self.stringCache[ text ] = nil
    end

    return bmfText
  end

  fontCache[ key ] = font

  return font
end

return bmf
