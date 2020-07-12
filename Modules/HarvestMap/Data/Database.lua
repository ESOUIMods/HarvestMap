
local Database = {}

function Database:Initialize()
	
	signedFloat = "(-?%d+%.?%d*),"
	unsignedInt = "(%d+),"

	node = {}
	-- world x,y,z
	node[1] = signedFloat
	node[2] = signedFloat
	node[3] = signedFloat
	-- global x,y
	node[4] = signedFloat
	node[5] = signedFloat
	-- terminator
	node[9] = "|"

	self.nodePattern = table.concat(node)
end

function Database:LoadDataToCache(mapCache, pinTypeId, serializedData)
	for worldX, worldY, worldZ, globalX, globalY 
				in string.gmatch(serializedData, self.nodePattern) do
		worldX = tonumber(worldX)
		worldY = tonumber(worldY)
		worldZ = tonumber(worldZ)
		globalX = tonumber(globalX)
		globalY = tonumber(globalY)
		mapCache:AddNode(pinTypeId, worldX, worldY, worldZ, globalX, globalY)
	end
end