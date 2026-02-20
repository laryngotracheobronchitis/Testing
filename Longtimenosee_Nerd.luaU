-- Minesweeper Auto Solver with Rayfield UI - OPTIMIZED (NO NOTIFICATIONS)
-- Based on shiziks-solver detection system
-- Pure LuaU - NO DELAY, PERFECT TELEPORT, NO NOTIFICATIONS

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    TeleportSpeed = 0.0001,
    FlagRange = 25,
    FreezeEnabled = true
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local Controls = nil

-- Get Controls
pcall(function()
    Controls = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
end)

-- Helper Functions
local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function isAlreadyFlagged(part)
    return part:FindFirstChild("Flag") or part:FindFirstChild("BombFlag") or part:FindFirstChild("FlagModel")
end

-- Freeze Function
local function updatePhysics()
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
            pcall(function() Controls:Disable() end)
        else 
            pcall(function() Controls:Enable() end)
        end
    end
end

-- Teleport Function - Instan dan di ATAS part
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end
    
    -- Hitung posisi di ATAS part
    local targetPos = target.Position
    local partSize = target.Size
    local standHeight = (partSize.Y / 2) + 3
    
    root.CFrame = CFrame.new(
        targetPos.X,
        targetPos.Y + standHeight,
        targetPos.Z
    )
    
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    if Config.FreezeEnabled then
        updatePhysics()
    end
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    if (part.Position - root.Position).Magnitude > Config.FlagRange then return false end
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 0.3 then return false end
    
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
                    placeFlag:FireServer(part)
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
    if not folder then 
        folder = workspace:FindFirstChild("Parts", true)
    end
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
                if n.Color == Color3.new(0, 0, 0) or isAlreadyFlagged(n) then
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
        updatePhysics()
        return 
    end
    
    local data = getSolverData()
    local safeQueue, mineQueue, riskyCells = {}, {}, {}
    local foundAnything = false
    
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
    
    -- Basic detection
    local basicSafe, basicMines = {}, {}
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            if #d.hidden == d.eVal then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicMines, n)
                    foundAnything = true
                end
            elseif d.eVal <= 0 then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicSafe, n)
                    foundAnything = true
                end
            end
        end
    end
    
    -- Mark mines
    for _, m in ipairs(mineQueue) do
        m.Color = Color3.new(0, 0, 0)
    end
    for _, m in ipairs(basicMines) do
        m.Color = Color3.new(0, 0, 0)
    end
    
    -- Auto Flag
    if Config.AutoFlag then
        local allMines = {}
        for _, m in ipairs(mineQueue) do table.insert(allMines, m) end
        for _, m in ipairs(basicMines) do table.insert(allMines, m) end
        
        local uniqueMines = {}
        for _, mine in ipairs(allMines) do
            uniqueMines[mine] = mine
        end
        
        for _, mine in pairs(uniqueMines) do
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
            if not isCellOpen(s) then
                teleportTo(s)
                task.wait(Config.TeleportSpeed)
            end
        end
    -- Auto Guess
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.3 then
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n.Color ~= Color3.new(0, 0, 0) and not isAlreadyFlagged(n) then
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
    
    updatePhysics()
end

-- Auto Solver Loop
local function autoSolverLoop()
    while Config.AutoSolver do
        task.wait(Config.TeleportSpeed)
        
        if not Config.AutoSolver then 
            updatePhysics()
            break 
        end
        
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
           updatePhysics()
       else
           updatePhysics()
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
   end,
})

-- Main Tab - Auto Guess
local AutoGuessToggle = MainTab:CreateToggle({
   Name = "Auto Guess",
   CurrentValue = false,
   Flag = "AutoGuess",
   Callback = function(Value)
       Config.AutoGuess = Value
   end,
})

-- Settings Tab - Freeze Toggle
local FreezeToggle = SettingsTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = true,
   Flag = "FreezeEnabled",
   Callback = function(Value)
       Config.FreezeEnabled = Value
       updatePhysics()
   end,
})

-- Settings Tab - Teleport Speed
local SpeedSlider = SettingsTab:CreateSlider({
   Name = "Teleport Speed",
   Range = {0.00001, 0.1},
   Increment = 0.00001,
   Suffix = "s",
   CurrentValue = 0.0001,
   Flag = "TPSpeed",
   Callback = function(Value)
       Config.TeleportSpeed = Value
   end,
})

-- Settings Tab - Flag Range
local FlagRangeSlider = SettingsTab:CreateSlider({
   Name = "Auto Flag Range",
   Range = {10, 100},
   Increment = 5,
   Suffix = " studs",
   CurrentValue = 25,
   Flag = "FlagRange",
   Callback = function(Value)
       Config.FlagRange = Value
   end,
})

-- Info Section
MainTab:CreateSection("Status")

MainTab:CreateParagraph({
   Title = "Features",
   Content = "• NO DELAY\n• 0.0001s speed\n• ABOVE part teleport\n• Auto Flag\n• Auto Guess"
})

-- Continuous freeze update
task.spawn(function()
    while true do
        task.wait(0.05)
        if Config.AutoSolver and Config.FreezeEnabled then
            pcall(updatePhysics)
        end
    end
end)
