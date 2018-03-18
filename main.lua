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
        newAsteroid:setLinearVelocity(math.random(40, 120), math.random(20,60))
    elseif (whereFrom == 2) then
        -- From the top
        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random(-40,40), math.random(40,120))
    elseif (whereFrom == 3) then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(-120, -40), math.random(20,60))
    end

    newAsteroid:applyTorque(math.random(-6,6))
end

local function fireLaser()
    local newLaser = display.newImageRect(mainGroup, objectSheet, 5, 14, 40)
    physics.addBody(newLaser, "dynamic", {isSensor=true})
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = ship.x
    newLaser.y = ship.y
    newLaser:toBack()

    transition.to(newLaser, {
                            y=-40, 
                            time=500, 
                            onComplete = function() display.remove(newLaser) end
                            })
end
    
-- Add tap listener for firing
ship:addEventListener("tap", fireLaser)

-- Function to handle dragging the ship
local function dragShip(event)
    local ship = event.target
    local phase = event.phase

    if ("began" == phase) then
        -- Set touch focus on the ship
        display.currentStage:setFocus(ship)
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
    elseif ("moved" == phase) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
    elseif ("ended" == phase or "cancelled" == phase) then
        -- Release touch focus on the ship
        display.currentStage:setFocus(nil)
    end

    -- Prevent touch propagation to underlying objects
    return true
end

ship:addEventListener("touch", dragShip)

-- Create a game loop for info updates and asteriod cleanup
local function gameLoop()
    -- Create a new asteroid
    createAsteroid()

    -- Remove asteroids which have drifted off screen
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]

        if (thisAsteroid.x < -100 or
            thisAsteroid.x > display.contentWidth+100 or
            thisAsteroid.y < -100 or
            thisAsteroid.y > display.contentHeight + 100) 
        then
            -- remove the asteroid from the screen
            display.remove(thisAsteroid)
            -- remove the asteroid from memory (the asteroidTable)
            table.remove(asteroidsTable, i)
        end
    end
end

gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)

local function restoreShip()
    ship.isBodyActive = false
end