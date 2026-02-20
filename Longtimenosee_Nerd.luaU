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
    TeleportSpeed = 0.1,
    UpdateSpeed = 0.05, -- Update lebih cepat dari teleport
    FlagRange = 25,
    FreezeCharacter = false
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local lastUpdateTime = 0
local characterFrozen = false
local currentData = {} -- Menyimpan data terakhir

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

-- FIXED Teleport Function - Berdiri DI ATAS part
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
    
    -- Bagian ATAS part
    local partTopY = targetPos.Y + (partHeight / 2)
    local standHeight = 3.1 -- Tinggi karakter dari kaki ke root
    
    -- Posisi akhir: bagian ATAS part + offset
    local finalY = partTopY + standHeight
    
    -- Teleport dengan CFrame baru
    root.CFrame = CFrame.new(
        targetPos.X,
        finalY,
        targetPos.Z
    )
    
    -- Small downward velocity
    root.Velocity = Vector3.new(0, -50, 0)
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    -- Check range
    if (part.Position - root.Position).Magnitude > Config.FlagRange then return false end
    
    -- Check debounce
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 0.5 then return false end
    
    local success = pcall(function()
        -- Try ClickDetector first
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
    return workspace:FindFirstChild("Parts", true)
end

-- Get Solver Data - UPDATE VERSION (lebih cepat)
local function getSolverData()
    local folder = getPartsFolder()
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    local currentTime = tick()
    
    -- Bersihkan cache lama
    if currentTime - lastUpdateTime > 5 then
        neighborCache = {}
    end
    
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
        
        -- Build neighbor cache (lebih cepat)
        if not neighborCache[cell] then
            local nbs = {}
            local cellPos = cell.Position
            local cellSize = cell.Size.X * 1.8
            
            for _, n in ipairs(allParts) do
                if n:IsA("BasePart") and n ~= cell then
                    if (n.Position - cellPos).Magnitude < cellSize then
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
                if n.Color == Color3.new(0, 0, 0) or isAlreadyFlagged(n) then
                    mines = mines + 1
                else
                    table.insert(hidden, n)
                end
            end
        end
        
        if #hidden > 0 then
            table.insert(numberData, {
                obj = cell,
                eVal = val - mines,
                hidden = hidden,
                val = val
            })
        end
    end
    
    lastUpdateTime = currentTime
    return numberData
end

-- Verifikasi tile sebelum teleport
local function isTileSafe(tile, data)
    if not tile then return false end
    if isCellOpen(tile) then return true end
    if tile.Color == Color3.new(0, 0, 0) then return false end
    if isAlreadyFlagged(tile) then return false end
    
    -- Cek di data terbaru
    for _, d in ipairs(data) do
        for _, h in ipairs(d.hidden) do
            if h == tile then
                return d.eVal == 0 -- Aman hanya jika expected mines = 0
            end
        end
    end
    
    return false
end

-- Update detection (dipanggil terus)
local function updateDetection()
    if stopExecution then return end
    if not Config.AutoSolver then return end
    
    currentData = getSolverData()
end

-- Main Action Loop (untuk teleport)
local function actionLoop()
    if stopExecution or not Config.AutoSolver or #currentData == 0 then return end
    
    local data = currentData
    local safeTiles = {}
    local mineTiles = {}
    local foundAnything = false
    
    -- PRIORITAS 1: Tile yang 100% aman (eVal = 0)
    for _, d in ipairs(data) do
        if #d.hidden > 0 and d.eVal == 0 then
            for _, n in ipairs(d.hidden) do
                safeTiles[n] = true
                foundAnything = true
            end
        end
    end
    
    -- PRIORITAS 2: Tile yang 100% mine
    for _, d in ipairs(data) do
        if #d.hidden > 0 and #d.hidden == d.eVal and d.eVal > 0 then
            for _, n in ipairs(d.hidden) do
                mineTiles[n] = true
                foundAnything = true
            end
        end
    end
    
    -- Mark mines
    for tile, _ in pairs(mineTiles) do
        if tile and tile:IsA("BasePart") then
            tile.Color = Color3.new(0, 0, 0)
        end
    end
    
    -- Auto Flag
    if Config.AutoFlag then
        for tile, _ in pairs(mineTiles) do
            if not stopExecution then
                task.spawn(function()
                    flagTile(tile)
                end)
            end
        end
    end
    
    -- Teleport ke safe tiles (hanya yang 100% aman)
    local safeList = {}
    for tile, _ in pairs(safeTiles) do
        table.insert(safeList, tile)
    end
    
    if #safeList > 0 then
        isGuessing = false
        for _, tile in ipairs(safeList) do
            if stopExecution or not Config.AutoSolver then break end
            if tile and tile:IsA("BasePart") and not isCellOpen(tile) then
                -- Verifikasi ulang dengan data terbaru
                if isTileSafe(tile, currentData) then
                    teleportTo(tile)
                    task.wait(Config.TeleportSpeed)
                end
            end
        end
    end
    
    -- Auto Guess (hanya jika tidak ada yang ditemukan)
    if Config.AutoGuess and not foundAnything and tick() - lastActionTime > 1 then
        -- Kumpulkan semua hidden tiles
        local candidates = {}
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n and n:IsA("BasePart") and n.Color ~= Color3.new(0, 0, 0) then
                    candidates[n] = (candidates[n] or 0) + 1
                end
            end
        end
        
        -- Cari yang paling sering muncul
        local best, maxCount = nil, -1
        for tile, count in pairs(candidates) do
            if count > maxCount then
                maxCount = count
                best = tile
            end
        end
        
        if best then
            isGuessing = true
            teleportTo(best)
            lastActionTime = tick()
        end
    end
end

-- Update Loop (jalan terus untuk update data)
local function updateLoop()
    while Config.AutoSolver do
        task.wait(Config.UpdateSpeed) -- Update lebih cepat
        pcall(updateDetection)
    end
end

-- Action Loop (jalan dengan kecepatan teleport)
local function actionLoopWrapper()
    while Config.AutoSolver do
        task.wait(Config.TeleportSpeed)
        pcall(actionLoop)
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
    currentData = {}
    if characterFrozen then freezeCharacter(false) end
    
    task.wait(1)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    currentData = {}
    
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
           task.spawn(updateLoop)
           task.spawn(actionLoopWrapper)
           Rayfield:Notify({
              Title = "Auto Solver",
              Content = "Solver Enabled - Dual Loop Active",
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
              Content = "⚠️ Auto Guess Enabled - Will take risks!",
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
       elseif Value and Config.AutoSolver and not characterFrozen then
           freezeCharacter(true)
       end
   end,
})

-- Settings Tab - Teleport Speed (INPUT)
SettingsTab:CreateParagraph({
   Title = "Teleport Speed",
   Content = "0.1 = Balanced | 0.05 = Fast | 0.01 = Very Fast | 0.2 = Slow"
})

local SpeedInput = SettingsTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.1",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.TeleportSpeed = math.max(0.005, math.min(0.5, num))
       end
   end,
})

-- Settings Tab - Update Speed (INPUT) - BARU!
SettingsTab:CreateParagraph({
   Title = "Update Speed",
   Content = "0.05 = Fast Update | 0.1 = Normal | 0.2 = Slow (harus lebih cepat dari teleport)"
})

local UpdateSpeedInput = SettingsTab:CreateInput({
   Name = "Update Speed (seconds)",
   PlaceholderText = "0.05",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.UpdateSpeed = math.max(0.01, math.min(0.2, num))
       end
   end,
})

-- Settings Tab - Flag Range (INPUT)
SettingsTab:CreateParagraph({
   Title = "Flag Range",
   Content = "25 = Default | 50 = Medium | 75 = Far"
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
MainTab:CreateSection("Dual Loop System")

MainTab:CreateParagraph({
   Title = "Fixed Update",
   Content = "✓ Update Loop: " .. Config.UpdateSpeed .. "s\n✓ Action Loop: " .. Config.TeleportSpeed .. "s\n✓ Update selalu lebih cepat\n✓ Tile diverifikasi sebelum teleport\n✓ Tidak ketinggalan update"
})

-- Set default values
task.spawn(function()
    task.wait(1)
    pcall(function()
        if SpeedInput and SpeedInput.Set then
            SpeedInput:Set("0.1")
        end
        if UpdateSpeedInput and UpdateSpeedInput.Set then
            UpdateSpeedInput:Set("0.05")
        end
        if FlagRangeInput and FlagRangeInput.Set then
            FlagRangeInput:Set("25")
        end
    end)
end)

-- Success Notification
Rayfield:Notify({
   Title = "Solver Loaded",
   Content = "Dual Loop System - Update lebih cepat dari Teleport",
   Duration = 3,
   Image = 4483362458,
})
