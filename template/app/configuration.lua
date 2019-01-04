
local cfg = {
  windowWidth = 1920,
  windowHeight = 1080,
  logicalWidth = 1920,
  logicalHeight = 1080,
  windowTitle = "Untitled Project",
  id = "untitled_project",
  backgroundColor = {
    r = 0,
    g = 0,
    b = 0
  }
}

local function info( )
  print( "Lua version: " .. _VERSION )
  if jit then
    print( "LuaJIT version: " .. jit.version )
  end
end

info()

return cfg
