local v0 = game:GetService('TweenService')
local v1 = game:GetService('Players')
local v3 = v1.LocalPlayer
local v4 = v3:WaitForChild('PlayerGui')

-- Minesweeper Solver Data Structure
local data = {
	cells = {
		all = {},
		numbered = {},
		toFlag = {},
		toClear = {},
		guess = {}
	},
	cache = {
		xs_centers_cached = nil,
		zs_centers_cached = nil
	},
	grid = {
		w = 0,
		h = 0
	},
	ui = {
		PROB_FLAG_THRESHOLD = 0.7,
		PROB_SAFE_THRESHOLD = 0.3,
		showProbability = false,
		uiVisible = true
	},
	timing = {
		lastPlanTick = 0,
		planIntervalMs = 100
	},
	highlights = {},
	probLabels = {},
	enabled = true
}

-- Helper functions
local abs, floor, huge = math.abs, math.floor, math.huge
local sort = table.sort

local function isNumber(str)
	return tonumber(str) ~= nil
end

local function key(ix, iz)
	return tostring(ix) .. ":" .. tostring(iz)
end

local function clusterSorted(sorted_list, epsilon)
	local clusters = {}
	if (#sorted_list == 0) then
		return clusters
	end
	local current_center = sorted_list[1]
	local current_count = 1
	for i = 2, #sorted_list do
		local v = sorted_list[i]
		if (abs(v - current_center) <= epsilon) then
			current_count = current_count + 1
			current_center = current_center + ((v - current_center) / current_count)
		else
			table.insert(clusters, current_center)
			current_center = v
			current_count = 1
		end
	end
	table.insert(clusters, current_center)
	return clusters
end

local function median(tbl)
	if (#tbl == 0) then
		return nil
	end
	sort(tbl)
	local mid = floor((#tbl + 1) / 2)
	return tbl[mid]
end

local function typicalSpacing(sorted_centers)
	if (#sorted_centers < 2) then
		return 4
	end
	local diffs = {}
	for i = 2, #sorted_centers do
		diffs[#diffs + 1] = abs(sorted_centers[i] - sorted_centers[i - 1])
	end
	return median(diffs) or 4
end

local function nearestIndex(v, centers)
	local bestI = 1
	local bestD = huge
	for i = 1, #centers do
		local d = abs(v - centers[i])
		if (d < bestD) then
			bestD = d
			bestI = i
		end
	end
	return bestI - 1
end

local function isCoveredCell(cell)
	if not cell then
		return false
	end
	if ((cell.state == "number") or (cell.state == "flagged")) then
		return false
	end
	return cell.covered ~= false
end

local function isPartFlagged(part)
	if (not part or not part.GetChildren) then
		return false
	end
	local children = part:GetChildren()
	for _, child in pairs(children) do
		local name = child and child.Name
		if (name and (string.sub(name, 1, 4) == "Flag")) then
			return true
		end
	end
	return false
end

local function buildGrid()
	data.cells.all = {}
	data.cells.numbered = {}
	data.cells.grid = {}
	
	local root = game.Workspace:FindFirstChild("Flag")
	if not root then
		return
	end
	local partsFolder = root:FindFirstChild("Parts")
	if not partsFolder then
		return
	end
	local parts = partsFolder:GetChildren()
	
	local raw = {}
	local sumY, countY = 0, 0
	for _, part in pairs(parts) do
		local pos = part and part.Position
		if pos then
			table.insert(raw, {part=part, pos=pos})
			sumY = sumY + pos.Y
			countY = countY + 1
		end
	end
	
	local centersX, centersZ = {}, {}
	for _, item in ipairs(raw) do
		centersX[#centersX + 1] = item.pos.X
		centersZ[#centersZ + 1] = item.pos.Z
	end
	sort(centersX)
	sort(centersZ)
	
	local typicalWX = typicalSpacing(centersX)
	local typicalWZ = typicalSpacing(centersZ)
	local epsX = typicalWX * 0.6
	local epsZ = typicalWZ * 0.6
	data.cache.xs_centers_cached = clusterSorted(centersX, epsX)
	data.cache.zs_centers_cached = clusterSorted(centersZ, epsZ)
	data.grid.w = #data.cache.xs_centers_cached
	data.grid.h = #data.cache.zs_centers_cached
	
	local planeY = ((countY > 0) and (sumY / countY)) or 0
	for iz = 0, data.grid.h - 1 do
		for ix = 0, data.grid.w - 1 do
			local k = key(ix, iz)
			local row = data.cells.grid[ix]
			if not row then
				row = {}
				data.cells.grid[ix] = row
			end
			local cell = {
				ix = ix,
				iz = iz,
				part = nil,
				pos = Vector3.new(data.cache.xs_centers_cached[ix + 1] or 0, planeY, data.cache.zs_centers_cached[iz + 1] or 0),
				state = "unknown",
				number = nil,
				k = k,
				covered = true,
				neigh = nil
			}
			data.cells.all[k] = cell
			row[iz] = cell
		end
	end
	
	for _, item in ipairs(raw) do
		local part = item.part
		local pos = item.pos
		local ix = nearestIndex(pos.X, data.cache.xs_centers_cached)
		local iz = nearestIndex(pos.Z, data.cache.zs_centers_cached)
		if ((ix >= 0) and (ix < data.grid.w) and (iz >= 0) and (iz < data.grid.h)) then
			local k = key(ix, iz)
			local cell = data.cells.all[k]
			if not cell.part then
				cell.part = part
				cell.pos = pos
			else
				local cur_d = abs(((cell.part and cell.part.Position.X) or cell.pos.X) - data.cache.xs_centers_cached[ix + 1]) + abs(((cell.part and cell.part.Position.Z) or cell.pos.Z) - data.cache.zs_centers_cached[iz + 1])
				local new_d = abs(pos.X - data.cache.xs_centers_cached[ix + 1]) + abs(pos.Z - data.cache.zs_centers_cached[iz + 1])
				if (new_d < cur_d) then
					cell.part = part
					cell.pos = pos
				end
			end
			
			if part.Color then
				local color = part.Color
				local r = color.R or color.r or color[1]
				local g = color.G or color.g or color[2]
				local b = color.B or color.b or color[3]
				if (r and (r <= 1)) then
					r = math.floor((r * 255) + 0.5)
				end
				if (g and (g <= 1)) then
					g = math.floor((g * 255) + 0.5)
				end
				if (b and (b <= 1)) then
					b = math.floor((b * 255) + 0.5)
				end
				cell.color = {R=r, G=g, B=b}
			end
			
			local ngui = part:FindFirstChild("NumberGui")
			if ngui then
				local textLabel = ngui:FindFirstChild("TextLabel")
				if (textLabel and textLabel.Text and isNumber(textLabel.Text)) then
					cell.number = tonumber(textLabel.Text)
					cell.covered = false
				end
			end
			
			if (cell.color and cell.color.R and cell.color.G and cell.color.B) then
				if ((cell.color.R == 255) and (cell.color.G == 255) and (cell.color.B == 125)) then
					cell.covered = false
				end
			end
			
			if isPartFlagged(part) then
				cell.state = "flagged"
			end
			
			if (cell.number and not cell.covered) then
				cell.state = "number"
				table.insert(data.cells.numbered, cell)
			end
		end
	end
	
	for iz = 0, data.grid.h - 1 do
		for ix = 0, data.grid.w - 1 do
			local c = data.cells.grid[ix][iz]
			local neigh = {}
			for dz = -1, 1 do
				for dx = -1, 1 do
					if not ((dx == 0) and (dz == 0)) then
						local jx, jz = ix + dx, iz + dz
						if ((jx >= 0) and (jx < data.grid.w) and (jz >= 0) and (jz < data.grid.h)) then
							local row = data.cells.grid[jx]
							local n = row and row[jz]
							if n then
								neigh[#neigh + 1] = n
							end
						end
					end
				end
			end
			c.neigh = neigh
		end
	end
end

local function neighbors(ix, iz)
	local row = data.cells.grid[ix]
	local c = row and row[iz]
	return (c and c.neigh) or {}
end

local function planMove()
	if (not data.cache.xs_centers_cached or not data.cache.zs_centers_cached or (data.grid.w == 0) or (data.grid.h == 0)) then
		return
	end
	if (#data.cells.numbered == 0) then
		data.cells.toFlag = {}
		data.cells.toClear = {}
		data.cells.guess = {}
		return
	end
	
	data.cells.toFlag = {}
	data.cells.toClear = {}
	data.cells.guess = {}
	local knownFlag = {}
	for _, cell in pairs(data.cells.all) do
		if (cell.state == "flagged") then
			knownFlag[cell] = true
		end
	end
	
	local knownClear = {}
	local scratch = {}
	local function computeUnknowns(c)
		local nbs = neighbors(c.ix, c.iz)
		for i = 1, #scratch do
			scratch[i] = nil
		end
		local flaggedCount = 0
		for i = 1, #nbs do
			local nb = nbs[i]
			if (knownFlag[nb] or (nb.state == "flagged")) then
				flaggedCount = flaggedCount + 1
			elseif (not knownClear[nb] and isCoveredCell(nb)) then
				scratch[#scratch + 1] = nb
			end
		end
		return scratch, flaggedCount
	end
	
	local changed = true
	local guard = 0
	while changed and (guard < 64) do
		changed = false
		guard = guard + 1
		for _, cell in ipairs(data.cells.numbered) do
			local num = cell.number or 0
			local unknowns, flaggedCount = computeUnknowns(cell)
			local remaining = num - flaggedCount
			if ((remaining > 0) and (remaining == #unknowns)) then
				for i = 1, #unknowns do
					local u = unknowns[i]
					if not knownFlag[u] then
						knownFlag[u] = true
						data.cells.toFlag[u] = true
						changed = true
					end
				end
			elseif ((remaining == 0) and (#unknowns > 0)) then
				for i = 1, #unknowns do
					local u = unknowns[i]
					if not knownClear[u] then
						knownClear[u] = true
						data.cells.toClear[u] = true
						changed = true
					end
				end
			end
		end
	end
	
	local accum = {}
	for _, cell in ipairs(data.cells.numbered) do
		local num = cell.number or 0
		local unknowns, flaggedCount = computeUnknowns(cell)
		local remaining = num - flaggedCount
		if ((remaining > 0) and (#unknowns > 0)) then
			local p_each = remaining / #unknowns
			for i = 1, #unknowns do
				local u = unknowns[i]
				if (not knownFlag[u] and not knownClear[u]) then
					local e = accum[u]
					if not e then
						e = {sum=0, w=0}
						accum[u] = e
					end
					e.sum = e.sum + p_each
					e.w = e.w + 1
				end
			end
		end
	end
	
	local pflag = data.ui.PROB_FLAG_THRESHOLD
	for cell, e in pairs(accum) do
		local p = ((e.w > 0) and (e.sum / e.w)) or 0
		if knownFlag[cell] then
			data.cells.toFlag[cell] = true
		elseif (p >= pflag) then
			data.cells.toFlag[cell] = true
			knownFlag[cell] = true
		else
			data.cells.guess[cell] = p
		end
	end
	
	for cell, _ in pairs(data.cells.toFlag) do
		data.cells.toClear[cell] = nil
		data.cells.guess[cell] = nil
	end
	for cell, _ in pairs(data.cells.toClear) do
		data.cells.toFlag[cell] = nil
		data.cells.guess[cell] = nil
	end
	for cell, _ in pairs(data.cells.guess) do
		if knownFlag[cell] then
			data.cells.guess[cell] = nil
		end
	end
end

local function clearHighlights()
	for _, highlight in pairs(data.highlights) do
		if (highlight and highlight.Parent) then
			highlight:Destroy()
		end
	end
	data.highlights = {}
end

local function clearProbLabels()
	for _, label in pairs(data.probLabels) do
		if (label and label.Parent) then
			label:Destroy()
		end
	end
	data.probLabels = {}
end

local function createHighlight(part, color)
	local highlight = Instance.new("SelectionBox")
	highlight.Adornee = part
	highlight.Color3 = color
	highlight.LineThickness = 0.1
	highlight.Transparency = 0.3
	highlight.Parent = part
	return highlight
end

local function createProbLabel(part, probability)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Adornee = part
	billboardGui.Size = UDim2.new(0, 50, 0, 30)
	billboardGui.StudsOffset = Vector3.new(0, 1, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = part
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.BackgroundTransparency = 0.3
	textLabel.BorderSizePixel = 0
	textLabel.Text = string.format("%.0f%%", probability * 100)
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	textLabel.TextSize = 18
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboardGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = textLabel
	
	return billboardGui
end

local function highlightCells()
	clearHighlights()
	clearProbLabels()
	
	local safeCount = 0
	local mineCount = 0
	
	for cell, _ in pairs(data.cells.toClear or {}) do
		if cell.part then
			local highlight = createHighlight(cell.part, Color3.fromRGB(0, 255, 0))
			table.insert(data.highlights, highlight)
			safeCount = safeCount + 1
		end
	end
	
	for cell, _ in pairs(data.cells.toFlag or {}) do
		if cell.part then
			local highlight = createHighlight(cell.part, Color3.fromRGB(255, 0, 0))
			table.insert(data.highlights, highlight)
			mineCount = mineCount + 1
		end
	end
	
	-- Show probability labels if enabled
	if data.ui.showProbability then
		for cell, prob in pairs(data.cells.guess or {}) do
			if cell.part and prob > 0 then
				local label = createProbLabel(cell.part, prob)
				table.insert(data.probLabels, label)
			end
		end
	end
	
	if ((safeCount > 0) or (mineCount > 0)) then
		print("Highlighted: " .. safeCount .. " safe (green), " .. mineCount .. " mines (red)")
	end
end

-- =============================================
-- NEW CLEAN UI WITH SHOW/HIDE AND PROBABILITY
-- =============================================

local mainGui = Instance.new('ScreenGui')
mainGui.Name = 'MinesweeperSolverUI'
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = v4

-- Main Control Frame
local controlFrame = Instance.new('Frame')
controlFrame.Name = 'ControlFrame'
controlFrame.Size = UDim2.new(0, 280, 0, 180)
controlFrame.Position = UDim2.new(1, -300, 0, 20)
controlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
controlFrame.BorderSizePixel = 0
controlFrame.Parent = mainGui

local frameCorner = Instance.new('UICorner')
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = controlFrame

local frameStroke = Instance.new('UIStroke')
frameStroke.Color = Color3.fromRGB(100, 200, 255)
frameStroke.Thickness = 3
frameStroke.Parent = controlFrame

-- Title
local titleLabel = Instance.new('TextLabel')
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = '💣 MINESWEEPER SOLVER'
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = controlFrame

-- Status Label
local statusLabel = Instance.new('TextLabel')
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = 'Status: ACTIVE'
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = controlFrame

-- Toggle Solver Button
local toggleButton = Instance.new('TextButton')
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleButton.Text = '✓ ENABLED'
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = controlFrame

local toggleCorner = Instance.new('UICorner')
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Show Probability Button
local probButton = Instance.new('TextButton')
probButton.Size = UDim2.new(0, 120, 0, 35)
probButton.Position = UDim2.new(0, 150, 0, 70)
probButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
probButton.Text = '% OFF'
probButton.TextSize = 14
probButton.Font = Enum.Font.GothamBold
probButton.TextColor3 = Color3.fromRGB(255, 255, 255)
probButton.BorderSizePixel = 0
probButton.Parent = controlFrame

local probCorner = Instance.new('UICorner')
probCorner.CornerRadius = UDim.new(0, 8)
probCorner.Parent = probButton

-- Stats Label
local statsLabel = Instance.new('TextLabel')
statsLabel.Size = UDim2.new(1, -20, 0, 40)
statsLabel.Position = UDim2.new(0, 10, 0, 115)
statsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statsLabel.Text = '🟢 Safe: 0 | 🔴 Mines: 0'
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.BorderSizePixel = 0
statsLabel.Parent = controlFrame

local statsCorner = Instance.new('UICorner')
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsLabel

-- Hide/Show Button (minimized state)
local hideButton = Instance.new('TextButton')
hideButton.Size = UDim2.new(0, 40, 0, 40)
hideButton.Position = UDim2.new(1, -300, 0, 20)
hideButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
hideButton.Text = '◀'
hideButton.TextSize = 20
hideButton.Font = Enum.Font.GothamBold
hideButton.TextColor3 = Color3.fromRGB(100, 200, 255)
hideButton.BorderSizePixel = 0
hideButton.Parent = mainGui
hideButton.Visible = false

local hideCorner = Instance.new('UICorner')
hideCorner.CornerRadius = UDim.new(0, 10)
hideCorner.Parent = hideButton

local hideStroke = Instance.new('UIStroke')
hideStroke.Color = Color3.fromRGB(100, 200, 255)
hideStroke.Thickness = 3
hideStroke.Parent = hideButton

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	controlFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	hideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

controlFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = controlFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

controlFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Toggle Solver ON/OFF
toggleButton.MouseButton1Click:Connect(function()
	data.enabled = not data.enabled
	if data.enabled then
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		toggleButton.Text = '✓ ENABLED'
		statusLabel.Text = 'Status: ACTIVE'
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
		print("Minesweeper Solver ENABLED")
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		toggleButton.Text = '✗ DISABLED'
		statusLabel.Text = 'Status: INACTIVE'
		statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		clearHighlights()
		clearProbLabels()
		print("Minesweeper Solver DISABLED")
	end
end)

-- Toggle Probability Display
probButton.MouseButton1Click:Connect(function()
	data.ui.showProbability = not data.ui.showProbability
	if data.ui.showProbability then
		probButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		probButton.Text = '% ON'
		print("Probability Display ENABLED")
	else
		probButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		probButton.Text = '% OFF'
		clearProbLabels()
		print("Probability Display DISABLED")
	end
end)

-- Hide/Show UI functionality
hideButton.MouseButton1Click:Connect(function()
	data.ui.uiVisible = true
	controlFrame.Visible = true
	hideButton.Visible = false
	hideButton.Text = '◀'
end)

titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		data.ui.uiVisible = false
		controlFrame.Visible = false
		hideButton.Visible = true
		hideButton.Text = '▶'
	end
end)

-- Update stats display
local function updateStats()
	local safeCount = 0
	local mineCount = 0
	for _ in pairs(data.cells.toClear or {}) do
		safeCount = safeCount + 1
	end
	for _ in pairs(data.cells.toFlag or {}) do
		mineCount = mineCount + 1
	end
	statsLabel.Text = '🟢 Safe: ' .. safeCount .. ' | 🔴 Mines: ' .. mineCount
end

-- Main update loop
local lastBuild = 0
local function onUpdate()
	if not data.enabled then
		return
	end
	
	local now = tick()
	if ((now - lastBuild) > 2) then
		buildGrid()
		lastBuild = now
	end
	if ((data.grid.w == 0) or not data.cache.xs_centers_cached or not data.cache.zs_centers_cached) then
		return
	end
	
	local nowMs = now * 1000
	if ((data.timing.lastPlanTick == 0) or ((nowMs - data.timing.lastPlanTick) >= data.timing.planIntervalMs)) then
		planMove()
		highlightCells()
		updateStats()
		data.timing.lastPlanTick = nowMs
	end
end

game:GetService("RunService").Heartbeat:Connect(onUpdate)

print("======================")
print("💣 MINESWEEPER SOLVER")
print("======================")
print("✓ Loaded successfully!")
print("🟢 Green = Safe cells")
print("🔴 Red = Mine locations")
print("📊 Toggle % to show probability")
print("🖱️ Right-click title to hide/show UI")
print("📍 Drag panel to move")
print("======================")
