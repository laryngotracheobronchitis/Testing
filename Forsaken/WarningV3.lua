-- ========================================
-- ATTACK WARNING SYSTEM - FULL FEATURES
-- Ukuran Normal | Warning Fix | Banyak Fitur
-- ========================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ========================================
-- AUTO BLOCK TRIGGER SOUNDS (LENGKAP)
-- ========================================
local autoBlockTriggerSounds = {
    ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true, ["136323728355613"] = true,
    ["115026634746636"] = true, ["84116622032112"] = true, ["108907358619313"] = true, ["127793641088496"] = true,
    ["86174610237192"] = true, ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,
    ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true, ["75330693422988"] = true,
    ["82221759983649"] = true, ["109348678063422"] = true, ["81702359653578"] = true, ["85853080745515"] = true,
    ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["12222216"] = true,
    ["79980897195554"] = true, ["119583605486352"] = true, ["71834552297085"] = true, ["116581754553533"] = true,
    ["86833981571073"] = true, ["110372418055226"] = true, ["105840448036441"] = true, ["86494585504534"] = true,
    ["80516583309685"] = true, ["131406927389838"] = true, ["89004992452376"] = true, ["117231507259853"] = true,
    ["101698569375359"] = true, ["101553872555606"] = true, ["140412278320643"] = true, ["106300477136129"] = true,
    ["117173212095661"] = true, ["104910828105172"] = true, ["140194172008986"] = true, ["85544168523099"] = true,
    ["114506382930939"] = true, ["99829427721752"] = true, ["120059928759346"] = true, ["104625283622511"] = true,
    ["105316545074913"] = true, ["126131675979001"] = true, ["82336352305186"] = true, ["93366464803829"] = true,
    ["84069821282466"] = true, ["128856426573270"] = true, ["121954639447247"] = true, ["128195973631079"] = true,
    ["124903763333174"] = true, ["94317217837143"] = true, ["98111231282218"] = true, ["119089145505438"] = true,
    ["136728245733659"] = true, ["71310583817000"] = true, ["107444859834748"] = true, ["76959687420003"] = true,
    ["72425554233832"] = true, ["96594507550917"] = true, ["139996647355899"] = true, ["107345261604889"] = true,
    ["127557531826290"] = true, ["108651070773439"] = true, ["74842815979546"] = true, ["119583605486352"] = true,
    ["115026634746636"] = true, ["124397369810639"] = true, ["76467993976301"] = true, ["118493324723683"] = true,
    ["78298577002481"] = true, ["116527305931161"] = true, ["5148302439"] = true, ["98675142200448"] = true,
    ["128367348686124"] = true, ["71805956520207"] = true, ["125213046326879"] = true,
}

-- ========================================
-- PING COMPENSATION
-- ========================================
local pingCompensation = true
local currentPing = 0

RunService.RenderStepped:Connect(function()
    currentPing = lp:GetNetworkPing() * 1000
end)

local function getWarningAdvanceTime()
    if not pingCompensation then return 0 end
    return currentPing / 1000 * 1.2
end

-- ========================================
-- CONFIGURATION (SEMUA FITUR)
-- ========================================
local soundWarningEnabled = true
local warningSize = 200
local warningDuration = 0.45
local warningColor = Color3.fromRGB(255, 50, 50)

-- TOGGLES (SEMUA FITUR)
local showHint = true
local showPingDisplay = true
local showPingInfo = true
local showCounter = true
local showKillerName = true
local showDistance = true

-- ========================================
-- PING DISPLAY (ATAS - UKURAN NORMAL)
-- ========================================
local pingDisplay = {gui = nil, frame = nil, label = nil}

local function createPingDisplay()
    if pingDisplay.gui then pingDisplay.gui:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "PingDisplay"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999997
    gui.Parent = PlayerGui
    gui.Enabled = showPingDisplay
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 35)
    frame.Position = UDim2.new(0.5, -100, 0, 8)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "📶 Ping: 0ms | +0ms"
    label.TextColor3 = Color3.fromRGB(255, 255, 100)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    pingDisplay.gui = gui
    pingDisplay.frame = frame
    pingDisplay.label = label
    
    RunService.RenderStepped:Connect(function()
        if pingDisplay.label and showPingDisplay then
            pingDisplay.label.Text = string.format("📶 Ping: %dms | +%dms", 
                math.floor(currentPing),
                math.floor(getWarningAdvanceTime() * 1000)
            )
        end
    end)
end

-- ========================================
-- WARNING INDICATOR (UKURAN NORMAL + BANYAK INFO)
-- ========================================
local warningGui = nil
local warningLabel = nil
local hintLabel = nil
local pingInfoLabel = nil
local counterLabel = nil
local killerLabel = nil
local distanceLabel = nil
local detectionCounter = 0

local function createWarningIndicator()
    if warningGui then warningGui:Destroy() end
    
    warningGui = Instance.new("ScreenGui")
    warningGui.Name = "AttackWarning"
    warningGui.ResetOnSpawn = false
    warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    warningGui.DisplayOrder = 999999
    warningGui.Parent = PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 400)
    frame.Position = UDim2.new(0.5, -175, 0.35, -200)
    frame.BackgroundTransparency = 1
    frame.Parent = warningGui
    
    -- Warning "!" BESAR
    warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(1, 0, 0, 250)
    warningLabel.Position = UDim2.new(0, 0, 0, 0)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "!"
    warningLabel.TextColor3 = warningColor
    warningLabel.TextSize = warningSize
    warningLabel.Font = Enum.Font.GothamBlack
    warningLabel.TextStrokeTransparency = 0
    warningLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warningLabel.TextTransparency = 1
    warningLabel.Parent = frame
    
    local yPos = 260
    
    -- HINT
    hintLabel = Instance.new("TextLabel")
    hintLabel.Size = UDim2.new(1, -20, 0, 30)
    hintLabel.Position = UDim2.new(0, 10, 0, yPos)
    hintLabel.BackgroundTransparency = 0.3
    hintLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    hintLabel.BorderSizePixel = 0
    hintLabel.Text = "⚡ KILLER ATTACK DETECTED ⚡"
    hintLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    hintLabel.TextSize = 16
    hintLabel.Font = Enum.Font.GothamBold
    hintLabel.TextTransparency = 1
    hintLabel.Visible = showHint
    hintLabel.Parent = frame
    Instance.new("UICorner", hintLabel).CornerRadius = UDim.new(0, 8)
    
    yPos = yPos + 35
    
    -- COUNTER
    counterLabel = Instance.new("TextLabel")
    counterLabel.Size = UDim2.new(0.45, -5, 0, 30)
    counterLabel.Position = UDim2.new(0, 10, 0, yPos)
    counterLabel.BackgroundTransparency = 0.3
    counterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    counterLabel.BorderSizePixel = 0
    counterLabel.Text = "Detected: 0"
    counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    counterLabel.TextSize = 14
    counterLabel.Font = Enum.Font.GothamBold
    counterLabel.TextTransparency = 1
    counterLabel.Visible = showCounter
    counterLabel.Parent = frame
    Instance.new("UICorner", counterLabel).CornerRadius = UDim.new(0, 8)
    
    -- KILLER NAME
    killerLabel = Instance.new("TextLabel")
    killerLabel.Size = UDim2.new(0.45, -5, 0, 30)
    killerLabel.Position = UDim2.new(0.5, 5, 0, yPos)
    killerLabel.BackgroundTransparency = 0.3
    killerLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    killerLabel.BorderSizePixel = 0
    killerLabel.Text = "Killer: Unknown"
    killerLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
    killerLabel.TextSize = 14
    killerLabel.Font = Enum.Font.GothamBold
    killerLabel.TextTransparency = 1
    killerLabel.Visible = showKillerName
    killerLabel.Parent = frame
    Instance.new("UICorner", killerLabel).CornerRadius = UDim.new(0, 8)
    
    yPos = yPos + 35
    
    -- DISTANCE
    distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(0.45, -5, 0, 30)
    distanceLabel.Position = UDim2.new(0, 10, 0, yPos)
    distanceLabel.BackgroundTransparency = 0.3
    distanceLabel.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
    distanceLabel.BorderSizePixel = 0
    distanceLabel.Text = "Distance: 0 studs"
    distanceLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    distanceLabel.TextSize = 14
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextTransparency = 1
    distanceLabel.Visible = showDistance
    distanceLabel.Parent = frame
    Instance.new("UICorner", distanceLabel).CornerRadius = UDim.new(0, 8)
    
    -- PING INFO
    pingInfoLabel = Instance.new("TextLabel")
    pingInfoLabel.Size = UDim2.new(0.45, -5, 0, 30)
    pingInfoLabel.Position = UDim2.new(0.5, 5, 0, yPos)
    pingInfoLabel.BackgroundTransparency = 0.3
    pingInfoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pingInfoLabel.BorderSizePixel = 0
    pingInfoLabel.Text = "Ping: 0ms"
    pingInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    pingInfoLabel.TextSize = 14
    pingInfoLabel.Font = Enum.Font.GothamBold
    pingInfoLabel.TextTransparency = 1
    pingInfoLabel.Visible = showPingInfo
    pingInfoLabel.Parent = frame
    Instance.new("UICorner", pingInfoLabel).CornerRadius = UDim.new(0, 8)
end

-- ========================================
-- SHOW WARNING (FIXED - PASTI MUNCUL)
-- ========================================
local lastWarningTime = 0
local warningCooldown = 0.1

local function showAttackWarning(killerName, distance)
    local now = tick()
    if now - lastWarningTime < warningCooldown then return end
    lastWarningTime = now
    
    detectionCounter = detectionCounter + 1
    
    if not warningGui then
        createWarningIndicator()
        task.wait(0.05)
    end
    
    -- PASTIKAN SEMUA ELEMEN ADA
    if not warningLabel then
        createWarningIndicator()
        task.wait(0.05)
    end
    
    -- UPDATE INFO
    if counterLabel and showCounter then
        counterLabel.Text = "Detected: " .. detectionCounter
    end
    
    if killerLabel and showKillerName then
        killerLabel.Text = "Killer: " .. (killerName or "Unknown")
    end
    
    if distanceLabel and showDistance then
        distanceLabel.Text = string.format("Distance: %.0f studs", distance or 0)
    end
    
    if pingInfoLabel and showPingInfo then
        pingInfoLabel.Text = string.format("Ping: %dms", math.floor(currentPing))
    end
    
    -- RESET TRANSPARANSI
    warningLabel.TextTransparency = 0
    warningLabel.TextSize = warningSize * 0.7
    warningLabel.Rotation = -3
    
    if showHint and hintLabel then
        hintLabel.TextTransparency = 0
    end
    
    if showCounter and counterLabel then
        counterLabel.TextTransparency = 0
    end
    
    if showKillerName and killerLabel then
        killerLabel.TextTransparency = 0
    end
    
    if showDistance and distanceLabel then
        distanceLabel.TextTransparency = 0
    end
    
    if showPingInfo and pingInfoLabel then
        pingInfoLabel.TextTransparency = 0
    end
    
    -- ANIMASI
    local tweenIn = TweenService:Create(warningLabel, 
        TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {TextSize = warningSize, Rotation = 3}
    )
    tweenIn:Play()
    
    -- FADE OUT
    task.delay(warningDuration - 0.15, function()
        if not warningLabel then return end
        
        local fadeInfo = TweenInfo.new(0.15)
        TweenService:Create(warningLabel, fadeInfo, {TextTransparency = 1, TextSize = warningSize * 0.5}):Play()
        
        if hintLabel and showHint then
            TweenService:Create(hintLabel, fadeInfo, {TextTransparency = 1}):Play()
        end
        
        if counterLabel and showCounter then
            TweenService:Create(counterLabel, fadeInfo, {TextTransparency = 1}):Play()
        end
        
        if killerLabel and showKillerName then
            TweenService:Create(killerLabel, fadeInfo, {TextTransparency = 1}):Play()
        end
        
        if distanceLabel and showDistance then
            TweenService:Create(distanceLabel, fadeInfo, {TextTransparency = 1}):Play()
        end
        
        if pingInfoLabel and showPingInfo then
            TweenService:Create(pingInfoLabel, fadeInfo, {TextTransparency = 1}):Play()
        end
    end)
end

-- ========================================
-- SOUND DETECTION (FIXED - AGGRESSIVE)
-- ========================================
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local soundConnections = {}

local function extractSoundId(sound)
    if not sound then return nil end
    local id = tostring(sound.SoundId):match("%d+")
    return id
end

local function getDistanceFromKiller(killer)
    if not lp.Character then return 999 end
    local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
    local killerRoot = killer and killer:FindFirstChild("HumanoidRootPart")
    if not myRoot or not killerRoot then return 999 end
    return (killerRoot.Position - myRoot.Position).Magnitude
end

local function onSoundPlayed(sound, killer)
    if not soundWarningEnabled then return end
    if not sound or not sound.IsPlaying then return end
    
    local soundId = extractSoundId(sound)
    if not soundId then return end
    
    if autoBlockTriggerSounds[soundId] then
        local killerName = killer and killer.Name or "Unknown"
        local distance = getDistanceFromKiller(killer)
        showAttackWarning(killerName, distance)
    end
end

local function setupKillerHooks(killer)
    if not killer or not killer:IsA("Model") then return end
    
    -- HOOK SEMUA SOUND (AGGRESSIVE)
    local function hookAllSounds()
        for _, sound in pairs(killer:GetDescendants()) do
            if sound:IsA("Sound") and not soundConnections[sound] then
                -- CONNECT PLAYED
                local conn = sound.Played:Connect(function()
                    onSoundPlayed(sound, killer)
                end)
                soundConnections[sound] = conn
                
                -- CEK LANSUNG JIKA SEDANG PLAYING
                if sound.IsPlaying then
                    onSoundPlayed(sound, killer)
                end
                
                -- CONNECT PROPERTY CHANGED (UNTUK JAGA-JAGA)
                sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                    if sound.IsPlaying then
                        onSoundPlayed(sound, killer)
                    end
                end)
            end
        end
    end
    
    -- HOOK SEMUA YANG ADA
    hookAllSounds()
    
    -- HOOK UNTUK SOUND BARU
    killer.DescendantAdded:Connect(function(desc)
        task.wait(0.1)
        if desc:IsA("Sound") and not soundConnections[desc] then
            local conn = desc.Played:Connect(function()
                onSoundPlayed(desc, killer)
            end)
            soundConnections[desc] = conn
            
            if desc.IsPlaying then
                onSoundPlayed(desc, killer)
            end
            
            desc:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if desc.IsPlaying then
                    onSoundPlayed(desc, killer)
                end
            end)
        end
    end)
    
    -- SCAN BERKALA (UNTUK JAGA-JAGA)
    task.spawn(function()
        while task.wait(2) do
            if not killer or not killer.Parent then break end
            hookAllSounds()
        end
    end)
end

-- ========================================
-- CONTROL UI (UKURAN NORMAL + BANYAK TOGGLE)
-- ========================================
local controlGui = nil
local controlFrame = nil

local function createControlUI()
    if controlGui then controlGui:Destroy() end
    
    controlGui = Instance.new("ScreenGui")
    controlGui.Name = "WarningControl"
    controlGui.ResetOnSpawn = false
    controlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    controlGui.DisplayOrder = 999998
    controlGui.Parent = PlayerGui
    
    controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0, 200, 0, 320)
    controlFrame.Position = UDim2.new(1, -210, 0, 10)
    controlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    controlFrame.BackgroundTransparency = 0.1
    controlFrame.BorderSizePixel = 0
    controlFrame.Active = true
    controlFrame.Draggable = true
    controlFrame.Parent = controlGui
    
    Instance.new("UICorner", controlFrame).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 35)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ ATTACK WARNING"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = controlFrame
    
    local yPos = 45
    
    -- FUNCTION TO CREATE TOGGLE BUTTON
    local function createToggle(y, text, var, color1, color2)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.BackgroundColor3 = var and color1 or color2
        btn.BorderSizePixel = 0
        btn.Text = text .. (var and " ON" or " OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = controlFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end
    
    -- MAIN TOGGLE
    local warnBtn = createToggle(yPos, "🔊 WARNING", soundWarningEnabled, Color3.fromRGB(100,200,100), Color3.fromRGB(150,150,150))
    warnBtn.MouseButton1Click:Connect(function()
        soundWarningEnabled = not soundWarningEnabled
        warnBtn.BackgroundColor3 = soundWarningEnabled and Color3.fromRGB(100,200,100) or Color3.fromRGB(150,150,150)
        warnBtn.Text = "🔊 WARNING " .. (soundWarningEnabled and "ON" or "OFF")
    end)
    
    yPos = yPos + 35
    
    -- HINT TOGGLE
    local hintBtn = createToggle(yPos, "📝 HINT", showHint, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    hintBtn.MouseButton1Click:Connect(function()
        showHint = not showHint
        hintBtn.BackgroundColor3 = showHint and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        hintBtn.Text = "📝 HINT " .. (showHint and "ON" or "OFF")
        if hintLabel then hintLabel.Visible = showHint end
    end)
    
    yPos = yPos + 35
    
    -- COUNTER TOGGLE
    local counterBtn = createToggle(yPos, "🔢 COUNTER", showCounter, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    counterBtn.MouseButton1Click:Connect(function()
        showCounter = not showCounter
        counterBtn.BackgroundColor3 = showCounter and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        counterBtn.Text = "🔢 COUNTER " .. (showCounter and "ON" or "OFF")
        if counterLabel then counterLabel.Visible = showCounter end
    end)
    
    yPos = yPos + 35
    
    -- KILLER NAME TOGGLE
    local killerBtn = createToggle(yPos, "👤 KILLER", showKillerName, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    killerBtn.MouseButton1Click:Connect(function()
        showKillerName = not showKillerName
        killerBtn.BackgroundColor3 = showKillerName and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        killerBtn.Text = "👤 KILLER " .. (showKillerName and "ON" or "OFF")
        if killerLabel then killerLabel.Visible = showKillerName end
    end)
    
    yPos = yPos + 35
    
    -- DISTANCE TOGGLE
    local distBtn = createToggle(yPos, "📏 DISTANCE", showDistance, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    distBtn.MouseButton1Click:Connect(function()
        showDistance = not showDistance
        distBtn.BackgroundColor3 = showDistance and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        distBtn.Text = "📏 DISTANCE " .. (showDistance and "ON" or "OFF")
        if distanceLabel then distanceLabel.Visible = showDistance end
    end)
    
    yPos = yPos + 35
    
    -- PING DISPLAY TOGGLE
    local pingBtn = createToggle(yPos, "📶 PING", showPingDisplay, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    pingBtn.MouseButton1Click:Connect(function()
        showPingDisplay = not showPingDisplay
        pingBtn.BackgroundColor3 = showPingDisplay and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        pingBtn.Text = "📶 PING " .. (showPingDisplay and "ON" or "OFF")
        if pingDisplay.gui then pingDisplay.gui.Enabled = showPingDisplay end
    end)
    
    yPos = yPos + 35
    
    -- PING INFO TOGGLE
    local pingInfoBtn = createToggle(yPos, "ℹ️ PING INFO", showPingInfo, Color3.fromRGB(40,200,40), Color3.fromRGB(200,40,40))
    pingInfoBtn.MouseButton1Click:Connect(function()
        showPingInfo = not showPingInfo
        pingInfoBtn.BackgroundColor3 = showPingInfo and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        pingInfoBtn.Text = "ℹ️ PING INFO " .. (showPingInfo and "ON" or "OFF")
        if pingInfoLabel then pingInfoLabel.Visible = showPingInfo end
    end)
    
    -- MINIMIZE BUTTON
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 25, 0, 25)
    minBtn.Position = UDim2.new(1, -30, 0, 8)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minBtn.BorderSizePixel = 0
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = controlFrame
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        controlFrame.Size = minimized and UDim2.new(0, 200, 0, 45) or UDim2.new(0, 200, 0, 320)
        minBtn.Text = minimized and "+" or "−"
        
        warnBtn.Visible = not minimized
        hintBtn.Visible = not minimized
        counterBtn.Visible = not minimized
        killerBtn.Visible = not minimized
        distBtn.Visible = not minimized
        pingBtn.Visible = not minimized
        pingInfoBtn.Visible = not minimized
    end)
end

-- ========================================
-- INITIALIZATION
-- ========================================
createControlUI()
createWarningIndicator()
createPingDisplay()

for _, killer in pairs(KillersFolder:GetChildren()) do
    task.spawn(setupKillerHooks, killer)
end

KillersFolder.ChildAdded:Connect(function(killer)
    task.wait(0.5)
    task.spawn(setupKillerHooks, killer)
end)

task.spawn(function()
    task.wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ ATTACK WARNING";
        Text = "Full Features Active";
        Duration = 2;
    })
end)
