-- Minesweeper Auto Solver with Rayfield UI
-- Shiziks Detection + Freeze + Proper Teleport
-- Pure LuaU

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Get Controls for freeze
local Controls = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Minesweeper Solver",
   LoadingTitle = "Minesweeper Auto Solver",
   LoadingSubtitle = "Shiziks System",
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
    FreezeEnabled = true,
    BaseDelay = 0.1,
    ServerUpdateDelay = 0.08,
    FlagRange = 25,
    TeleportHeight = 5  -- Height above part (adjustable)
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local isFrozen = false

-- Freeze/Unfreeze Character
local function setFrozen(freeze)
    local char = player.Character
    if not char then return end
    
    isFrozen = freeze and Config.FreezeEnabled and Config.AutoSolver
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = isFrozen
        end
    end
    
    if isFrozen then
        Controls:Disable()
    else
        Controls:Enable()
    end
end

-- Helper Functions
local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function isAlreadyFlagged(part)
    return part:FindFirstChild("Flag") or part:FindFirstChild("BombFlag") or part:FindFirstChild("FlagModel")
end

-- Teleport Function - FIXED untuk tidak tembus
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Unfreeze sementara untuk teleport
    setFrozen(false)
    
    -- Calculate proper position ABOVE part
    -- target.CFrame.Position adalah center part
    -- Tambahkan offset ke ATAS supaya kaki tidak tembus
    local targetPosition = target.Position + Vector3.new(0, Config.TeleportHeight, 0)
    
    -- Set CFrame dengan posisi yang sudah di adjust
    root.CFrame = CFrame.new(targetPosition)
    
    -- Apply downward velocity untuk landing smooth
    root.Velocity = Vector3.new(0, -50, 0)
    root.AssemblyLinearVelocity = Vector3.new(0, -50, 0)
    
    -- Wait untuk server update
    task.wait(Config.ServerUpdateDelay)
    
    -- Re-freeze setelah teleport
    setFrozen(true)
    
    -- Wait base delay
    task.wait(Config.BaseDelay)
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    -- Check range
    if (part.Position - root.Position).Magnitude > Config.FlagRange then return false end
    
    -- Check debounce
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 1 then return false end
    
    local success = pcall(function()
        -- Try ClickDetector first (shiziks method)
        local cd = part:FindFirstChildOfClass("ClickDetector", true)
        if cd then
            fireclickdetector(cd)
            flaggedDebounce[part] = tick()
            return
        end
        
        -- Fallback to RemoteEvent
        local events = replicatedStorage:FindFirstChild("Events")
        if not events then return end
        
        local flagEvents = events:FindFirstChild("FlagEvents")
        if not flagEvents then return end
        
        local placeFlag = flagEvents:FindFirstChild("PlaceFlag")
        if not placeFlag then return end
        
        placeFlag:FireServer(unpack({part}))
        flaggedDebounce[part] = tick()
    end)
    
    return success
end

-- Get Solver Data (shiziks detection system)
local function getSolverData()
    local folder = workspace:FindFirstChild("Flag") and workspace.Flag:FindFirstChild("Parts")
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    
    for _, cell in ipairs(allParts) do
        if not isCellOpen(cell) then continue end
        
        -- Get number from GUI
        local label = cell:FindFirstChild("NumberGui") and cell.NumberGui:FindFirstChildOfClass("TextLabel")
        local val = (label and tonumber(label.Text)) or 0
        
        -- Build neighbor cache
        if not neighborCache[cell] then
            local nbs = {}
            for _, n in ipairs(allParts) do
                if n ~= cell and (n.Position - cell.Position).Magnitude < (cell.Size.X * 1.8) then
                    table.insert(nbs, n)
                end
            end
            neighborCache[cell] = nbs
        end
        
        -- Count hidden and flagged neighbors
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

-- Main Detection Loop (shiziks algorithm)
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then return end
    
    local data = getSolverData()
    local safeQueue, mineQueue, riskyCells = {}, {}, {}
    local foundAnything = false
    
    -- Advanced subset detection (Euler method)
    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1, d2 = data[i], data[j]
                if (d1.obj.Position - d2.obj.Position).Magnitude < 12 then
                    local s1, s2 = d1.hidden, d2.hidden
                    
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
                        
                        -- If difference is 0 mines, all are safe
                        if diffMines == 0 then
                            for _, n in ipairs(diffCells) do
                                table.insert(safeQueue, n)
                                foundAnything = true
                            end
                        -- If difference equals cells, all are mines
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
    
    -- Basic detection (corner cases)
    local basicSafe, basicMines = {}, {}
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            -- All hidden are mines
            if #d.hidden == d.eVal then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicMines, n)
                    foundAnything = true
                end
            -- All hidden are safe
            elseif d.eVal <= 0 then
                for _, n in ipairs(d.hidden) do
                    table.insert(basicSafe, n)
                    foundAnything = true
                end
            end
        end
    end
    
    -- Mark mines as black
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
        
        for _, mine in ipairs(allMines) do
            if not stopExecution then
                task.spawn(function()
                    flagTile(mine)
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
            end
        end
    -- Auto Guess if enabled and nothing found
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.8 then
        -- Build risk map
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n.Color ~= Color3.new(0, 0, 0) then
                    riskyCells[n] = (riskyCells[n] or 0) + 1
                end
            end
        end
        
        -- Find best guess (most common in risk analysis)
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
    -- Initial freeze
    setFrozen(true)
    
    while Config.AutoSolver do
        task.wait(0.05)  -- Main loop tick
        
        if not Config.AutoSolver then break end
        
        pcall(mainLoop)
    end
    
    -- Unfreeze when stopped
    setFrozen(false)
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
    
    -- Unfreeze on death
    setFrozen(false)
    
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
              Content = "Solver Enabled - Character Frozen",
              Duration = 2,
              Image = 4483362458,
           })
       else
           setFrozen(false)
           Rayfield:Notify({
              Title = "Auto Solver",
              Content = "Solver Disabled - Character Unfrozen",
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
              Content = "⚠️ Auto Guess Enabled - Will take risks!",
              Duration = 3,
              Image = 4483362458,
           })
       end
   end,
})

-- Main Tab - Freeze Toggle
local FreezeToggle = MainTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = true,
   Flag = "Freeze",
   Callback = function(Value)
       Config.FreezeEnabled = Value
       if not Value and Config.AutoSolver then
           setFrozen(false)
       end
   end,
})

-- Settings Tab - Base Delay
local BaseDelayInput = SettingsTab:CreateInput({
   Name = "Base Delay (seconds)",
   PlaceholderText = "0.1",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       local num = tonumber(Text)
       if num and num >= 0.01 and num <= 2 then
           Config.BaseDelay = num
           Rayfield:Notify({
              Title = "Base Delay Updated",
              Content = "Set to " .. num .. "s",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Settings Tab - Server Update Delay
local ServerDelayInput = SettingsTab:CreateInput({
   Name = "Server Update Delay (seconds)",
   PlaceholderText = "0.08",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       local num = tonumber(Text)
       if num and num >= 0.01 and num <= 0.5 then
           Config.ServerUpdateDelay = num
           Rayfield:Notify({
              Title = "Server Delay Updated",
              Content = "Set to " .. num .. "s",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Settings Tab - Teleport Height
local HeightInput = SettingsTab:CreateInput({
   Name = "Teleport Height (studs)",
   PlaceholderText = "5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       local num = tonumber(Text)
       if num and num >= 2 and num <= 10 then
           Config.TeleportHeight = num
           Rayfield:Notify({
              Title = "Height Updated",
              Content = "Set to " .. num .. " studs above part",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Settings Tab - Flag Range
local FlagRangeInput = SettingsTab:CreateInput({
   Name = "Auto Flag Range (studs)",
   PlaceholderText = "25",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       local num = tonumber(Text)
       if num and num >= 10 and num <= 200 then
           Config.FlagRange = num
           Rayfield:Notify({
              Title = "Flag Range Updated",
              Content = "Set to " .. num .. " studs",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Info Section
MainTab:CreateSection("Detection System")

MainTab:CreateParagraph({
   Title = "Shiziks Advanced Detection",
   Content = "• Euler subset algorithm\n• Corner detection\n• Pattern recognition\n• Character freeze for stability"
})

SettingsTab:CreateSection("Configuration Guide")

SettingsTab:CreateParagraph({
   Title = "Recommended Settings",
   Content = "Base Delay: 0.1s (balanced)\nServer Delay: 0.08s (safe)\nHeight: 5 studs (no clip)\nFlag Range: 25 studs"
})

SettingsTab:CreateParagraph({
   Title = "Timing Explained",
   Content = "Base Delay = wait between tiles\nServer Delay = wait for server update\n(Prevents stepping on bombs!)"
})

-- Success Notification
Rayfield:Notify({
   Title = "Solver Loaded",
   Content = "Shiziks System Ready! Character will freeze when active.",
   Duration = 3,
   Image = 4483362458,
})
