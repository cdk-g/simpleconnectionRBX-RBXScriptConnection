--[[ 

   @cdk 2026
   
   @Simple Connection
   
   how to use this?
   
   module.new() <-- init your connection
   
   module.new():createconnection(signal, callback, isrefresh)
   
   "isrefresh" is used then it creates another like "clone" of the connection then deletes the old one...
   
   false: when function is run then it disconnects itself,
   true: when function is run then it disconnects itself and creates another connection of itself

   and auto-reconnects refreshable connections
   
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
	local connection
	local fn

	fn = function(...)
		cb(...)

		if isrefresh == false and connection then
			connection:Disconnect()
		elseif isrefresh == true then
			self:clearconnections()
		end
	end

	connection = sl:Connect(fn)

	table.insert(self.connections, connection)

	-- if refresh is used it will create a new connection and store it 	 the refreshdata
	if isrefresh then
		local exists = false
		for _, data in ipairs(self.refreshdata) do
			if data.signal == sl and data.callback == cb then
				exists = true
				break
			end	
		end
		if not exists then
			table.insert(self.refreshdata, {signal = sl, callback = cb,refresh = isrefresh})
		end
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

	table.clear(self.connections)
   
   --refresh the refreshable connections:)
	for _, data in ipairs(self.refreshdata) do
		if data.refresh then
			self:createconnection(data.signal, data.callback, true)
		end
	end

end

return cnctables
