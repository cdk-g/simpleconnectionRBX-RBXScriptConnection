local part = script.Parent
local clickdetector = part:WaitForChild("ClickDetector")

local connectionModule = require(script.cntion)

local connection = connectionModule.new()

--true, when function run, it creates new "clone" itself
cnt:createconnection(color1_part.ClickDetector.MouseClick:Connect(function()
	print('true')
end), true

--false, when function run, it disconnects 

cnt:createconnection(color1_part.ClickDetector.MouseClick:Connect(function()
	print('true')
end), false)


--no need to put clearconnections() because it is handle by the module





