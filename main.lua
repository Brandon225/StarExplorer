-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- Setup Game Physics
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 ) -- no gravity is space so 0,0 sets gravity to none

-- Seed the random number generator
math.randomseed( os.time() )
