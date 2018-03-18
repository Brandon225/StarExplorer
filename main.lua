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
local background = display.newImageRect(backGroup, "background.png", 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterX

ship = display.newImageRect(mainGroup, objectSheet, 4, 98, 79)
ship.x = display.contentCenterX
ship.y = display.safeActualContentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true })
ship.myName = "ship"

-- setup game stat text
livesText = display.newText(uiGroup, "Lives: " .. lives, 200, display.safeScreenOriginY, native.systemFont, 36)
scoreText = display.newText(uiGroup, "Score: " .. score, 400, display.safeScreenOriginY, native.systemFont, 36)

-- hide the statusbar
display.setStatusBar(display.HiddenStatusBar)

-- function to update the game stat text
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

local function createAsteroid()
    local newAsteroid = display.newImageRect(mainGroup, objectSheet, 1, 102, 85)
    table.insert(asteroidsTable, newAsteroid)
    physics.addBody(newAsteroid, "dynamic", { radius=40, bounce=0.8 })
    newAsteroid.myName = "asteroid"

    local whereFrom = math.random(3)

    if (whereFrom == 1) then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random(500)
    end

    -- STOPPED AT MOVEMENT

end