-- Auto Solve Minesweeper (Using Sweep UI)
if game:GetService("RunService"):IsStudio() or (game.PlaceId ~= 7871169780 and game.PlaceId ~= 9797651295) then
    return
end

local v1 = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
if v1:GetAttribute("AutoSolveMine") then return end
v1:SetAttribute("AutoSolveMine", true)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Helper functions
local P = v1
local c = Color3.fromRGB
local v = Vector2.new
local u = UDim2.new
local N = NumberSequence.new
local K = NumberSequenceKeypoint.new
local F = Font.new

local function n(t, p, x)
    local o = Instance.new(t, p)
    if x then
        for k, w in pairs(x) do
            pcall(function() o[k] = w end)
        end
    end
    return o
end

-- UI Setup (Same as Sweep)
local s = n("ScreenGui", P, {
    DisplayOrder = 2147483647,
    Name = "AutoSolveMinesweeper",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

local open = n("TextButton", s, {
    BorderSizePixel = 2,
    TextSize = 16,
    TextColor3 = c(255, 255, 255),
    BackgroundColor3 = c(40, 40, 40),
    FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    AnchorPoint = v(1, 1),
    BackgroundTransparency = 0.6,
    Size = u(0, 60, 0, 60),
    BorderColor3 = c(100, 100, 100),
    Text = "🚩",
    TextScaled = true,
    Name = "open",
    Position = u(1, -10, 1, -10)
})

n("UICorner", open, { CornerRadius = UDim.new(0.15, 0) })
n("UIPadding", open, { PaddingTop = UDim.new(.1, 0), PaddingBottom = UDim.new(.1, 0), PaddingLeft = UDim.new(.1, 0), PaddingRight = UDim.new(.1, 0) })

local panel = n("Frame", s, {
    Visible = false,
    BorderSizePixel = 0,
    BackgroundColor3 = c(0, 0, 0),
    AnchorPoint = v(.5, .5),
    Size = u(0, 600, 0, 308),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.95 })

local a = n("Frame", panel, {
    BorderSizePixel = 0,
    BackgroundColor3 = c(20, 20, 20),
    AnchorPoint = v(.5, .5),
    Size = u(.99, 0, .99, 0),
    Position = u(.5, 0, .505, 0),
    BorderColor3 = c(0, 0, 0)
})

n("UICorner", a, { CornerRadius = UDim.new(.05, 0) })

local creditLabel = n("TextLabel", a, {
    Text = "Auto Solve Minesweeper - v2.0",
    TextSize = 18,
    TextColor3 = c(200, 200, 200),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.35, 0, 0.08, 0),
    Position = u(0.63, 0, 0.01, 0),
    ZIndex = 10
})

local function ico(name, y)
    local i = n("ImageButton", a, {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        BackgroundColor3 = c(0, 0, 0),
        AnchorPoint = v(.5, .5),
        Image = "rbxassetid://16167594452",
        ImageRectSize = v(90, 90),
        Size = u(.06363, 0, .12408, 0),
        BorderColor3 = c(0, 0, 0),
        Name = name,
        ImageRectOffset = v(862, 472),
        Position = u(.06254, 0, y, 0)
    })
    n("UIAspectRatioConstraint", i)
    return i
end

local btnAutoSolve = ico("autosolve", .14419)
local btnRange = ico("range", .37886)
local btnFreeze = ico("freeze", .61352)

local function gradL(p)
    n("UIGradient", p, { Transparency = N { K(0, 0), K(1, .33125) } })
end

local function pad(p, t, l, bm)
    n("UIPadding", p, {
        PaddingTop = UDim.new(t, 0),
        PaddingLeft = UDim.new(l, 0),
        PaddingBottom = UDim.new(bm, 0)
    })
end

local function lbl(txt, sx, py, pt, pb)
    local L = n("TextLabel", a, {
        TextWrapped = true,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = c(0, 0, 0),
        FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextColor3 = c(255, 255, 255),
        BackgroundTransparency = 1,
        Size = u(sx, 0, .18773, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txt,
        Position = u(.10693, 0, py, 0)
    })
    pad(L, pt, .05, pb)
    gradL(L)
    return L
end

lbl("Auto Solve", .2796, .05033, .06, .15)
lbl("Range", .29895, .28344, .07, .13)
lbl("Freeze", .2796, .51656, .08, .12)

local function gradB(p)
    n("UIGradient", p, {
        Rotation = 90,
        Transparency = N { K(0, 0), K(.684, 0), K(.9, .3), K(1, 1) }
    })
end

local function txt(name, ph, sx, px, py, txtv)
    local t = n("TextBox", a, {
        CursorPosition = -1,
        Name = name,
        PlaceholderColor3 = c(190, 190, 190),
        BorderSizePixel = 0,
        TextWrapped = true,
        TextSize = 14,
        TextColor3 = c(0, 0, 0),
        TextScaled = true,
        BackgroundColor3 = c(255, 255, 255),
        FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        PlaceholderText = ph,
        Size = u(sx, 0, .13791, 0),
        Position = u(px, 0, py, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txtv or ""
    })
    gradB(t)
    n("UICorner", t, { CornerRadius = UDim.new(.157, 0) })
    n("UIPadding", t, {
        PaddingRight = UDim.new(.05, 0),
        PaddingLeft = UDim.new(.05, 0),
        PaddingBottom = UDim.new(.1, 0)
    })
    return t
end

local boxMax = txt("max", "5000", .16214, .40588, .07417, "5000")
local boxR = txt("r", "100", .16214, .40403, .30729, "100")

local img = n("ImageLabel", a, {
    ZIndex = 9,
    BorderSizePixel = 0,
    BackgroundColor3 = c(255, 255, 255),
    ResampleMode = Enum.ResamplerMode.Pixelated,
    Image = "rbxassetid://91463315015793",
    Size = u(.46942, 0, .90793, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 1,
    Position = u(.53564, 0, .15447, 0)
})

local statusText = n("TextLabel", img, {
    TextWrapped = true,
    BorderSizePixel = 0,
    TextSize = 14,
    TextScaled = true,
    BackgroundColor3 = c(255, 255, 255),
    FontFace = F("rbxasset://fonts/families/SpecialElite.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    TextColor3 = c(255, 255, 255),
    BackgroundTransparency = 1,
    Size = u(.9, 0, .15, 0),
    BorderColor3 = c(0, 0, 0),
    Text = "Ready to solve",
    Rotation = -5,
    Position = u(.05, 0, .14, 0)
})

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

local draggingOpen = false
local dragInputOpen, dragStartOpen, startPosOpen

local function updateInput(input)
    if dragging and panel.Visible then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

local function updateInputOpen(input)
    if draggingOpen then
        local delta = input.Position - dragStartOpen
        open.Position = UDim2.new(
            startPosOpen.X.Scale,
            startPosOpen.X.Offset + delta.X,
            startPosOpen.Y.Scale,
            startPosOpen.Y.Offset + delta.Y
        )
    end
end

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

open.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = true
        dragStartOpen = input.Position
        startPosOpen = open.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingOpen = false
            end
        end)
    end
end)

open.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputOpen = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateInput(input)
    elseif input == dragInputOpen then
        updateInputOpen(input)
    end
end)

local clickStart = nil
open.MouseButton1Down:Connect(function()
    clickStart = tick()
end)

open.MouseButton1Up:Connect(function()
    if clickStart and (tick() - clickStart) < 0.2 and not draggingOpen then
        panel.Visible = not panel.Visible
    end
    clickStart = nil
end)

-- State management
local ON_IMG = "rbxassetid://16884179507"
local ON_OFF1 = Vector2.new(578, 50)
local ON_OFF2 = Vector2.new(48, 48)
local OFF_IMG = "rbxassetid://16167594452"
local OFF_OFF1 = Vector2.new(862, 472)
local OFF_OFF2 = Vector2.new(90, 90)

local btnState = setmetatable({}, { __mode = "k" })

local function setVis(bx, on)
    if not bx then return end
    if on then
        bx.Image = ON_IMG
        bx.ImageRectOffset = ON_OFF1
        bx.ImageRectSize = ON_OFF2
    else
        bx.Image = OFF_IMG
        bx.ImageRectOffset = OFF_OFF1
        bx.ImageRectSize = OFF_OFF2
    end
    btnState[bx] = on
end

local function getState(bx)
    if not bx then return false end
    return btnState[bx] or false
end

local function tonum(sv)
    if not sv then return nil end
    sv = sv:match("^%s*(.-)%s*$")
    return tonumber(sv)
end

-- Set initial states
for _, btt in ipairs({btnAutoSolve, btnRange, btnFreeze}) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

-- Toggle functionality
local function bindToggle(bx)
    if not bx then return end
    bx.MouseButton1Click:Connect(function()
        local nstate = not getState(bx)
        setVis(bx, nstate)
    end)
end

bindToggle(btnAutoSolve)
bindToggle(btnRange)
bindToggle(btnFreeze)

-- Bind textboxes
for _, tb in ipairs({boxMax, boxR}) do
    if tb then
        tb.ClearTextOnFocus = false
    end
end

-- Auto Solve State
local state = {
    solving = false,
    needRefresh = false,
    flaggedIds = {},
    frozenConnection = nil
}

-- Freeze character
local function freezeCharacter(enable)
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if enable then
        if root then
            if state.frozenConnection then
                state.frozenConnection:Disconnect()
            end
            root.Anchored = true
            state.frozenConnection = root:GetPropertyChangedSignal("Anchored"):Connect(function()
                if getState(btnFreeze) then
                    root.Anchored = true
                end
            end)
        end
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    else
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

-- Watch freeze toggle
btnFreeze.MouseButton1Click:Connect(function()
    freezeCharacter(getState(btnFreeze))
end)

-- Find parts folder
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

-- Grid helper
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

-- Find safe revealed tile to stand on (not covered tiles!)
local function findSafeStandingTile(targetPos, revealedTilesData, bombTilesData, coveredTilesData)
    local player = Players.LocalPlayer
    if not player or not player.Character then return nil end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local candidates = {}
    
    -- Only consider REVEALED tiles (already opened, safe to stand on)
    for _, revealedData in ipairs(revealedTilesData) do
        if revealedData.part then
            local dist = (revealedData.part.Position - targetPos).Magnitude
            
            -- Within 16 studs and not too close to bombs
            if dist <= 16 and dist > 2 then
                local isSafe = true
                
                -- Check not near bombs
                for _, bombData in ipairs(bombTilesData) do
                    if bombData.part then
                        local bombDist = (bombData.part.Position - revealedData.part.Position).Magnitude
                        if bombDist < 4 then -- Extra margin
                            isSafe = false
                            break
                        end
                    end
                end
                
                -- CRITICAL: Check not near covered tiles (probability/unknown)
                if isSafe then
                    for _, coveredData in ipairs(coveredTilesData) do
                        if coveredData.part then
                            local covDist = (coveredData.part.Position - revealedData.part.Position).Magnitude
                            if covDist < 4 then -- Stay away from unknown tiles!
                                isSafe = false
                                break
                            end
                        end
                    end
                end
                
                if isSafe then
                    table.insert(candidates, {
                        part = revealedData.part,
                        dist = dist,
                        distFromPlayer = (revealedData.part.Position - root.Position).Magnitude
                    })
                end
            end
        end
    end
    
    -- Sort by closest to player
    if #candidates > 0 then
        table.sort(candidates, function(a, b)
            return a.distFromPlayer < b.distFromPlayer
        end)
        return candidates[1].part
    end
    
    return nil
end

-- Teleport to safe revealed tile
local function teleportToSafeTile(part)
    local player = Players.LocalPlayer
    if not player or not player.Character then return false end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local wasAnchored = root.Anchored
    if getState(btnFreeze) then
        root.Anchored = false
    end
    
    pcall(function()
        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    end)
    
    task.wait(0.25)
    
    if getState(btnFreeze) and not wasAnchored then
        root.Anchored = true
    end
    
    return true
end

-- Click tile from distance (don't need to be on top of it)
local function clickTileFromDistance(part, maxDistance)
    if not part then return false end
    
    local player = Players.LocalPlayer
    if not player or not player.Character then return false end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local dist = (part.Position - root.Position).Magnitude
    if dist > maxDistance then
        return false -- Too far
    end
    
    local cd = part:FindFirstChildOfClass("ClickDetector", true)
    if cd then
        pcall(function()
            fireclickdetector(cd)
        end)
        return true
    end
    return false
end

-- Place flag
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

-- Click tile
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

-- Main solve function
local function autoSolve()
    if state.solving or not getState(btnAutoSolve) then return end
    state.solving = true
    
    local folder = findPartsFolder()
    if not folder then
        statusText.Text = "No parts found"
        state.solving = false
        return
    end
    
    local player = Players.LocalPlayer
    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local useRange = getState(btnRange)
    local rangeValue = tonum(boxR.Text) or 100
    
    -- Build part cache
    local partCache = {}
    local revealedParts = {}
    
    for _, part in ipairs(folder:GetChildren()) do
        if part:IsA("BasePart") then
            if useRange and root then
                local dist = (part.Position - root.Position).Magnitude
                if dist > rangeValue then continue end
            end
            
            local gui = part:FindFirstChild("NumberGui", true)
            local textLabel = gui and gui:FindFirstChildWhichIsA("TextLabel")
            
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
        statusText.Text = "No revealed tiles"
        state.solving = false
        return
    end
    
    -- Find center
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
    
    -- Solve: find 100% safe and 100% bomb tiles
    local safeTiles = {}
    local bombTiles = {}
    local uncertainTiles = 0
    
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
                
                -- All remaining are mines (100% certainty)
                if #coveredNeighbors > 0 and (num - flaggedCount) == #coveredNeighbors then
                    for _, rc in ipairs(coveredNeighbors) do
                        local alreadyAdded = false
                        for _, t in ipairs(bombTiles) do
                            if t.r == rc[1] and t.c == rc[2] then
                                alreadyAdded = true
                                break
                            end
                        end
                        if not alreadyAdded then
                            table.insert(bombTiles, {r = rc[1], c = rc[2]})
                        end
                    end
                end
                
                -- All mines found, rest are safe (100% certainty)
                if #coveredNeighbors > 0 and flaggedCount == num then
                    for _, rc in ipairs(coveredNeighbors) do
                        local alreadyAdded = false
                        for _, t in ipairs(safeTiles) do
                            if t.r == rc[1] and t.c == rc[2] then
                                alreadyAdded = true
                                break
                            end
                        end
                        if not alreadyAdded then
                            table.insert(safeTiles, {r = rc[1], c = rc[2]})
                        end
                    end
                end
                
                -- Count uncertain (probability-based) tiles
                if #coveredNeighbors > 0 and flaggedCount < num and (num - flaggedCount) < #coveredNeighbors then
                    uncertainTiles = uncertainTiles + #coveredNeighbors
                end
            end
        end
    end
    
    -- Collect revealed tiles data (safe to stand on)
    local revealedTilesData = {}
    local coveredTilesData = {}
    
    for r = 1, H do
        for c = 1, W do
            if b0[r][c].state == "revealed" and b0[r][c].data then
                table.insert(revealedTilesData, {
                    part = b0[r][c].data.part,
                    r = r,
                    c = c
                })
            elseif b0[r][c].state == "covered" and b0[r][c].data then
                -- Collect covered tiles (unknown/probability) - NEVER step on these!
                table.insert(coveredTilesData, {
                    part = b0[r][c].data.part,
                    r = r,
                    c = c
                })
            end
        end
    end
    
    -- Execute: Flag bombs in 16 radius from revealed tiles
    local flaggedCount = 0
    local bombPartsData = {}
    
    for _, tile in ipairs(bombTiles) do
        local data = b0[tile.r][tile.c].data
        if data and not data.flagged then
            table.insert(bombPartsData, {part = data.part, r = tile.r, c = tile.c})
        end
    end
    
    -- Flag bombs within 16 studs of any revealed tile
    for _, bombData in ipairs(bombPartsData) do
        if bombData.part then
            local shouldFlag = false
            
            for _, revData in ipairs(revealedTilesData) do
                local dist = (bombData.part.Position - revData.part.Position).Magnitude
                if dist <= 16 then
                    shouldFlag = true
                    break
                end
            end
            
            if shouldFlag then
                if placeFlag(bombData.part) then
                    flaggedCount = flaggedCount + 1
                    statusText.Text = string.format("Flagging: %d", flaggedCount)
                    task.wait(0.05)
                end
            end
        end
    end
    
    -- Execute: For each safe tile to click
    local clickedCount = 0
    local skippedCount = 0
    
    for _, tile in ipairs(safeTiles) do
        local data = b0[tile.r][tile.c].data
        if data then
            -- Find revealed tile to stand on (within 16 studs, away from bombs AND covered tiles)
            local standingTile = findSafeStandingTile(data.part.Position, revealedTilesData, bombPartsData, coveredTilesData)
            
            if standingTile then
                -- Teleport to revealed tile (safe!)
                if teleportToSafeTile(standingTile) then
                    task.wait(0.2)
                    
                    -- Click target from distance (max 16 studs)
                    if clickTileFromDistance(data.part, 16) then
                        clickedCount = clickedCount + 1
                        statusText.Text = string.format("F:%d C:%d", flaggedCount, clickedCount)
                        task.wait(0.25)
                        
                        -- Auto-refresh after each click to update grid
                        -- This fixes detection errors (e.g., tile "1" showing 3 bombs)
                        state.needRefresh = true
                    end
                end
            else
                -- No safe revealed tile within 16 studs - skip for now
                skippedCount = skippedCount + 1
            end
        end
    end
    
    -- Status
    if flaggedCount == 0 and clickedCount == 0 then
        if uncertainTiles > 0 then
            statusText.Text = string.format("Waiting: %d uncertain\n(probability tiles)", math.floor(uncertainTiles / 8))
        elseif skippedCount > 0 then
            statusText.Text = string.format("Skipped: %d no safe path\n(covered nearby)", skippedCount)
        else
            statusText.Text = "Complete!\nAll safe"
            setVis(btnAutoSolve, false)
        end
    else
        statusText.Text = string.format("Progress:\nF:%d C:%d", flaggedCount, clickedCount)
        
        if skippedCount > 0 then
            statusText.Text = statusText.Text .. string.format("\nSkip:%d", skippedCount)
        end
    end
    
    state.solving = false
    
    -- If we clicked tiles, trigger refresh scan next cycle
    if clickedCount > 0 then
        task.wait(0.5)  -- Wait for tiles to reveal
        state.needRefresh = false
    end
end

-- Main loop with auto-refresh
RunService.Heartbeat:Connect(function()
    if getState(btnAutoSolve) and not state.solving then
        task.spawn(autoSolve)
        task.wait(0.5)
    end
end)
