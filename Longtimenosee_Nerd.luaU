-- Minesweeper Auto Solver with Rayfield UI - COMPLETE EDITION
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
    FreezeEnabled = false, -- Dimatikan default
    
    -- Legit/Visual Mode
    VisualEnabled = false,
    VisualRange = 100,
    VisualUpdateSpeed = 0.2,
    ShowMines = true,
    ShowSafe = true,
    ShowNumbers = true,
    FlagEnabled = false,
    FlagSpeed = 0.05
}

-- State variables
local neighborCache = {}
local flaggedDebounce = {}
local stopExecution = false
local isGuessing = false
local lastActionTime = 0
local Controls = nil

-- Sweep.lua style variables
local visualState = { b = false, c = 0 }
local visualCache = {}
local lastSeenRun = setmetatable({}, { __mode = "k" })
local updateThrottle = 0
local THROTTLE_INTERVAL = 0.05
local guiCache = {}
local A4 = {} -- Part cache

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

-- Get Parts Folder
local function getPartsFolder()
    local w = workspace
    local d = w:FindFirstChild("Flag")
    if d then
        local u = d:FindFirstChild("Parts")
        if u and u:IsA("Folder") then return u end
    end
    local p = w:FindFirstChild("Parts", true)
    if p and p:IsA("Folder") then return p end
    
    -- Search for folder with most parts
    local best, bestCount = nil, -1
    for _, i in ipairs(w:GetDescendants()) do
        if i:IsA("Folder") and i.Name == "Parts" then
            local count = 0
            for _, ch in ipairs(i:GetChildren()) do
                if ch:IsA("BasePart") then count = count + 1 end
            end
            if count > bestCount then
                best, bestCount = i, count
            end
        end
    end
    return best
end

-- Freeze Function (dimatikan default)
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
            pcall(function() Controls:Disable() end)
        else 
            pcall(function() Controls:Enable() end)
        end
    end
end

-- PERFECT TELEPORT FUNCTION - DI ATAS PART
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
    local standHeight = 3 -- Tinggi karakter
    
    -- Posisi akhir: bagian ATAS part + offset
    local finalY = partTopY + standHeight
    
    -- Teleport
    root.CFrame = CFrame.new(
        targetPos.X,
        finalY,
        targetPos.Z
    )
    
    -- Reset velocity
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

-- Flag Function
local function flagTile(part)
    if not part or not part.Parent or isAlreadyFlagged(part) then return false end
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
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

-- Get Solver Data untuk Rage Mode
local function getSolverData()
    local folder = getPartsFolder()
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

-- ================ VISUAL SYSTEM (Sweep.lua Style) ================

local function getPartDebugId(p0) 
    return tostring(p0:GetDebugId()) 
end

local function getNumberFromText(sv)
    if type(sv) ~= "string" then return nil end
    local d = sv:match("(%d)")
    return d and tonumber(d) or nil
end

local function clampValue(a2) 
    a2 = tonumber(a2) or 0 
    if a2 < 0 then return 0 
    elseif a2 > 1 then return 1 
    else return a2 end 
end

local function getColorFromProbability(pv) 
    pv = clampValue(pv) 
    if pv <= 0.5 then 
        local q0 = pv / 0.5 
        return Color3.fromRGB(math.floor(250 * q0 + 0.5), 250, 0) 
    else 
        local q0 = (pv - 0.5) / 0.5 
        return Color3.fromRGB(255, math.floor(250 * (1 - q0) + 0.5), 0) 
    end 
end

local function getNeighbors(r0, c0, Hn, Wn)
    local result = {}
    for dr = -1, 1 do
        for dc = -1, 1 do
            if not (dr == 0 and dc == 0) then
                local rr, cc = r0 + dr, c0 + dc
                if rr >= 1 and rr <= Hn and cc >= 1 and cc <= Wn then
                    table.insert(result, { rr, cc })
                end
            end
        end
    end
    return result
end

local function gridIndex(vDelta, cell, tol)
    tol = math.clamp(tol or .25, 0, .49)
    local raw = vDelta / cell
    local idx = math.floor(raw + 0.5)
    if math.abs(raw - idx) > 0.5 + tol then
        idx = idx + (raw > idx and 1 or -1)
    end
    return idx
end

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

local function createOrGetSurfaceGui(folder, part, timestamp)
    if not (part and part:IsA("BasePart")) then return nil end
    
    local partId = getPartDebugId(part)
    local gui = guiCache[partId]
    
    if not gui or not gui.Parent then
        gui = folder:FindFirstChild(partId)
        if not gui then
            gui = Instance.new("SurfaceGui")
            gui.Name = partId
            gui.AlwaysOnTop = true
            gui.LightInfluence = 0
            gui.Face = Enum.NormalId.Top
            gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
            gui.PixelsPerStud = 25
            gui.Parent = folder
            gui.Adornee = part
        end
        guiCache[partId] = gui
    end
    
    if gui.Adornee ~= part then gui.Adornee = part end
    if gui.Face ~= Enum.NormalId.Top then gui.Face = Enum.NormalId.Top end
    lastSeenRun[gui] = timestamp
    
    -- Create or get text label
    local label = gui:FindFirstChild("ValueText")
    if not label or not label:IsA("TextLabel") then
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        label = Instance.new("TextLabel")
        label.Name = "ValueText"
        label.Size = UDim2.fromScale(1, 1)
        label.Position = UDim2.fromScale(0, 0)
        label.BackgroundTransparency = 1
        label.TextSize = 60
        label.TextWrapped = false
        label.Font = Enum.Font.Arcade
        label.Text = ""
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = gui
    end
    
    gui.Enabled = true
    label.Visible = true
    
    return gui, label
end

-- Visual Update Function (Sweep.lua algorithm)
local function updateVisuals()
    if not Config.VisualEnabled then return end
    
    local currentTime = tick()
    if currentTime - updateThrottle < Config.VisualUpdateSpeed then
        return
    end
    updateThrottle = currentTime
    
    local partsFolder = getPartsFolder()
    if not partsFolder then return end
    
    local character = player.Character
    local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
    
    -- Filter parts by range
    local rangeSquared = Config.VisualRange * Config.VisualRange
    local allParts = partsFolder:GetChildren()
    local visibleParts = {}
    
    -- Update part cache
    for _, part in ipairs(allParts) do
        if part:IsA("BasePart") and part.Anchored ~= false then
            -- Check range
            if root then
                local dist = (part.Position - root.Position).MagnitudeSquared
                if dist > rangeSquared then
                    -- Hide if out of range
                    local partId = getPartDebugId(part)
                    local gui = guiCache[partId]
                    if gui and gui.Parent then
                        gui.Enabled = false
                    end
                    goto continue
                end
            end
            
            -- Get or create cache entry
            local partId = getPartDebugId(part)
            local cache = A4[partId]
            if not cache then
                local numberGui = part:FindFirstChild("NumberGui", true)
                local textLabel = numberGui and (numberGui:FindFirstChildWhichIsA("TextLabel") or numberGui:FindFirstChild("TextLabel"))
                local isFlagged = part:FindFirstChild("Flag") or part:FindFirstChild("Flagged") or part:GetAttribute("Flagged")
                
                cache = {
                    a = part,
                    b = part.Position,
                    c = part.Size,
                    d = (textLabel and textLabel:IsA("TextLabel")) and textLabel or nil,
                    e = (isFlagged ~= nil and isFlagged ~= false),
                    f = currentTime
                }
                A4[partId] = cache
            else
                cache.b = part.Position
                cache.c = part.Size
                cache.f = currentTime
                
                -- Check flagged status
                local isFlagged = part:FindFirstChild("Flag") or part:FindFirstChild("Flagged") or part:GetAttribute("Flagged")
                cache.e = (isFlagged ~= nil and isFlagged ~= false)
                
                -- Try to get text label if missing
                if not cache.d then
                    local numberGui = part:FindFirstChild("NumberGui", true)
                    local textLabel = numberGui and (numberGui:FindFirstChildWhichIsA("TextLabel") or numberGui:FindFirstChild("TextLabel"))
                    if textLabel and textLabel:IsA("TextLabel") then
                        cache.d = textLabel
                    end
                end
            end
            
            table.insert(visibleParts, cache)
            ::continue::
        end
    end
    
    if #visibleParts == 0 then return end
    
    -- Find reference part for grid alignment
    local refPart = nil
    local minDist = math.huge
    for _, cache in ipairs(visibleParts) do
        if cache.d and root then
            local dist = (cache.b - root.Position).MagnitudeSquared
            if dist < minDist then
                minDist = dist
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
    
    -- Grid parameters
    local cellSize = math.min(refPart.c.X, refPart.c.Z)
    local grid = {}
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    
    -- Map parts to grid
    for _, cache in ipairs(visibleParts) do
        local gx = gridIndex(cache.b.X - refPart.b.X, cellSize, 0.25)
        local gz = gridIndex(cache.b.Z - refPart.b.Z, cellSize, 0.25)
        
        if gx < minX then minX = gx end
        if gx > maxX then maxX = gx end
        if gz < minZ then minZ = gz end
        if gz > maxZ then maxZ = gz end
        
        local key = tostring(gx) .. ":" .. tostring(gz)
        if not grid[key] or (cache.c.X * cache.c.Z) > (grid[key].c.X * grid[key].c.Z) then
            grid[key] = cache
        end
    end
    
    minX, maxX, minZ, maxZ = minX - 1, maxX + 1, minZ - 1, maxZ + 1
    local offX, offZ = minX - 1, minZ - 1
    local width = maxX - minX + 1
    local height = maxZ - minZ + 1
    
    if width <= 0 or height <= 0 then return end
    
    -- Create grid representation
    local board = {}
    for z = 1, height do
        board[z] = {}
        for x = 1, width do
            board[z][x] = { state = "covered", value = nil, cache = nil }
        end
    end
    
    -- Mark revealed cells
    for _, cache in ipairs(visibleParts) do
        if cache.d then
            local gx = gridIndex(cache.b.X - refPart.b.X, cellSize, 0.25)
            local gz = gridIndex(cache.b.Z - refPart.b.Z, cellSize, 0.25)
            local x = gx - offX
            local z = gz - offZ
            
            if x >= 1 and x <= width and z >= 1 and z <= height then
                local num = getNumberFromText(cache.d.Text) or tonumber(cache.d.Text) or 0
                board[z][x].state = "revealed"
                board[z][x].value = num
                board[z][x].cache = cache
            end
        end
    end
    
    -- Mark flagged cells
    for gx = minX, maxX do
        for gz = minZ, maxZ do
            local cache = grid[tostring(gx) .. ":" .. tostring(gz)]
            if cache then
                local x = gx - offX
                local z = gz - offZ
                if x >= 1 and x <= width and z >= 1 and z <= height then
                    if board[z][x].state ~= "revealed" then
                        board[z][x].cache = cache
                        if cache.e then
                            board[z][x].state = "flagged"
                        end
                    end
                end
            end
        end
    end
    
    -- Simple detection for visual mode (just show numbers/probabilities)
    local visualFolder = getVisualFolder()
    local timestamp = tick()
    local updates = {}
    
    for z = 1, height do
        for x = 1, width do
            local cell = board[z][x]
            local part = cell.cache and cell.cache.a
            
            if part and part:IsA("BasePart") then
                local text = ""
                local color = nil
                
                if cell.state == "flagged" and Config.ShowMines then
                    text = "💣" -- Bomb
                elseif cell.state == "revealed" and Config.ShowNumbers then
                    text = tostring(cell.value or "?")
                elseif cell.state == "covered" and Config.ShowSafe then
                    -- Simple heuristic: if adjacent to revealed with no mines, show as safe
                    local isLikelySafe = false
                    for _, neighbor in ipairs(getNeighbors(z, x, height, width)) do
                        local nz, nx = neighbor[1], neighbor[2]
                        if board[nz][nx].state == "revealed" and board[nz][nx].value == 0 then
                            isLikelySafe = true
                            break
                        end
                    end
                    
                    if isLikelySafe then
                        text = "✓"
                        color = Color3.fromRGB(0, 255, 0)
                    end
                end
                
                if text ~= "" then
                    table.insert(updates, { part = part, text = text, color = color })
                else
                    -- Hide if no visual needed
                    local partId = getPartDebugId(part)
                    local gui = guiCache[partId]
                    if gui and gui.Parent then
                        gui.Enabled = false
                    end
                end
            end
        end
    end
    
    -- Apply updates
    for _, update in ipairs(updates) do
        local gui, label = createOrGetSurfaceGui(visualFolder, update.part, timestamp)
        if gui and label then
            if label.Text ~= update.text then
                label.Text = update.text
                if update.color then
                    label.TextColor3 = update.color
                else
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
    
    -- Clean up old GUIs
    for _, gui in ipairs(visualFolder:GetChildren()) do
        local lastSeen = lastSeenRun[gui]
        local alive = gui.Adornee and gui.Adornee.Parent
        if (lastSeen ~= timestamp) or not alive then
            guiCache[gui.Name] = nil
            gui:Destroy()
        end
    end
    
    -- Clean old part cache
    local now = tick()
    for id, cache in pairs(A4) do
        if (now - (cache.f or 0)) > 10 then
            A4[id] = nil
        end
    end
end

-- Auto Flag dari visual mode
local function autoFlagFromVisual()
    if not Config.VisualEnabled or not Config.FlagEnabled then return end
    
    local partsFolder = getPartsFolder()
    if not partsFolder then return end
    
    local character = player.Character
    local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
    if not root then return end
    
    local rangeSquared = Config.VisualRange * Config.VisualRange
    
    for _, part in ipairs(partsFolder:GetChildren()) do
        if part:IsA("BasePart") then
            -- Check range
            local dist = (part.Position - root.Position).MagnitudeSquared
            if dist <= rangeSquared then
                -- Check if it has bomb visual (💣)
                local partId = getPartDebugId(part)
                local gui = guiCache[partId]
                if gui and gui.Enabled then
                    local label = gui:FindFirstChild("ValueText")
                    if label and label:IsA("TextLabel") and label.Text == "💣" then
                        -- This is a bomb, flag it
                        if not isAlreadyFlagged(part) then
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
end

-- Visual loop
local function visualLoop()
    while Config.VisualEnabled do
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
    A4 = {}
end

-- ================ RAGE MODE FUNCTIONS ================

-- Main Detection Loop untuk Rage Mode
local function mainLoop()
    if stopExecution then return end
    if not Config.AutoSolver then 
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
end

-- Auto Solver Loop
local function autoSolverLoop()
    while Config.AutoSolver do
        task.wait(Config.TeleportSpeed)
        
        if not Config.AutoSolver then 
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

-- ================ UI CREATION ================

-- Create Tabs
local RageTab = Window:CreateTab("Rage Mode", 4483362458)
local LegitTab = Window:CreateTab("Legit Visuals", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

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

-- Freeze Toggle (off by default)
local FreezeToggle = RageTab:CreateToggle({
   Name = "Freeze Character (Optional)",
   CurrentValue = false,
   Flag = "FreezeEnabled",
   Callback = function(Value)
       Config.FreezeEnabled = Value
       updatePhysics()
   end,
})

RageTab:CreateParagraph({
   Title = "Info",
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
           task.spawn(visualLoop)
       else
           -- Clean up visuals
           local folder = getVisualFolder()
           for _, gui in ipairs(folder:GetChildren()) do
               gui:Destroy()
           end
           guiCache = {}
           A4 = {}
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

LegitTab:CreateSection("Auto Flag (Visual)")

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
   Content = "💣 = Mine Detected\n✓ = Safe (adjacent to 0)\nNumbers = Revealed tiles\nColors = Probability (Sweep style)"
})

-- ================ SETTINGS TAB ================

SettingsTab:CreateSection("Global Settings")

-- Flag Range Input
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

SettingsTab:CreateParagraph({
   Title = "About",
   Content = "Rage Mode: Auto solver with teleport\nLegit Mode: Visual indicators only\nCombined from shiziks + Sweep.lua"
})

-- Set default values for inputs
task.spawn(function()
    task.wait(1)
    -- Set default values in inputs
    pcall(function()
        TeleportSpeedInput:Set("0.0001")
        VisualRangeInput:Set("100")
        UpdateSpeedInput:Set("0.2")
        FlagSpeedInput:Set("0.05")
        FlagRangeInput:Set("25")
    end)
end)
