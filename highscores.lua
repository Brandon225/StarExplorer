
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local json = require("json")

local scoresTable = {}

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)


local function loadScores()
	-- load file from path for reading
	local file = io.open(filePath, "r")
	-- confirm that file exists
	if (file) then
		-- dump file
		local contents = file:read("*a")
		-- close file
		io.close(file)
		-- decode contents of file into scoresTable
		scoresTable = json.decode(contents)
	end

	-- if scoresTable is empty add default data to scoresTable
	if (scoresTable == nil or #scoresTable == 0) then
		scoresTable = {10000, 7500, 5200, 4700, 3500, 3200, 1200, 1100, 800, 500}
	end
end

local function saveScores()
	
	-- Only save the highest 10 scores
	for i = #scoresTable, 11, -1 do
		table.remove(scoresTable, i)
	end

	-- open file for writing
	local file = io.open(filePath, "w")

	if (file) then
		file:write(json.encode(scoresTable))
		io.close(file)
	end
end

local function gotoMenu()
	composer.gotoScene("menu", {time=800, effect="crossFade"})	
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Load the previous scores
	loadScores()

	-- Insert the saved score from the last game into the table, then reset it
	table.insert( scoresTable, composer.getVariable("finalScore") )
	composer.setVariable("finalScore", 0)

	-- Sort the table entries from highest to lowest
	local function compare(a, b)
		return a > b
	end
	table.sort(scoresTable, compare)

	-- Save the scores
	saveScores()

	-- Create the background image
	local background = display.newImageRect(sceneGroup, "background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	-- Create title text
	local highScoresHeader = display.newText("High Scores", display.contentCenterX, 100, native.systemFont, 44)

	-- Add the scores
	for i=1,10 do
		if (scoresTable[i]) then
			-- place the score text
			local yPos = 150 + (i*56)

			-- create 2 text objects - one for rank - one for score
			local rankNum = display.newText(sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36)
			rankNum:setFillColor(0.8)
			rankNum.anchorX = 1

			local theScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 36)
			theScore.anchorX = 0

			-- Create a button to allow return to Menu
			local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 810, native.systemFont, 44)
			menuButton:setFillColor(0.75, 0.78, 1)
			menuButton:addEventListener("tap", gotoMenu)
		end
	end
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		-- Cleanup scene
		composer.removeScene("highscores")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
