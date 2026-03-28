local part = script.Parent
local clickdetector = part:WaitForChild("ClickDetector")

local connectionModule = require(script.connection)

local connection = connectionModule.new()

connection:createconnection(clickdetector.MouseClick, function()
	print('true')
end, true )



	




