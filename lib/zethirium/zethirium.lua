local letterbox = require( "lib.zethirium.letterbox" )
local scenemanager = require( "lib.zethirium.scenemanager" )
local atlasmanager = require( "lib.zethirium.atlasmanager" )
local bmf = require( "lib.zethirium.bmf" )
local uuid = require( "lib.zethirium.uuid" )

local Z = {}

Z.letterbox = letterbox
Z.scenemanager = scenemanager
Z.atlasmanager = atlasmanager
Z.bmf = bmf
Z.uuid = uuid

function Z:quitToOS( )
  love.event.push( "quit" )
end

return Z
