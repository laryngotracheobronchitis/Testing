-- Auto Solve Minesweeper Script
if game:GetService("RunService"):IsStudio() or (game.PlaceId ~= 7871169780 and game.PlaceId ~= 9797651295) then
    return
end

local v1 = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
if v1:GetAttribute("AutoSolveMine") then return end
v1:SetAttribute("AutoSolveMine", true)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local c = Color3.fromRGB
local v = Vector2.new
local u = UDim2.new

local function n(t, p, x)
    local o = Instance.new(t, p)
    if x then
        for k, w in pairs(x) do
            pcall(function() o[k] = w end)
        end
    end
    return o
end

-- UI Setup
local sg = n("ScreenGui", v1, {
    DisplayOrder = 2147483647,
    Name = "AutoSolveMinesweeper",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- Show/Hide button (Flag emoji)
local showHideBtn = n("TextButton", sg, {
    Size = u(0, 60, 0, 60),
    Position = u(1, -70, 1, -70),
    BackgroundColor3 = c(40, 40, 40),
    BorderSizePixel = 2,
    BorderColor3 = c(100, 100, 100),
    Text = "ðŸš©",
    TextSize = 30,
    TextScaled = true,
    Font = Enum.Font.SourceSansBold,
    BackgroundTransparency = 0.6
})
n("UICorner", showHideBtn, { CornerRadius = UDim.new(0.15, 0) })
n("UIPadding", showHideBtn, { 
    PaddingTop = UDim.new(0.1, 0), 
    PaddingBottom = UDim.new(0.1, 0), 
    PaddingLeft = UDim.new(0.1, 0), 
    PaddingRight = UDim.new(0.1, 0) 
})

local main = n("Frame", sg, {
    Visible = false,
    Size = u(0, 300, 0, 240),
    Position = u(0.5, -150, 0.5, -120),
    BackgroundColor3 = c(0, 0, 0),
    BorderSizePixel = 0,
    BackgroundTransparency = 0.1
})
n("UICorner", main, { CornerRadius = UDim.new(0.05, 0) })
n("UIAspectRatioConstraint", main, { AspectRatio = 1.25 })

local innerFrame = n("Frame", main, {
    Size = u(0.99, 0, 0.99, 0),
    Position = u(0.5, 0, 0.505, 0),
    AnchorPoint = v(0.5, 0.5),
    BackgroundColor3 = c(20, 20, 20),
    BorderSizePixel = 0
})
n("UICorner", innerFrame, { CornerRadius = UDim.new(0.05, 0) })

local title = n("TextLabel", innerFrame, {
    Size = u(0.8, 0, 0, 30),
    Position = u(0.1, 0, 0, 10),
    BackgroundTransparency = 1,
    Text = "Auto Solve Minesweeper",
    TextColor3 = c(255, 255, 255),
    TextSize = 16,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local credit = n("TextLabel", innerFrame, {
    Size = u(0.5, 0, 0, 20),
    Position = u(0.5, 0, 0, 12),
    BackgroundTransparency = 1,
    Text = "v1.0",
    TextColor3 = c(150, 150, 150),
    TextSize = 11,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Right
})

-- Toggle Auto Solve
local toggleSolve = n("TextButton", innerFrame, {
    Size = u(0, 270, 0, 35),
    Position = u(0, 15, 0, 50),
    BackgroundColor3 = c(60, 60, 60),
    Text = "Auto Solve: OFF",
    TextColor3 = c(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.SourceSansBold,
    BorderSizePixel = 0
})
n("UICorner", toggleSolve, { CornerRadius = UDim.new(0.12, 0) })
n("UIGradient", toggleSolve, {
    Rotation = 90,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.684, 0),
        NumberSequenceKeypoint.new(0.9, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
})

-- Toggle Range
local toggleRange = n("TextButton", innerFrame, {
    Size = u(0, 130, 0, 32),
    Position = u(0, 15, 0, 95),
    BackgroundColor3 = c(60, 60, 60),
    Text = "Range: OFF",
    TextColor3 = c(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.SourceSansBold,
    BorderSizePixel = 0
})
n("UICorner", toggleRange, { CornerRadius = UDim.new(0.15, 0) })
n("UIGradient", toggleRange, {
    Rotation = 90,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.684, 0),
        NumberSequenceKeypoint.new(0.9, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
})

-- Range TextBox
local rangeInput = n("TextBox", innerFrame, {
    Size = u(0, 125, 0, 32),
    Position = u(0, 155, 0, 95),
    BackgroundColor3 = c(255, 255, 255),
    Text = "100",
    TextColor3 = c(0, 0, 0),
    TextSize = 13,
    Font = Enum.Font.SourceSansBold,
    PlaceholderText = "Range",
    PlaceholderColor3 = c(150, 150, 150),
    ClearTextOnFocus = false,
    BorderSizePixel = 0
})
n("UICorner", rangeInput, { CornerRadius = UDim.new(0.15, 0) })
n("UIGradient", rangeInput, {
    Rotation = 90,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.684, 0),
        NumberSequenceKeypoint.new(0.9, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
})
n("UIPadding", rangeInput, {
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
})

-- Toggle Freeze
local toggleFreeze = n("TextButton", innerFrame, {
    Size = u(0, 270, 0, 32),
    Position = u(0, 15, 0, 137),
    BackgroundColor3 = c(60, 60, 60),
    Text = "Freeze: OFF (Enable Auto Solve first)",
    TextColor3 = c(150, 150, 150),
    TextSize = 13,
    Font = Enum.Font.SourceSansBold,
    Active = false,
    BorderSizePixel = 0
})
n("UICorner", toggleFreeze, { CornerRadius = UDim.new(0.15, 0) })
n("UIGradient", toggleFreeze, {
    Rotation = 90,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.684, 0),
        NumberSequenceKeypoint.new(0.9, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
})

-- Status
local status = n("TextLabel", innerFrame, {
    Size = u(1, -30, 0, 35),
    Position = u(0, 15, 1, -50),
    BackgroundTransparency = 1,
    Text = "Status: Idle",
    TextColor3 = c(150, 150, 150),
    TextSize = 11,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true
})
n("UIGradient", status, {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.33)
    })
})

-- Make main panel draggable
local dragging, dragInput, dragStart, startPos
innerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

innerFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Make show/hide button draggable
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
showHideBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = showHideBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingBtn = false
            end
        end)
    end
end)

showHideBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputBtn = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - dragStartBtn
        showHideBtn.Position = UDim2.new(
            startPosBtn.X.Scale,
            startPosBtn.X.Offset + delta.X,
            startPosBtn.Y.Scale,
            startPosBtn.Y.Offset + delta.Y
        )
    end
end)

-- Show/Hide toggle with click detection
local clickStart = nil
showHideBtn.MouseButton1Down:Connect(function()
    clickStart = tick()
end)

showHideBtn.MouseButton1Up:Connect(function()
    if clickStart and (tick() - clickStart) < 0.2 and not draggingBtn then
        main.Visible = not main.Visible
    end
    clickStart = nil
end)

-- State
local state = {
    autosolve = false,
    range = false,
    rangeValue = 100,
    freeze = false,
    solving = false,
    flaggedIds = {},
    scannedTiles = {},
    frozenConnection = nil
}

-- Freeze character function
local function freezeCharacter(enable)
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if enable then
        -- Freeze
        if root then
            if state.frozenConnection then
                state.frozenConnection:Disconnect()
            end
            
            -- Anchor root
            root.Anchored = true
            
            -- Keep anchored even if game tries to unanchor
            state.frozenConnection = root:GetPropertyChangedSignal("Anchored"):Connect(function()
                if state.freeze then
                    root.Anchored = true
                end
            end)
        end
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    else
        -- Unfreeze
        if state.frozenConnection then
            state.frozenConnection:Disconnect()
            state.frozenConnection = nil
        end
        if root then
            root.Anchored = false
        end
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end

-- Toggles
toggleSolve.MouseButton1Click:Connect(function()
    state.autosolve = not state.autosolve
    toggleSolve.Text = "Auto Solve: " .. (state.autosolve and "ON" or "OFF")
    toggleSolve.BackgroundColor3 = state.autosolve and c(70, 150, 70) or c(60, 60, 60)
    
    -- Enable/disable freeze button
    if state.autosolve then
        toggleFreeze.Active = true
        toggleFreeze.Text = "Freeze: " .. (state.freeze and "ON" or "OFF")
        toggleFreeze.TextColor3 = c(255, 255, 255)
    else
        -- Turn off freeze and disable button
        if state.freeze then
            state.freeze = false
            freezeCharacter(false)
        end
        toggleFreeze.Active = false
        toggleFreeze.Text = "Freeze: OFF (Enable Auto Solve first)"
        toggleFreeze.TextColor3 = c(150, 150, 150)
        toggleFreeze.BackgroundColor3 = c(60, 60, 60)
        status.Text = "Status: Stopped"
    end
end)

toggleRange.MouseButton1Click:Connect(function()
    state.range = not state.range
    toggleRange.Text = "Range: " .. (state.range and "ON" or "OFF")
    toggleRange.BackgroundColor3 = state.range and c(70, 130, 255) or c(60, 60, 60)
end)

toggleFreeze.MouseButton1Click:Connect(function()
    if not state.autosolve then return end
    
    state.freeze = not state.freeze
    toggleFreeze.Text = "Freeze: " .. (state.freeze and "ON" or "OFF")
    toggleFreeze.BackgroundColor3 = state.freeze and c(255, 150, 50) or c(60, 60, 60)
    
    freezeCharacter(state.freeze)
end)

-- Range input
rangeInput.FocusLost:Connect(function()
    local value = tonumber(rangeInput.Text)
    if value and value >= 10 and value <= 10000 then
        state.rangeValue = value
    else
        rangeInput.Text = tostring(state.rangeValue)
    end
end)

-- Helper functions from original script
local function findPartsFolder()
    local w = game:GetService("Workspace")
    local d = w:FindFirstChild("Flag")
    if d then
        local u = d:FindFirstChild("Parts")
        if u and u:IsA("Folder") then return u end
    end
    local p = w:FindFirstChild("Parts", true)
    if p and p:IsA("Folder") then return p end
    local b, bC = nil, -1
    for _, i in ipairs(w:GetDescendants()) do
        if i:IsA("Folder") and i.Name == "Parts" then
            local c = 0
            for _, ch in ipairs(i:GetChildren()) do
                if ch:IsA("BasePart") then c = c + 1 end
            end
            if c > bC then b, bC = i, c end
        end
    end
    return b
end

local function clamp(val, min, max)
    if val < min then return min
    elseif val > max then return max
    else return val end
end

local function GridIndex(vDelta, cell, tol)
    tol = math.clamp(tol or 0.25, 0, 0.49)
    local raw = vDelta / cell
    local idx = math.floor(raw + 0.5)
    if math.abs(raw - idx) > 0.5 + tol then
        idx = idx + (raw > idx and 1 or -1)
    end
    return idx
end

local function getNeighbors(r, c, H, W)
    local neighbors = {}
    for dr = -1, 1 do
        for dc = -1, 1 do
            if not (dr == 0 and dc == 0) then
                local rr, cc = r + dr, c + dc
                if rr >= 1 and rr <= H and cc >= 1 and cc <= W then
                    table.insert(neighbors, {rr, cc})
                end
            end
        end
    end
    return neighbors
end

local function getTileNumber(textLabel)
    if not textLabel then return nil end
    local text = textLabel.Text
    local num = tonumber(text)
    if num then return num end
    local d = text:match("(%d)")
    return d and tonumber(d) or 0
end

-- Teleport function
local function teleportTo(position)
    local player = Players.LocalPlayer
    if not player or not player.Character then return false end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    -- Temporarily unfreeze for teleport
    local wasAnchored = root.Anchored
    if state.freeze then
        root.Anchored = false
    end
    
    pcall(function()
        root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    end)
    
    task.wait(0.1)
    
    -- Refreeze if needed
    if state.freeze and not wasAnchored then
        root.Anchored = true
    end
    
    return true
end

-- Flag function
local function placeFlag(part)
    if not part then return false end
    local id = part:GetDebugId()
    if state.flaggedIds[id] then return false end
    
    local flagEvent = ReplicatedStorage:FindFirstChild("Events")
    if flagEvent then
        flagEvent = flagEvent:FindFirstChild("FlagEvents")
        if flagEvent then
            flagEvent = flagEvent:FindFirstChild("PlaceFlag")
            if flagEvent then
                pcall(function()
                    flagEvent:FireServer(part, id, true)
                    state.flaggedIds[id] = true
                end)
                return true
            end
        end
    end
    return false
end

-- Click tile function
local function clickTile(part)
    if not part then return false end
    local cd = part:FindFirstChildOfClass("ClickDetector", true)
    if cd then
        pcall(function()
            fireclickdetector(cd)
        end)
        return true
    end
    return false
end

-- Scan and solve
local function solveMinesweeper()
    if state.solving or not state.autosolve then return end
    state.solving = true
    
    local folder = findPartsFolder()
    if not folder then
        status.Text = "Status: Parts folder not found"
        state.solving = false
        return
    end
    
    local player = Players.LocalPlayer
    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    -- Build part cache
    local partCache = {}
    local revealedParts = {}
    
    for _, part in ipairs(folder:GetChildren()) do
        if part:IsA("BasePart") then
            -- Check if in range
            if state.range and root then
                local dist = (part.Position - root.Position).Magnitude
                if dist > state.rangeValue then
                    continue
                end
            end
            
            local gui = part:FindFirstChild("NumberGui", true)
            local textLabel = gui and gui:FindFirstChildWhichIsA("TextLabel")
            
            -- Check if flagged
            local isFlagged = false
            for _, child in ipairs(part:GetChildren()) do
                if child.Name:lower():find("flag") or child:IsA("BillboardGui") then
                    isFlagged = true
                    break
                end
            end
            
            local id = part:GetDebugId()
            if state.flaggedIds[id] then isFlagged = true end
            
            partCache[part] = {
                part = part,
                pos = part.Position,
                label = textLabel,
                flagged = isFlagged,
                revealed = textLabel ~= nil
            }
            
            if textLabel and not isFlagged then
                table.insert(revealedParts, part)
            end
        end
    end
    
    if #revealedParts == 0 then
        status.Text = "Status: No revealed tiles found"
        state.solving = false
        return
    end
    
    -- Find closest revealed tile as center
    local centerPart = revealedParts[1]
    if root then
        local minDist = math.huge
        for _, part in ipairs(revealedParts) do
            local dist = (part.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                centerPart = part
            end
        end
    end
    
    -- Estimate grid spacing
    local spacings = {}
    for i = 1, math.min(50, #revealedParts) do
        for j = i + 1, math.min(50, #revealedParts) do
            local p1 = revealedParts[i].Position
            local p2 = revealedParts[j].Position
            local d = (p1 - p2).Magnitude
            if d > 0.1 and d < 20 then
                table.insert(spacings, d)
            end
        end
    end
    
    table.sort(spacings)
    local cellSize = spacings[math.floor(#spacings * 0.2)] or 5
    
    -- Build grid
    local centerPos = centerPart.Position
    local grid = {}
    local minR, maxR, minC, maxC = math.huge, -math.huge, math.huge, -math.huge
    
    for part, data in pairs(partCache) do
        local gx = GridIndex(data.pos.X - centerPos.X, cellSize, 0.25)
        local gy = GridIndex(data.pos.Z - centerPos.Z, cellSize, 0.25)
        
        if not grid[gy] then grid[gy] = {} end
        grid[gy][gx] = data
        
        minR = math.min(minR, gy)
        maxR = math.max(maxR, gy)
        minC = math.min(minC, gx)
        maxC = math.max(maxC, gx)
    end
    
    local H = maxR - minR + 1
    local W = maxC - minC + 1
    
    -- Convert to 1-indexed grid
    local b0 = {}
    for r = 1, H do
        b0[r] = {}
        for c = 1, W do
            local gy = minR + r - 1
            local gx = minC + c - 1
            local data = grid[gy] and grid[gy][gx]
            if data then
                if data.flagged then
                    b0[r][c] = { state = "flagged", data = data }
                elseif data.revealed then
                    local num = getTileNumber(data.label)
                    b0[r][c] = { state = "revealed", num = num or 0, data = data }
                else
                    b0[r][c] = { state = "covered", data = data }
                end
            else
                b0[r][c] = { state = "empty" }
            end
        end
    end
    
    -- Solve logic
    local safeTiles = {}
    local bombTiles = {}
    local unknownTiles = {}
    
    for r = 1, H do
        for c = 1, W do
            if b0[r][c].state == "revealed" then
                local num = b0[r][c].num
                local neighbors = getNeighbors(r, c, H, W)
                
                local coveredNeighbors = {}
                local flaggedCount = 0
                
                for _, rc in ipairs(neighbors) do
                    local rr, cc = rc[1], rc[2]
                    if b0[rr][cc].state == "flagged" then
                        flaggedCount = flaggedCount + 1
                    elseif b0[rr][cc].state == "covered" then
                        table.insert(coveredNeighbors, {rr, cc})
                    end
                end
                
                -- All remaining are mines
                if #coveredNeighbors > 0 and (num - flaggedCount) == #coveredNeighbors then
                    for _, rc in ipairs(coveredNeighbors) do
                        table.insert(bombTiles, {r = rc[1], c = rc[2]})
                    end
                end
                
                -- All mines found, rest are safe
                if #coveredNeighbors > 0 and flaggedCount == num then
                    for _, rc in ipairs(coveredNeighbors) do
                        table.insert(safeTiles, {r = rc[1], c = rc[2]})
                    end
                end
            elseif b0[r][c].state == "covered" then
                table.insert(unknownTiles, {r = r, c = c})
            end
        end
    end
    
    -- Execute actions
    local actionCount = 0
    
    -- Place flags on bombs
    for _, tile in ipairs(bombTiles) do
        local data = b0[tile.r][tile.c].data
        if data and not data.flagged then
            if placeFlag(data.part) then
                actionCount = actionCount + 1
                status.Text = string.format("Status: Flagging bomb (%d,%d)", tile.r, tile.c)
                task.wait(0.05)
            end
        end
    end
    
    -- Click safe tiles
    for _, tile in ipairs(safeTiles) do
        local data = b0[tile.r][tile.c].data
        if data then
            if root and state.range then
                local dist = (data.part.Position - root.Position).Magnitude
                if dist > state.rangeValue then
                    teleportTo(data.part.Position)
                    task.wait(0.3)
                end
            end
            
            if clickTile(data.part) then
                actionCount = actionCount + 1
                status.Text = string.format("Status: Clicking safe tile (%d,%d)", tile.r, tile.c)
                task.wait(0.1)
            end
        end
    end
    
    -- Status update
    if actionCount == 0 then
        if #unknownTiles > 0 then
            status.Text = string.format("Status: %d unknown tiles, waiting...", #unknownTiles)
        else
            status.Text = "Status: Puzzle complete!"
            state.autosolve = false
            toggleSolve.Text = "Auto Solve: OFF"
            toggleSolve.BackgroundColor3 = c(60, 60, 60)
        end
    end
    
    state.solving = false
end

-- Main loop
RunService.Heartbeat:Connect(function()
    if state.autosolve and not state.solving then
        task.spawn(solveMinesweeper)
        task.wait(0.5)
    end
end)

status.Text = "Status: Ready"
