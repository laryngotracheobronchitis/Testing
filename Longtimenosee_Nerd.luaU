-- Minesweeper Auto Solver with Rayfield UI - FIXED TELEPORT
-- Based on shiziks-solver detection system
-- Pure LuaU

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

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
    FreezeCharacter = true
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

-- Freeze Character Function
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

-- FIXED TELEPORT FUNCTION - BERDIRI DI ATAS PART
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Freeze character if enabled
    if Config.FreezeCharacter and not characterFrozen then
        freezeCharacter(true)
    end
    
    -- Hitung posisi di ATAS part
    local targetPos = target.Position
    local partHeight = target.Size.Y or 1
    
    -- Bagian ATAS part + offset untuk berdiri
    local partTopY = targetPos.Y + (partHeight / 2)
    local standHeight = 3.1 -- Tinggi karakter (sama dengan offset original)
    
    -- Posisi akhir: bagian ATAS part + offset
    local finalY = partTopY + standHeight
    
    -- Teleport dengan CFrame baru (bukan target.CFrame)
    root.CFrame = CFrame.new(
        targetPos.X,
        finalY,
        targetPos.Z
    )
    
    -- Small downward velocity untuk memastikan kontak
    root.Velocity = Vector3.new(0, -50, 0)
    
    task.wait(Config.TeleportSpeed)
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
        -- Try ClickDetector first
        local cd = part:FindFirstChildOfClass("ClickDetector")
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
        
        placeFlag:FireServer(part)
        flaggedDebounce[part] = tick()
    end)
    
    return success
end

-- Get Parts Folder
local function getPartsFolder()
    local flag = workspace:FindFirstChild("Flag")
    if flag then
        local parts = flag:FindFirstChild("Parts")
        if parts then return parts end
    end
    
    local parts = workspace:FindFirstChild("Parts", true)
    if parts then return parts end
    
    return nil
end

-- Get Solver Data
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
        local val = (label and tonumber(label.Text)) or 0
        
        -- Build neighbor cache
        if not neighborCache[cell] then
            local nbs = {}
            for _, n in ipairs(allParts) do
                if n:IsA("BasePart") and n ~= cell and (n.Position - cell.Position).Magnitude < (cell.Size.X * 1.8) then
                    table.insert(nbs, n)
                end
            end
            neighborCache[cell] = nbs
        end
        
        -- Count hidden and flagged neighbors
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
        if characterFrozen then freezeCharacter(false) end
        return 
    end
    
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
    
    -- Basic detection
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
        for _, m in ipairs(mineQueue) do table.insert(allMines, m) end
        for _, m in ipairs(basicMines) do table.insert(allMines, m) end
        
        for _, mine in ipairs(allMines) do
            if not stopExecution then
                flagTile(mine)
            end
        end
    end
    
    -- Teleport to safe tiles (PAKAI TELEPORT FIXED)
    local targetQueue = #safeQueue > 0 and safeQueue or basicSafe
    if #targetQueue > 0 then
        isGuessing = false
        for _, s in ipairs(targetQueue) do
            if stopExecution or not Config.AutoSolver then break end
            if s and s:IsA("BasePart") and not isCellOpen(s) then
                teleportTo(s)
            end
        end
    -- Auto Guess if enabled and nothing found
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.8 then
        -- Build risk map
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n and n:IsA("BasePart") and n.Color ~= Color3.new(0, 0, 0) then
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
    while Config.AutoSolver do
        task.wait(Config.TeleportSpeed)
        
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
           if Config.FreezeCharacter then
               freezeCharacter(true)
           end
       else
           if characterFrozen then freezeCharacter(false) end
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

-- Settings Tab - Freeze Character
local FreezeToggle = SettingsTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = true,
   Flag = "FreezeChar",
   Callback = function(Value)
       Config.FreezeCharacter = Value
       if not Value and characterFrozen then
           freezeCharacter(false)
       elseif Value and Config.AutoSolver and not characterFrozen then
           freezeCharacter(true)
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
           Config.TeleportSpeed = math.max(0.005, math.min(1, num))
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
MainTab:CreateSection("Fixed Features")

MainTab:CreateParagraph({
   Title = "FIXED TELEPORT",
   Content = "✓ Berdiri DI ATAS part\n✓ Tidak menembus part\n✓ Freeze character\n✓ Input fields (no slider)\n✓ 0.1s default speed"
})

SettingsTab:CreateSection("Settings Guide")

SettingsTab:CreateParagraph({
   Title = "Recommended",
   Content = "Teleport Speed: 0.1 (Balanced)\nFlag Range: 25 (Default)\nFreeze: ON untuk auto solver"
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

-- Success message (tanpa notifikasi)
print("Minesweeper Solver Loaded - Fixed Teleport")
