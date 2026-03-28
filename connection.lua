--[[ 

   @cdk 2026
   
   @Simple Connection
   
   how to use this?
   
   module.new() <-- init your connection
   
   module.new():createconnection(signal, callback, isrefresh)
   
   "isrefresh" is used then it creates another like "clone" of the connection then deletes the old one...
   
   
   module.new():clearconnections() <-- clears all connections
   
   module.new():getconnections() <-- gets all connections
   
]]-- 

local cnctables = {}
cnctables.__index = cnctables


function cnctables.new()
	local self = setmetatable({}, cnctables)
	
	self.connections = {}
	self.refreshdata = {}
	
	return self
end	


--creates connection!
function cnctables:createconnection(sl, cb, isrefresh: boolean)
	
	
	local connection = sl:Connect(cb)
	
	table.insert(self.connections, connection)
	
	-- if refresh is used it will create a new connection and store it 	 the refreshdata
	if isrefresh then
		table.insert(self.refreshdata, {signal = sl, callback = cb})
	end



	warn(self.connections) 
	
	return connection
end

function cnctables:getconnections()
    return self.connections
end

function cnctables:clearconnections()
	
	for _, v in ipairs(self.connections) do
		v:Disconnect()
		
	end
	
	-- creates a simple connection
	for _, data in ipairs(self.refreshdata) do
		self:createconnection(data.signal, data.callback, true)
	end
	
	table.clear(self.connections)
end
	
return cnctables

