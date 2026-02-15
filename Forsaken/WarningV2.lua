-- ========================================
-- ATTACK WARNING SYSTEM - WITH TOGGLES (NO SOUND)
-- Mobile UI + Show Hint + Ping Display
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
local soundWarningEnabled = true
local warningSize = 200
local warningDuration = 0.4
local warningColor = Color3.fromRGB(255, 50, 50)

-- TOGGLES
local showHint = true           -- Toggle untuk petunjuk di bawah
local showPingDisplay = true    -- Toggle untuk ping di atas layar
local showPingInfo = true       -- Toggle untuk info ping di warning

-- ========================================
-- PING DISPLAY (di ATAS layar)
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
    
    -- Update loop untuk ping display
    task.spawn(function()
        while pingDisplayLabel and pingDisplayLabel.Parent do
            pingDisplayLabel.Text = string.format("📶 Ping: %dms | +%dms", 
                math.floor(averagePing),
                math.floor(getWarningAdvanceTime() * 1000)
            )
            task.wait(0.5)
        end
    end)
    
    -- Visibility berdasarkan toggle
    pingDisplayGui.Enabled = showPingDisplay
end

-- ========================================
-- WARNING INDICATOR (dengan HINT)
-- ========================================
local warningGui = nil
local warningLabel = nil
local pingLabel = nil
local detectionTypeLabel = nil
local hintLabel = nil
local detectionCounter = 0
local counterLabel = nil

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
    warningFrame.Size = UDim2.new(0, 300, 0, 400)
    warningFrame.Position = UDim2.new(0.5, -150, 0.3, -200)
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
    
    -- Counter Label
    counterLabel = Instance.new("TextLabel")
    counterLabel.Name = "CounterLabel"
    counterLabel.Size = UDim2.new(1, 0, 0, 30)
    counterLabel.Position = UDim2.new(0, 0, 0, 260)
    counterLabel.BackgroundTransparency = 0.5
    counterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    counterLabel.BorderSizePixel = 0
    counterLabel.Text = "Detected: 0"
    counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    counterLabel.TextSize = 16
    counterLabel.Font = Enum.Font.GothamBold
    counterLabel.TextTransparency = 1
    counterLabel.Parent = warningFrame
    
    local counterCorner = Instance.new("UICorner")
    counterCorner.CornerRadius = UDim.new(0, 8)
    counterCorner.Parent = counterLabel
    
    -- HINT LABEL (PETUNJUK DI BAWAH)
    hintLabel = Instance.new("TextLabel")
    hintLabel.Name = "HintLabel"
    hintLabel.Size = UDim2.new(1, 0, 0, 25)
    hintLabel.Position = UDim2.new(0, 0, 0, 295)
    hintLabel.BackgroundTransparency = 0.5
    hintLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    hintLabel.BorderSizePixel = 0
    hintLabel.Text = "⚡ KILLER ATTACK DETECTED ⚡"
    hintLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    hintLabel.TextSize = 14
    hintLabel.Font = Enum.Font.GothamBold
    hintLabel.TextTransparency = 1
    hintLabel.Parent = warningFrame
    hintLabel.Visible = showHint
    
    local hintCorner = Instance.new("UICorner")
    hintCorner.CornerRadius = UDim.new(0, 8)
    hintCorner.Parent = hintLabel
    
    if showPingInfo then
        pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingLabel"
        pingLabel.Size = UDim2.new(1, 0, 0, 30)
        pingLabel.Position = UDim2.new(0, 0, 0, 325)
        pingLabel.BackgroundTransparency = 0.5
        pingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pingLabel.BorderSizePixel = 0
        pingLabel.Text = "Ping: " .. math.floor(averagePing) .. "ms"
        pingLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        pingLabel.TextSize = 14
        pingLabel.Font = Enum.Font.GothamBold
        pingLabel.TextTransparency = 1
        pingLabel.Parent = warningFrame
        
        local pingCorner = Instance.new("UICorner")
        pingCorner.CornerRadius = UDim.new(0, 8)
        pingCorner.Parent = pingLabel
        
        detectionTypeLabel = Instance.new("TextLabel")
        detectionTypeLabel.Name = "DetectionTypeLabel"
        detectionTypeLabel.Size = UDim2.new(1, 0, 0, 25)
        detectionTypeLabel.Position = UDim2.new(0, 0, 0, 360)
        detectionTypeLabel.BackgroundTransparency = 0.5
        detectionTypeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        detectionTypeLabel.BorderSizePixel = 0
        detectionTypeLabel.Text = "Type: Sound"
        detectionTypeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        detectionTypeLabel.TextSize = 12
        detectionTypeLabel.Font = Enum.Font.GothamBold
        detectionTypeLabel.TextTransparency = 1
        detectionTypeLabel.Parent = warningFrame
        
        local typeCorner = Instance.new("UICorner")
        typeCorner.CornerRadius = UDim.new(0, 8)
        typeCorner.Parent = detectionTypeLabel
    end
    
    return warningLabel
end

-- ========================================
-- SHOW WARNING (dengan HINT) - NO SOUND
-- ========================================
local function showAttackWarning(killerName)
    detectionCounter = detectionCounter + 1
    
    if not warningLabel then
        createWarningIndicator()
    end
    
    if counterLabel then
        counterLabel.Text = "Detected: " .. detectionCounter
    end
    
    if pingLabel and showPingInfo then
        pingLabel.Text = string.format("Ping: %dms | Comp: +%dms", 
            math.floor(averagePing), 
            math.floor(getWarningAdvanceTime() * 1000)
        )
    end
    
    if detectionTypeLabel and showPingInfo then
        detectionTypeLabel.Text = string.format("🔊 Sound | %s", killerName or "Unknown")
        detectionTypeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    -- Tampilkan semua elemen
    warningLabel.TextTransparency = 0
    counterLabel.TextTransparency = 0
    
    if showHint then
        hintLabel.TextTransparency = 0
    end
    
    if pingLabel and showPingInfo then
        pingLabel.TextTransparency = 0
    end
    
    if detectionTypeLabel and showPingInfo then
        detectionTypeLabel.TextTransparency = 0
    end
    
    warningLabel.TextSize = warningSize * 0.7
    warningLabel.Rotation = 0
    
    local tweenInfo1 = TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local growTween = TweenService:Create(warningLabel, tweenInfo1, {
        TextSize = warningSize,
        Rotation = 3
    })
    
    growTween:Play()
    
    task.spawn(function()
        task.wait(0.08)
        local shakeTween = TweenService:Create(warningLabel, 
            TweenInfo.new(0.03, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 3, true), 
            {Rotation = -3}
        )
        shakeTween:Play()
        
        task.wait(warningDuration - 0.2)
        local fadeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local fadeTween = TweenService:Create(warningLabel, fadeInfo, {
            TextTransparency = 1,
            TextSize = warningSize * 0.5
        })
        fadeTween:Play()
        
        local counterFade = TweenService:Create(counterLabel, fadeInfo, {
            TextTransparency = 1
        })
        counterFade:Play()
        
        if showHint then
            local hintFade = TweenService:Create(hintLabel, fadeInfo, {
                TextTransparency = 1
            })
            hintFade:Play()
        end
        
        if pingLabel and showPingInfo then
            local fadePing = TweenService:Create(pingLabel, fadeInfo, {
                TextTransparency = 1
            })
            fadePing:Play()
        end
        
        if detectionTypeLabel and showPingInfo then
            local fadeType = TweenService:Create(detectionTypeLabel, fadeInfo, {
                TextTransparency = 1
            })
            fadeType:Play()
        end
    end)
    
    -- TIDAK ADA SOUND EFFECT - Bagian ini dihapus
end

-- ========================================
-- SISTEM DETEKSI (TIDAK DIUBAH)
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
    
    local killerName = killerModel.Name
    
    for _, sound in pairs(killerModel:GetDescendants()) do
        if sound:IsA("Sound") and not soundHooks[sound] then
            local function checkSound()
                if not soundWarningEnabled then return end
                local soundId = extractNumericSoundId(sound)
                if soundId and autoBlockTriggerSounds[soundId] then
                    local char = getCharacterFromDescendant(sound)
                    if char then
                        showAttackWarning(killerName)
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
                    showAttackWarning(killerName)
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
-- MOBILE CONTROL GUI (DENGAN TOGGLES)
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
    controlFrame.Size = UDim2.new(0, 190, 0, 340)
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
    toggleSound.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    toggleSound.BorderSizePixel = 0
    toggleSound.Text = "🔊 Warning: ON"
    toggleSound.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleSound.TextSize = 13
    toggleSound.Font = Enum.Font.GothamBold
    toggleSound.Parent = controlFrame
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 8)
    corner1.Parent = toggleSound
    
    yPos = yPos + 40
    
    -- Toggle Hint (PETUNJUK DI BAWAH)
    local toggleHint = Instance.new("TextButton")
    toggleHint.Name = "ToggleHint"
    toggleHint.Size = UDim2.new(1, -20, 0, 35)
    toggleHint.Position = UDim2.new(0, 10, 0, yPos)
    toggleHint.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    toggleHint.BorderSizePixel = 0
    toggleHint.Text = "✅ Show Hint: ON"
    toggleHint.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleHint.TextSize = 13
    toggleHint.Font = Enum.Font.GothamBold
    toggleHint.Parent = controlFrame
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = toggleHint
    
    yPos = yPos + 40
    
    -- Toggle Ping Display (DI ATAS LAYAR)
    local togglePingDisplay = Instance.new("TextButton")
    togglePingDisplay.Name = "TogglePingDisplay"
    togglePingDisplay.Size = UDim2.new(1, -20, 0, 35)
    togglePingDisplay.Position = UDim2.new(0, 10, 0, yPos)
    togglePingDisplay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    togglePingDisplay.BorderSizePixel = 0
    togglePingDisplay.Text = "✅ Ping Display: ON"
    togglePingDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingDisplay.TextSize = 13
    togglePingDisplay.Font = Enum.Font.GothamBold
    togglePingDisplay.Parent = controlFrame
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 8)
    corner3.Parent = togglePingDisplay
    
    yPos = yPos + 40
    
    -- Toggle Ping Info (di warning)
    local togglePingInfo = Instance.new("TextButton")
    togglePingInfo.Name = "TogglePingInfo"
    togglePingInfo.Size = UDim2.new(1, -20, 0, 35)
    togglePingInfo.Position = UDim2.new(0, 10, 0, yPos)
    togglePingInfo.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    togglePingInfo.BorderSizePixel = 0
    togglePingInfo.Text = "✅ Ping Info: ON"
    togglePingInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingInfo.TextSize = 13
    togglePingInfo.Font = Enum.Font.GothamBold
    togglePingInfo.Parent = controlFrame
    
    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 8)
    corner4.Parent = togglePingInfo
    
    yPos = yPos + 40
    
    -- Ping Comp Toggle
    local togglePingComp = Instance.new("TextButton")
    togglePingComp.Name = "TogglePingComp"
    togglePingComp.Size = UDim2.new(1, -20, 0, 35)
    togglePingComp.Position = UDim2.new(0, 10, 0, yPos)
    togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    togglePingComp.BorderSizePixel = 0
    togglePingComp.Text = "✅ Ping Comp: ON"
    togglePingComp.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingComp.TextSize = 13
    togglePingComp.Font = Enum.Font.GothamBold
    togglePingComp.Parent = controlFrame
    
    local corner5 = Instance.new("UICorner")
    corner5.CornerRadius = UDim.new(0, 8)
    corner5.Parent = togglePingComp
    
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
    
    local corner6 = Instance.new("UICorner")
    corner6.CornerRadius = UDim.new(0, 8)
    corner6.Parent = pingDisplay
    
    -- Update ping display
    task.spawn(function()
        while task.wait(1) do
            if pingDisplay then
                pingDisplay.Text = string.format("Ping: %dms | +%dms", 
                    math.floor(averagePing),
                    math.floor(getWarningAdvanceTime() * 1000)
                )
            end
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
    
    local corner7 = Instance.new("UICorner")
    corner7.CornerRadius = UDim.new(0, 6)
    corner7.Parent = minimizeBtn
    
    -- ========================================
    -- TOGGLE FUNCTIONS
    -- ========================================
    
    -- Toggle Warning
    toggleSound.MouseButton1Click:Connect(function()
        soundWarningEnabled = not soundWarningEnabled
        if soundWarningEnabled then
            toggleSound.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            toggleSound.Text = "🔊 Warning: ON"
        else
            toggleSound.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            toggleSound.Text = "🔇 Warning: OFF"
        end
    end)
    
    -- Toggle Hint (PETUNJUK DI BAWAH)
    toggleHint.MouseButton1Click:Connect(function()
        showHint = not showHint
        if hintLabel then
            hintLabel.Visible = showHint
        end
        if showHint then
            toggleHint.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            toggleHint.Text = "✅ Show Hint: ON"
        else
            toggleHint.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            toggleHint.Text = "❌ Show Hint: OFF"
        end
    end)
    
    -- Toggle Ping Display (DI ATAS LAYAR)
    togglePingDisplay.MouseButton1Click:Connect(function()
        showPingDisplay = not showPingDisplay
        if pingDisplayGui then
            pingDisplayGui.Enabled = showPingDisplay
        end
        if showPingDisplay then
            togglePingDisplay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingDisplay.Text = "✅ Ping Display: ON"
        else
            togglePingDisplay.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingDisplay.Text = "❌ Ping Display: OFF"
        end
    end)
    
    -- Toggle Ping Info (di warning)
    togglePingInfo.MouseButton1Click:Connect(function()
        showPingInfo = not showPingInfo
        if pingLabel then
            pingLabel.Visible = showPingInfo
        end
        if detectionTypeLabel then
            detectionTypeLabel.Visible = showPingInfo
        end
        if showPingInfo then
            togglePingInfo.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingInfo.Text = "✅ Ping Info: ON"
        else
            togglePingInfo.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingInfo.Text = "❌ Ping Info: OFF"
        end
    end)
    
    -- Toggle Ping Comp
    togglePingComp.MouseButton1Click:Connect(function()
        pingCompensation = not pingCompensation
        if pingCompensation then
            togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingComp.Text = "✅ Ping Comp: ON"
        else
            togglePingComp.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingComp.Text = "❌ Ping Comp: OFF"
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
            togglePingInfo.Visible = false
            togglePingComp.Visible = false
            pingDisplay.Visible = false
        else
            controlFrame.Size = UDim2.new(0, 190, 0, 340)
            minimizeBtn.Text = "-"
            toggleSound.Visible = true
            toggleHint.Visible = true
            togglePingDisplay.Visible = true
            togglePingInfo.Visible = true
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

-- Monitor killer baru
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
        Text = "System Active - No Sound Effect";
        Duration = 3;
    })
end)

print("✅ Attack Warning System dengan TOGGLES loaded!")
print("📱 Fitur:")
print("   - Show Hint (petunjuk di bawah)")
print("   - Ping Display (di atas layar)")
print("   - Ping Info (di warning)")
print("🔇 NO SOUND EFFECT - Visual only")
