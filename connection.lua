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

-- refresh mode rebuilds itself after firing once
--@param sl RBXScriptSignal | RBXScriptConnection
--@param cb function
--@return conn
function cnctables:createconnection(sl, cb, isrefresh: boolean)
	local connection
	local fn
	local i

	if typeof(sl) == "RBXScriptConnection" then
		table.insert(self.connections, sl)
		return sl
	end

	assert(typeof(sl) == "RBXScriptSignal", "its not a signal!")
	assert(type(cb) == "function", "callback has to be a function")

	fn = function(...)
		cb(...)
		if not connection then return end

		i = nil
		for idx, conn in ipairs(self.connections) do
			if conn == connection then
				i = idx
				break
			end
		end

		connection:Disconnect()
		if i then table.remove(self.connections, i) end
		if isrefresh == true then
			task.defer(function()
				self:createconnection(sl, cb, true)
			end)
		end
	end

	connection = sl:Connect(fn)
	table.insert(self.connections, connection)

	return connection
end

--@return table
function cnctables:getconnections()
	return self.connections
end

function cnctables:clearconnections()
	local connections = self.connections

	for _, v in ipairs(connections) do
		if v and v.Connected then v:Disconnect() end
	end

	table.clear(connections)
	table.clear(self.refreshdata)
end

return cnctables
