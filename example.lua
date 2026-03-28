local part = script.Parent
local clickdetector = part:WaitForChild("ClickDetector")

local connectionModule = require(script.cntion)

local connection = connectionModule.new()

connection:createconnection(clickdetector.MouseClick, function()
	print('true')

	
end, true)
	
connection:clearconnections() -- refresh the refreshable connections






