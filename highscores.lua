
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
	local file = io.open(filePath "r")
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

	-- STOPPED AT 4
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
