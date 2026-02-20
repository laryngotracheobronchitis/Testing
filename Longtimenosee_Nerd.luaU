-- Minesweeper Auto Solver with Rayfield UI - COMPLETE EDITION (FIXED)
-- Based on shiziks-solver detection system + Sweep.lua visuals
-- Pure LuaU - NO DELAY, PERFECT TELEPORT, VISUAL INDICATORS

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Minesweeper Solver",
   LoadingTitle = "Minesweeper Auto Solver",
   LoadingSubtitle = "by Shiziks System + Sweep Visuals",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Variables
local Config = {
    -- Rage Mode
    AutoSolver = false,
    AutoFlag = false,
    AutoGuess = false,
    TeleportSpeed = 0.0001,
    FreezeEnabled = false,
    
    -- Legit/Visual Mode
    VisualEnabled = false,
    VisualRange = 100,
    VisualUpdateSpeed = 0.2,
    ShowMines = true,
    ShowSafe = true,
    ShowNumbers = true,
    FlagEnabled = false,
    FlagSpeed = 0.05,
    FlagRange = 25
}

-- State variables
local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local Controls = nil

-- Visual variables
local visualState = { running = false }
local visualCache = {}
local lastSeenRun = {}
local updateThrottle = 0
local THROTTLE_INTERVAL = 0.05
local guiCache = {}
local partCache = {}

-- Try to get Controls
pcall(function()
    local playerScripts = player:FindFirstChild("PlayerScripts")
    if playerScripts then
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            Controls = require(playerModule):GetControls()
        end
    end
end)

-- Helper Functions
local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function isAlreadyFlagged(part)
    if not part then return false end
    -- Cek berbagai kemungkinan flag
    if part:FindFirstChild("Flag") then return true end
    if part:FindFirstChild("BombFlag") then return true end
    if part:FindFirstChild("FlagModel") then return true end
    if part:FindFirstChild("Flagged") then return true end
    
    -- Cek attribute
    local success, flagged = pcall(function()
        return part:GetAttribute("Flagged")
    end)
    if success and flagged then return true end
    
    return false
end

-- Get Parts Folder
local function getPartsFolder()
    local w = workspace
    
    -- Coba cari di Folder Flag
    local flag = w:FindFirstChild("Flag")
    if flag then
        local parts = flag:FindFirstChild("Parts")
        if parts and parts:IsA("Folder") then 
            return parts 
        end
    end
    
    -- Coba cari folder Parts di mana saja
    local parts = w:FindFirstChild("Parts", true)
    if parts and parts:IsA("Folder") then 
        return parts 
    end
    
    -- Cari folder dengan nama Parts yang punya banyak part
    local best, bestCount = nil, -1
    for _, i in ipairs(w:GetDescendants()) do
        if i:IsA("Folder") and i.Name == "Parts" then
            local count = 0
            for _, ch in ipairs(i:GetChildren()) do
                if ch:IsA("BasePart") then 
                    count = count + 1 
                end
            end
            if count > bestCount then
                best, bestCount = i, count
            end
        end
    end
    
    return best
end

-- Freeze Function
local function updatePhysics()
    if not Config.FreezeEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local shouldFreeze = (Config.AutoSolver and Config.FreezeEnabled)
    
    for _, p in ipairs(char:GetDescendants()) do 
        if p:IsA("BasePart") then 
            p.Anchored = shouldFreeze
            if shouldFreeze then
                p.Velocity = Vector3.new(0, 0, 0)
                p.RotVelocity = Vector3.new(0, 0, 0)
            end
        end 
    end
    
    if Controls then
        if shouldFreeze then 
            pcall(function() 
                if Controls.Disable then
                    Controls:Disable() 
                end
            end)
        else 
            pcall(function() 
                if Controls.Enable then
                    Controls:Enable() 
                end
            end)
        end
    end
end

-- PERFECT TELEPORT FUNCTION
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end
    
    -- Hitung posisi di ATAS part
    local targetPos = target.Position
    local targetSize = target.Size
    
    -- Bagian ATAS part + tinggi karakter
    local partTopY = targetPos.Y + (targetSize.Y / 2)
    local standHeight = 3 -- Tinggi karakter dari kaki ke root
    
    -- Posisi akhir: bagian ATAS part + offset
    local finalY = partTopY + standHeight
    
    -- Teleport
    root.CFrame = CFrame.new(
        targetPos.X,
        finalY,
        targetPos.Z
    )
    
    -- Reset velocity
    root.Velocity = Vector3.new(0, 0, 0)
    root.RotVelocity = Vector3.new(0, 0, 0)
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 0.3 then return false end
    
    local success = pcall(function()
        -- Method 1: ClickDetector
        local cd = part:FindFirstChildOfClass("ClickDetector")
        if cd then
            fireclickdetector(cd)
            flaggedDebounce[part] = tick()
            return true
        end
        
        -- Method 2: RemoteEvent
        local events = replicatedStorage:FindFirstChild("Events")
        if events then
            local flagEvents = events:FindFirstChild("FlagEvents")
            if flagEvents then
                local placeFlag = flagEvents:FindFirstChild("PlaceFlag")
                if placeFlag then
                    placeFlag:FireServer(part)
                    flaggedDebounce[part] = tick()
                    return true
                end
            end
        end
        
        -- Method 3: Coba fire touch interest
        local touchInterest = part:FindFirstChildOfClass("TouchTransmitter")
        if touchInterest then
            firetouchinterest(player.Character and player.Character:FindFirstChild("HumanoidRootPart"), part, 0)
            firetouchinterest(player.Character and player.Character:FindFirstChild("HumanoidRootPart"), part, 1)
            flaggedDebounce[part] = tick()
            return true
        end
    end)
    
    return success
end

-- Get Solver Data untuk Rage Mode
local function getSolverData()
    local folder = getPartsFolder()
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    
    for _, cell in ipairs(allParts) do
        if not cell:IsA("BasePart") then continue end
        if not isCellOpen(cell) then continue end
        
        -- Get number from GUI
        local numberGui = cell:FindFirstChild("NumberGui")
        local label = numberGui and numberGui:FindFirstChildOfClass("TextLabel")
        local val = 0
        if label and label.Text then
            val = tonumber(label.Text) or 0
        end
        
        -- Build neighbor cache
        if not neighborCache[cell] then
            local nbs = {}
            for _, n in ipairs(allParts) do
                if n:IsA("BasePart") and n ~= cell then
                    local dist = (n.Position - cell.Position).Magnitude
                    if dist < (cell.Size.X * 1.8) then
                        table.insert(nbs, n)
                    end
                end
            end
            neighborCache[cell] = nbs
        end
        
        -- Count hidden and flagged neighbors
        local hidden = {}
        local mines = 0
        for _, n in ipairs(neighborCache[cell]) do
            if not isCellOpen(n) then
                if isAlreadyFlagged(n) or n.Color == Color3.new(0, 0, 0) then
                    mines = mines + 1
                else
                    table.insert(hidden, n)
                end
            end
        end
        
        if #hidden > 0 or val == 0 then
            table.insert(numberData, {
                obj = cell,
                eVal = val - mines,
                hidden = hidden
            })
        end
    end
    
    return numberData
end

-- ================ VISUAL SYSTEM ================

local function getVisualFolder()
    local parent = game:GetService("CoreGui")
    local folder = parent:FindFirstChild("MinesweeperVisuals")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "MinesweeperVisuals"
        folder.Parent = parent
    end
    return folder
end

local function getPartId(part)
    return tostring(part:GetDebugId())
end

local function getNumberFromText(text)
    if type(text) ~= "string" then return nil end
    local num = text:match("(%d+)")
    return num and tonumber(num) or nil
end

local function clampValue(val)
    val = tonumber(val) or 0
    if val < 0 then return 0
    elseif val > 1 then return 1
    else return val end
end

local function getNeighborCells(r, c, height, width)
    local neighbors = {}
    for dr = -1, 1 do
        for dc = -1, 1 do
            if not (dr == 0 and dc == 0) then
                local nr, nc = r + dr, c + dc
                if nr >= 1 and nr <= height and nc >= 1 and nc <= width then
                    table.insert(neighbors, {nr, nc})
                end
            end
        end
    end
    return neighbors
end

-- Visual Update Function
local function updateVisuals()
    if not Config.VisualEnabled then return end
    
    local currentTime = tick()
    if currentTime - updateThrottle < Config.VisualUpdateSpeed then
        return
    end
    updateThrottle = currentTime
    
    local partsFolder = getPartsFolder()
    if not partsFolder then return end
    
    local char = player.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    
    -- Filter parts by range
    local rangeSq = Config.VisualRange * Config.VisualRange
    local visibleParts = {}
    
    for _, part in ipairs(partsFolder:GetChildren()) do
        if part:IsA("BasePart") and part.Anchored ~= false then
            
            -- Check range
            if root then
                local distSq = (part.Position - root.Position).MagnitudeSquared
                if distSq > rangeSq then
                    -- Hide if out of range
                    local partId = getPartId(part)
                    local gui = guiCache[partId]
                    if gui and gui.Parent then
                        gui.Enabled = false
                    end
                    goto continue
                end
            end
            
            -- Get or create cache
            local partId = getPartId(part)
            local cache = partCache[partId]
            if not cache then
                local numberGui = part:FindFirstChild("NumberGui", true)
                local textLabel = numberGui and (numberGui:FindFirstChildWhichIsA("TextLabel") or numberGui:FindFirstChild("TextLabel"))
                
                cache = {
                    part = part,
                    position = part.Position,
                    size = part.Size,
                    label = textLabel,
                    flagged = isAlreadyFlagged(part),
                    lastSeen = currentTime
                }
                partCache[partId] = cache
            else
                cache.position = part.Position
                cache.size = part.Size
                cache.lastSeen = currentTime
                cache.flagged = isAlreadyFlagged(part)
                
                -- Try to get label if missing
                if not cache.label then
                    local numberGui = part:FindFirstChild("NumberGui", true)
                    cache.label = numberGui and (numberGui:FindFirstChildWhichIsA("TextLabel") or numberGui:FindFirstChild("TextLabel"))
                end
            end
            
            table.insert(visibleParts, cache)
            ::continue::
        end
    end
    
    if #visibleParts == 0 then return end
    
    -- Find reference part for grid
    local refPart = nil
    local minDist = math.huge
    
    for _, cache in ipairs(visibleParts) do
        if cache.label and root then
            local distSq = (cache.position - root.Position).MagnitudeSquared
            if distSq < minDist then
                minDist = distSq
                refPart = cache
            end
        end
    end
    
    if not refPart then
        -- Hide all if no reference
        local folder = getVisualFolder()
        for _, gui in ipairs(folder:GetChildren()) do
            gui.Enabled = false
        end
        return
    end
    
    -- Simple grid mapping
    local visualFolder = getVisualFolder()
    local timestamp = currentTime
    
    for _, cache in ipairs(visibleParts) do
        local part = cache.part
        
        -- Create or get GUI
        local partId = getPartId(part)
        local gui = guiCache[partId]
        
        if not gui or not gui.Parent then
            gui = visualFolder:FindFirstChild(partId)
            if not gui then
                gui = Instance.new("SurfaceGui")
                gui.Name = partId
                gui.AlwaysOnTop = true
                gui.LightInfluence = 0
                gui.Face = Enum.NormalId.Top
                gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
                gui.PixelsPerStud = 25
                gui.Parent = visualFolder
            end
            guiCache[partId] = gui
        end
        
        gui.Adornee = part
        lastSeenRun[gui] = timestamp
        
        -- Determine what to show
        local text = ""
        local color = Color3.fromRGB(255, 255, 255)
        
        if cache.flagged and Config.ShowMines then
            text = "💣"
        elseif cache.label and Config.ShowNumbers then
            local num = getNumberFromText(cache.label.Text)
            if num then
                text = tostring(num)
            end
        elseif not cache.label and not cache.flagged and Config.ShowSafe then
            -- Simple safe detection (adjacent to 0)
            -- In a full implementation, this would use actual logic
            text = "?"
        end
        
        -- Create or update label
        local label = gui:FindFirstChild("ValueText")
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "ValueText"
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 1
            label.TextSize = 60
            label.Font = Enum.Font.Arcade
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Parent = gui
        end
        
        if text ~= "" then
            gui.Enabled = true
            label.Visible = true
            label.Text = text
            label.TextColor3 = color
        else
            gui.Enabled = false
        end
    end
    
    -- Clean up old GUIs
    for _, gui in ipairs(visualFolder:GetChildren()) do
        if lastSeenRun[gui] ~= timestamp then
            guiCache[gui.Name] = nil
            gui:Destroy()
        end
    end
    
    -- Clean old part cache
    for id, cache in pairs(partCache) do
        if currentTime - (cache.lastSeen or 0) > 10 then
            partCache[id] = nil
        end
    end
end

-- Auto Flag dari visual
local function autoFlagFromVisual()
    if not Config.VisualEnabled or not Config.FlagEnabled then return end
    
    local partsFolder = getPartsFolder()
    if not partsFolder then return end
    
    local char = player.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if not root then return end
    
    local rangeSq = Config.VisualRange * Config.VisualRange
    
    for _, part in ipairs(partsFolder:GetChildren()) do
        if part:IsA("BasePart") and not isAlreadyFlagged(part) then
            -- Check range
            local distSq = (part.Position - root.Position).MagnitudeSquared
            if distSq <= rangeSq then
                -- Check if it has bomb visual
                local partId = getPartId(part)
                local gui = guiCache[partId]
                if gui and gui.Enabled then
                    local label = gui:FindFirstChild("ValueText")
                    if label and label:IsA("TextLabel") and label.Text == "💣" then
                        -- This is a bomb candidate, flag it
                        task.spawn(function()
                            flagTile(part)
                            task.wait(Config.FlagSpeed)
                        end)
                    end
                end
            end
        end
    end
end

-- Visual loop
local function visualLoop()
    visualState.running = true
    while Config.VisualEnabled and visualState.running do
        task.wait(Config.VisualUpdateSpeed)
        pcall(updateVisuals)
        if Config.FlagEnabled then
            pcall(autoFlagFromVisual)
        end
    end
    
    -- Clean up on disable
    local folder = getVisualFolder()
    for _, gui in ipairs(folder:GetChildren()) do
        gui:Destroy()
    end
    guiCache = {}
    partCache = {}
end

-- ================ RAGE MODE FUNCTIONS ================

-- Main Detection Loop
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then return end
    
    local data = getSolverData()
    local safeQueue = {}
    local mineQueue = {}
    local riskyCells = {}
    local foundAnything = false
    
    -- Basic detection first
    local basicSafe = {}
    local basicMines = {}
    
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            -- All hidden are mines
            if #d.hidden == d.eVal then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicMines, n)
                    foundAnything = true
                end
            -- All hidden are safe
            elseif d.eVal == 0 then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicSafe, n)
                    foundAnything = true
                end
            end
        end
    end
    
    -- Advanced subset detection
    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1 = data[i]
                local d2 = data[j]
                
                if d1.obj and d2.obj then
                    local dist = (d1.obj.Position - d2.obj.Position).Magnitude
                    if dist < 12 then
                        local s1 = d1.hidden
                        local s2 = d2.hidden
                        
                        -- Check if s1 is subset of s2
                        local isSubset = true
                        for _, x in ipairs(s1) do
                            local found = false
                            for _, y in ipairs(s2) do
                                if x == y then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                isSubset = false
                                break
                            end
                        end
                        
                        if isSubset and #s2 > #s1 then
                            local diffMines = d2.eVal - d1.eVal
                            local diffCells = {}
                            
                            for _, x in ipairs(s2) do
                                local inS1 = false
                                for _, y in ipairs(s1) do
                                    if x == y then
                                        inS1 = true
                                        break
                                    end
                                end
                                if not inS1 then
                                    table.insert(diffCells, x)
                                end
                            end
                            
                            if diffMines == 0 then
                                for _, n in ipairs(diffCells) do
                                    table.insert(safeQueue, n)
                                    foundAnything = true
                                end
                            elseif diffMines == #diffCells then
                                for _, n in ipairs(diffCells) do
                                    table.insert(mineQueue, n)
                                    foundAnything = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Mark mines
    for _, m in ipairs(mineQueue) do
        if m and m:IsA("BasePart") then
            m.Color = Color3.new(0, 0, 0)
        end
    end
    for _, m in ipairs(basicMines) do
        if m and m:IsA("BasePart") then
            m.Color = Color3.new(0, 0, 0)
        end
    end
    
    -- Auto Flag
    if Config.AutoFlag then
        local allMines = {}
        for _, m in ipairs(mineQueue) do 
            if m then allMines[m] = m end
        end
        for _, m in ipairs(basicMines) do 
            if m then allMines[m] = m end
        end
        
        for _, mine in pairs(allMines) do
            if not stopExecution and Config.AutoSolver then
                task.spawn(function()
                    flagTile(mine)
                    task.wait(0.01)
                end)
            end
        end
    end
    
    -- Teleport to safe tiles
    local targetQueue = #safeQueue > 0 and safeQueue or basicSafe
    if #targetQueue > 0 then
        isGuessing = false
        for _, s in ipairs(targetQueue) do
            if stopExecution or not Config.AutoSolver then break end
            if s and s:IsA("BasePart") and not isCellOpen(s) then
                teleportTo(s)
                task.wait(Config.TeleportSpeed)
            end
        end
    -- Auto Guess
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.3 then
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n and n:IsA("BasePart") and n.Color ~= Color3.new(0, 0, 0) and not isAlreadyFlagged(n) then
                    riskyCells[n] = (riskyCells[n] or 0) + 1
                end
            end
        end
        
        local best = nil
        local maxWeight = -1
        for cell, weight in pairs(riskyCells) do
            if weight > maxWeight then
                maxWeight = weight
                best = cell
            end
        end
        
        if best then
            isGuessing = true
            teleportTo(best)
            lastActionTime = tick()
        end
    end
end

-- Auto Solver Loop
local function autoSolverLoop()
    while Config.AutoSolver do
        task.wait(Config.TeleportSpeed)
        if not Config.AutoSolver then break end
        pcall(mainLoop)
    end
end

-- Death Handler
local function handleDeath()
    if not Config.AutoSolver then return end
    
    isGuessing = false
    stopExecution = true
    neighborCache = {}
    
    task.wait(1)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(handleDeath)
    end
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

-- ================ UI CREATION ================

-- Create Tabs
local RageTab = Window:CreateTab("Rage Mode", 4483362458)
local LegitTab = Window:CreateTab("Legit Visuals", 4483362458)

-- ================ RAGE MODE TAB ================

RageTab:CreateSection("Auto Solver Settings")

-- Auto Solver Toggle
local AutoSolverToggle = RageTab:CreateToggle({
   Name = "Auto Solver",
   CurrentValue = false,
   Flag = "AutoSolver",
   Callback = function(Value)
       Config.AutoSolver = Value
       if Value then
           task.spawn(autoSolverLoop)
       end
   end,
})

-- Auto Flag Toggle
local AutoFlagToggle = RageTab:CreateToggle({
   Name = "Auto Flag",
   CurrentValue = false,
   Flag = "RageAutoFlag",
   Callback = function(Value)
       Config.AutoFlag = Value
   end,
})

-- Auto Guess Toggle
local AutoGuessToggle = RageTab:CreateToggle({
   Name = "Auto Guess (Risky)",
   CurrentValue = false,
   Flag = "AutoGuess",
   Callback = function(Value)
       Config.AutoGuess = Value
   end,
})

-- Teleport Speed Input
RageTab:CreateParagraph({
   Title = "Teleport Speed",
   Content = "0.0001 = Super Fast | 0.01 = Normal | 0.1 = Slow"
})

local TeleportSpeedInput = RageTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.0001",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.TeleportSpeed = math.max(0.00001, math.min(0.5, num))
       end
   end,
})

-- Freeze Toggle
local FreezeToggle = RageTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = false,
   Flag = "FreezeEnabled",
   Callback = function(Value)
       Config.FreezeEnabled = Value
       updatePhysics()
   end,
})

-- Flag Range Input
local FlagRangeInput = RageTab:CreateInput({
   Name = "Flag Range (studs)",
   PlaceholderText = "25",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.FlagRange = math.max(10, math.min(200, num))
       end
   end,
})

RageTab:CreateParagraph({
   Title = "Rage Mode Info",
   Content = "• Teleports to safe tiles\n• Marks mines in black\n• Auto flag detected mines\n• Auto guess as last resort"
})

-- ================ LEGIT VISUALS TAB ================

LegitTab:CreateSection("Visual Detection System")

-- Visual Enabled Toggle
local VisualToggle = LegitTab:CreateToggle({
   Name = "Enable Visuals",
   CurrentValue = false,
   Flag = "VisualEnabled",
   Callback = function(Value)
       Config.VisualEnabled = Value
       if Value then
           visualState.running = true
           task.spawn(visualLoop)
       else
           visualState.running = false
           -- Clean up visuals
           local folder = getVisualFolder()
           for _, gui in ipairs(folder:GetChildren()) do
               gui:Destroy()
           end
           guiCache = {}
           partCache = {}
       end
   end,
})

-- Show Mines Toggle
local ShowMinesToggle = LegitTab:CreateToggle({
   Name = "Show Mines (💣)",
   CurrentValue = true,
   Flag = "ShowMines",
   Callback = function(Value)
       Config.ShowMines = Value
   end,
})

-- Show Safe Toggle
local ShowSafeToggle = LegitTab:CreateToggle({
   Name = "Show Safe (✓)",
   CurrentValue = true,
   Flag = "ShowSafe",
   Callback = function(Value)
       Config.ShowSafe = Value
   end,
})

-- Show Numbers Toggle
local ShowNumbersToggle = LegitTab:CreateToggle({
   Name = "Show Numbers",
   CurrentValue = true,
   Flag = "ShowNumbers",
   Callback = function(Value)
       Config.ShowNumbers = Value
   end,
})

LegitTab:CreateSection("Range Settings")

-- Visual Range Input
local VisualRangeInput = LegitTab:CreateInput({
   Name = "Visual Range (studs)",
   PlaceholderText = "100",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.VisualRange = math.max(10, math.min(500, num))
       end
   end,
})

-- Update Speed Input
local UpdateSpeedInput = LegitTab:CreateInput({
   Name = "Update Speed (seconds)",
   PlaceholderText = "0.2",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.VisualUpdateSpeed = math.max(0.05, math.min(1, num))
       end
   end,
})

LegitTab:CreateSection("Auto Flag")

-- Visual Auto Flag Toggle
local VisualFlagToggle = LegitTab:CreateToggle({
   Name = "Auto Flag from Visuals",
   CurrentValue = false,
   Flag = "VisualFlag",
   Callback = function(Value)
       Config.FlagEnabled = Value
   end,
})

-- Flag Speed Input
local FlagSpeedInput = LegitTab:CreateInput({
   Name = "Flag Speed (seconds)",
   PlaceholderText = "0.05",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.FlagSpeed = math.max(0.01, math.min(0.5, num))
       end
   end,
})

LegitTab:CreateParagraph({
   Title = "Visual Legend",
   Content = "💣 = Potential Mine\nNumbers = Revealed tiles\n? = Unknown/Safe candidate"
})

-- Set default values
task.spawn(function()
    task.wait(1)
    pcall(function()
        if TeleportSpeedInput and TeleportSpeedInput.Set then
            TeleportSpeedInput:Set("0.0001")
        end
        if VisualRangeInput and VisualRangeInput.Set then
            VisualRangeInput:Set("100")
        end
        if UpdateSpeedInput and UpdateSpeedInput.Set then
            UpdateSpeedInput:Set("0.2")
        end
        if FlagSpeedInput and FlagSpeedInput.Set then
            FlagSpeedInput:Set("0.05")
        end
        if FlagRangeInput and FlagRangeInput.Set then
            FlagRangeInput:Set("25")
        end
    end)
end)

-- Success message
print("Minesweeper Solver Loaded - Rage Mode + Legit Visuals")
