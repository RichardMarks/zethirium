local cfg = require( "app.configuration" )

function love.conf( t )
  t.window.title = cfg.windowTitle
  t.window.width = cfg.windowWidth
  t.window.height = cfg.windowHeight
  t.identity = cfg.id

  t.window.fullscreen = true
  t.window.display = 3
  t.window.fullscreentype = "desktop"

  t.modules.physics = false
end
