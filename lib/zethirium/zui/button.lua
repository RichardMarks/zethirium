local ZUIButton = {
  humanId = "ZUIButton",
  frameId = nil,
  frame = nil,
  pivotX = 0,
  pivotY = 0,
  x = 0,
  y = 0,
  width = 0,
  height = 0,
  listeners = { over = { }, out = { }, click = { } },
  hover = false
}

-- chainable methods

function ZUIButton:name( humanId )
  self.humanId = humanId or "ZUIButton"
  return self
end

function ZUIButton:frame( frameId )
  if self.frameId ~= frameId then
    self.frameId = frameId

  end
  return self
end

function ZUIButton:pivot( x, y )
  self.pivotX = x or 0
  self.pivotY = y or 0
  return self
end

function ZUIButton:anchor( side, offset )
  if side == "left" then
    -- set the x position such that the left edge of the button is offset from the left edge of the screen
  elseif side == "top" then
    -- set the y position such that the top edge of the button is offset from the top edge of the screen
  elseif side == "right" then
    -- set the x position such that the right edge of the button is offset from the right edge of the screen
  elseif side == "bottom" then
    -- set the y position such that the bottom edge of the button is offset from the bottom edge of the screen
  end
  return self
end

function ZUIButton:move( dx, dy )
  dx = dx or 0
  dy = dy or 0
  self.x = self.x + dx
  self.y = self.y + dy
  return self
end

function ZUIButton:on( eventName, handler )
  local listeners = self.listeners[ eventName ]
  if listeners ~= nil then
    local listener = {
      name = eventName,
      handler = handler
    }
    listeners[ #listeners + 1 ] = listener
  end

  return self
end


-- non-chainable methods

function ZUIButton:left( )
  -- left is x
end

function ZUIButton:update( dt, mouseX, mouseY )

end

function ZUIButton:draw( )
end

function ZUIButton:click( )
end

return ZUIButton
