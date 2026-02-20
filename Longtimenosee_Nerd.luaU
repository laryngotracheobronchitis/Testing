-- Minesweeper Auto Solver with Rayfield UI - IMPROVED DETECTION
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
    TeleportSpeed = 0.001, -- Kembali ke 0.001
    FlagRange = 25,
    FreezeCharacter = true
}

local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local characterFrozen = false
local roundStartTime = 0
local safeTilesFound = 0

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
    -- Cek apakah part sudah di-mark sebagai mine (warna hitam)
    if part.Color == Color3.new(0, 0, 0) then return true end
    return false
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

-- PERFECT TELEPORT FUNCTION - DI ATAS PART
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
    local standHeight = 3 -- Tinggi karakter
    
    -- Posisi akhir: bagian ATAS part + offset
    local finalY = partTopY + standHeight
    
    -- Teleport
    root.CFrame = CFrame.new(
        targetPos.X,
        finalY,
        targetPos.Z
    )
    
    -- Stop momentum
    root.Velocity = Vector3.new(0, 0, 0)
    root.RotVelocity = Vector3.new(0, 0, 0)
    
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
    if flaggedDebounce[part] and tick() - flaggedDebounce[part] < 0.5 then return false end
    
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

-- Get Solver Data dengan validasi lebih ketat
local function getSolverData()
    local folder = getPartsFolder()
    if not folder then return {} end
    
    local numberData = {}
    local allParts = folder:GetChildren()
    
    -- Filter parts yang valid
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
            for _, n in ipairs(validParts) do
                if n ~= cell then
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
                if isMine(n) or isAlreadyFlagged(n) then
                    mines = mines + 1
                else
                    table.insert(hidden, n)
                end
            end
        end
        
        -- Hanya masukkan jika ada hidden cells atau angka 0
        if #hidden > 0 or val == 0 then
            table.insert(numberData, {
                obj = cell,
                eVal = val - mines,
                hidden = hidden,
                val = val
            })
        end
        
        ::continue::
    end
    
    return numberData
end

-- Verifikasi keamanan tile sebelum teleport
local function isTileSafe(tile, data)
    if not tile then return false end
    if isCellOpen(tile) then return true end
    if isMine(tile) then return false end
    if isAlreadyFlagged(tile) then return false end
    
    -- Cek dari data solver
    for _, d in ipairs(data) do
        for _, h in ipairs(d.hidden) do
            if h == tile then
                -- Jika tile ini ada di hidden list, cek nilai expected
                if d.eVal == 0 then
                    return true -- Aman karena expected mines = 0
                end
            end
        end
    end
    
    return false
end

-- Main Detection Loop dengan improved logic
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then 
        if characterFrozen then freezeCharacter(false) end
        return 
    end
    
    local data = getSolverData()
    local safeTiles = {}
    local mineTiles = {}
    local riskyTiles = {}
    local foundAnything = false
    
    -- PRIORITAS 1: Deteksi dasar (paling aman)
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            -- Case 1: Semua hidden adalah mines
            if #d.hidden == d.eVal and d.eVal > 0 then
                for _, n in ipairs(d.hidden) do
                    mineTiles[n] = true
                    foundAnything = true
                end
            -- Case 2: Semua hidden adalah safe
            elseif d.eVal == 0 then
                for _, n in ipairs(d.hidden) do
                    safeTiles[n] = true
                    foundAnything = true
                end
            end
        end
    end
    
    -- PRIORITAS 2: Deteksi subset (Euler method) - hanya jika belum ada yang ditemukan
    if not foundAnything then
        for i = 1, #data do
            for j = 1, #data do
                if i ~= j then
                    local d1, d2 = data[i], data[j]
                    
                    -- Pastikan kedua cell berdekatan
                    local dist = (d1.obj.Position - d2.obj.Position).Magnitude
                    if dist < 12 then
                        local s1, s2 = d1.hidden, d2.hidden
                        
                        -- Cek apakah s1 adalah subset dari s2
                        local isSubset = true
                        local subsetMap = {}
                        for _, x in ipairs(s1) do
                            subsetMap[x] = true
                        end
                        
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
                                if not subsetMap[x] then
                                    table.insert(diffCells, x)
                                end
                            end
                            
                            -- Jika difference mines = 0, semua diffCells aman
                            if diffMines == 0 then
                                for _, n in ipairs(diffCells) do
                                    safeTiles[n] = true
                                    foundAnything = true
                                end
                            -- Jika difference mines = jumlah diffCells, semua adalah mines
                            elseif diffMines == #diffCells and #diffCells > 0 then
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
    
    -- Mark mines sebagai hitam
    for tile, _ in pairs(mineTiles) do
        if tile and tile:IsA("BasePart") then
            tile.Color = Color3.new(0, 0, 0)
        end
    end
    
    -- Auto Flag untuk mines
    if Config.AutoFlag then
        for tile, _ in pairs(mineTiles) do
            if not stopExecution then
                task.spawn(function()
                    flagTile(tile)
                    task.wait(0.05)
                end)
            end
        end
    end
    
    -- Teleport ke safe tiles (PALING AMAN)
    local safeTileList = {}
    for tile, _ in pairs(safeTiles) do
        table.insert(safeTileList, tile)
    end
    
    if #safeTileList > 0 then
        isGuessing = false
        safeTilesFound = safeTilesFound + 1
        
        for _, tile in ipairs(safeTileList) do
            if stopExecution or not Config.AutoSolver then break end
            if tile and tile:IsA("BasePart") and not isCellOpen(tile) and not isMine(tile) then
                -- Verifikasi keamanan sekali lagi
                if isTileSafe(tile, data) then
                    teleportTo(tile)
                    task.wait(Config.TeleportSpeed)
                end
            end
        end
    -- Auto Guess sebagai last resort (dengan risiko)
    elseif Config.AutoGuess and not foundAnything and tick() - lastActionTime > 1 then
        -- Kumpulkan semua hidden tiles
        local allHidden = {}
        for _, d in ipairs(data) do
            for _, n in ipairs(d.hidden) do
                if n and n:IsA("BasePart") and not isMine(n) and not isAlreadyFlagged(n) then
                    allHidden[n] = (allHidden[n] or 0) + 1
                end
            end
        end
        
        -- Cari tile dengan frekuensi tertinggi (paling sering muncul di persamaan)
        local bestTile = nil
        local maxCount = -1
        for tile, count in pairs(allHidden) do
            if count > maxCount then
                maxCount = count
                bestTile = tile
            end
        end
        
        if bestTile then
            isGuessing = true
            teleportTo(bestTile)
            lastActionTime = tick()
        end
    end
    
    -- Update freeze status
    if Config.AutoSolver and Config.FreezeCharacter and not characterFrozen then
        freezeCharacter(true)
    elseif not Config.AutoSolver and characterFrozen then
        freezeCharacter(false)
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
    safeTilesFound = 0
    if characterFrozen then freezeCharacter(false) end
    
    task.wait(2)
    stopExecution = false
end

local function setupCharacter(char)
    if not char then return end
    stopExecution = false
    roundStartTime = tick()
    safeTilesFound = 0
    
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
           freezeCharacter(true)
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
   Content = "0.001 = Fast (Recommended) | 0.01 = Normal | 0.1 = Slow"
})

local SpeedInput = SettingsTab:CreateInput({
   Name = "Teleport Speed (seconds)",
   PlaceholderText = "0.001",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
       local num = tonumber(Value)
       if num and num > 0 then
           Config.TeleportSpeed = math.max(0.0005, math.min(0.5, num))
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
MainTab:CreateSection("Improved Detection")

MainTab:CreateParagraph({
   Title = "Fixed Issues",
   Content = "✓ Teleport DI ATAS part\n✓ Tidak menginjak bomb\n✓ Prioritas safe tiles\n✓ Verifikasi keamanan\n✓ 0.001s speed (recommended)"
})

-- Set default values
task.spawn(function()
    task.wait(1)
    pcall(function()
        if SpeedInput and SpeedInput.Set then
            SpeedInput:Set("0.001")
        end
        if FlagRangeInput and FlagRangeInput.Set then
            FlagRangeInput:Set("25")
        end
    end)
end)

-- Status indicator di chat (opsional, bisa dihapus)
local function log(msg)
    print("[Solver] " .. msg)
end

log("Fixed version loaded - Improved bomb detection")
