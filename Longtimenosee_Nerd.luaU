-- Minesweeper Auto Solver with Rayfield UI - ACCURATE DETECTION
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
local solvedTiles = {} -- Track tiles yang sudah diproses

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
    
    local success, flagged = pcall(function()
        return part:GetAttribute("Flagged")
    end)
    if success and flagged then return true end
    
    return false
end

local function isMine(part)
    if not part then return false end
    return part.Color == Color3.new(0, 0, 0) or isAlreadyFlagged(part)
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

-- FIXED Teleport Function - Berdiri DI ATAS part
local function teleportTo(target)
    if stopExecution or not target or not target.Parent or isCellOpen(target) then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Freeze if enabled
    if Config.FreezeCharacter and not characterFrozen then
        freezeCharacter(true)
    end
    
    -- Hitung posisi di ATAS part
    local targetPos = target.Position
    local partHeight = target.Size.Y or 1
    
    -- Bagian ATAS part
    local partTopY = targetPos.Y + (partHeight / 2)
    local standHeight = 3.1
    
    -- Teleport dengan CFrame baru
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
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 0.5 then return false end
    
    local success = pcall(function()
        local cd = part:FindFirstChildOfClass("ClickDetector", true)
        if cd then
            fireclickdetector(cd)
            flaggedDebounce[part] = tick()
            return true
        end
        
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

-- Get Solver Data dengan validasi lengkap
local function getSolverData()
    local folder = getPartsFolder()
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    
    -- Filter part yang valid
    local validParts = {}
    for _, cell in ipairs(allParts) do
        if cell:IsA("BasePart") then
            table.insert(validParts, cell)
        end
    end
    
    for _, cell in ipairs(validParts) do
        if not isCellOpen(cell) then goto continue end
        
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
            local cellPos = cell.Position
            local cellSize = cell.Size.X * 1.8
            
            for _, n in ipairs(validParts) do
                if n ~= cell then
                    if (n.Position - cellPos).Magnitude < cellSize then
                        table.insert(nbs, n)
                    end
                end
            end
            neighborCache[cell] = nbs
        end
        
        -- Hitung hidden dan mines
        local hidden = {}
        local mines = 0
        local flagged = 0
        
        for _, n in ipairs(neighborCache[cell]) do
            if not isCellOpen(n) then
                if isMine(n) then
                    mines = mines + 1
                elseif isAlreadyFlagged(n) then
                    flagged = flagged + 1
                else
                    table.insert(hidden, n)
                end
            end
        end
        
        -- Tambah flagged ke mines count
        mines = mines + flagged
        
        -- Hanya masukkan jika ada hidden cells
        if #hidden > 0 then
            table.insert(numberData, {
                obj = cell,
                val = val,
                eVal = val - mines,  -- Expected mines di hidden
                hidden = hidden,
                mines = mines,
                totalHidden = #hidden
            })
        end
        
        ::continue::
    end
    
    return numberData
end

-- Verifikasi tile aman dengan multiple checks
local function isTileAbsolutelySafe(tile, data)
    if not tile then return false end
    if isCellOpen(tile) then return true end
    if isMine(tile) then return false end
    
    -- Cek di semua data
    for _, d in ipairs(data) do
        for _, h in ipairs(d.hidden) do
            if h == tile then
                -- Jika tile ini ada di hidden, cek expected value
                if d.eVal == 0 then
                    return true -- 100% aman
                elseif d.eVal == d.totalHidden then
                    return false -- 100% mine
                end
            end
        end
    end
    
    return false
end

-- Deteksi tile yang 100% aman
local function findSafeTiles(data)
    local safeTiles = {}
    
    -- Metode 1: eVal = 0 (semua hidden aman)
    for _, d in ipairs(data) do
        if d.eVal == 0 then
            for _, tile in ipairs(d.hidden) do
                safeTiles[tile] = true
            end
        end
    end
    
    -- Metode 2: Subset detection
    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1, d2 = data[i], data[j]
                
                -- Cek apakah d1.hidden subset dari d2.hidden
                local isSubset = true
                local subsetMap = {}
                
                for _, tile in ipairs(d1.hidden) do
                    subsetMap[tile] = true
                end
                
                for _, tile in ipairs(d1.hidden) do
                    local found = false
                    for _, tile2 in ipairs(d2.hidden) do
                        if tile == tile2 then
                            found = true
                            break
                        end
                    end
                    if not found then
                        isSubset = false
                        break
                    end
                end
                
                if isSubset and #d2.hidden > #d1.hidden then
                    local diffMines = d2.eVal - d1.eVal
                    local diffTiles = {}
                    
                    for _, tile in ipairs(d2.hidden) do
                        if not subsetMap[tile] then
                            table.insert(diffTiles, tile)
                        end
                    end
                    
                    -- Jika selisih mines = 0, semua diffTiles aman
                    if diffMines == 0 then
                        for _, tile in ipairs(diffTiles) do
                            safeTiles[tile] = true
                        end
                    end
                end
            end
        end
    end
    
    return safeTiles
end

-- Deteksi tile yang 100% mine
local function findMineTiles(data)
    local mineTiles = {}
    
    -- Metode 1: #hidden == eVal (semua hidden adalah mine)
    for _, d in ipairs(data) do
        if #d.hidden == d.eVal and d.eVal > 0 then
            for _, tile in ipairs(d.hidden) do
                mineTiles[tile] = true
            end
        end
    end
    
    -- Metode 2: Subset detection untuk mine
    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1, d2 = data[i], data[j]
                
                local isSubset = true
                local subsetMap = {}
                
                for _, tile in ipairs(d1.hidden) do
                    subsetMap[tile] = true
                end
                
                for _, tile in ipairs(d1.hidden) do
                    local found = false
                    for _, tile2 in ipairs(d2.hidden) do
                        if tile == tile2 then
                            found = true
                            break
                        end
                    end
                    if not found then
                        isSubset = false
                        break
                    end
                end
                
                if isSubset and #d2.hidden > #d1.hidden then
                    local diffMines = d2.eVal - d1.eVal
                    local diffTiles = {}
                    
                    for _, tile in ipairs(d2.hidden) do
                        if not subsetMap[tile] then
                            table.insert(diffTiles, tile)
                        end
                    end
                    
                    -- Jika selisih mines = jumlah diffTiles, semua adalah mine
                    if diffMines == #diffTiles and #diffTiles > 0 then
                        for _, tile in ipairs(diffTiles) do
                            mineTiles[tile] = true
                        end
                    end
                end
            end
        end
    end
    
    return mineTiles
end

-- Main Detection Loop
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then 
        if characterFrozen then freezeCharacter(false) end
        return 
    end
    
    -- Ambil data terbaru
    local data = getSolverData()
    if #data == 0 then return end
    
    -- Deteksi tile aman dan mine
    local safeTiles = findSafeTiles(data)
    local mineTiles = findMineTiles(data)
    
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
    local hasTeleported = false
    for tile, _ in pairs(safeTiles) do
        if stopExecution or not Config.AutoSolver then break end
        if tile and tile:IsA("BasePart") and not isCellOpen(tile) then
            -- Verifikasi sekali lagi
            if isTileAbsolutelySafe(tile, data) then
                teleportTo(tile)
                hasTeleported = true
                solvedTiles[tile] = true
            end
        end
    end
    
    -- Auto Guess (hanya jika tidak ada safe tiles dan AutoGuess aktif)
    if not hasTeleported and Config.AutoGuess and tick() - lastActionTime > 1 then
        -- Kumpulkan kandidat (hidden tiles yang belum di-solve)
        local candidates = {}
        for _, d in ipairs(data) do
            for _, tile in ipairs(d.hidden) do
                if tile and tile:IsA("BasePart") and not isMine(tile) and not solvedTiles[tile] then
                    candidates[tile] = (candidates[tile] or 0) + 1
                end
            end
        end
        
        -- Cari tile dengan frekuensi tertinggi (paling aman untuk ditebak)
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
    
    -- Bersihkan solvedTiles jika terlalu besar
    if #solvedTiles > 100 then
        solvedTiles = {}
    end
end

-- Auto Solver Loop
local function autoSolverLoop()
    while Config.AutoSolver do
        task.wait(0.001) -- Update sangat cepat
        
        if not Config.AutoSolver then 
            if characterFrozen then freezeCharacter(false) end
            break 
        end
        
        local success, err = pcall(mainLoop)
        if not success then
            warn("Error in mainLoop:", err)
        end
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
    solvedTiles = {}
    if characterFrozen then freezeCharacter(false) end
    
    task.wait(1)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    solvedTiles = {}
    
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
              Content = "Solver Enabled - Accurate Detection",
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
   Content = "0.1 = Balanced | 0.05 = Fast | 0.01 = Very Fast"
})

local SpeedInput = SettingsTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.1",
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
MainTab:CreateSection("Accurate Detection")

MainTab:CreateParagraph({
   Title = "Improved Algorithm",
   Content = "✓ Multi-layer verification\n✓ Subset detection (Euler)\n✓ 100% safe tile priority\n✓ Mine marking\n✓ Solved tile tracking\n✓ Update 0.001s"
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
   Content = "Accurate Detection - Multi-layer verification",
   Duration = 3,
   Image = 4483362458,
})
