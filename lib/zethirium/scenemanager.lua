-- scenemanager.lua

local scenes = {}
local sceneStack = {}
local sceneManager = {}

function sceneManager:register( sceneId, sceneFile )
  if scenes[ sceneId ] ~= nil then
    scenes[ sceneId ]:destroy()
  end
  scenes[ sceneId ] = require( sceneFile )
  if scenes[ sceneId ] ~= nil then
    scenes[ sceneId ].sceneManager = sceneManager
    scenes[ sceneId ]:create()
  end
end

function sceneManager:push( sceneId )
  if #sceneStack > 0 then
    self:top():hide()
  end
  local scene = scenes[ sceneId ]
  if scene ~= nil then
    sceneStack[ #sceneStack + 1 ] = scene
    scene:show()
  else
    if #sceneStack > 0 then
      self:top():show()
    end
  end
end

function sceneManager:pop( )
  if #sceneStack > 0 then
    local scene = sceneStack[ #sceneStack ]
    table.remove( sceneStack )
    scene:hide()
    return scene
  end
end

function sceneManager:top( )
  return sceneStack[ #sceneStack ]
end

function sceneManager:callback( functionName, ... )
  if #sceneStack > 0 then
    local scene = sceneStack[ #sceneStack ]
    scene[ functionName ]( scene, ... )
  end
end

return sceneManager
