-- ========================================
-- ATTACK WARNING SYSTEM - MINIMALIS
-- Hanya Ping + Warning | Bisa Atur Delay
-- ========================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
-- PING DISPLAY (BISA DI-DRAG)
-- ========================================
local pingDisplay = {
    gui = nil,
    frame = nil,
    label = nil,
    enabled = true
}

local function updatePing()
    return lp:GetNetworkPing() * 1000
end

local function createPingDisplay()
    if pingDisplay.gui then
        pingDisplay.gui:Destroy()
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "PingDisplay"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999997
    gui.Parent = PlayerGui
    gui.Enabled = pingDisplay.enabled
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 140, 0, 30)
    frame.Position = UDim2.new(0.5, -70, 0, 5)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "📶 0 ms"
    label.TextColor3 = Color3.fromRGB(255, 255, 100)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    pingDisplay.gui = gui
    pingDisplay.frame = frame
    pingDisplay.label = label
    
    -- Update ping setiap frame
    RunService.RenderStepped:Connect(function()
        if pingDisplay.label and pingDisplay.enabled then
            local ping = math.floor(updatePing())
            pingDisplay.label.Text = "📶 " .. ping .. " ms"
        end
    end)
end

-- ========================================
-- WARNING "!" (SEDERHANA)
-- ========================================
local warningGui = nil
local warningLabel = nil
local warningEnabled = true
local warningSize = 200
local warningDuration = 0.4

-- INPUT DELAY (bisa diatur)
local warningDelay = 0 -- default 0 (langsung)
local lastWarningTime = 0
local warningCooldown = 0.1

local function createWarning()
    if warningGui then
        warningGui:Destroy()
    end
    
    warningGui = Instance.new("ScreenGui")
    warningGui.Name = "AttackWarning"
    warningGui.ResetOnSpawn = false
    warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    warningGui.DisplayOrder = 999999
    warningGui.Parent = PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 300)
    frame.Position = UDim2.new(0.5, -150, 0.4, -150)
    frame.BackgroundTransparency = 1
    frame.Parent = warningGui
    
    warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(1, 0, 1, 0)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "!"
    warningLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    warningLabel.TextSize = warningSize
    warningLabel.Font = Enum.Font.GothamBlack
    warningLabel.TextStrokeTransparency = 0
    warningLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    warningLabel.TextTransparency = 1
    warningLabel.Parent = frame
end

local function showWarning()
    local now = tick()
    if now - lastWarningTime < warningCooldown then return end
    lastWarningTime = now
    
    if not warningEnabled then return end
    if not warningGui or not warningLabel then
        createWarning()
        task.wait(0.05)
    end
    
    -- Reset
    warningLabel.TextTransparency = 0
    warningLabel.TextSize = warningSize * 0.7
    warningLabel.Rotation = -3
    
    -- Animasi masuk
    local tweenIn = TweenService:Create(warningLabel, 
        TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {TextSize = warningSize, Rotation = 3}
    )
    tweenIn:Play()
    
    -- Animasi keluar
    task.delay(warningDuration - 0.1, function()
        if not warningLabel then return end
        local tweenOut = TweenService:Create(warningLabel, 
            TweenInfo.new(0.1), 
            {TextTransparency = 1, TextSize = warningSize * 0.5}
        )
        tweenOut:Play()
    end)
end

-- ========================================
-- SOUND DETECTION (EFISIEN)
-- ========================================
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local soundHooks = {}

local function extractSoundId(sound)
    if not sound then return nil end
    return tostring(sound.SoundId):match("%d+")
end

local function onKillerSound(sound)
    if not warningEnabled then return end
    
    local id = extractSoundId(sound)
    if id and autoBlockTriggerSounds[id] then
        -- APPLY DELAY JIKA ADA
        if warningDelay > 0 then
            task.wait(warningDelay)
        end
        showWarning()
    end
end

local function setupKillerHooks(killer)
    if not killer or not killer:IsA("Model") then return end
    
    for _, sound in pairs(killer:GetDescendants()) do
        if sound:IsA("Sound") and not soundHooks[sound] then
            local conn = sound.Played:Connect(function()
                onKillerSound(sound)
            end)
            soundHooks[sound] = conn
            
            -- Cek jika sudah playing
            if sound.IsPlaying then
                onKillerSound(sound)
            end
        end
    end
    
    -- Hook sound baru
    killer.DescendantAdded:Connect(function(desc)
        task.wait(0.1)
        if desc:IsA("Sound") and not soundHooks[desc] then
            local conn = desc.Played:Connect(function()
                onKillerSound(desc)
            end)
            soundHooks[desc] = conn
        end
    end)
end

-- ========================================
-- CONTROL UI (SEDERHANA)
-- ========================================
local controlGui = nil

local function createControlUI()
    if controlGui then
        controlGui:Destroy()
    end
    
    controlGui = Instance.new("ScreenGui")
    controlGui.Name = "WarningControl"
    controlGui.ResetOnSpawn = false
    controlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    controlGui.DisplayOrder = 999998
    controlGui.Parent = PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 160, 0, 130)
    frame.Position = UDim2.new(1, -170, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = controlGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ WARNING"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local yPos = 35
    
    -- Toggle Warning
    local warnBtn = Instance.new("TextButton")
    warnBtn.Size = UDim2.new(1, -20, 0, 30)
    warnBtn.Position = UDim2.new(0, 10, 0, yPos)
    warnBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    warnBtn.BorderSizePixel = 0
    warnBtn.Text = "🔊 ON"
    warnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnBtn.TextSize = 12
    warnBtn.Font = Enum.Font.GothamBold
    warnBtn.Parent = frame
    Instance.new("UICorner", warnBtn).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 35
    
    -- Toggle Ping Display
    local pingBtn = Instance.new("TextButton")
    pingBtn.Size = UDim2.new(1, -20, 0, 30)
    pingBtn.Position = UDim2.new(0, 10, 0, yPos)
    pingBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    pingBtn.BorderSizePixel = 0
    pingBtn.Text = "📶 ON"
    pingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pingBtn.TextSize = 12
    pingBtn.Font = Enum.Font.GothamBold
    pingBtn.Parent = frame
    Instance.new("UICorner", pingBtn).CornerRadius = UDim.new(0, 6)
    
    yPos = yPos + 35
    
    -- Delay Input
    local delayFrame = Instance.new("Frame")
    delayFrame.Size = UDim2.new(1, -20, 0, 30)
    delayFrame.Position = UDim2.new(0, 10, 0, yPos)
    delayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    delayFrame.BorderSizePixel = 0
    delayFrame.Parent = frame
    Instance.new("UICorner", delayFrame).CornerRadius = UDim.new(0, 6)
    
    local delayLabel = Instance.new("TextLabel")
    delayLabel.Size = UDim2.new(0.5, 0, 1, 0)
    delayLabel.Position = UDim2.new(0, 5, 0, 0)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Text = "Delay:"
    delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    delayLabel.TextSize = 12
    delayLabel.Font = Enum.Font.GothamBold
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left
    delayLabel.Parent = delayFrame
    
    local delayValue = Instance.new("TextLabel")
    delayValue.Size = UDim2.new(0.3, 0, 1, 0)
    delayValue.Position = UDim2.new(0.5, 0, 0, 0)
    delayValue.BackgroundTransparency = 1
    delayValue.Text = "0.0s"
    delayValue.TextColor3 = Color3.fromRGB(255, 255, 100)
    delayValue.TextSize = 12
    delayValue.Font = Enum.Font.GothamBold
    delayValue.Parent = delayFrame
    
    local delayBtn = Instance.new("TextButton")
    delayBtn.Size = UDim2.new(0.2, -5, 1, -4)
    delayBtn.Position = UDim2.new(0.8, 0, 0, 2)
    delayBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    delayBtn.BorderSizePixel = 0
    delayBtn.Text = "⚙️"
    delayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    delayBtn.TextSize = 12
    delayBtn.Font = Enum.Font.GothamBold
    delayBtn.Parent = delayFrame
    Instance.new("UICorner", delayBtn).CornerRadius = UDim.new(0, 4)
    
    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -27, 0, 6)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minBtn.BorderSizePixel = 0
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 14
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = frame
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)
    
    -- ========================================
    -- BUTTON FUNCTIONS
    -- ========================================
    
    -- Toggle Warning
    warnBtn.MouseButton1Click:Connect(function()
        warningEnabled = not warningEnabled
        warnBtn.BackgroundColor3 = warningEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(150, 150, 150)
        warnBtn.Text = warningEnabled and "🔊 ON" or "🔇 OFF"
    end)
    
    -- Toggle Ping Display
    pingBtn.MouseButton1Click:Connect(function()
        pingDisplay.enabled = not pingDisplay.enabled
        pingBtn.BackgroundColor3 = pingDisplay.enabled and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
        pingBtn.Text = pingDisplay.enabled and "📶 ON" or "📶 OFF"
        if pingDisplay.gui then
            pingDisplay.gui.Enabled = pingDisplay.enabled
        end
    end)
    
    -- Delay Setting (cycle: 0.0 -> 0.1 -> 0.2 -> 0.3 -> 0.5 -> 1.0 -> 0.0)
    local delayOptions = {0, 0.1, 0.2, 0.3, 0.5, 1.0}
    local delayIndex = 1
    
    delayBtn.MouseButton1Click:Connect(function()
        delayIndex = delayIndex + 1
        if delayIndex > #delayOptions then
            delayIndex = 1
        end
        warningDelay = delayOptions[delayIndex]
        delayValue.Text = string.format("%.1fs", warningDelay)
        
        -- Animasi button
        delayBtn.Size = UDim2.new(0.2, -5, 1, -8)
        task.wait(0.05)
        delayBtn.Size = UDim2.new(0.2, -5, 1, -4)
    end)
    
    -- Minimize
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        frame.Size = minimized and UDim2.new(0, 160, 0, 35) or UDim2.new(0, 160, 0, 130)
        minBtn.Text = minimized and "+" or "−"
        warnBtn.Visible = not minimized
        pingBtn.Visible = not minimized
        delayFrame.Visible = not minimized
    end)
end

-- ========================================
-- INITIALIZATION
-- ========================================
createControlUI()
createWarning()
createPingDisplay()

-- Setup hooks untuk semua killer
for _, killer in pairs(KillersFolder:GetChildren()) do
    task.spawn(setupKillerHooks, killer)
end

-- Monitor killer baru
KillersFolder.ChildAdded:Connect(function(killer)
    task.wait(0.5)
    task.spawn(setupKillerHooks, killer)
end)

-- Notifikasi singkat
task.spawn(function()
    task.wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ WARNING";
        Text = "Minimal Mode + Delay";
        Duration = 1.5;
    })
end)
