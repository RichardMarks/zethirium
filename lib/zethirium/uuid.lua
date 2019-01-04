local m = {}

math.randomseed( os.time() )
local random = math.random
local fmt = string.format

m.uuid = function( )
  return string.gsub(
    "aaabbaaa-aaaa-7aaa-baaa-abaaaaaaabaa",
    '[ab]',
    function( character )
      return fmt( '%X', ( character == 'a' ) and random( 0, 0xf ) or random( 8, 0xb ) )
    end
  )
end

return m
