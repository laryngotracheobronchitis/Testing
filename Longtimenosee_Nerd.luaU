-- Minesweeper Auto Solver with Rayfield UI
-- Based on shiziks-solver detection system
-- Pure LuaU

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Minesweeper Solver",
   LoadingTitle = "Minesweeper Auto Solver",
   LoadingSubtitle = "by Shiziks System",
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
    AutoSolver = false,
    AutoFlag = false,
    AutoGuess = false,
    TeleportSpeed = 0.1,
    FlagRange = 25,
    FreezeCharacter = false
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local characterFrozen = false

-- Helper Functions
local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function isAlreadyFlagged(part)
    return part:FindFirstChild("Flag") or part:FindFirstChild("BombFlag") or part:FindFirstChild("FlagModel")
end

-- Freeze Character
local function freezeCharacter(freeze)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if freeze then
        if humanoid then
            humanoid.PlatformStand = true
            humanoid.AutoRotate = false
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end
        characterFrozen = true
    else
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
        characterFrozen = false
    end
end

-- Teleport Function - Berdiri DI ATAS part
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if Config.FreezeCharacter and not characterFrozen then
        freezeCharacter(true)
    end
    
    local targetPos = target.Position
    local partHeight = target.Size.Y or 1
    local partTopY = targetPos.Y + (partHeight / 2)
    local standHeight = 3.1
    
    root.CFrame = CFrame.new(
        targetPos.X,
        partTopY + standHeight,
        targetPos.Z
    )
    
    root.Velocity = Vector3.new(0, -50, 0)
    task.wait(Config.TeleportSpeed)
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    if (part.Position - root.Position).Magnitude > Config.FlagRange then return false end
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 1 then return false end
    
    local success = pcall(function()
        local cd = part:FindFirstChildOfClass("ClickDetector", true)
        if cd then
            fireclickdetector(cd)
            flaggedDebounce[part] = tick()
            return
        end
        
        local events = replicatedStorage:FindFirstChild("Events")
        if events then
            local flagEvents = events:FindFirstChild("FlagEvents")
            if flagEvents then
                local placeFlag = flagEvents:FindFirstChild("PlaceFlag")
                if placeFlag then
                    placeFlag:FireServer(unpack({part}))
                    flaggedDebounce[part] = tick()
                end
            end
        end
    end)
    
    return success
end

-- Get Solver Data
local function getSolverData()
    local folder = workspace:FindFirstChild("Flag") and workspace.Flag:FindFirstChild("Parts")
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    
    for _, cell in ipairs(allParts) do
        if not isCellOpen(cell) then continue end
        
        local label = cell:FindFirstChild("NumberGui") and cell.NumberGui:FindFirstChildOfClass("TextLabel")
        local val = (label and tonumber(label.Text)) or 0
        
        if not neighborCache[cell] then
            local nbs = {}
            for _, n in ipairs(allParts) do
                if n ~= cell and (n.Position - cell.Position).Magnitude < (cell.Size.X * 1.8) then
                    table.insert(nbs, n)
                end
            end
            neighborCache[cell] = nbs
        end
        
        local hidden, mines = {}, 0
        for _, n in ipairs(neighborCache[cell]) do
            if not isCellOpen(n) then
                if n.Color == Color3.new(0, 0, 0) then
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

-- Main Detection Loop
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then 
        if characterFrozen then freezeCharacter(false) end
        return 
    end
    
    local data = getSolverData()
    local safeQueue, mineQueue, riskyCells = {}, {}, {}
    local foundAnything = false
    
    -- Basic detection
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            if #d.hidden == d.eVal then
                for _, n in ipairs(d.hidden) do
                    table.insert(mineQueue, n)
                    foundAnything = true
                end
            elseif d.eVal <= 0 then
                for _, n in ipairs(d.hidden) do
                    table.insert(safeQueue, n)
                    foundAnything = true
                end
            end
        end
    end
    
    -- Advanced subset detection
    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1, d2 = data[i], data[j]
                if (d1.obj.Position - d2.obj.Position).Magnitude < 12 then
                    local s1, s2 = d1.hidden, d2.hidden
                    
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
    
    -- Mark mines
    for _, m in ipairs(mineQueue) do
        m.Color = Color3.new(0, 0, 0)
    end
    
    -- Auto Flag
    if Config.AutoFlag then
        for _, mine in ipairs(mineQueue) do
            if not stopExecution then
                flagTile(mine)
            end
        end
    end
    
    -- Teleport to safe tiles
    if #safeQueue > 0 then
        isGuessing = false
        for _, s in ipairs(safeQueue) do
            if stopExecution or not Config.AutoSolver then break end
            if not isCellOpen(s) then
                teleportTo(s)
            end
        end
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.8 then
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n.Color ~= Color3.new(0, 0, 0) then
                    riskyCells[n] = (riskyCells[n] or 0) + 1
                end
            end
        end
        
        local best, maxWeight = nil, -1
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
        task.wait(0.001)
        
        if not Config.AutoSolver then 
            if characterFrozen then freezeCharacter(false) end
            break 
        end
        
        pcall(mainLoop)
    end
end

-- Death Handler
local function handleDeath()
    if not Config.AutoSolver then return end
    
    local deathMsg = isGuessing and "Guess was wrong" or "Hit a mine"
    Rayfield:Notify({
       Title = "Death",
       Content = deathMsg,
       Duration = 2,
       Image = 4483362458,
    })
    
    isGuessing = false
    stopExecution = true
    neighborCache = {}
    if characterFrozen then freezeCharacter(false) end
    
    task.wait(1)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then
        hum.Died:Connect(handleDeath)
    end
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

-- Create Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Main Tab - Auto Solver
local AutoSolverToggle = MainTab:CreateToggle({
   Name = "Auto Solver",
   CurrentValue = false,
   Flag = "AutoSolver",
   Callback = function(Value)
       Config.AutoSolver = Value
       if Value then
           task.spawn(autoSolverLoop)
           Rayfield:Notify({
              Title = "Auto Solver",
              Content = "Solver Enabled",
              Duration = 2,
              Image = 4483362458,
           })
       else
           if characterFrozen then freezeCharacter(false) end
           Rayfield:Notify({
              Title = "Auto Solver",
              Content = "Solver Disabled",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Main Tab - Auto Flag
local AutoFlagToggle = MainTab:CreateToggle({
   Name = "Auto Flag",
   CurrentValue = false,
   Flag = "AutoFlag",
   Callback = function(Value)
       Config.AutoFlag = Value
       if Value then
           Rayfield:Notify({
              Title = "Auto Flag",
              Content = "Auto Flag Enabled",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Main Tab - Auto Guess
local AutoGuessToggle = MainTab:CreateToggle({
   Name = "Auto Guess",
   CurrentValue = false,
   Flag = "AutoGuess",
   Callback = function(Value)
       Config.AutoGuess = Value
       if Value then
           Rayfield:Notify({
              Title = "Auto Guess",
              Content = "⚠️ Auto Guess Enabled",
              Duration = 3,
              Image = 4483362458,
           })
       end
   end,
})

-- Settings Tab - Freeze Character
local FreezeToggle = SettingsTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = false,
   Flag = "FreezeChar",
   Callback = function(Value)
       Config.FreezeCharacter = Value
       if not Value and characterFrozen then
           freezeCharacter(false)
       end
   end,
})

-- Settings Tab - Teleport Speed (INPUT)
SettingsTab:CreateParagraph({
   Title = "Teleport Speed",
   Content = "0.01 = Very Fast | 0.1 = Balanced | 0.5 = Slow"
})

local SpeedInput = SettingsTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.1",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.TeleportSpeed = math.max(0.01, math.min(1, num))
       end
   end,
})

-- Settings Tab - Flag Range (INPUT)
SettingsTab:CreateParagraph({
   Title = "Flag Range",
   Content = "25 = Default | 50 = Medium | 100 = Far"
})

local FlagRangeInput = SettingsTab:CreateInput({
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

-- Info Section
MainTab:CreateSection("Detection System")

MainTab:CreateParagraph({
   Title = "Advanced Detection",
   Content = "• Euler subset algorithm\n• Corner detection\n• Pattern recognition\n• Auto Guess (risky)"
})

SettingsTab:CreateSection("Speed Guide")

SettingsTab:CreateParagraph({
   Title = "Recommended Settings",
   Content = "0.01s = Very Fast\n0.1s = Balanced (Recommended)\n0.5s = Safe/Slow\n1s = Very Safe"
})

-- Set default values
task.spawn(function()
    task.wait(1)
    pcall(function()
        if SpeedInput and SpeedInput.Set then
            SpeedInput:Set("0.1")
        end
        if FlagRangeInput and FlagRangeInput.Set then
            FlagRangeInput:Set("25")
        end
    end)
end)

-- Success Notification
Rayfield:Notify({
   Title = "Solver Loaded",
   Content = "Shiziks Detection System Ready!",
   Duration = 3,
   Image = 4483362458,
})
