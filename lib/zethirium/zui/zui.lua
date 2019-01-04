-- ZUI - Zethirium User Interface Library

local zui = {
  manager = require( "lib.zethirium.zui.manager" ),
-- container = require( "lib.zethirium.zui.container" ),
-- panel = require( "lib.zethirium.zui.panel" ),
-- text = require( "lib.zethirium.zui.text" ),
-- button = require( "lib.zethirium.zui.button" ),
-- textbutton = require( "lib.zethirium.zui.textbutton" ),
-- iconbutton = require( "lib.zethirium.zui.iconbutton" ),
}

function zui:add( obj )
  self.manager:add( obj )
end

function zui:remove( obj )
  self.manager:remove( obj )
end

function zui:update( dt )
  self.manager:update( dt )
end

function zui:draw( )
  self.manager:draw()
end


local function test( )
  zui:useAtlas( "ui" )

  local frameIdPrefix = "btn-play--"
  local frameIdSuffixes = { "normal", "hover" }

  local btn = zui:newButton( frameIdPrefix, frameIdSuffixes )
  :name( "play" ) -- set the humanId property of the button
  :frame( "normal" ) -- select the "btn-play--normal" atlas frame to represent the button
  :pivot( 0.5, 0.5 ) -- set the button pivot point to the button's center
  :anchor( "left", 10 ) -- anchor the left edge of the button to 10 pixels from the left edge of the screen
  :move( 120, 100 ) -- move the button 120 pixels to the right and 100 pixels down
  :on( "over", function ( button ) button:frame( "hover" ) end ) -- handle mouse over
  :on( "out", function ( button ) button:frame( "normal" ) end ) -- handle mouse out
  :on( "click", function ( button ) print( button.humanId .. " clicked" ) end ) -- handle mouse click
  zui:add( btn )
end


function zui:newContainer( x, y )
end

function zui:newPanel( x, y, backgroundImage, backgroundQuad )
end

function zui:newText( text, x, y, font, alignment )
end

function zui:newButton( x, y, normalImage, hoverState )
end

function zui:newTextButton( x, y, normalImage, hoverState )
end

function zui:newIconButton( x, y, normalImage, hoverState )
end

return zui

-- zui.manager
-- UI Manager System
-- iterates through all ui objects, updating and drawing as necessary

-- zui.container
-- Hierarchial Container. children are drawn relative to the container

-- zui.panel
-- serves as a container with a background image

-- zui.text
-- static/dynamic text display

-- zui.button
-- clickable image with hover state image

-- zui.textbutton
-- button with centered text label

-- zui.iconbutton
-- button with centered icon image
