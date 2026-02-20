local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "goorner",
   LoadingTitle = "Auto Solver minesweeper",
   LoadingSubtitle = "inspired by deadshizik and made by yar",
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
    TeleportSpeed = 0.05,
    FlagRange = 25,
    FreezeCharacter = false
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local characterFrozen = false
local lastData = {} -- Simpan data terakhir untuk perbandingan
local lastUpdateTime = 0

-- Helper Functions
local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function isAlreadyFlagged(part)
    if not part then return false end
    if part:FindFirstChild("Flag") then return true end
    if part:FindFirstChild("BombFlag") then return true end
    if part:FindFirstChild("FlagModel") then return true end
    return false
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

-- Get Parts Folder dengan caching
local function getPartsFolder()
    local flag = workspace:FindFirstChild("Flag")
    if flag then
        local parts = flag:FindFirstChild("Parts")
        if parts then return parts end
    end
    return workspace:FindFirstChild("Parts", true)
end

-- Get Solver Data - OPTIMIZED
local function getSolverData()
    local folder = getPartsFolder()
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    local currentTime = tick()
    
    -- Bersihkan cache lama setiap 5 detik
    if currentTime - lastUpdateTime > 5 then
        neighborCache = {}
        lastUpdateTime = currentTime
    end
    
    for _, cell in ipairs(allParts) do
        if not cell:IsA("BasePart") then continue end
        if not isCellOpen(cell) then continue end
        
        -- Get number from GUI - lebih cepat
        local numberGui = cell:FindFirstChild("NumberGui")
        local label = numberGui and numberGui:FindFirstChildOfClass("TextLabel")
        local val = 0
        if label and label.Text then
            val = tonumber(label.Text) or 0
        end
        
        -- Skip kalau tidak ada angka dan tidak ada hidden tiles potensial
        if val == 0 then
            -- Cek dulu apakah ada tetangga yang belum terbuka
            local hasHidden = false
            for _, n in ipairs(allParts) do
                if n:IsA("BasePart") and n ~= cell and not isCellOpen(n) then
                    hasHidden = true
                    break
                end
            end
            if not hasHidden then
                goto continue
            end
        end
        
        -- Build neighbor cache - optimized
        if not neighborCache[cell] then
            local nbs = {}
            local cellPos = cell.Position
            local threshold = cell.Size.X * 1.8
            
            for _, n in ipairs(allParts) do
                if n:IsA("BasePart") and n ~= cell then
                    if (n.Position - cellPos).Magnitude < threshold then
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
                hidden = hidden
            })
        end
        
        ::continue::
    end
    
    return numberData
end

-- Verifikasi tile sebelum teleport
local function isTileSafe(tile, data)
    if not tile then return false end
    if isCellOpen(tile) then return true end
    if tile.Color == Color3.new(0, 0, 0) then return false end
    if isAlreadyFlagged(tile) then return false end
    
    -- Cek di semua data
    for _, d in ipairs(data) do
        for _, h in ipairs(d.hidden) do
            if h == tile then
                -- Kalau tile ini ada di hidden list, cek expected value
                if d.eVal == 0 then
                    return true -- 100% aman
                elseif #d.hidden == d.eVal then
                    return false -- 100% mine
                end
            end
        end
    end
    
    return false
end

-- Main Detection Loop - SUPER FAST
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then 
        if characterFrozen then freezeCharacter(false) end
        return 
    end
    
    -- Ambil data dengan cepat
    local data = getSolverData()
    if #data == 0 then return end
    
    -- Simpan untuk perbandingan
    lastData = data
    
    local safeTiles = {}
    local mineTiles = {}
    local foundAnything = false
    
    -- PRIORITAS 1: Tile dengan eVal = 0 (100% aman)
    for _, d in ipairs(data) do
        if #d.hidden > 0 and d.eVal == 0 then
            for _, n in ipairs(d.hidden) do
                safeTiles[n] = true
                foundAnything = true
            end
        end
    end
    
    -- PRIORITAS 2: Tile yang pasti mine
    for _, d in ipairs(data) do
        if #d.hidden > 0 and #d.hidden == d.eVal and d.eVal > 0 then
            for _, n in ipairs(d.hidden) do
                mineTiles[n] = true
                foundAnything = true
            end
        end
    end
    
    -- Advanced subset detection (tetap dijalankan tapi tidak prioritas)
    if not foundAnything then
        for i = 1, #data do
            for j = 1, #data do
                if i ~= j then
                    local d1, d2 = data[i], data[j]
                    if (d1.obj.Position - d2.obj.Position).Magnitude < 12 then
                        local s1, s2 = d1.hidden, d2.hidden
                        
                        -- Check subset
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
                                    safeTiles[n] = true
                                    foundAnything = true
                                end
                            elseif diffMines == #diffCells then
                                for _, n in ipairs(diffCells) do
                                    mineTiles[n] = true
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
    for tile, _ in pairs(mineTiles) do
        if tile and tile:IsA("BasePart") then
            tile.Color = Color3.new(0, 0, 0)
        end
    end
    
    -- Auto Flag - lebih cepat
    if Config.AutoFlag then
        for tile, _ in pairs(mineTiles) do
            if not stopExecution then
                task.spawn(function()
                    flagTile(tile)
                end)
            end
        end
    end
    
    -- Teleport ke safe tiles - PRIORITAS UTAMA
    local teleported = false
    for tile, _ in pairs(safeTiles) do
        if stopExecution or not Config.AutoSolver then break end
        if tile and tile:IsA("BasePart") and not isCellOpen(tile) then
            -- Verifikasi cepat sebelum teleport
            if isTileSafe(tile, data) then
                teleportTo(tile)
                teleported = true
            end
        end
    end
    
    -- Auto Guess - hanya jika tidak ada safe tiles dan AutoGuess aktif
    if not teleported and Config.AutoGuess and not foundAnything and tick() - lastActionTime > 0.5 then
        local candidates = {}
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n and n:IsA("BasePart") and n.Color ~= Color3.new(0, 0, 0) then
                    candidates[n] = (candidates[n] or 0) + 1
                end
            end
        end
        
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

-- Auto Solver Loop - EXTRA FAST
local function autoSolverLoop()
    while Config.AutoSolver do
        -- Loop sangat cepat
        task.wait(0.0005) -- 2x lebih cepat dari sebelumnya
        
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
    lastData = {}
    if characterFrozen then freezeCharacter(false) end
    
    task.wait(1)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    lastData = {}
    
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
              Content = "Solver Enabled - Ultra Fast",
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
   Content = "0.05 = Fast | 0.1 = Balanced | 0.2 = Slow"
})

local SpeedInput = SettingsTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.05",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.TeleportSpeed = math.max(0.01, math.min(0.5, num))
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
MainTab:CreateSection("Ultra Fast Detection")

MainTab:CreateParagraph({
   Title = "Optimizations",
   Content = "• Update: 0.0005s (2x faster)\n• Priority: eVal=0 tiles first\n• Pre-teleport verification\n• Optimized neighbor cache\n• Teleport speed: 0.05s default"
})

-- Set default values
task.spawn(function()
    task.wait(1)
    pcall(function()
        if SpeedInput and SpeedInput.Set then
            SpeedInput:Set("0.05")
        end
        if FlagRangeInput and FlagRangeInput.Set then
            FlagRangeInput:Set("25")
        end
    end)
end)

-- Success Notification
Rayfield:Notify({
   Title = "Solver Loaded",
   Content = "Ultra Fast Mode - 0.0005s Update",
   Duration = 3,
   Image = 4483362458,
})
