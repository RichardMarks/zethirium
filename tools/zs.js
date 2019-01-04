const fs = require('fs');

const redText = text => `\x1b[1;31m${text}\x1b[m`;
const greenText = text => `\x1b[1;32m${text}\x1b[m`;

const sceneName = process.argv[2] || "new_scene";

const sceneFilename = `app/scenes/${sceneName}.lua`;

const sceneTemplateCode = `local Z = require( "lib.zethirium.zethirium" )
local cfg = require( "app.configuration" )

local atlasManager = Z.atlasmanager
local bmf = Z.bmf

local scene = { id = "${sceneName}" }

function scene:create( )
  -- load assets
  local assets = {
    -- assetName = yourLoadAssetFunction( pathToAsset )
  }
  self.assets = assets
end

function scene:destroy( )
  -- unload assets
  for k,v in pairs( self.assets ) do
    self.assets[ k ] = nil
  end
  self.assets = nil
end

function scene:show( )
end

function scene:hide( )
end

function scene:update( dt )
end

function scene:draw( )
end

function scene:click( x, y )
end

function scene:keypressed( key )
end

return scene`;

// check for app folder
fs.access('./app', fs.constants.F_OK | fs.constants.W_OK, err => {
  if (err) {
    console.log(`Checking for app folder: ${redText('NOT FOUND or NOT WRITABLE')}`);
  } else {
    console.log(`Checking for app folder: ${greenText('OK')}`);
    // check for scenes folder
    fs.access('./app/scenes', fs.constants.F_OK | fs.constants.W_OK, err2 => {
      if (err2) {
        console.log(`Checking for scenes folder: ${redText('NOT FOUND or NOT WRITABLE')}`);
      } else {
        console.log(`Checking for scenes folder: ${greenText('OK')}`);
        // check for scene file
        fs.access(sceneFilename, fs.constants.F_OK | fs.constants.R_OK, err3 => {
          if (err3) {
            console.log(`Checking for scene file: ${greenText('OK')}`);
            // all good, proceed to try to write the file
            fs.writeFile(sceneFilename, sceneTemplateCode, err => {
              if (err) {
                console.log(`${redText(`Oh no! Failed to write ${sceneFilename}`)}`);
                console.log(err);
              } else {
                console.log(`Created new scene in ${sceneFilename}`);
              }
            });
          } else {
            console.log(`Checking for scene file: ${redText('ALREADY EXISTS')}`);
          }
        });
      }
    });
  }
});




