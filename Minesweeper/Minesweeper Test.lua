local v0 = game:GetService('TweenService')
local v1 = game:GetService('Players')
local v3 = v1.LocalPlayer
local v4 = v3:WaitForChild('PlayerGui')

-- Minesweeper Solver Data Structure
local data = {
	ui = {
		PROB_FLAG_THRESHOLD = 0.7,
	},
	grid = {
		w = 0,
		h = 0,
	},
	cache = {
		xs_cached = nil,
		zs_cached = nil,
		xs_centers_cached = nil,
		zs_centers_cached = nil,
	},
	cells = {
		grid = {},
		all = {},
		numbered = {},
		toFlag = {},
		toClear = {},
		guess = {},
	},
	timing = {
		lastPlanTick = 0,
		planIntervalMs = 0,
	},
	highlights = {},
	enabled = true,
}

-- Helper functions
local function key(ix, iz)
	return tostring(ix) .. "_" .. tostring(iz);
end

local function abs(x)
	return (x >= 0) and x or (-x);
end

local function isNumber(str)
	return str and (str:match("^%d+$") ~= nil);
end

local function isCoveredCell(cell)
	return cell.covered;
end

local function isPartFlagged(part)
	if not part then
		return false;
	end
	local fg = part:FindFirstChild("FlagGui");
	if fg then
		local flag = fg:FindFirstChild("Flag");
		if (flag and flag.Visible) then
			return true;
		end
	end
	return false;
end

local function nearestIndex(val, arr)
	if (not arr or (#arr == 0)) then
		return -1;
	end
	local best = 0;
	local bestDist = abs(val - arr[1]);
	for i = 2, #arr do
		local d = abs(val - arr[i]);
		if (d < bestDist) then
			bestDist = d;
			best = i - 1;
		end
	end
	return best;
end

local function buildGrid()
	local boardParts = {};
	local ok, result = pcall(function()
		local folder = workspace:FindFirstChild("BoardFolder");
		if (not folder or (not folder:IsA("Folder") and not folder:IsA("Model"))) then
			return {};
		end
		local out = {};
		for _, child in pairs(folder:GetChildren()) do
			if (child:IsA("BasePart") and (child.Name == "Board")) then
				out[#out + 1] = child;
			end
		end
		return out;
	end);
	if not ok then
		boardParts = {};
	else
		boardParts = result;
	end
	if (#boardParts == 0) then
		data.grid.w = 0;
		data.grid.h = 0;
		data.cache.xs_cached = nil;
		data.cache.zs_cached = nil;
		data.cache.xs_centers_cached = nil;
		data.cache.zs_centers_cached = nil;
		return;
	end
	local raw = {};
	for _, board in ipairs(boardParts) do
		local ok2, pos = pcall(function()
			return board.Position;
		end);
		if ok2 then
			raw[#raw + 1] = {part=board,pos=pos};
		end
	end
	if (#raw == 0) then
		data.grid.w = 0;
		data.grid.h = 0;
		data.cache.xs_cached = nil;
		data.cache.zs_cached = nil;
		data.cache.xs_centers_cached = nil;
		data.cache.zs_centers_cached = nil;
		return;
	end
	local xs = {};
	local zs = {};
	for _, item in ipairs(raw) do
		local pos = item.pos;
		xs[#xs + 1] = pos.X;
		zs[#zs + 1] = pos.Z;
	end
	table.sort(xs, function(a, b)
		return a < b;
	end);
	table.sort(zs, function(a, b)
		return a < b;
	end);
	local function uniqueRows(arr, eps)
		if (#arr == 0) then
			return {};
		end
		local out = {arr[1]};
		for i = 2, #arr do
			local v = arr[i];
			local last = out[#out];
			if (abs(v - last) > eps) then
				out[#out + 1] = v;
			end
		end
		return out;
	end
	local eps = 0.2;
	local xs_unique = uniqueRows(xs, eps);
	local zs_unique = uniqueRows(zs, eps);
	local function centerRows(arr)
		if (#arr < 2) then
			return arr;
		end
		local out = {};
		for i = 1, #arr - 1 do
			local a = arr[i];
			local b = arr[i + 1];
			local mid = (a + b) / 2;
			out[#out + 1] = mid;
		end
		return out;
	end
	local xs_centers = centerRows(xs_unique);
	local zs_centers = centerRows(zs_unique);
	local w = #xs_centers;
	local h = #zs_centers;
	if ((w < 4) or (h < 4)) then
		data.grid.w = 0;
		data.grid.h = 0;
		data.cache.xs_cached = nil;
		data.cache.zs_cached = nil;
		data.cache.xs_centers_cached = nil;
		data.cache.zs_centers_cached = nil;
		return;
	end
	data.grid.w = w;
	data.grid.h = h;
	data.cache.xs_cached = xs_unique;
	data.cache.zs_cached = zs_unique;
	data.cache.xs_centers_cached = xs_centers;
	data.cache.zs_centers_cached = zs_centers;
	data.cells.grid = {};
	data.cells.all = {};
	data.cells.numbered = {};
	for ix = 0, w - 1 do
		local row = {};
		data.cells.grid[ix] = row;
		for iz = 0, h - 1 do
			local k = key(ix, iz);
			local cell = {
				ix = ix,
				iz = iz,
				part = nil,
				pos = nil,
				color = nil,
				covered = true,
				state = "unknown",
				number = nil,
				neigh = {},
			};
			data.cells.all[k] = cell;
			row[iz] = cell;
		end
	end
	for _, item in ipairs(raw) do
		local part = item.part;
		local pos = item.pos;
		local ix = nearestIndex(pos.X, data.cache.xs_centers_cached);
		local iz = nearestIndex(pos.Z, data.cache.zs_centers_cached);
		if ((ix >= 0) and (ix < data.grid.w) and (iz >= 0) and (iz < data.grid.h)) then
			local k = key(ix, iz);
			local cell = data.cells.all[k];
			if not cell.part then
				cell.part = part;
				cell.pos = pos;
			else
				local cur_d = abs(((cell.part and cell.part.Position.X) or cell.pos.X) - data.cache.xs_centers_cached[ix + 1]) + abs(((cell.part and cell.part.Position.Z) or cell.pos.Z) - data.cache.zs_centers_cached[iz + 1]);
				local new_d = abs(pos.X - data.cache.xs_centers_cached[ix + 1]) + abs(pos.Z - data.cache.zs_centers_cached[iz + 1]);
				if (new_d < cur_d) then
					cell.part = part;
					cell.pos = pos;
				end
			end
			if part.Color then
				local color = part.Color;
				local r = color.R or color.r or color[1];
				local g = color.G or color.g or color[2];
				local b = color.B or color.b or color[3];
				if (r and (r <= 1)) then
					r = math.floor((r * 255) + 0.5);
				end
				if (g and (g <= 1)) then
					g = math.floor((g * 255) + 0.5);
				end
				if (b and (b <= 1)) then
					b = math.floor((b * 255) + 0.5);
				end
				cell.color = {R=r,G=g,B=b};
			end
			local ngui = part:FindFirstChild("NumberGui");
			if ngui then
				local textLabel = ngui:FindFirstChild("TextLabel");
				if (textLabel and textLabel.Text and isNumber(textLabel.Text)) then
					cell.number = tonumber(textLabel.Text);
					cell.covered = false;
				end
			end
			if (cell.color and cell.color.R and cell.color.G and cell.color.B) then
				if ((cell.color.R == 255) and (cell.color.G == 255) and (cell.color.B == 125)) then
					cell.covered = false;
				end
			end
			if isPartFlagged(part) then
				cell.state = "flagged";
			end
			if (cell.number and not cell.covered) then
				cell.state = "number";
				table.insert(data.cells.numbered, cell);
			end
		end
	end
	for iz = 0, data.grid.h - 1 do
		for ix = 0, data.grid.w - 1 do
			local c = data.cells.grid[ix][iz];
			local neigh = {};
			for dz = -1, 1 do
				for dx = -1, 1 do
					if not ((dx == 0) and (dz == 0)) then
						local jx, jz = ix + dx, iz + dz;
						if ((jx >= 0) and (jx < data.grid.w) and (jz >= 0) and (jz < data.grid.h)) then
							local row = data.cells.grid[jx];
							local n = row and row[jz];
							if n then
								neigh[#neigh + 1] = n;
							end
						end
					end
				end
			end
			c.neigh = neigh;
		end
	end
end

local function neighbors(ix, iz)
	local row = data.cells.grid[ix];
	local c = row and row[iz];
	return (c and c.neigh) or {};
end

local function planMove()
	if (not data.cache.xs_centers_cached or not data.cache.zs_centers_cached or (data.grid.w == 0) or (data.grid.h == 0)) then
		return;
	end
	if (#data.cells.numbered == 0) then
		data.cells.toFlag = {};
		data.cells.toClear = {};
		data.cells.guess = {};
		return;
	end
	data.cells.toFlag = {};
	data.cells.toClear = {};
	data.cells.guess = {};
	local knownFlag = {};
	for _, cell in pairs(data.cells.all) do
		if (cell.state == "flagged") then
			knownFlag[cell] = true;
		end
	end
	local knownClear = {};
	local scratch = {};
	local function computeUnknowns(c)
		local nbs = neighbors(c.ix, c.iz);
		for i = 1, #scratch do
			scratch[i] = nil;
		end
		local flaggedCount = 0;
		for i = 1, #nbs do
			local nb = nbs[i];
			if (knownFlag[nb] or (nb.state == "flagged")) then
				flaggedCount = flaggedCount + 1;
			elseif (not knownClear[nb] and isCoveredCell(nb)) then
				scratch[#scratch + 1] = nb;
			end
		end
		return scratch, flaggedCount;
	end
	local changed = true;
	local guard = 0;
	while changed and (guard < 64) do
		changed = false;
		guard = guard + 1;
		for _, cell in ipairs(data.cells.numbered) do
			local num = cell.number or 0;
			local unknowns, flaggedCount = computeUnknowns(cell);
			local remaining = num - flaggedCount;
			if ((remaining > 0) and (remaining == #unknowns)) then
				for i = 1, #unknowns do
					local u = unknowns[i];
					if not knownFlag[u] then
						knownFlag[u] = true;
						data.cells.toFlag[u] = true;
						changed = true;
					end
				end
			elseif ((remaining == 0) and (#unknowns > 0)) then
				for i = 1, #unknowns do
					local u = unknowns[i];
					if not knownClear[u] then
						knownClear[u] = true;
						data.cells.toClear[u] = true;
						changed = true;
					end
				end
			end
		end
	end
	local accum = {};
	for _, cell in ipairs(data.cells.numbered) do
		local num = cell.number or 0;
		local unknowns, flaggedCount = computeUnknowns(cell);
		local remaining = num - flaggedCount;
		if ((remaining > 0) and (#unknowns > 0)) then
			local p_each = remaining / #unknowns;
			for i = 1, #unknowns do
				local u = unknowns[i];
				if (not knownFlag[u] and not knownClear[u]) then
					local e = accum[u];
					if not e then
						e = {sum=0,w=0};
						accum[u] = e;
					end
					e.sum = e.sum + p_each;
					e.w = e.w + 1;
				end
			end
		end
	end
	local pflag = data.ui.PROB_FLAG_THRESHOLD;
	for cell, e in pairs(accum) do
		local p = ((e.w > 0) and (e.sum / e.w)) or 0;
		if knownFlag[cell] then
			data.cells.toFlag[cell] = true;
		elseif (p >= pflag) then
			data.cells.toFlag[cell] = true;
			knownFlag[cell] = true;
		else
			data.cells.guess[cell] = p;
		end
	end
	for cell, _ in pairs(data.cells.toFlag) do
		data.cells.toClear[cell] = nil;
		data.cells.guess[cell] = nil;
	end
	for cell, _ in pairs(data.cells.toClear) do
		data.cells.toFlag[cell] = nil;
		data.cells.guess[cell] = nil;
	end
	for cell, _ in pairs(data.cells.guess) do
		if knownFlag[cell] then
			data.cells.guess[cell] = nil;
		end
	end
end

local function clearHighlights()
	for _, highlight in pairs(data.highlights) do
		if (highlight and highlight.Parent) then
			highlight:Destroy();
		end
	end
	data.highlights = {};
end

local function createHighlight(part, color)
	local highlight = Instance.new("SelectionBox");
	highlight.Adornee = part;
	highlight.Color3 = color;
	highlight.LineThickness = 0.1;
	highlight.Transparency = 0.3;
	highlight.Parent = part;
	return highlight;
end

local function highlightCells()
	clearHighlights();
	local safeCount = 0;
	local mineCount = 0;
	for cell, _ in pairs(data.cells.toClear or {}) do
		if cell.part then
			local highlight = createHighlight(cell.part, Color3.fromRGB(0, 255, 0));
			table.insert(data.highlights, highlight);
			safeCount = safeCount + 1;
		end
	end
	for cell, _ in pairs(data.cells.toFlag or {}) do
		if cell.part then
			local highlight = createHighlight(cell.part, Color3.fromRGB(255, 0, 0));
			table.insert(data.highlights, highlight);
			mineCount = mineCount + 1;
		end
	end
end

-- NEW CLEAN UI - Toggle Control Panel
local mainGui = Instance.new('ScreenGui')
mainGui.Name = 'MinesweeperSolverUI'
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = v4

-- Main Control Frame
local controlFrame = Instance.new('Frame')
controlFrame.Name = 'ControlFrame'
controlFrame.Size = UDim2.new(0, 280, 0, 120)
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
frameStroke.Transparency = 0
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

-- Toggle Button
local toggleButton = Instance.new('TextButton')
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleButton.Text = '✓ ENABLED'
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = controlFrame

local toggleCorner = Instance.new('UICorner')
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- Info Button
local infoButton = Instance.new('TextButton')
infoButton.Size = UDim2.new(0, 120, 0, 40)
infoButton.Position = UDim2.new(0, 150, 0, 70)
infoButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
infoButton.Text = 'ℹ INFO'
infoButton.TextSize = 16
infoButton.Font = Enum.Font.GothamBold
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.BorderSizePixel = 0
infoButton.Parent = controlFrame

local infoCorner = Instance.new('UICorner')
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoButton

-- Stats Label
local statsLabel = Instance.new('TextLabel')
statsLabel.Size = UDim2.new(0, 260, 0, 50)
statsLabel.Position = UDim2.new(0, 10, 1, 10)
statsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statsLabel.Text = '🟢 Safe: 0 | 🔴 Mines: 0'
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.BorderSizePixel = 0
statsLabel.Parent = controlFrame

local statsCorner = Instance.new('UICorner')
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsLabel

local statsStroke = Instance.new('UIStroke')
statsStroke.Color = Color3.fromRGB(100, 200, 255)
statsStroke.Thickness = 2
statsStroke.Parent = statsLabel

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	controlFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- Toggle Button Functionality
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
		print("Minesweeper Solver DISABLED")
	end
end)

-- Info Button Functionality
infoButton.MouseButton1Click:Connect(function()
	print("======================")
	print("MINESWEEPER SOLVER INFO")
	print("======================")
	print("🟢 Green boxes = Safe cells")
	print("🔴 Red boxes = Mine locations")
	print("Toggle ON/OFF to control solver")
	print("Drag the panel to move it")
	print("======================")
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
	
	planMove()
	highlightCells()
	updateStats()
	data.timing.lastPlanTick = now * 1000
end

game:GetService("RunService").Heartbeat:Connect(onUpdate)

print("======================")
print("💣 MINESWEEPER SOLVER")
print("======================")
print("✓ Loaded successfully!")
print("🟢 Green = Safe")
print("🔴 Red = Mines")
print("📍 Drag panel to move")
print("======================")
