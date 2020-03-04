if not Harvest then
	Harvest = {}
end

-- updating the data can take quite some time
-- to prevent the game from freezing, we break each update process down into smaller parts
-- the smaller parts are executed with a small delay (see Harvest.OnUpdate(time) )
Harvest.updateQueue = {}
Harvest.updateQueue.first = 1
Harvest.updateQueue.afterLast = 1
function Harvest.IsUpdateQueueEmpty()
	return (Harvest.updateQueue.first == Harvest.updateQueue.afterLast)
end

function Harvest.AddToUpdateQueue(fun)
	Harvest.updateQueue[Harvest.updateQueue.afterLast] = fun
	Harvest.updateQueue.afterLast = Harvest.updateQueue.afterLast + 1
end

function Harvest.AddToFrontOfUpdateQueue(fun)
	Harvest.updateQueue.first = Harvest.updateQueue.first - 1
	Harvest.updateQueue[Harvest.updateQueue.first] = fun
end

function Harvest.UpdateUpdateQueue() --shitty function name is shitty
	local fun = Harvest.updateQueue[Harvest.updateQueue.first]
	Harvest.updateQueue[Harvest.updateQueue.first] = nil
	Harvest.updateQueue.first = Harvest.updateQueue.first + 1

	fun()

	if Harvest.IsUpdateQueueEmpty() then
		Harvest.updateQueue.first = 1
		Harvest.updateQueue.afterLast = 1
		Harvest.RefreshPins()
	end
end

function Harvest.GetQueuePercent()
	return zo_floor((Harvest.updateQueue.first/Harvest.updateQueue.afterLast)*100)
end

-- check if saved data is from an older version,
-- update the data if needed
function Harvest.UpdateDataVersion( saveFile )
	-- import old data
	Harvest.UpdatePreOrsiniumData( saveFile )
end

function Harvest.UpdatePreOrsiniumData( saveFile )
	saveFile = saveFile or Harvest.savedVars["nodes"]

	if (saveFile.dataVersion or 0) >= 10 then
		return
	end

	Harvest.AddToUpdateQueue(function()
		Harvest.DelayedUpdatePreOrsiniumData(saveFile.data, nil, nil, nil, nil, nil)
	end)
end

function Harvest.DelayedUpdatePreOrsiniumData(data, pinTypes, nodes, mapIndex, pinIndex, nodeIndex)
	local entry = nil
	if nodeIndex ~= nil then
		entry = nodes[nodeIndex]
	end
	for counter = 1,2000 do
		while nodeIndex == nil do
			if pinTypes ~= nil then
				pinIndex, nodes = next(pinTypes, pinIndex)
			end
			while pinIndex == nil do
				mapIndex, pinTypes = next(data, mapIndex)
				if mapIndex == nil then
					Harvest.savedVars["nodes"].dataVersion = 10
					d("HarvestMap finished updating pre-Orsinium data.")
					return
				end
				pinIndex, nodes = next(pinTypes, pinIndex)
			end
			nodeIndex, entry = next(nodes, nodeIndex)
		end
		if type(entry) == "table" then
			nodes[nodeIndex] = Harvest.Serialize(entry)
		end
		nodeIndex, entry = next(nodes, nodeIndex)
	end
	d("HarvestMap is updating pre-Orsinium data.")
	Harvest.AddToFrontOfUpdateQueue(function()
		Harvest.DelayedUpdatePreOrsiniumData(data, pinTypes, nodes, mapIndex, pinIndex, nodeIndex)
	end)
	--zo_callLater(function() Harvest.DelayedUpdatePreOrsiniumData(data, nodes, mapIndex, nodeIndex) end, 0.1)
end