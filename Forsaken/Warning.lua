-- ========================================
-- ATTACK WARNING SYSTEM - FIXED VERSION
-- Menggunakan metode yang sama seperti AutoBlock
-- ========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

-- ========================================
-- SOUND TRIGGERS (sama persis dengan AutoBlock)
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
-- CONFIGURATION
-- ========================================
local soundWarningEnabled = true
local warningSize = 200
local warningDuration = 0.4
local warningColor = Color3.fromRGB(255, 50, 50)
local showPingInfo = true

-- ========================================
-- SOUND DETECTION (SISTEM SEPERTI AUTOBLOCK)
-- ========================================
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

local function isKiller(character)
    if not character then return false end
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then return false end
    local killersFolder = playersFolder:FindFirstChild("Killers")
    if not killersFolder then return false end
    return character:IsDescendantOf(killersFolder)
end

-- ========================================
-- WARNING INDICATOR
-- ========================================
local warningGui = nil
local warningLabel = nil
local pingLabel = nil
local detectionTypeLabel = nil

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
    warningLabel.Size = UDim2.new(1, 0, 1, 0)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "!"
    warningLabel.TextColor3 = warningColor
    warningLabel.TextSize = warningSize
    warningLabel.Font = Enum.Font.GothamBold
    warningLabel.TextStrokeTransparency = 0
    warningLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warningLabel.TextTransparency = 1
    warningLabel.Parent = warningFrame
    
    if showPingInfo then
        pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingLabel"
        pingLabel.Size = UDim2.new(0, 220, 0, 35)
        pingLabel.Position = UDim2.new(0.5, -110, 1, 10)
        pingLabel.BackgroundTransparency = 0.5
        pingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pingLabel.BorderSizePixel = 0
        pingLabel.Text = "Ping: " .. math.floor(averagePing) .. "ms"
        pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        pingLabel.TextSize = 16
        pingLabel.Font = Enum.Font.GothamBold
        pingLabel.TextTransparency = 1
        pingLabel.Parent = warningFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = pingLabel
        
        detectionTypeLabel = Instance.new("TextLabel")
        detectionTypeLabel.Name = "DetectionTypeLabel"
        detectionTypeLabel.Size = UDim2.new(0, 220, 0, 25)
        detectionTypeLabel.Position = UDim2.new(0.5, -110, 1, 50)
        detectionTypeLabel.BackgroundTransparency = 0.5
        detectionTypeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        detectionTypeLabel.BorderSizePixel = 0
        detectionTypeLabel.Text = "Type: Sound"
        detectionTypeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        detectionTypeLabel.TextSize = 14
        detectionTypeLabel.Font = Enum.Font.GothamBold
        detectionTypeLabel.TextTransparency = 1
        detectionTypeLabel.Parent = warningFrame
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 8)
        corner2.Parent = detectionTypeLabel
    end
    
    return warningLabel
end

-- ========================================
-- SHOW WARNING
-- ========================================
local function showAttackWarning(killerName)
    if not warningLabel then
        createWarningIndicator()
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
    
    warningLabel.TextTransparency = 0
    warningLabel.TextSize = warningSize * 0.7
    warningLabel.Rotation = 0
    
    if pingLabel and showPingInfo then
        pingLabel.TextTransparency = 0
    end
    
    if detectionTypeLabel and showPingInfo then
        detectionTypeLabel.TextTransparency = 0
    end
    
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
end

-- ========================================
-- SOUND MONITORING (FIXED VERSION - seperti AutoBlock)
-- ========================================
local soundHooks = {}

local function setupSoundHooksForKiller(killerModel)
    if not killerModel then return end
    local killerName = killerModel.Name
    
    -- Hook semua sound di killer
    for _, sound in pairs(killerModel:GetDescendants()) do
        if sound:IsA("Sound") and not soundHooks[sound] then
            -- Gunakan method yang sama seperti AutoBlock
            local function checkSound()
                if not soundWarningEnabled then return end
                local soundId = extractNumericSoundId(sound)
                if soundId and autoBlockTriggerSounds[soundId] then
                    showAttackWarning(killerName)
                end
            end
            
            -- Hook Played event
            local playedConn = sound.Played:Connect(checkSound)
            
            -- Hook IsPlaying change (untuk jaga-jaga)
            local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if sound.IsPlaying then
                    checkSound()
                end
            end)
            
            -- Cleanup saat sound dihapus
            local destroyConn = sound.Destroying:Connect(function()
                playedConn:Disconnect()
                propConn:Disconnect()
                destroyConn:Disconnect()
                soundHooks[sound] = nil
            end)
            
            soundHooks[sound] = {playedConn, propConn, destroyConn}
            
            -- Cek jika sound sudah playing
            if sound.IsPlaying then
                checkSound()
            end
        end
    end
end

-- ========================================
-- MOBILE CONTROL GUI
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
    controlFrame.Size = UDim2.new(0, 190, 0, 190)
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
    
    -- Sound Warning Toggle
    local toggleSound = Instance.new("TextButton")
    toggleSound.Name = "ToggleSound"
    toggleSound.Size = UDim2.new(1, -20, 0, 40)
    toggleSound.Position = UDim2.new(0, 10, 0, 40)
    toggleSound.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    toggleSound.BorderSizePixel = 0
    toggleSound.Text = "🔊 Warning: ON"
    toggleSound.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleSound.TextSize = 14
    toggleSound.Font = Enum.Font.GothamBold
    toggleSound.Parent = controlFrame
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 8)
    corner1.Parent = toggleSound
    
    -- Ping Comp Toggle
    local togglePingComp = Instance.new("TextButton")
    togglePingComp.Name = "TogglePingComp"
    togglePingComp.Size = UDim2.new(1, -20, 0, 40)
    togglePingComp.Position = UDim2.new(0, 10, 0, 90)
    togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    togglePingComp.BorderSizePixel = 0
    togglePingComp.Text = "✅ Ping Comp: ON"
    togglePingComp.TextColor3 = Color3.fromRGB(255, 255, 255)
    togglePingComp.TextSize = 14
    togglePingComp.Font = Enum.Font.GothamBold
    togglePingComp.Parent = controlFrame
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = togglePingComp
    
    -- Ping Display
    local pingDisplay = Instance.new("TextLabel")
    pingDisplay.Name = "PingDisplay"
    pingDisplay.Size = UDim2.new(1, -20, 0, 40)
    pingDisplay.Position = UDim2.new(0, 10, 0, 140)
    pingDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    pingDisplay.BackgroundTransparency = 0.3
    pingDisplay.BorderSizePixel = 0
    pingDisplay.Text = "Ping: " .. math.floor(averagePing) .. "ms"
    pingDisplay.TextColor3 = Color3.fromRGB(255, 255, 100)
    pingDisplay.TextSize = 14
    pingDisplay.Font = Enum.Font.GothamBold
    pingDisplay.Parent = controlFrame
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 8)
    corner3.Parent = pingDisplay
    
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
    
    -- Toggle Functions
    toggleSound.MouseButton1Click:Connect(function()
        soundWarningEnabled = not soundWarningEnabled
        if soundWarningEnabled then
            toggleSound.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            toggleSound.Text = "🔊 Warning: ON"
        else
            toggleSound.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            toggleSound.Text = "🔇 Warning: OFF"
        end
        
        local originalSize = toggleSound.Size
        toggleSound.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 5, originalSize.Y.Scale, originalSize.Y.Offset - 5)
        task.wait(0.1)
        toggleSound.Size = originalSize
    end)
    
    togglePingComp.MouseButton1Click:Connect(function()
        pingCompensation = not pingCompensation
        if pingCompensation then
            togglePingComp.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
            togglePingComp.Text = "✅ Ping Comp: ON"
        else
            togglePingComp.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            togglePingComp.Text = "❌ Ping Comp: OFF"
        end
        
        local originalSize = togglePingComp.Size
        togglePingComp.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 5, originalSize.Y.Scale, originalSize.Y.Offset - 5)
        task.wait(0.1)
        togglePingComp.Size = originalSize
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
    
    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 6)
    corner4.Parent = minimizeBtn
    
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            controlFrame.Size = UDim2.new(0, 190, 0, 40)
            minimizeBtn.Text = "+"
            toggleSound.Visible = false
            togglePingComp.Visible = false
            pingDisplay.Visible = false
        else
            controlFrame.Size = UDim2.new(0, 190, 0, 190)
            minimizeBtn.Text = "-"
            toggleSound.Visible = true
            togglePingComp.Visible = true
            pingDisplay.Visible = true
        end
    end)
end

-- ========================================
-- INITIALIZATION
-- ========================================

-- Create GUI
createMobileControlGUI()
createWarningIndicator()

-- Find Killers folder
local function initialize()
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then
        warn("Players folder not found")
        return
    end
    
    local killersFolder = playersFolder:FindFirstChild("Killers")
    if not killersFolder then
        warn("Killers folder not found")
        return
    end
    
    print("✅ Attack Warning System initialized - Monitoring", #autoBlockTriggerSounds, "attack sounds")
    
    -- Setup hooks for existing killers
    for _, killer in pairs(killersFolder:GetChildren()) do
        if killer:IsA("Model") then
            task.spawn(function()
                setupSoundHooksForKiller(killer)
            end)
        end
    end
    
    -- Hook for new killers
    killersFolder.ChildAdded:Connect(function(killer)
        task.wait(0.5)
        if killer:IsA("Model") then
            task.spawn(function()
                setupSoundHooksForKiller(killer)
            end)
        end
    end)
    
    -- Also hook descendant added for each killer
    killersFolder.DescendantAdded:Connect(function(desc)
        task.wait(0.1)
        if desc:IsA("Sound") and not soundHooks[desc] then
            local killer = desc:FindFirstAncestorOfClass("Model")
            if killer and isKiller(killer) then
                setupSoundHooksForKiller(killer)
            end
        end
    end)
end

-- Start initialization
task.spawn(initialize)

-- Notification
task.spawn(function()
    task.wait(2)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Attack Warning";
        Text = "System Active - Menggunakan metode AutoBlock";
        Duration = 3;
    })
end)

print("✅ Attack Warning System loaded - Siap mendeteksi serangan killer!")
