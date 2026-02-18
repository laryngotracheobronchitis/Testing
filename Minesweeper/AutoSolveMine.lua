-- bLockerman's Minesweeper Auto Solver - Clean Version
-- Auto Run + Auto Flag (Combined) with Safe Teleport

if game:GetService("RunService"):IsStudio() or (game.PlaceId ~= 7871169780 and game.PlaceId ~= 9797651295) then
    -- warn("nice game")
end

local v1 = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")

if v1:GetAttribute("loaded") then
    return
end

v1:SetAttribute("loaded", true)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinesweeperSolver"
ScreenGui.Parent = v1
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- Colors
local c = Color3.fromRGB

-- Open Button
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(1, -60, 1, -60)
OpenBtn.AnchorPoint = Vector2.new(1, 1)
OpenBtn.BackgroundColor3 = c(40, 40, 40)
OpenBtn.BorderColor3 = c(100, 100, 100)
OpenBtn.BorderSizePixel = 2
OpenBtn.Text = "💣"
OpenBtn.TextColor3 = c(255, 255, 255)
OpenBtn.TextSize = 24
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0.2, 0)
OpenCorner.Parent = OpenBtn

-- Main Panel
local Panel = Instance.new("Frame")
Panel.Name = "MainPanel"
Panel.Size = UDim2.new(0, 500, 0, 350)
Panel.Position = UDim2.new(0.5, -250, 0.5, -175)
Panel.BackgroundColor3 = c(25, 25, 25)
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.Active = true
Panel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0.02, 0)
PanelCorner.Parent = Panel

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = c(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Panel

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0.02, 0)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.02, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🎯 Minesweeper Auto Solver"
TitleText.TextColor3 = c(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = c(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = c(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.3, 0)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Panel

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready - Press Start"
StatusLabel.TextColor3 = c(100, 255, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Content

-- Toggle Buttons Container
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(0.5, -5, 0, 200)
ToggleContainer.Position = UDim2.new(0, 0, 0, 30)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Parent = Content

-- Main Toggle (Run + Auto Flag Combined)
local MainToggle = Instance.new("TextButton")
MainToggle.Name = "MainToggle"
MainToggle.Size = UDim2.new(1, 0, 0, 40)
MainToggle.Position = UDim2.new(0, 0, 0, 0)
MainToggle.BackgroundColor3 = c(150, 50, 50) -- Red = OFF
MainToggle.Text = "▶️ START SOLVER (OFF)"
MainToggle.TextColor3 = c(255, 255, 255)
MainToggle.TextSize = 14
MainToggle.Font = Enum.Font.SourceSansBold
MainToggle.Parent = ToggleContainer

local MainToggleCorner = Instance.new("UICorner")
MainToggleCorner.CornerRadius = UDim.new(0.1, 0)
MainToggleCorner.Parent = MainToggle

-- Visual Range Toggle (Optional)
local VisualToggle = Instance.new("TextButton")
VisualToggle.Name = "VisualToggle"
VisualToggle.Size = UDim2.new(1, 0, 0, 35)
VisualToggle.Position = UDim2.new(0, 0, 0, 50)
VisualToggle.BackgroundColor3 = c(80, 80, 80) -- Gray = OFF
VisualToggle.Text = "👁️ Visual Range (OFF)"
VisualToggle.TextColor3 = c(200, 200, 200)
VisualToggle.TextSize = 13
VisualToggle.Font = Enum.Font.SourceSans
VisualToggle.Parent = ToggleContainer

local VisualToggleCorner = Instance.new("UICorner")
VisualToggleCorner.CornerRadius = UDim.new(0.1, 0)
VisualToggleCorner.Parent = VisualToggle

-- Rotation Toggle (Optional)
local RotToggle = Instance.new("TextButton")
RotToggle.Name = "RotToggle"
RotToggle.Size = UDim2.new(1, 0, 0, 35)
RotToggle.Position = UDim2.new(0, 0, 0, 95)
RotToggle.BackgroundColor3 = c(80, 80, 80)
RotToggle.Text = "🔄 Rotation (OFF)"
RotToggle.TextColor3 = c(200, 200, 200)
RotToggle.TextSize = 13
RotToggle.Font = Enum.Font.SourceSans
RotToggle.Parent = ToggleContainer

local RotToggleCorner = Instance.new("UICorner")
RotToggleCorner.CornerRadius = UDim.new(0.1, 0)
RotToggleCorner.Parent = RotToggle

-- Guess Mode Toggle
local GuessToggle = Instance.new("TextButton")
GuessToggle.Name = "GuessToggle"
GuessToggle.Size = UDim2.new(1, 0, 0, 35)
GuessToggle.Position = UDim2.new(0, 0, 0, 140)
GuessToggle.BackgroundColor3 = c(80, 80, 80)
GuessToggle.Text = "🎲 Auto Guess (OFF)"
GuessToggle.TextColor3 = c(200, 200, 200)
GuessToggle.TextSize = 13
GuessToggle.Font = Enum.Font.SourceSans
GuessToggle.Parent = ToggleContainer

local GuessToggleCorner = Instance.new("UICorner")
GuessToggleCorner.CornerRadius = UDim.new(0.1, 0)
GuessToggleCorner.Parent = GuessToggle

-- Input Container
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(0.5, -5, 0, 200)
InputContainer.Position = UDim2.new(0.5, 5, 0, 30)
InputContainer.BackgroundTransparency = 1
InputContainer.Parent = Content

-- Input Fields
local function createInput(name, label, yPos, default)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = c(180, 180, 180)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.SourceSans
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = InputContainer
    
    local box = Instance.new("TextBox")
    box.Name = name
    box.Size = UDim2.new(0.55, 0, 0, 22)
    box.Position = UDim2.new(0.45, 0, 0, yPos - 1)
    box.BackgroundColor3 = c(40, 40, 40)
    box.TextColor3 = c(255, 255, 255)
    box.TextSize = 12
    box.Font = Enum.Font.SourceSans
    box.Text = tostring(default)
    box.ClearTextOnFocus = false
    box.Parent = InputContainer
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0.1, 0)
    boxCorner.Parent = box
    
    return box
end

local MaxInput = createInput("max", "Max Cluster:", 0, "5000")
local SpeedInput = createInput("speed", "Update Speed:", 30, "0.1")
local FlagRangeInput = createInput("frange", "Flag Range:", 60, "16")
local FlagSpeedInput = createInput("fspeed", "Flag Speed:", 90, "0.05")

-- Info Text
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 0, 40)
InfoText.Position = UDim2.new(0, 0, 1, -40)
InfoText.BackgroundTransparency = 1
InfoText.Text = "💡 START = Run + Auto Flag\nGuess Mode = Auto pick if no safe tiles"
InfoText.TextColor3 = c(150, 150, 150)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.SourceSansItalic
InfoText.TextWrapped = true
InfoText.Parent = Content

-- ==========================================
-- SOLVER STATE
-- ==========================================

local SolverState = {
    Running = false,
    VisualEnabled = false,
    RotationEnabled = false,
    GuessMode = false,
    MaxCluster = 5000,
    UpdateSpeed = 0.1,
    FlagRange = 16,
    FlagSpeed = 0.05,
    CurrentSession = 0
}

-- ==========================================
-- UTILITY FUNCTIONS
-- ==========================================

local function findBoard()
    local w = Workspace
    local flag = w:FindFirstChild("Flag")
    if flag then
        local parts = flag:FindFirstChild("Parts")
        if parts and parts:IsA("Folder") then return parts end
    end
    
    local parts = w:FindFirstChild("Parts", true)
    if parts and parts:IsA("Folder") then return parts end
    
    local bestFolder, bestCount = nil, -1
    for _, obj in ipairs(w:GetDescendants()) do
        if obj:IsA("Folder") and obj.Name == "Parts" then
            local count = 0
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") then count += 1 end
            end
            if count > bestCount then
                bestFolder = obj
                bestCount = count
            end
        end
    end
    return bestFolder
end

local function getCharacterRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function safeTeleport(safeTiles)
    local root = getCharacterRoot()
    if not root or #safeTiles == 0 then return false end
    
    -- Find nearest safe tile
    local nearest = safeTiles[1]
    local nearestDist = (nearest.Position - root.Position).Magnitude
    
    for i = 2, #safeTiles do
        local dist = (safeTiles[i].Position - root.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearest = safeTiles[i]
        end
    end
    
    -- Teleport
    pcall(function()
        root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3.5, 0))
    end)
    
    return true, nearest
end

local function clickTile(tile)
    if not tile or not tile.Part then return end
    local part = tile.Part
    if not part.Parent then return end
    
    local cd = part:FindFirstChildOfClass("ClickDetector", true)
    if not cd then return end
    
    local alreadyClicked = part:GetAttribute("AutoClicked")
    if alreadyClicked then return end
    
    pcall(function()
        fireclickdetector(cd)
        part:SetAttribute("AutoClicked", true)
    end)
end

local function flagTile(tile)
    if not tile or not tile.Part then return end
    local part = tile.Part
    if not part.Parent then return end
    
    -- Check already flagged
    if part:FindFirstChild("Flag") or part:FindFirstChild("Flagged") then return end
    if part:GetAttribute("Flagged") then return end
    
    pcall(function()
        local args = {part}
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag"):FireServer(unpack(args))
        part:SetAttribute("Flagged", true)
    end)
end

-- ==========================================
-- MAIN SOLVER LOGIC
-- ==========================================

local function runSolver()
    if not SolverState.Running then return end
    
    SolverState.CurrentSession += 1
    local sessionId = SolverState.CurrentSession
    
    -- Auto Flag Thread
    task.spawn(function()
        while SolverState.Running and SolverState.CurrentSession == sessionId do
            local root = getCharacterRoot()
            local board = findBoard()
            
            if root and board then
                for _, part in ipairs(board:GetChildren()) do
                    if part:IsA("BasePart") then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist <= SolverState.FlagRange then
                            -- Check if flagged via GUI
                            local gui = part:FindFirstChild("NumberGui", true)
                            if gui then
                                local lbl = gui:FindFirstChild("ValueText")
                                if lbl and lbl:IsA("TextLabel") and lbl.Text == "💣" then
                                    flagTile({Part = part})
                                end
                            end
                        end
                    end
                end
            end
            
            task.wait(SolverState.FlagSpeed)
        end
    end)
    
    -- Main Solver Thread
    task.spawn(function()
        local lastUpdate = 0
        
        while SolverState.Running and SolverState.CurrentSession == sessionId do
            local now = tick()
            if now - lastUpdate < SolverState.UpdateSpeed then
                task.wait(0.05)
                continue
            end
            lastUpdate = now
            
            local board = findBoard()
            local root = getCharacterRoot()
            
            if not board then
                StatusLabel.Text = "Status: ❌ Board Not Found"
                StatusLabel.TextColor3 = c(255, 100, 100)
                task.wait(1)
                continue
            end
            
            -- Collect all tiles
            local tiles = {}
            local revealedTiles = {}
            local coveredTiles = {}
            
            for _, part in ipairs(board:GetChildren()) do
                if part:IsA("BasePart") and part.Anchored then
                    local gui = part:FindFirstChild("NumberGui", true)
                    local isRevealed = false
                    local number = 0
                    
                    if gui then
                        local lbl = gui:FindFirstChild("ValueText")
                        if lbl and lbl:IsA("TextLabel") then
                            local text = lbl.Text
                            if text ~= "" and text ~= "?" and text ~= "💣" and text ~= "✅" then
                                isRevealed = true
                                number = tonumber(text) or 0
                            end
                        end
                    end
                    
                    local tile = {
                        Part = part,
                        Position = part.Position,
                        Revealed = isRevealed,
                        Number = number,
                        Flagged = part:FindFirstChild("Flag") ~= nil or part:GetAttribute("Flagged") == true
                    }
                    
                    table.insert(tiles, tile)
                    
                    if isRevealed then
                        table.insert(revealedTiles, tile)
                    elseif not tile.Flagged then
                        table.insert(coveredTiles, tile)
                    end
                end
            end
            
            if #tiles == 0 then
                task.wait(0.5)
                continue
            end
            
            -- Calculate cell size
            local cellSize = 3 -- default
            if #tiles >= 2 then
                local dists = {}
                for i = 1, math.min(10, #tiles) do
                    for j = i+1, math.min(10, #tiles) do
                        local dist = (tiles[i].Position - tiles[j].Position).Magnitude
                        if dist > 0 and dist < 20 then
                            table.insert(dists, dist)
                        end
                    end
                end
                if #dists > 0 then
                    table.sort(dists)
                    cellSize = dists[1]
                end
            end
            
            -- Build grid
            local grid = {}
            local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
            
            for _, tile in ipairs(tiles) do
                local gx = math.floor(tile.Position.X / cellSize + 0.5)
                local gz = math.floor(tile.Position.Z / cellSize + 0.5)
                tile.GridX = gx
                tile.GridZ = gz
                
                if gx < minX then minX = gx end
                if gx > maxX then maxX = gx end
                if gz < minZ then minZ = gz end
                if gz > maxZ then maxZ = gz end
                
                if not grid[gz] then grid[gz] = {} end
                grid[gz][gx] = tile
            end
            
            -- Calculate probabilities
            local safeTiles = {}
            local bombTiles = {}
            local riskyTiles = {}
            local unknownTiles = {}
            
            for _, tile in ipairs(coveredTiles) do
                tile.Probability = nil -- unknown initially
            end
            
            -- Simple constraint solving
            for _, revealed in ipairs(revealedTiles) do
                local neighbors = {}
                local flaggedCount = 0
                local coveredCount = 0
                
                for dz = -1, 1 do
                    for dx = -1, 1 do
                        if dz == 0 and dx == 0 then continue end
                        
                        local nz = revealed.GridZ + dz
                        local nx = revealed.GridX + dx
                        
                        if grid[nz] and grid[nz][nx] then
                            local neighbor = grid[nz][nx]
                            if neighbor.Flagged then
                                flaggedCount += 1
                            elseif not neighbor.Revealed then
                                table.insert(neighbors, neighbor)
                                coveredCount += 1
                            end
                        end
                    end
                end
                
                local remaining = revealed.Number - flaggedCount
                
                if remaining == 0 and #neighbors > 0 then
                    -- All neighbors are safe
                    for _, n in ipairs(neighbors) do
                        n.Probability = 0
                    end
                elseif remaining == #neighbors and #neighbors > 0 then
                    -- All neighbors are bombs
                    for _, n in ipairs(neighbors) do
                        n.Probability = 1
                        if not n.Flagged then
                            table.insert(bombTiles, n)
                        end
                    end
                elseif #neighbors > 0 then
                    -- Partial probability
                    local prob = remaining / #neighbors
                    for _, n in ipairs(neighbors) do
                        if not n.Probability or prob > n.Probability then
                            n.Probability = prob
                        end
                    end
                end
            end
            
            -- Classify tiles
            for _, tile in ipairs(coveredTiles) do
                if tile.Probability == 0 then
                    table.insert(safeTiles, tile)
                elseif tile.Probability == 1 then
                    if not tile.Flagged then
                        table.insert(bombTiles, tile)
                    end
                elseif tile.Probability then
                    table.insert(riskyTiles, tile)
                else
                    table.insert(unknownTiles, tile)
                end
            end
            
            -- Auto Flag Bombs
            for _, bomb in ipairs(bombTiles) do
                flagTile(bomb)
            end
            
            -- Decision Making
            local action = "Scanning..."
            
            -- Priority 1: Safe tiles
            if #safeTiles > 0 then
                action = "Safe tiles found: " .. #safeTiles
                
                -- Teleport to nearest safe
                local teleported, target = safeTeleport(safeTiles)
                
                if teleported then
                    action = "Teleported to safe tile"
                    
                    -- Click safe tiles
                    task.delay(0.2, function()
                        clickTile(target)
                    end)
                    
                    task.delay(0.4, function()
                        for _, t in ipairs(safeTiles) do
                            if t ~= target then
                                clickTile(t)
                            end
                        end
                    end)
                end
                
                StatusLabel.Text = "Status: ✅ " .. action
                StatusLabel.TextColor3 = c(100, 255, 100)
                
            -- Priority 2: Guess Mode
            elseif SolverState.GuessMode and (#riskyTiles > 0 or #unknownTiles > 0) then
                local candidates = {}
                for _, t in ipairs(riskyTiles) do table.insert(candidates, t) end
                for _, t in ipairs(unknownTiles) do table.insert(candidates, t) end
                
                -- Find lowest probability
                table.sort(candidates, function(a, b)
                    local pa = a.Probability or 0.5
                    local pb = b.Probability or 0.5
                    return pa < pb
                end)
                
                local best = candidates[1]
                local prob = best.Probability or 0.5
                
                if prob < 0.5 then
                    action = "GUESSING: " .. string.format("%.0f%%", prob * 100)
                    
                    local teleported = safeTeleport({best})
                    if teleported then
                        task.delay(0.3, function()
                            clickTile(best)
                        end)
                    end
                    
                    StatusLabel.Text = "Status: 🎲 " .. action
                    StatusLabel.TextColor3 = c(255, 200, 100)
                else
                    action = "Too risky to guess (>50%)"
                    StatusLabel.Text = "Status: ⚠️ " .. action
                    StatusLabel.TextColor3 = c(255, 150, 50)
                end
                
            -- No safe tiles, no guess mode
            else
                if #riskyTiles > 0 or #unknownTiles > 0 then
                    action = "No safe tiles! Enable Guess to continue"
                    StatusLabel.Text = "Status: ⛔ " .. action
                    StatusLabel.TextColor3 = c(255, 100, 100)
                else
                    action = "Complete or waiting"
                    StatusLabel.Text = "Status: ⏳ " .. action
                    StatusLabel.TextColor3 = c(150, 150, 150)
                end
            end
            
            -- Visual Overlay
            if SolverState.VisualEnabled then
                for _, tile in ipairs(tiles) do
                    if not tile.Revealed and not tile.Flagged then
                        local prob = tile.Probability
                        local text = "?"
                        local color = c(150, 150, 150)
                        
                        if prob == 0 then
                            text = "✅"
                            color = c(0, 255, 0)
                        elseif prob == 1 then
                            text = "💣"
                            color = c(255, 0, 0)
                        elseif prob then
                            text = string.format("%.0f%%", prob * 100)
                            if prob < 0.3 then
                                color = c(100, 255, 100)
                            elseif prob < 0.7 then
                                color = c(255, 255, 0)
                            else
                                color = c(255, 100, 100)
                            end
                        end
                        
                        -- Create/update billboard
                        local bill = tile.Part:FindFirstChild("SolverOverlay")
                        if not bill then
                            bill = Instance.new("BillboardGui")
                            bill.Name = "SolverOverlay"
                            bill.Size = UDim2.new(0, 100, 0, 50)
                            bill.StudsOffset = Vector3.new(0, 2, 0)
                            bill.AlwaysOnTop = true
                            bill.Parent = tile.Part
                            
                            local lbl = Instance.new("TextLabel")
                            lbl.Name = "Text"
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.TextStrokeTransparency = 0.5
                            lbl.TextStrokeColor3 = c(0, 0, 0)
                            lbl.Font = Enum.Font.SourceSansBold
                            lbl.TextSize = 24
                            lbl.Parent = bill
                        end
                        
                        local lbl = bill:FindFirstChild("Text")
                        if lbl then
                            lbl.Text = text
                            lbl.TextColor3 = color
                        end
                    else
                        -- Remove overlay if revealed/flagged
                        local bill = tile.Part:FindFirstChild("SolverOverlay")
                        if bill then bill:Destroy() end
                    end
                end
            end
            
            task.wait(SolverState.UpdateSpeed)
        end
        
        -- Cleanup overlays
        local board = findBoard()
        if board then
            for _, part in ipairs(board:GetChildren()) do
                local bill = part:FindFirstChild("SolverOverlay")
                if bill then bill:Destroy() end
            end
        end
    end)
end

-- ==========================================
-- UI INTERACTION
-- ==========================================

-- Update inputs
local function updateInputs()
    SolverState.MaxCluster = tonumber(MaxInput.Text) or 5000
    SolverState.UpdateSpeed = tonumber(SpeedInput.Text) or 0.1
    SolverState.FlagRange = tonumber(FlagRangeInput.Text) or 16
    SolverState.FlagSpeed = tonumber(FlagSpeedInput.Text) or 0.05
end

MaxInput.FocusLost:Connect(updateInputs)
SpeedInput.FocusLost:Connect(updateInputs)
FlagRangeInput.FocusLost:Connect(updateInputs)
FlagSpeedInput.FocusLost:Connect(updateInputs)

-- Main Toggle (Start/Stop)
MainToggle.MouseButton1Click:Connect(function()
    SolverState.Running = not SolverState.Running
    
    if SolverState.Running then
        MainToggle.BackgroundColor3 = c(50, 150, 50) -- Green
        MainToggle.Text = "⏹️ STOP SOLVER (ON)"
        updateInputs()
        runSolver()
    else
        MainToggle.BackgroundColor3 = c(150, 50, 50) -- Red
        MainToggle.Text = "▶️ START SOLVER (OFF)"
        StatusLabel.Text = "Status: Stopped"
        StatusLabel.TextColor3 = c(255, 100, 100)
    end
end)

-- Visual Toggle
VisualToggle.MouseButton1Click:Connect(function()
    SolverState.VisualEnabled = not SolverState.VisualEnabled
    
    if SolverState.VisualEnabled then
        VisualToggle.BackgroundColor3 = c(50, 150, 50)
        VisualToggle.TextColor3 = c(255, 255, 255)
        VisualToggle.Text = "👁️ Visual Range (ON)"
    else
        VisualToggle.BackgroundColor3 = c(80, 80, 80)
        VisualToggle.TextColor3 = c(200, 200, 200)
        VisualToggle.Text = "👁️ Visual Range (OFF)"
        
        -- Clear overlays
        local board = findBoard()
        if board then
            for _, part in ipairs(board:GetChildren()) do
                local bill = part:FindFirstChild("SolverOverlay")
                if bill then bill:Destroy() end
            end
        end
    end
end)

-- Rotation Toggle
RotToggle.MouseButton1Click:Connect(function()
    SolverState.RotationEnabled = not SolverState.RotationEnabled
    
    if SolverState.RotationEnabled then
        RotToggle.BackgroundColor3 = c(50, 150, 50)
        RotToggle.TextColor3 = c(255, 255, 255)
        RotToggle.Text = "🔄 Rotation (ON)"
    else
        RotToggle.BackgroundColor3 = c(80, 80, 80)
        RotToggle.TextColor3 = c(200, 200, 200)
        RotToggle.Text = "🔄 Rotation (OFF)"
    end
end)

-- Guess Toggle
GuessToggle.MouseButton1Click:Connect(function()
    SolverState.GuessMode = not SolverState.GuessMode
    
    if SolverState.GuessMode then
        GuessToggle.BackgroundColor3 = c(255, 150, 50)
        GuessToggle.TextColor3 = c(255, 255, 255)
        GuessToggle.Text = "🎲 Auto Guess (ON)"
    else
        GuessToggle.BackgroundColor3 = c(80, 80, 80)
        GuessToggle.TextColor3 = c(200, 200, 200)
        GuessToggle.Text = "🎲 Auto Guess (OFF)"
    end
end)

-- ==========================================
-- DRAG AND OPEN SYSTEM
-- ==========================================

-- Panel Drag
local panelDragging = false
local panelDragStart = nil
local panelStartPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        panelDragging = true
        panelDragStart = input.Position
        panelStartPos = Panel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                panelDragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if panelDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - panelDragStart
        Panel.Position = UDim2.new(
            panelStartPos.X.Scale,
            panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale,
            panelStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Open Button Drag
local openDragging = false
local openDragStart = nil
local openStartPos = nil
local clickStartTime = 0

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = OpenBtn.Position
        clickStartTime = tick()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openDragging = false
            end
        end)
    end
end)

OpenBtn.InputChanged:Connect(function(input)
    if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        OpenBtn.Position = UDim2.new(
            openStartPos.X.Scale,
            openStartPos.X.Offset + delta.X,
            openStartPos.Y.Scale,
            openStartPos.Y.Offset + delta.Y
        )
    end
end)

OpenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local clickDuration = tick() - clickStartTime
        if clickDuration < 0.25 and not openDragging then
            Panel.Visible = not Panel.Visible
            
            -- Animation
            if Panel.Visible then
                Panel.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(Panel, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 500, 0, 350)
                }):Play()
            end
        end
    end
end)

-- Close Button
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

print("✅ Minesweeper Auto Solver Loaded!")
print("💣 Click the bomb button to open UI")
print("🎯 Press START SOLVER to begin")
