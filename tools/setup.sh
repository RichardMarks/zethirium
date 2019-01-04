#!/bin/sh

ZETHIRIUM_HOME=~/zethirium

# create directory tree
mkdir -p assets
mkdir -p assets/{textures,sounds,music,atlases,data}
mkdir -p app
mkdir -p app/{scenes,components}
mkdir -p lib

# symlink zethirium lua library
ln -s $ZETHIRIUM_HOME/lib/zethirium lib/zethirium

# TODO: create a configurator to generate the app files
# for now just copy a simple template

# copy project template starter files
cp $ZETHIRIUM_HOME/template/main.lua .
cp $ZETHIRIUM_HOME/template/conf.lua .
cp $ZETHIRIUM_HOME/template/app/configuration.lua app/
cp $ZETHIRIUM_HOME/template/app/app.lua app/

# create empty scenes for title, credits and game
node $ZETHIRIUM_HOME/tools/zs.js title
node $ZETHIRIUM_HOME/tools/zs.js credits
node $ZETHIRIUM_HOME/tools/zs.js game
