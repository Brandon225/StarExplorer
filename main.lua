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

local sheetOptions = {
    frames = {
        { -- 1) asteriod 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        { -- 2) asteriod 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        { -- 3) asteriod 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        { -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        { -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        }
    },
}
local objectSheet = graphics.newImageSheet("gameObjects.png", sheetOptions)

-- Init Variables
local lives = 3
local score = 0
local died = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Display the background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterX

ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )


