
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local Generator = Harvest.farm.generator
Generator.logic = {}
local GeneratorLogic = Generator.logic

function GeneratorLogic:Initialize()
	-- only nodes that are closer than this (local) distance will be considered as neighbors
	self.maxDist = 0.1 * 4000
	-- minimum length of the path, can be set in the farming options panel
	self.minLengthKM = 3
end

function GeneratorLogic:IsPinTypeIncluded(pinTypeId)
	return Harvest.mapPins.filterProfile[pinTypeId]
end

-- most of the below code is copied from the old tour generation (version 3.4.15 and earlier)
-- todo: the code should be reworked

local edges
local points
local lastPointIndex
local bestPath
local bestRatio
local num_data_points

local distance, realDistance
do
	-- these functions are called often every frame, so add local references for performance
	local sqrt = math.sqrt
	distance = function(a, b)
		local dx = a[1] - b[1]
		local dy = a[2] - b[2]
		return sqrt(dx * dx + dy * dy)
	end

	realDistance = distance
	
	realDistanceWithHeight = function(a, b)
		local dx = a[1] - b[1]
		local dy = a[2] - b[2]
		local dz = a[5] - b[5]	
		return sqrt(dx * dx + dy * dy + dz * dz)
	end
end

local function generateEdges(num_data_points, points, maxLength)
	local dist, edge, pointA, pointB
	local numEdges = 0
	local edges = {}
	for i = 1, num_data_points do
		for j = (i+1), num_data_points do
			pointA = points[i]
			pointB = points[j]
			dist = realDistanceWithHeight(pointA, pointB)
			if dist <= maxLength then
				if zo_abs(pointA[5] - pointB[5]) / realDistance(pointA, pointB) < 0.5 then
					numEdges = numEdges + 1
					if numEdges > 30000 then
						return
					end
					-- each edge consists of the indizes of the two adjacent vertices, its distance and its pheromone value
					edge = { i, j, distance = dist}--, phero = 1 }
					edges[numEdges] = edge
					-- add the edge to the vertices' neighbor table
					--pointA.edges[j] = edge
					--pointB.edges[i] = edge
				end
			end
		end
	end
	return edges
end

-- construct a graph with the resource nodes as vertices, but the edges may only have a length of maxLength
local function constructGraph(maxLength)
	points = {}
	edges = {}
	num_data_points = 0

	local viewedMap = true
	local mapMetaData = Harvest.mapTools:GetViewedMapMetaData()

	GeneratorLogic.minLength = GeneratorLogic.minLengthKM * 1000
	
	local mapCache = Harvest.Data:GetMapCache( mapMetaData )
	if not mapCache then return 2 end
	-- add selected resource nodes to the points/vertices list
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if GeneratorLogic:IsPinTypeIncluded( pinTypeId ) then
			GeneratorLogic.mapCache = mapCache
			
			for _, nodeId in pairs(mapCache.nodesOfPinType[pinTypeId]) do
				-- each point/vertex consists of and x and y coordinate and a list of the neighbors/edges
				table.insert(points, {
					mapCache.worldX[nodeId], mapCache.worldY[nodeId],
					0, 0, -- used to be global coords
					mapCache.worldZ[nodeId] or 0, pinTypeId, edges={}})
				num_data_points = num_data_points + 1
			end
		end
	end
	-- no resources available, return an error
	if (#points) == 0 then
		GeneratorLogic.mapCache = nil
		return 2
	end
	-- create the edges
	edges = nil
	while not edges do
		edges = generateEdges(num_data_points, points, maxLength)
		maxLength = maxLength / 2
	end
	for _, edge in pairs(edges) do
		pointA = points[edge[1]]
		pointB = points[edge[2]]
		pointA.edges[edge[2]] = edge
		pointB.edges[edge[1]] = edge
	end
	GeneratorLogic.mapCache.accessed = GeneratorLogic.mapCache.accessed + 1
	return 0
end

-- this function lets the given ant move along one edge
-- the return value is true, if the ant was able to move and false if the ant is stuck and dies a horrible death by the GC
local updateAnt
do
	-- local references because this is called many times each frame
	local table = _G["table"]
	local next = _G["next"]
	local random = math.random
	local pairs = _G["pairs"]

	updateAnt = function(ant)
		local point = points[ant.currentIndex] -- the current vertex the ant is on
		local possible = {} -- list of all vertices the ant can move to during this step and their probabilities
		local total = 0 -- number of possible vertices
		local prob

		for neighborIndex, edge in pairs(point.edges) do
			-- only vertices the ant hasn't visited yet can be visited
			if not ant.visited[neighborIndex] then
				-- the may only return to its starting vertex, if its path is long enough
				if neighborIndex ~= ant.startIndex or ant.pathLength >= GeneratorLogic.minLength then
					-- probability of the ant taking this edge
					--prob = ((edge.phero)^HarvestFarm.alpha * (1/edge.distance)^HarvestFarm.beta )
					if edge.distance == 0 then
						ant.visited[neighborIndex] = true
						ant.currentIndex = neighborIndex
						ant.pathLength = ant.pathLength + edge.distance
						table.insert(ant.path, neighborIndex)--edge)
						return true
					end
					prob = (1/edge.distance)^10
					total = total + prob
					table.insert(possible, {index=neighborIndex, edge=edge, prob=prob} )
				end
			end
		end
		-- check if the ant can go somewhere
		if next(possible) == nil then
			return false
		end
		-- now the ant is going to choose an edge to walk on
		prob = random() * total
		for _, neighbor in pairs(possible) do
			prob = prob - neighbor.prob
			-- will the ant take this edge?
			if prob <= 0 then
				ant.visited[neighbor.index] = true
				ant.currentIndex = neighbor.index
				ant.pathLength = ant.pathLength + neighbor.edge.distance
				table.insert(ant.path, neighbor.index)--edge)
				return true
			end
		end
		return false -- rounding error :(
	end
end

-- this function starts the calculation (without any pheromone update)
function GeneratorLogic:Start()
	self.isGeneratingTour = true
	CallbackManager:FireCallbacks(Events.TOUR_GENERATION_STARTED)
	self.lastMap = GetMapTileTexture()
	self.bestPath = nil
	self.finishTime = nil
	self.numFarmedNodes = 0
	
	--if self.mapCache then
	--	self.mapCache.accessed = self.mapCache.accessed - 1
	--	self.mapCache = nil
	--end
	
	lastPointIndex = nil
	bestPath = nil
	bestRatio = 0

	local result = constructGraph(self.maxDist)
	if result == 0 then
		-- register the update function which will handle the actual computing of the path
		EVENT_MANAGER:RegisterForUpdate("HarvestFarm", 0, self.Compute)
	else
		self.isGeneratingTour = false
		CallbackManager:FireCallbacks(Events.TOUR_GENERATION_ERROR, result)
	end
end

-- this function updates the ants
do
	local next = _G["next"]
	local zo_max = _G["zo_max"]
	local GetGameTimeMilliseconds = _G["GetGameTimeMilliseconds"]
	function GeneratorLogic.Compute()
		local startTime = GetGameTimeMilliseconds()
		local ant, ratio
		-- update the ants for about 10 milliseconds, then stop until the next frame to prevent freezing the game
		while(GetGameTimeMilliseconds() - startTime < 20) do
			lastPointIndex = next(points, lastPointIndex)
			if not lastPointIndex then
				break
			end
			ant = {visited={}, currentIndex=lastPointIndex, startIndex=lastPointIndex, pathLength=0, path = {}}
			while(updateAnt(ant)) do
				if ant.currentIndex == ant.startIndex then
					ratio = ((#(ant.path)) / ant.pathLength)
					if ratio > bestRatio then
						bestRatio = ratio
						bestPath = ant.path
					end
					break
				end
			end
		end
		if lastPointIndex then
			local percentage = zo_max(100 * (lastPointIndex / num_data_points), 1)
			CallbackManager:FireCallbacks(Events.TOUR_GENERATION_UPDATED, percentage)
		else
			local percentage = 100
			CallbackManager:FireCallbacks(Events.TOUR_GENERATION_UPDATED, percentage)
			GeneratorLogic:Finish()
		end
	end
end

function GeneratorLogic:ReduceCrossings()
	-- crossing sections are not optimal and can always be reduced
	-- this leads to a shorter and thus better tour
	-- the below code will search for two edges that cross each other
	-- the first edge connects the two vertices with index bestPath[previousPathIndex]
	-- and bestPath[pathIndex]
	-- the second edge connects the vertices with index bestPath[previousOtherPathIndex]
	-- and bestPath[otherPathIndex]
	local again = true
	while(again) do
		again = false
		local deb = d
		local previousPathIndex = #bestPath
		local previousOtherPathIndex
		local a,b,c,d,e,f,det
		local lambda, mu
		for pathIndex = 1, #bestPath do
			if again then break end
			-- please excuse this horrible code. it's essentially just solving a 2x2 linear system to check if the two edges intersect each other
			a = points[bestPath[pathIndex]][1] - points[bestPath[previousPathIndex]][1]
			c = points[bestPath[pathIndex]][2] - points[bestPath[previousPathIndex]][2]
			previousOtherPathIndex = pathIndex + 1
			-- check the current edge with all other edges
			for otherPathIndex = (pathIndex + 2), (#bestPath) do
				if again then break end
				-- some more lineare algebra without proper variable names hooray
				b = points[bestPath[previousOtherPathIndex]][1] - points[bestPath[otherPathIndex]][1]
				d = points[bestPath[previousOtherPathIndex]][2] - points[bestPath[otherPathIndex]][2]
				e = points[bestPath[previousOtherPathIndex]][1] - points[bestPath[previousPathIndex]][1]
				f = points[bestPath[previousOtherPathIndex]][2] - points[bestPath[previousPathIndex]][2]
				det = a*d - b*c
				if det ~= 0 then
					lambda = (d*e - b*f) / det
					mu = (a*f - c*e) / det
					-- check if the two edges cross each other
					if lambda > 0 and lambda < 1 and mu > 0 and mu < 1 then
						again = true
						--deb("remove")
						-- if they do, untangle the crossing
						for i = 0, 99999 do--math.huge do
						if (pathIndex+i) >= (previousOtherPathIndex-i) then
							--deb("switched", i)
							break
						end
						a = bestPath[pathIndex+i]
						bestPath[pathIndex+i] = bestPath[previousOtherPathIndex-i]
						bestPath[previousOtherPathIndex-i] = a
						end -- end for
					end
				end
				previousOtherPathIndex = otherPathIndex
			end -- end for
			previousPathIndex = pathIndex
			--table.insert(bestPathPoints, points[pointIndex])
		end
	end
end

function GeneratorLogic:Finish()
	-- the calculation is over, so we can remove the update part
	EVENT_MANAGER:UnregisterForUpdate("HarvestFarm")
	-- output the results to the user and display the discovered path
	if bestPath then
		self:ReduceCrossings()
		-- the bestPath list consists of indices of the visited vertices
		-- we now create a list of these vertices objects/tables, so we can delete all the other vertices
		-- and all the edges. otherwise they'd use up a lot of memory
		local bestPathPoints = {}
		local length = 0
		local lastPoint = points[bestPath[#bestPath]]
		local point
		for _, pointIndex in ipairs(bestPath) do
			point = points[pointIndex]
			point.edges = nil
			length = length + realDistance(point, lastPoint)
			table.insert(bestPathPoints, point)
			lastPoint = point
		end
		
		assert(self.mapCache)
		local path = Harvest.path:New(self.mapCache)
		path:GenerateFromPoints(bestPathPoints)
		self.isGeneratingTour = false
		CallbackManager:FireCallbacks(Events.TOUR_GENERATION_FINISHED, path)
	else
		self.isGeneratingTour = false
		CallbackManager:FireCallbacks(Events.TOUR_GENERATION_ERROR)
	end
	-- delete all the data to get memory back (whenever the GC kicks in)
	bestPath = nil
	points = nil
	edges = nil
	
	self.mapCache = nil
end