-- ========================================
-- ATTACK WARNING SYSTEM - WITH KILLER NAME ESP
-- Mobile UI + Show Hint (DRAGGABLE) + Ping Display (DRAGGABLE) + DELAY INPUT + KILLER NAME ESP
-- ========================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ========================================
-- AUTO BLOCK TRIGGER SOUNDS
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
local averagePing = 0
local pingHistory = {}
local maxPingHistory = 10
local compensationMultiplier = 1.2

local function updatePing()
    local ping = lp:GetNetworkPing() * 1000
    table.insert(pingHistory, ping)
    
    if #pingHistory > maxPingHistory then
        table.remove(pingHistory, 1)
    end
    
    local total = 0
    for _, p in ipairs(pingHistory) do
        total = total + p
    end
    averagePing = total / #pingHistory
end

task.spawn(function()
    while task.wait(1) do
        pcall(updatePing)
    end
end)

local function getWarningAdvanceTime()
    if not pingCompensation then return 0 end
    return (averagePing / 1000) * compensationMultiplier
end

-- ========================================
-- CONFIGURATION WITH TOGGLES
-- ========================================
local soundWarningEnabled = false      -- OFF DEFAULT
local warningSize = 200
local warningDuration = 0.4
local warningColor = Color3.fromRGB(255, 50, 50)

-- TOGGLES
local showHint = false                 -- OFF DEFAULT
local showPingDisplay = false          -- OFF DEFAULT
local showKillerESP = false            -- NEW: Killer Name ESP (OFF DEFAULT)

-- DELAY SETTINGS
local warningDelay = 0
local detectionCounter = 0

-- ========================================
-- KILLER NAME ESP SYSTEM
-- ========================================
local killerESP = {
    enabled = false,
    guis = {},
    folder = nil,
    connections = {}
}

local function createKillerESP()
    -- Bersihkan ESP lama
    for _, gui in pairs(killerESP.guis) do
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
    killerESP.guis = {}
    
    if not showKillerESP then return end
    if not killerESP.folder then return end
    
    -- Buat ESP untuk setiap killer
    for _, killer in pairs(killerESP.folder:GetChildren()) do
        if killer:IsA("Model") then
            local root = killer:FindFirstChild("HumanoidRootPart") or killer:FindFirstChildWhichIsA("BasePart")
            if root then
                -- BillboardGui untuk nama
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "KillerESP_" .. killer.Name
                billboard.Adornee = root
                billboard.Size = UDim2.new(0, 150, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                billboard.Parent = killer
                
                -- Frame background
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Parent = billboard
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = frame
                
                -- Nama killer
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = killer.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                nameLabel.TextSize = 14
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0.3
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = frame
                
                -- Role label
                local roleLabel = Instance.new("TextLabel")
                roleLabel.Size = UDim2.new(1, 0, 0.4, 0)
                roleLabel.Position = UDim2.new(0, 0, 0.6, 0)
                roleLabel.BackgroundTransparency = 1
                roleLabel.Text = "⚔️ KILLER"
                roleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                roleLabel.TextSize = 10
                roleLabel.Font = Enum.Font.GothamBold
                roleLabel.TextStrokeTransparency = 0.3
                roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                roleLabel.Parent = frame
                
                killerESP.guis[killer] = billboard
            end
        end
    end
end

local function setupKillerESP()
    -- Cari folder killers
    local playersFolder = Workspace:FindFirstChild("Players")
    if playersFolder then
        killerESP.folder = playersFolder:FindFirstChild("Killers")
    end
    
    if not killerESP.folder then
        return
    end
    
    -- Buat ESP untuk yang sudah ada
    createKillerESP()
    
    -- Monitor killer baru
    local conn = killerESP.folder.ChildAdded:Connect(function(killer)
        task.wait(0.5)
        if showKillerESP then
            createKillerESP()
        end
    end)
    table.insert(killerESP.connections, conn)
    
    -- Monitor killer yang dihapus
    local conn2 = killerESP.folder.ChildRemoved:Connect(function(killer)
        if killerESP.guis[killer] then
            killerESP.guis[killer]:Destroy()
            killerESP.guis[killer] = nil
        end
    end)
    table.insert(killerESP.connections, conn2)
    
    -- Update posisi setiap frame (untuk jaga-jaga)
    local conn3 = RunService.RenderStepped:Connect(function()
        if not showKillerESP then return end
        for killer, gui in pairs(killerESP.guis) do
            if not killer or not killer.Parent then
                if gui and gui.Parent then
                    gui:Destroy()
                end
                killerESP.guis[killer] = nil
            end
        end
    end)
    table.insert(killerESP.connections, conn3)
end

-- ========================================
-- PING DISPLAY
-- ========================================
local pingDisplayGui = nil
local pingDisplayLabel = nil

local function createPingDisplay()
    if pingDisplayGui then
        pingDisplayGui:Destroy()
    end
    
    pingDisplayGui = Instance.new("ScreenGui")
    pingDisplayGui.Name = "PingDisplayGUI"
    pingDisplayGui.ResetOnSpawn = false
    pingDisplayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pingDisplayGui.DisplayOrder = 999997
    pingDisplayGui.Parent = PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Name = "PingFrame"
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = UDim2.new(0.5, -100, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = pingDisplayGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    pingDisplayLabel = Instance.new("TextLabel")
    pingDisplayLabel.Name = "PingLabel"
    pingDisplayLabel.Size = UDim2.new(1, 0, 1, 0)
    pingDisplayLabel.BackgroundTransparency = 1
    pingDisplayLabel.Text = string.format("📶 Ping: %dms | +%dms", 
        math.floor(averagePing),
        math.floor(getWarningAdvanceTime() * 1000)
    )
    pingDisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    pingDisplayLabel.TextSize = 16
    pingDisplayLabel.Font = Enum.Font.GothamBold
    pingDisplayLabel.TextStrokeTransparency = 0.5
    pingDisplayLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    pingDisplayLabel.Parent = frame
    
    task.spawn(function()
        while pingDisplayLabel and pingDisplayLabel.Parent do
            pingDisplayLabel.Text = string.format("📶 Ping: %dms | +%dms", 
                math.floor(averagePing),
                math.floor(getWarningAdvanceTime() * 1000)
            )
            task.wait(0.5)
        end
    end)
    
    pingDisplayGui.Enabled = showPingDisplay
end

-- ========================================
-- WARNING INDICATOR
-- ========================================
local warningGui = nil
local warningLabel = nil
local hintLabel = nil
local hintFrame = nil

local function createWarningIndicator()
    if warningGui then
        warningGui:Destroy()
    end
    
    warningGui = Instance.new("ScreenGui")
    warningGui.Name = "AttackWarningGUI"
    warningGui.ResetOnSpawn = false
    warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    warningGui.DisplayOrder = 999999
    warningGui.Parent = PlayerGui
    
    local warningFrame = Instance.new("Frame")
    warningFrame.Name = "WarningFrame"
    warningFrame.Size = UDim2.new(0, 300, 0, 300)
    warningFrame.Position = UDim2.new(0.5, -150, 0.4, -150)
    warningFrame.BackgroundTransparency = 1
    warningFrame.Parent = warningGui
    
    warningLabel = Instance.new("TextLabel")
    warningLabel.Name = "ExclamationLabel"
    warningLabel.Size = UDim2.new(1, 0, 0, 250)
    warningLabel.Position = UDim2.new(0, 0, 0, 0)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "!"
    warningLabel.TextColor3 = warningColor
    warningLabel.TextSize = warningSize
    warningLabel.Font = Enum.Font.GothamBold
    warningLabel.TextStrokeTransparency = 0
    warningLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warningLabel.TextTransparency = 1
    warningLabel.Parent = warningFrame
    
    -- HINT FRAME (BISA DI-DRAG)
    hintFrame = Instance.new("Frame")
    hintFrame.Name = "HintFrame"
    hintFrame.Size = UDim2.new(0, 280, 0, 35)
    hintFrame.Position = UDim2.new(0.5, -140, 0.85, 0)
    hintFrame.BackgroundTransparency = 0.3
    hintFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    hintFrame.BorderSizePixel = 0
    hintFrame.Active = true
    hintFrame.Draggable = true
    hintFrame.Visible = showHint
    hintFrame.Parent = warningGui
    
    local hintCorner = Instance.new("UICorner")
    hintCorner.CornerRadius = UDim.new(0, 8)
    hintCorner.Parent = hintFrame
    
    hintLabel = Instance.new("TextLabel")
    hintLabel.Name = "HintLabel"
    hintLabel.Size = UDim2.new(1, 0, 1, 0)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text = "⚡ KILLER ATTACK ⚡"
    hintLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    hintLabel.TextSize = 16
    hintLabel.Font = Enum.Font.GothamBold
    hintLabel.TextTransparency = 1
    hintLabel.Parent = hintFrame
    
    return warningLabel
end

-- ========================================
-- SHOW WARNING
-- ========================================
local lastWarningTime = 0
local warningCooldown = 0.1

local function showAttackWarning()
    local now = tick()
    if now - lastWarningTime < warningCooldown then return end
    lastWarningTime = now
    
    detectionCounter = detectionCounter + 1
    
    if not warningLabel then
        createWarningIndicator()
    end
    
    warningLabel.TextTransparency = 0
    warningLabel.TextSize = warningSize * 0.7
    warningLabel.Rotation = 0
    
    if showHint and hintLabel and hintFrame then
        hintLabel.TextTransparency = 0
        hintFrame.Visible = true
    end
    
    local tweenIn = TweenService:Create(warningLabel, 
        TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {TextSize = warningSize, Rotation = 3}
    )
    tweenIn:Play()
    
    task.spawn(function()
        task.wait(0.08)
        
        task.wait(warningDuration - 0.2)
        local fadeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        
        local fadeTween = TweenService:Create(warningLabel, fadeInfo, {
            TextTransparency = 1,
            TextSize = warningSize * 0.5
        })
        fadeTween:Play()
        
        if showHint and hintLabel then
            local hintFade = TweenService:Create(hintLabel, fadeInfo, {
                TextTransparency = 1
            })
            hintFade:Play()
            
            task.delay(0.2, function()
                if hintFrame and not showHint then
                    hintFrame.Visible = false
                end
            end)
        end
    end)
end

-- ========================================
-- SISTEM DETEKSI
-- ========================================
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local soundHooks = {}

local function extractNumericSoundId(sound)
    if not sound or not sound.SoundId then return nil end
    return tostring(sound.SoundId):match("%d+")
end

local function getCharacterFromDescendant(inst)
    if not inst then return nil end
    local model = inst:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then return model end
    return nil
end

local function monitorKillerSounds(killerModel)
    if not killerModel or not killerModel:IsA("Model") then return end
    
    for _, sound in pairs(killerModel:GetDescendants()) do
        if sound:IsA("Sound") and not soundHooks[sound] then
            local function checkSound()
                if not soundWarningEnabled then return end
                local soundId = extractNumericSoundId(sound)
                if soundId and autoBlockTriggerSounds[soundId] then
                    local char = getCharacterFromDescendant(sound)
                    if char then
                        if warningDelay > 0 then
                            task.wait(warningDelay)
                        end
                        showAttackWarning()
                    end
                end
            end
            
            local playedConn = sound.Played:Connect(checkSound)
            local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if sound.IsPlaying then
                    checkSound()
                end
            end)
            local destroyConn = sound.Destroying:Connect(function()
                playedConn:Disconnect()
                propConn:Disconnect()
                destroyConn:Disconnect()
                soundHooks[sound] = nil
            end)
            
            soundHooks[sound] = {playedConn, propConn, destroyConn}
            
            if sound.IsPlaying then
                checkSound()
            end
        end
    end
    
    killerModel.DescendantAdded:Connect(function(desc)
        if desc:IsA("Sound") and not soundHooks[desc] then
            local function checkNewSound()
                if not soundWarningEnabled then return end
                local soundId = extractNumericSoundId(desc)
                if soundId and autoBlockTriggerSounds[soundId] then
                    if warningDelay > 0 then
                        task.wait(warningDelay)
                    end
                    showAttackWarning()
                end
            end
            
            local playedConn = desc.Played:Connect(checkNewSound)
            local propConn = desc:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if desc.IsPlaying then
                    checkNewSound()
                end
            end)
            local destroyConn = desc.Destroying:Connect(function()
                playedConn:Disconnect()
                propConn:Disconnect()
                destroyConn:Disconnect()
                soundHooks[desc] = nil
            end)
            
            soundHooks[desc] = {playedConn, propConn, destroyConn}
            
            if desc.IsPlaying then
                checkNewSound()
            end
        end
    end)
end

-- ========================================
-- MOBILE CONTROL GUI (DENGAN KILLER ESP TOGGLE)
-- ========================================
local mobileGui = nil
local controlFrame = nil

local function createMobileControlGUI()
    if mobileGui then
        mobileGui:Destroy()
    end
    
    mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "MobileAttackWarningControls"
    mobileGui.ResetOnSpawn = false
    mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mobileGui.DisplayOrder = 999998
    mobileGui.Parent = PlayerGui
    
    controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(0, 190, 0, 410)  -- Ditambah untuk Killer ESP
    controlFrame.Position = UDim2.new(1, -200, 0, 10)
    controlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    controlFrame.BackgroundTransparency = 0.2
    controlFrame.BorderSizePixel = 0
    controlFrame.Active = true
    controlFrame.Draggable = true
    controlFrame.Parent = mobileGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = controlFrame
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -10, 0, 30)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ Attack Warning"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = controlFrame
    
    local yPos = 40
    
    -- Toggle Warning
    local toggleSound = Instance.new("TextButton")
    toggleSound.Name = "ToggleSound"
    toggleSound.Size = UDim2.new(1, -20, 0, 35)
    toggleSound.Position = UDim2.new(0, 10, 0, yPos)
    toggleSound.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    toggleSound.BorderSizePixel = 0
    toggleSound.Text = "🔊 Warning: OFF"
    toggleSound.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleSound.TextSize = 13
    toggleSound.Font = Enum.Font.GothamBold
    toggleSound.Parent = controlFrame
    Instance.new("UICorner", toggleSound).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 40
    
    -- Toggle Hint
    local toggleHint = Instance.new("TextButton")
    toggleHint.Name = "ToggleHint"
    toggleHint.Size = UDim2.new(1, -20, 0, 35)
    toggleHint.Position = UDim2.new(0, 10, 0, yPos)
    toggleHint.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    toggleHint.BorderSizePixel = 0
    toggleHint.Text = "❌ Hint: OFF"
    toggleHint.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleHint.TextSize = 13
    toggleHint.Font = Enum.Font.GothamBold
    toggleHint.Parent = controlFrame
    Instance.new("UICorner", toggleHint).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 40
    
    -- Toggle Ping Display
    local togglePingDisplay = Instance.new("TextButton")
    togglePingDisplay.Name = "TogglePingDisplay"
    togglePingDisplay.Size = UDim2.new(1, -20, 0, 35)
    togglePingDisplay.Position = UDim2.new(0, 10, 0, yPos)
    togglePingDisplay.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    togglePingDisplay.BorderSizePixel = 0
    togglePingDisplay.Text = "📶 Ping: OFF"
    togglePingDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingDisplay.TextSize = 13
    togglePingDisplay.Font = Enum.Font.GothamBold
    togglePingDisplay.Parent = controlFrame
    Instance.new("UICorner", togglePingDisplay).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 40
    
    -- NEW: Toggle Killer ESP
    local toggleKillerESP = Instance.new("TextButton")
    toggleKillerESP.Name = "ToggleKillerESP"
    toggleKillerESP.Size = UDim2.new(1, -20, 0, 35)
    toggleKillerESP.Position = UDim2.new(0, 10, 0, yPos)
    toggleKillerESP.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    toggleKillerESP.BorderSizePixel = 0
    toggleKillerESP.Text = "👤 Killer ESP: OFF"
    toggleKillerESP.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleKillerESP.TextSize = 13
    toggleKillerESP.Font = Enum.Font.GothamBold
    toggleKillerESP.Parent = controlFrame
    Instance.new("UICorner", toggleKillerESP).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 40
    
    -- DELAY INPUT SECTION
    local delayFrame = Instance.new("Frame")
    delayFrame.Name = "DelayFrame"
    delayFrame.Size = UDim2.new(1, -20, 0, 60)
    delayFrame.Position = UDim2.new(0, 10, 0, yPos)
    delayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    delayFrame.BackgroundTransparency = 0.3
    delayFrame.BorderSizePixel = 0
    delayFrame.Parent = controlFrame
    Instance.new("UICorner", delayFrame).CornerRadius = UDim.new(0, 8)
    
    local delayLabel = Instance.new("TextLabel")
    delayLabel.Name = "DelayLabel"
    delayLabel.Size = UDim2.new(1, -10, 0, 20)
    delayLabel.Position = UDim2.new(0, 5, 0, 5)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Text = "Delay (detik):"
    delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    delayLabel.TextSize = 12
    delayLabel.Font = Enum.Font.GothamBold
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left
    delayLabel.Parent = delayFrame
    
    local delayInput = Instance.new("TextBox")
    delayInput.Name = "DelayInput"
    delayInput.Size = UDim2.new(1, -20, 0, 25)
    delayInput.Position = UDim2.new(0, 10, 0, 28)
    delayInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    delayInput.BackgroundTransparency = 0.3
    delayInput.BorderSizePixel = 0
    delayInput.PlaceholderText = "0.0"
    delayInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    delayInput.Text = "0"
    delayInput.TextColor3 = Color3.fromRGB(255, 255, 100)
    delayInput.TextSize = 14
    delayInput.Font = Enum.Font.GothamBold
    delayInput.ClearTextOnFocus = false
    delayInput.Parent = delayFrame
    Instance.new("UICorner", delayInput).CornerRadius = UDim.new(0, 6)
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplyBtn"
    applyBtn.Size = UDim2.new(0.3, 0, 0, 20)
    applyBtn.Position = UDim2.new(0.7, -5, 0, 30)
    applyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "SET"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 11
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.Parent = delayFrame
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 4)
    
    yPos = yPos + 65
    
    -- Ping Comp Toggle
    local togglePingComp = Instance.new("TextButton")
    togglePingComp.Name = "TogglePingComp"
    togglePingComp.Size = UDim2.new(1, -20, 0, 35)
    togglePingComp.Position = UDim2.new(0, 10, 0, yPos)
    togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    togglePingComp.BorderSizePixel = 0
    togglePingComp.Text = "✅ Comp: ON"
    togglePingComp.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingComp.TextSize = 13
    togglePingComp.Font = Enum.Font.GothamBold
    togglePingComp.Parent = controlFrame
    Instance.new("UICorner", togglePingComp).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 40
    
    -- Ping Display (info kecil)
    local pingDisplay = Instance.new("TextLabel")
    pingDisplay.Name = "PingDisplay"
    pingDisplay.Size = UDim2.new(1, -20, 0, 30)
    pingDisplay.Position = UDim2.new(0, 10, 0, yPos)
    pingDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    pingDisplay.BackgroundTransparency = 0.3
    pingDisplay.BorderSizePixel = 0
    pingDisplay.Text = "Ping: " .. math.floor(averagePing) .. "ms"
    pingDisplay.TextColor3 = Color3.fromRGB(255, 255, 100)
    pingDisplay.TextSize = 12
    pingDisplay.Font = Enum.Font.GothamBold
    pingDisplay.Parent = controlFrame
    Instance.new("UICorner", pingDisplay).CornerRadius = UDim.new(0, 6)
    
    task.spawn(function()
        while pingDisplay and pingDisplay.Parent do
            pingDisplay.Text = string.format("Ping: %dms | +%dms", 
                math.floor(averagePing),
                math.floor(getWarningAdvanceTime() * 1000)
            )
            task.wait(1)
        end
    end)
    
    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = controlFrame
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)
    
    -- ========================================
    -- TOGGLE FUNCTIONS
    -- ========================================
    
    toggleSound.MouseButton1Click:Connect(function()
        soundWarningEnabled = not soundWarningEnabled
        if soundWarningEnabled then
            toggleSound.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            toggleSound.Text = "🔊 Warning: ON"
        else
            toggleSound.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            toggleSound.Text = "🔊 Warning: OFF"
        end
    end)
    
    toggleHint.MouseButton1Click:Connect(function()
        showHint = not showHint
        if hintFrame then
            hintFrame.Visible = showHint
        end
        if showHint then
            toggleHint.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            toggleHint.Text = "✅ Hint: ON"
        else
            toggleHint.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            toggleHint.Text = "❌ Hint: OFF"
        end
    end)
    
    togglePingDisplay.MouseButton1Click:Connect(function()
        showPingDisplay = not showPingDisplay
        if pingDisplayGui then
            pingDisplayGui.Enabled = showPingDisplay
        end
        if showPingDisplay then
            togglePingDisplay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingDisplay.Text = "📶 Ping: ON"
        else
            togglePingDisplay.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingDisplay.Text = "📶 Ping: OFF"
        end
    end)
    
    -- NEW: Toggle Killer ESP
    toggleKillerESP.MouseButton1Click:Connect(function()
        showKillerESP = not showKillerESP
        
        if showKillerESP then
            toggleKillerESP.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            toggleKillerESP.Text = "👤 Killer ESP: ON"
            setupKillerESP()  -- Aktifkan ESP
        else
            toggleKillerESP.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            toggleKillerESP.Text = "👤 Killer ESP: OFF"
            -- Hapus semua ESP
            for _, gui in pairs(killerESP.guis) do
                if gui and gui.Parent then
                    gui:Destroy()
                end
            end
            killerESP.guis = {}
        end
    end)
    
    -- Apply Delay
    applyBtn.MouseButton1Click:Connect(function()
        local input = delayInput.Text:gsub(",", ".")
        local delay = tonumber(input)
        if delay then
            warningDelay = math.max(0, math.min(3, delay))
            delayInput.Text = string.format("%.1f", warningDelay)
            
            applyBtn.Size = UDim2.new(0.3, -2, 0, 18)
            task.wait(0.05)
            applyBtn.Size = UDim2.new(0.3, 0, 0, 20)
        else
            delayInput.Text = string.format("%.1f", warningDelay)
        end
    end)
    
    delayInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local input = delayInput.Text:gsub(",", ".")
            local delay = tonumber(input)
            if delay then
                warningDelay = math.max(0, math.min(3, delay))
                delayInput.Text = string.format("%.1f", warningDelay)
            else
                delayInput.Text = string.format("%.1f", warningDelay)
            end
        end
    end)
    
    togglePingComp.MouseButton1Click:Connect(function()
        pingCompensation = not pingCompensation
        if pingCompensation then
            togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingComp.Text = "✅ Comp: ON"
        else
            togglePingComp.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingComp.Text = "❌ Comp: OFF"
        end
    end)
    
    -- Minimize
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            controlFrame.Size = UDim2.new(0, 190, 0, 40)
            minimizeBtn.Text = "+"
            toggleSound.Visible = false
            toggleHint.Visible = false
            togglePingDisplay.Visible = false
            toggleKillerESP.Visible = false
            delayFrame.Visible = false
            togglePingComp.Visible = false
            pingDisplay.Visible = false
        else
            controlFrame.Size = UDim2.new(0, 190, 0, 410)
            minimizeBtn.Text = "-"
            toggleSound.Visible = true
            toggleHint.Visible = true
            togglePingDisplay.Visible = true
            toggleKillerESP.Visible = true
            delayFrame.Visible = true
            togglePingComp.Visible = true
            pingDisplay.Visible = true
        end
    end)
end

-- ========================================
-- INITIALIZATION
-- ========================================
createMobileControlGUI()
createWarningIndicator()
createPingDisplay()

-- Setup monitoring untuk semua killer
for _, killer in pairs(KillersFolder:GetChildren()) do
    task.spawn(function()
        monitorKillerSounds(killer)
    end)
end

KillersFolder.ChildAdded:Connect(function(killer)
    task.wait(0.5)
    task.spawn(function()
        monitorKillerSounds(killer)
    end)
end)

-- Notification
task.spawn(function()
    task.wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Attack Warning";
        Text = "Killer ESP Added!";
        Duration = 2;
    })
end)
