if getgenv().DaraHubMovementExecuted then return end
getgenv().DaraHubMovementExecuted = true

-- ==============================================================================
-- 1. BUTTON LIBRARY (Tombol Mengambang)
-- ==============================================================================
local ButtonLib = {}
local CoreGui = game:GetService("CoreGui")
local camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

getgenv().ButtonLib = ButtonLib

local DraggingSystem = {}
function DraggingSystem.GetDistance(pos1, pos2) return math.sqrt((pos2.X - pos1.X)^2 + (pos2.Y - pos1.Y)^2) end
function DraggingSystem.IsMouseOverFrame(Frame, Position)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Position.X >= AbsPos.X and Position.X <= AbsPos.X + AbsSize.X and Position.Y >= AbsPos.Y and Position.Y <= AbsPos.Y + AbsSize.Y
end
function DraggingSystem.IsClickInput(Input)
    return Input.UserInputState == Enum.UserInputState.Begin and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
end
function DraggingSystem.MakeDraggable(MainFrame, DragFrame, CallbackTable)
    if not MainFrame or not DragFrame then return end
    local dragging, dragStart, startPos, dragDistance = false, nil, nil, 0
    local DRAG_THRESHOLD = 5
    local originalZIndex = MainFrame.ZIndex
    local isDraggingStarted, currentTouch = false, nil
    
    local function updatePosition(input)
        if not dragging or not dragStart then return end
        local delta = input.Position - dragStart
        dragDistance = math.sqrt(delta.X^2 + delta.Y^2)
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    local function resetDragState() dragging = false; dragStart = nil; startPos = nil; dragDistance = 0; isDraggingStarted = false; currentTouch = nil end
    local mouseButton1Connection, touchEndedConnection, movementConnection = nil, nil, nil
    
    local function onInputEnded()
        if dragging then
            local wasDragged = dragDistance > DRAG_THRESHOLD
            if not wasDragged and CallbackTable and CallbackTable.OnClick then CallbackTable.OnClick() end
            if wasDragged and isDraggingStarted then MainFrame.ZIndex = originalZIndex end
            resetDragState()
            if mouseButton1Connection then mouseButton1Connection:Disconnect(); mouseButton1Connection = nil end
            if touchEndedConnection then touchEndedConnection:Disconnect(); touchEndedConnection = nil end
            if movementConnection then movementConnection:Disconnect(); movementConnection = nil end
        end
    end
    local function onMovement(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == currentTouch) then
            if not isDraggingStarted and dragDistance > DRAG_THRESHOLD then
                isDraggingStarted = true
                local maxZIndex = 0
                local darahubGui = CoreGui:FindFirstChild("Darahub")
                if darahubGui then
                    for _, child in ipairs(darahubGui:GetChildren()) do
                        if child:IsA("Frame") and child ~= MainFrame and child.Visible and child.ZIndex > maxZIndex then maxZIndex = child.ZIndex end
                    end
                end
                MainFrame.ZIndex = maxZIndex + 1
                originalZIndex = MainFrame.ZIndex
            end
            updatePosition(input)
        end
    end
    local function onInputBegan(input)
        if DraggingSystem.IsClickInput(input) and not dragging then
            if DraggingSystem.IsMouseOverFrame(DragFrame, input.Position) then
                dragging = true; dragStart = input.Position; startPos = MainFrame.Position; dragDistance = 0; isDraggingStarted = false
                if input.UserInputType == Enum.UserInputType.Touch then currentTouch = input else currentTouch = nil end
                mouseButton1Connection = UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == Enum.UserInputType.MouseButton1 then onInputEnded() end end)
                touchEndedConnection = UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == Enum.UserInputType.Touch then onInputEnded() end end)
                movementConnection = UserInputService.InputChanged:Connect(function(moveInput) if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then onMovement(moveInput) end end)
            end
        end
    end
    local inputBeganConnection = DragFrame.InputBegan:Connect(onInputBegan)
    return function()
        inputBeganConnection:Disconnect()
        if mouseButton1Connection then mouseButton1Connection:Disconnect() end
        if touchEndedConnection then touchEndedConnection:Disconnect() end
        if movementConnection then movementConnection:Disconnect() end
    end
end

function getDPIScale() return camera.ViewportSize.Y / 1080 end
ButtonLib.Create = {}
ButtonLib._elements = {}

function buildBaseFrame(config)
    local darahubGui = CoreGui:FindFirstChild("Darahub") or Instance.new("ScreenGui", CoreGui)
    darahubGui.Name = "Darahub"; darahubGui.IgnoreGuiInset = true; darahubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local frame = Instance.new("Frame")
    local flag = config.Flag or config.Text or "Element"
    frame.Name = flag; frame.Parent = darahubGui; frame.Visible = config.Visible ~= false; frame.Active = true
    frame.Size = UDim2.new(0, 250, 0, 90); frame.Position = config.Position or UDim2.new(0.5, -125, 0.5, -45)
    frame.BackgroundColor3 = Color3.new(1, 1, 1); frame.BackgroundTransparency = 0.2; frame.ZIndex = config.ZIndex or 1
    Instance.new("UIScale", frame).Scale = getDPIScale()
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local strokeB = Instance.new("UIStroke", frame); strokeB.Thickness = 2; strokeB.Color = Color3.new(0,0,0)
    local strokeW = Instance.new("UIStroke", frame); strokeW.Thickness = 1; strokeW.Color = Color3.new(1,1,1)
    local grad = Instance.new("UIGradient", frame); grad.Rotation = 90; grad.Color = ColorSequence.new(Color3.fromRGB(47, 47, 47), Color3.new(0, 0, 0))
    local textButton = Instance.new("TextButton", frame); textButton.Size = UDim2.new(1, 0, 1, 0); textButton.BackgroundTransparency = 1; textButton.Text = ""; textButton.AutoButtonColor = false; textButton.ZIndex = 10
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -20, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1, 1, 1); label.TextScaled = true; label.Font = Enum.Font.FredokaOne; label.ZIndex = 5; label.Text = config.Text or "Button"
    local api = {}
    function api:Destroy() frame:Destroy() end
    function api:SetVisible(visible) frame.Visible = visible end
    function api:SetText(newText) label.Text = newText end
    return api, frame, textButton, label, flag
end

function ButtonLib.Create:Toggle(config)
    local api, frame, textButton, label, flag = buildBaseFrame(config)
    local callback = config.Callback or function() end
    local baseText = config.Text or "Toggle"
    local state = config.Default or false
    local function updateUI() label.Text = baseText .. (state and " : ON" or " : OFF") end
    updateUI()
    function api:Set(val) state = val; updateUI(); pcall(callback, state) end
    DraggingSystem.MakeDraggable(frame, textButton, { OnClick = function() api:Set(not state) end })
    getgenv().ButtonLib[flag] = api
    return api
end

-- ==============================================================================
-- 2. SERVICES & VARIABEL
-- ==============================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local autoJumpEnabled = false
local bhopHoldEnabled = false
local autoJumpType = "Simulation"
local bhopMode = "Acceleration"
local currentFriction = -0.2
local lastFriction = nil

local originalMovementUpdate = nil

local function MovementValueSet(MovementType, value)
    local char = LocalPlayer.Character
    if not char then return end
    local CharacterTag = char:GetAttribute("Tag")
    if not CharacterTag then return end
    firesignal(ReplicatedStorage.Events.CharacterTask.OnClientEvent, 
        CharacterTag, "ModifyMovement", { MovementType, value }
    )
end

local function updateBhopState()
    local shouldEnable = autoJumpEnabled or bhopHoldEnabled
    MovementValueSet("BhopEnabled", shouldEnable)
    if not shouldEnable then
        MovementValueSet("Friction", 5)
        lastFriction = 5
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HipHeight = char:FindFirstChild("R15Visual") and 0.75 or -1.25
            end
        end
    end
end

local Movement = require(ReplicatedStorage:WaitForChild("Objects"):WaitForChild("Game"):WaitForChild("Character"):WaitForChild("Client"):WaitForChild("Movement"))
originalMovementUpdate = Movement.Update

Movement.Update = function(self, ...)
    originalMovementUpdate(self, ...)
    local char = self.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local grounded = self.DataRegistry:Get("Grounded")
    
    -- Logika DaraHub: Bhop hanya dianggap aktif jika Auto Jump aktif, ATAU Hold Jump aktif DAN tombol lompat ditekan
    local isBhopActive = autoJumpEnabled or (bhopHoldEnabled and humanoid.Jump == true)

    -- 1. LOGIKA FRICTION DARAHUB ASLI
    local desiredFriction = nil
    if isBhopActive and not grounded and bhopMode == "Acceleration" then
        desiredFriction = currentFriction
    end
    
    if desiredFriction ~= lastFriction then
        if desiredFriction ~= nil then
            MovementValueSet("Friction", desiredFriction)
        else
            MovementValueSet("Friction", 5)
        end
        lastFriction = desiredFriction
    end

    -- 2. PHANTOMWRYM PHYSICS EXPLOIT (Hanya berjalan saat isBhopActive true)
    if isBhopActive then
        if bhopMode == "Acceleration" then
            local targetHipHeight = -1.10
            if char:FindFirstChild("R15Visual") then targetHipHeight = 0.9 end
            if humanoid.HipHeight ~= targetHipHeight then
                humanoid.HipHeight = targetHipHeight
            end
            local currentVel = hrp.AssemblyLinearVelocity
            local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z)
            if horizontalVel.Magnitude > 1 then
                local boost = horizontalVel.Unit * 2.5
                hrp.AssemblyLinearVelocity = Vector3.new(currentVel.X + boost.X, currentVel.Y, currentVel.Z + boost.Z)
            end
        end

        -- 3. EKSEKUSI LOMPAT (Logika DaraHub Asli)
        if grounded then
            if autoJumpEnabled then
                if autoJumpType == "Realistic" then
                    pcall(function() self:AttemptJump() end)
                else
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            elseif bhopHoldEnabled then
                -- Ini akan memicu lompatan selama menahan tombol jump
                pcall(function() self:AttemptJump() end)
            end
        end
    end
end

-- ==============================================================================
-- 3. LOGIKA VISUALS (DaraHub)
-- ==============================================================================
local ServerStateRegistryService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Data"):WaitForChild("ServerStateRegistryService"))

local originalFogEnd = Lighting.FogEnd
local originalAtmospheres = {}
for _, v in pairs(Lighting:GetDescendants()) do
    if v:IsA("Atmosphere") then table.insert(originalAtmospheres, v) end
end

local function startNoFog()
    originalFogEnd = Lighting.FogEnd
    Lighting.FogEnd = 1000000
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then v:Destroy() end
    end
end

local function stopNoFog()
    Lighting.FogEnd = originalFogEnd
    for _, atmosphere in pairs(originalAtmospheres) do
        if not atmosphere.Parent then
            local newAtmosphere = Instance.new("Atmosphere")
            for _, prop in pairs({"Density", "Offset", "Color", "Decay", "Glare", "Haze"}) do
                if atmosphere[prop] then newAtmosphere[prop] = atmosphere[prop] end
            end
            newAtmosphere.Parent = Lighting
        end
    end
end

local fullBrightConnection
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalColorShiftBottom = Lighting.ColorShift_Bottom
local originalColorShiftTop = Lighting.ColorShift_Top

local function applyFullBright()
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
end

-- Timer Display Logic
local TimerGUI = nil
local TimerEnabled = false
local SpecialRoundEnabled = false
local CheckingGameTimer = false

local function GetRoundTitle(roundName)
    if not roundName or roundName == "" then return "" end
    local specialRoundsFolder = ReplicatedStorage:FindFirstChild("Info")
    if not specialRoundsFolder then return roundName end
    specialRoundsFolder = specialRoundsFolder:FindFirstChild("SpecialRounds")
    if not specialRoundsFolder then return roundName end
    local roundModule = specialRoundsFolder:FindFirstChild(roundName)
    if not roundModule then return roundName end
    local success, moduleData = pcall(function() return require(roundModule) end)
    if success and moduleData and moduleData.Title then return moduleData.Title end
    return roundName
end

local function SetTime(seconds)
    if not TimerGUI then return end
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = math.floor(seconds % 60)
    TimerGUI.TimeDisplay.Text = string.format("%d:%02d", minutes, remainingSeconds)
end

local function SetStatus(text)
    if not TimerGUI then return end
    TimerGUI.StatusLabel.Text = text:upper()
end

local function SetSpecialRound(roundName)
    if not TimerGUI then return end
    if roundName and roundName ~= "" then
        TimerGUI.SpecialRoundLabel.Text = GetRoundTitle(roundName)
        TimerGUI.SpecialRound.Visible = SpecialRoundEnabled
    else
        TimerGUI.SpecialRound.Visible = false
    end
end

local function CheckGameTimerVisibility()
    if not TimerEnabled or not TimerGUI then if TimerGUI then TimerGUI.MainTimer.Visible = false end return end
    local hud = LocalPlayer.PlayerGui:FindFirstChild("Shared")
    if hud then hud = hud:FindFirstChild("HUD") end
    if hud then hud = hud:FindFirstChild("Overlay") end
    if hud then hud = hud:FindFirstChild("Default") end
    if hud then hud = hud:FindFirstChild("RoundOverlay") end
    if hud then hud = hud:FindFirstChild("Round") end
    local roundTimer = hud and hud:FindFirstChild("RoundTimer")
    if roundTimer and roundTimer.Visible then
        TimerGUI.MainTimer.Visible = false
    else
        TimerGUI.MainTimer.Visible = true
    end
end

local function UpdateFromAttributes()
    local timerValue = ServerStateRegistryService.Registry.Time
    local specialRoundValue = ServerStateRegistryService.Registry.SpecialRound
    local roundStatus = ServerStateRegistryService.Registry.RoundStatus
    if timerValue and timerValue ~= -1 then SetTime(timerValue) end
    if roundStatus == 2 then SetStatus("Round Active") elseif roundStatus == 1 then SetStatus("Intermission") else SetStatus("Waiting") end
    if specialRoundValue and specialRoundValue ~= false then SetSpecialRound(tostring(specialRoundValue)) else SetSpecialRound("") end
end

local _attributeConnection = nil
local function StartAttributeMonitor()
    if _attributeConnection then _attributeConnection:Disconnect() end
    local lastTimer = ServerStateRegistryService.Registry.Time
    local lastRoundStatus = ServerStateRegistryService.Registry.RoundStatus
    local lastSpecialRound = ServerStateRegistryService.Registry.SpecialRound
    _attributeConnection = RunService.Heartbeat:Connect(function()
        local currentTimer = ServerStateRegistryService.Registry.Time
        local currentRoundStatus = ServerStateRegistryService.Registry.RoundStatus
        local currentSpecialRound = ServerStateRegistryService.Registry.SpecialRound
        if currentTimer ~= lastTimer or currentRoundStatus ~= lastRoundStatus or currentSpecialRound ~= lastSpecialRound then
            lastTimer = currentTimer; lastRoundStatus = currentRoundStatus; lastSpecialRound = currentSpecialRound
            UpdateFromAttributes()
        end
    end)
    UpdateFromAttributes()
end

local function createTimerGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TimerGUI"; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ScreenGui.Parent = PlayerGui
    
    local Timer = Instance.new("Frame"); Timer.Name = "Timer"; Timer.BackgroundTransparency = 1; Timer.Size = UDim2.new(1, 0, 1, 0); Timer.Parent = ScreenGui
    
    local Top = Instance.new("Frame"); Top.Name = "Top"; Top.AnchorPoint = Vector2.new(0.5, 0); Top.BackgroundTransparency = 1; Top.Position = UDim2.new(0.5, 0, 0, 0); Top.Size = UDim2.new(1, 0, 1, 0); Top.Parent = Timer
    Instance.new("UIAspectRatioConstraint", Top)
    local SizeConstraint = Instance.new("UISizeConstraint", Top); SizeConstraint.MaxSize = Vector2.new(900, 900)
    
    local MainTimer = Instance.new("Frame"); MainTimer.Name = "MainTimer"; MainTimer.AnchorPoint = Vector2.new(0.5, 0); MainTimer.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainTimer.BackgroundTransparency = 0.6; MainTimer.BorderSizePixel = 0; MainTimer.Position = UDim2.new(0.5, 0, 0.04, 0); MainTimer.Size = UDim2.new(0.25, 0, 0.1, 0); MainTimer.Visible = false; MainTimer.Parent = Top
    Instance.new("UICorner", MainTimer).CornerRadius = UDim.new(0, 4)
    
    local MainTimerImage = Instance.new("ImageLabel"); MainTimerImage.Image = "rbxassetid://196969716"; MainTimerImage.ImageColor3 = Color3.fromRGB(21, 21, 21); MainTimerImage.ImageTransparency = 0.7; MainTimerImage.AnchorPoint = Vector2.new(0.5, 0.5); MainTimerImage.BackgroundTransparency = 1; MainTimerImage.Position = UDim2.new(0.5, 0, 0.5, 0); MainTimerImage.Size = UDim2.new(1, 0, 1, 0); MainTimerImage.ZIndex = 0; MainTimerImage.Parent = MainTimer
    Instance.new("UICorner", MainTimerImage).CornerRadius = UDim.new(0, 4)
    
    local StatusLabel = Instance.new("TextLabel"); StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold); StatusLabel.Text = "ROUND ACTIVE"; StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255); StatusLabel.TextScaled = true; StatusLabel.TextStrokeTransparency = 0.95; StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5); StatusLabel.BackgroundTransparency = 1; StatusLabel.Position = UDim2.new(0.5, 0, 0.25, 0); StatusLabel.Size = UDim2.new(0.8, 0, 0.25, 0); StatusLabel.ZIndex = 3; StatusLabel.Parent = MainTimer
    Instance.new("UIStroke", StatusLabel).Thickness = 2
    
    local TimeDisplay = Instance.new("TextLabel"); TimeDisplay.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold); TimeDisplay.Text = "0:00"; TimeDisplay.TextColor3 = Color3.fromRGB(165, 194, 255); TimeDisplay.TextScaled = true; TimeDisplay.TextStrokeTransparency = 0.95; TimeDisplay.AnchorPoint = Vector2.new(0.5, 0.5); TimeDisplay.BackgroundTransparency = 1; TimeDisplay.Position = UDim2.new(0.5, 0, 0.65, 0); TimeDisplay.Size = UDim2.new(0.5, 0, 0.5, 0); TimeDisplay.ZIndex = 3; TimeDisplay.Parent = MainTimer
    Instance.new("UIStroke", TimeDisplay).Thickness = 3
    
    local SpecialRound = Instance.new("Frame"); SpecialRound.Name = "SpecialRound"; SpecialRound.AnchorPoint = Vector2.new(0.5, 0); SpecialRound.BackgroundColor3 = Color3.fromRGB(0, 0, 0); SpecialRound.BackgroundTransparency = 0.6; SpecialRound.BorderSizePixel = 0; SpecialRound.Position = UDim2.new(0.5, 0, 0.15, 0); SpecialRound.Size = UDim2.new(0.23, 0, 0.05, 0); SpecialRound.Visible = false; SpecialRound.Parent = Top
    Instance.new("UICorner", SpecialRound).CornerRadius = UDim.new(0, 4)
    
    local SpecialRoundLabel = Instance.new("TextLabel"); SpecialRoundLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold); SpecialRoundLabel.Text = "No Data"; SpecialRoundLabel.TextColor3 = Color3.fromRGB(255, 208, 115); SpecialRoundLabel.TextScaled = true; SpecialRoundLabel.TextStrokeTransparency = 0.95; SpecialRoundLabel.AnchorPoint = Vector2.new(0.5, 0.5); SpecialRoundLabel.BackgroundTransparency = 1; SpecialRoundLabel.Position = UDim2.new(0.5, 0, 0.5, 0); SpecialRoundLabel.Size = UDim2.new(0.9, 0, 0.6, 0); SpecialRoundLabel.ZIndex = 3; SpecialRoundLabel.Parent = SpecialRound
    Instance.new("UIStroke", SpecialRoundLabel).Thickness = 2
    
    TimerGUI = { ScreenGui = ScreenGui, TimeDisplay = TimeDisplay, SpecialRoundLabel = SpecialRoundLabel, StatusLabel = StatusLabel, MainTimer = MainTimer, SpecialRound = SpecialRound }
    
    task.spawn(function()
        while CheckingGameTimer do CheckGameTimerVisibility() wait(0.1) end
    end)
end

local function destroyTimerGUI()
    if _attributeConnection then _attributeConnection:Disconnect(); _attributeConnection = nil end
    CheckingGameTimer = false
    if TimerGUI then TimerGUI.ScreenGui:Destroy(); TimerGUI = nil end
end

local function handleTimerToggles()
    if not TimerEnabled and not SpecialRoundEnabled then
        destroyTimerGUI()
    else
        if not TimerGUI then createTimerGUI() end
        if TimerEnabled then
            TimerGUI.MainTimer.Visible = true
            StartAttributeMonitor()
            CheckingGameTimer = true
        end
        if SpecialRoundEnabled then
            TimerGUI.SpecialRound.Visible = true
        end
    end
end

-- Player Stats Logic
local useCurrency = require(ReplicatedStorage.Shared.UserData.ClientHooks.useCurrency)
local useProgression = require(ReplicatedStorage.Shared.UserData.ClientHooks.useProgression)
local useEvent = require(ReplicatedStorage.Shared.UserData.ClientHooks.useEvent)

local PlayerStatsEnabled = false
local PlayerStats = nil
local textLabels = {}
local frontFrames = {}
local observeConnections = {}

local function formatNumber(num)
    local str = tostring(math.floor(num)); local formatted = ""; local length = #str
    for i = 1, length do
        formatted = formatted .. str:sub(i, i)
        if (length - i) % 3 == 0 and i ~= length then formatted = formatted .. "," end
    end
    return formatted
end

local function updateFrontFrameXSize(frame, textLabel)
    if frame and textLabel then frame.Size = UDim2.new(0, textLabel.TextBounds.X + 20, 1, 0) end
end

local function createResourceRow(name, defaultValue, textColor, iconAssetId, iconColor, layoutOrder, leftColumn)
    local container = Instance.new("Frame"); container.Name = name; container.BackgroundTransparency = 1; container.Size = UDim2.fromScale(1, 1); container.LayoutOrder = layoutOrder; container.Parent = leftColumn
    local background = Instance.new("ImageLabel"); background.BackgroundTransparency = 1; background.Image = "rbxassetid://196969716"; background.ImageColor3 = Color3.fromRGB(21, 21, 21); background.ImageTransparency = 0.4; background.AnchorPoint = Vector2.new(0.5, 0.5); background.Position = UDim2.fromScale(0.5, 0.5); background.Size = UDim2.fromScale(1.25, 1.25); background.Parent = container
    Instance.new("UICorner", background).CornerRadius = UDim.new(0, 4)
    local icon = Instance.new("ImageLabel"); icon.BackgroundTransparency = 1; icon.Image = "rbxassetid://" .. iconAssetId; if iconColor then icon.ImageColor3 = iconColor end; icon.AnchorPoint = Vector2.new(0.5, 0.5); icon.Position = UDim2.fromScale(0.5, 0.5); icon.Size = UDim2.fromScale(0.8, 0.8); icon.Parent = container
    Instance.new("UIAspectRatioConstraint", icon)
    local textLabel = Instance.new("TextLabel"); textLabel.BackgroundTransparency = 1; textLabel.Font = Enum.Font.GothamBold; textLabel.Text = tostring(defaultValue); textLabel.TextColor3 = textColor; textLabel.TextScaled = true; textLabel.TextStrokeTransparency = 0.9; textLabel.TextXAlignment = Enum.TextXAlignment.Left; textLabel.AnchorPoint = Vector2.new(0, 0.5); textLabel.Position = UDim2.new(1.3, 0, 0.5, 0); textLabel.Size = UDim2.new(6, 0, 0.8, 0); textLabel.Parent = container
    textLabels[name] = textLabel
    Instance.new("UIStroke", textLabel).Thickness = 2
    local clipFront = Instance.new("Frame"); clipFront.Name = "Front"; clipFront.BackgroundTransparency = 1; clipFront.ClipsDescendants = true; clipFront.Position = UDim2.new(1, 0, 0, 0); clipFront.Size = UDim2.new(0.5, 33, 1, 0); clipFront.Parent = container
    local frontEffect = Instance.new("Frame"); frontEffect.BackgroundColor3 = Color3.new(0, 0, 0); frontEffect.BackgroundTransparency = 0.9; frontEffect.Position = UDim2.new(-1, 0, 0, 0); frontEffect.Size = UDim2.new(2, 0, 1, 0); frontEffect.Parent = clipFront
    Instance.new("UICorner", frontEffect).CornerRadius = UDim.new(0, 4)
    frontFrames[name] = { frame = clipFront, effect = frontEffect, textLabel = textLabel }
    task.spawn(function() task.wait() updateFrontFrameXSize(clipFront, textLabel) end)
end

local function DisableScanData()
    PlayerStatsEnabled = false
    for _, disconnect in pairs(observeConnections) do if type(disconnect) == "function" then disconnect() end end
    observeConnections = {}
    if PlayerStats then PlayerStats.ScreenGui:Destroy(); PlayerStats = nil end
    textLabels = {}; frontFrames = {}
end

local function EnableScanData()
    if PlayerStats then DisableScanData() end
    local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "PlayerStats"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 333; ScreenGui.Parent = PlayerGui
    local views = Instance.new("Frame"); views.BackgroundTransparency = 1; views.Size = UDim2.fromScale(1, 1); views.Position = UDim2.fromScale(0.5, 0.5); views.AnchorPoint = Vector2.new(0.5, 0.5); views.Parent = ScreenGui
    local defaultView = Instance.new("Frame"); defaultView.BackgroundTransparency = 1; defaultView.Size = UDim2.fromScale(1, 1); defaultView.Parent = views
    local bottom = Instance.new("Frame"); bottom.BackgroundTransparency = 1; bottom.Position = UDim2.fromScale(0.01, 0.01); bottom.Size = UDim2.fromScale(0.98, 0.98); bottom.Parent = defaultView
    Instance.new("UIAspectRatioConstraint", bottom)
    local sizeConstraint = Instance.new("UISizeConstraint", bottom); sizeConstraint.MinSize = Vector2.new(450, 450); sizeConstraint.MaxSize = Vector2.new(700, 700)
    local leftColumn = Instance.new("Frame"); leftColumn.BackgroundTransparency = 1; leftColumn.Position = UDim2.new(0.004, 0, 0.06, 0); leftColumn.Size = UDim2.new(0.05, 0, 0.05, 0); leftColumn.Parent = bottom
    local listLayout = Instance.new("UIListLayout", leftColumn); listLayout.Padding = UDim.new(0.175, 0); listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    createResourceRow("Tokens", "0", Color3.fromRGB(163, 255, 87), "7149239101", Color3.fromRGB(163, 255, 87), 1, leftColumn)
    createResourceRow("Points", "0", Color3.new(1, 1, 1), "4648327306", nil, 2, leftColumn)
    createResourceRow("Survivals", "0", Color3.fromRGB(255, 188, 110), "88681516628510", Color3.fromRGB(255, 201, 162), 3, leftColumn)
    createResourceRow("Tickets", "0", Color3.fromRGB(255, 121, 121), "14478137255", Color3.fromRGB(255, 115, 115), 4, leftColumn)
    createResourceRow("Streak", "0", Color3.fromRGB(255, 217, 78), "13518130183", Color3.fromRGB(255, 217, 78), 5, leftColumn)
    
    local levelBar = Instance.new("Frame"); levelBar.BackgroundColor3 = Color3.fromRGB(105, 138, 255); levelBar.BackgroundTransparency = 0.9; levelBar.Position = UDim2.new(0, 4, 0, 4); levelBar.Size = UDim2.new(0.7, 0, 0.016, 0); levelBar.Parent = bottom
    Instance.new("UICorner", levelBar).CornerRadius = UDim.new(0.5, 0)
    Instance.new("UIStroke", levelBar).Thickness = 2
    local barContainer = Instance.new("Frame"); barContainer.BackgroundTransparency = 1; barContainer.ClipsDescendants = true; barContainer.Size = UDim2.new(1, 0, 1, 0); barContainer.Parent = levelBar
    local fill = Instance.new("Frame"); fill.BackgroundColor3 = Color3.fromRGB(105, 138, 255); fill.BackgroundTransparency = 0.2; fill.Size = UDim2.new(0, 0, 1, 0); fill.Parent = barContainer
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0.5, 0)
    local gradient = Instance.new("UIGradient", fill); gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.3149, Color3.fromRGB(241, 246, 249)), ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 201, 222))}); gradient.Rotation = 90
    local levelText = Instance.new("TextLabel"); levelText.BackgroundTransparency = 1; levelText.Font = Enum.Font.GothamBold; levelText.Text = "LEVEL 1"; levelText.TextColor3 = Color3.fromRGB(105, 138, 255); levelText.TextScaled = true; levelText.TextXAlignment = Enum.TextXAlignment.Left; levelText.TextYAlignment = Enum.TextYAlignment.Bottom; levelText.Position = UDim2.new(0, 0, 1.25, 0); levelText.Size = UDim2.new(0.5, 0, 1.5, 0); levelText.Parent = levelBar
    Instance.new("UIStroke", levelText).Thickness = 2
    local expText = Instance.new("TextLabel"); expText.BackgroundTransparency = 1; expText.Font = Enum.Font.GothamBold; expText.Text = "0/100"; expText.TextColor3 = Color3.fromRGB(105, 138, 255); expText.TextScaled = true; expText.TextXAlignment = Enum.TextXAlignment.Right; expText.TextYAlignment = Enum.TextYAlignment.Bottom; expText.AnchorPoint = Vector2.new(1, 0); expText.Position = UDim2.new(1, 0, 1.25, 0); expText.Size = UDim2.new(0.5, 0, 1.25, 0); expText.Parent = levelBar
    Instance.new("UIStroke", expText).Thickness = 2
    
    PlayerStats = { ScreenGui = ScreenGui, levelText = levelText, expText = expText, fill = fill }
    PlayerStatsEnabled = true
    
    local function updateCurrencyUI()
        local allCurrencies = useCurrency.All()
        if textLabels["Tokens"] then textLabels["Tokens"].Text = formatNumber(allCurrencies["Tokens"] or 0) end
        if textLabels["Points"] then textLabels["Points"].Text = formatNumber(allCurrencies["Points"] or 0) end
        if textLabels["Survivals"] then textLabels["Survivals"].Text = formatNumber(allCurrencies["Survivals"] or 0) end
        if textLabels["Streak"] then textLabels["Streak"].Text = formatNumber(allCurrencies["Streak"] or 0) end
        for _, data in pairs(frontFrames) do updateFrontFrameXSize(data.frame, data.textLabel) end
    end
    local function updateProgressionUI()
        if not PlayerStats then return end
        local level = useProgression.Level(); local xp = useProgression.XP(); local requiredXP = useProgression.RequiredXP() or (level * 100); local progress = useProgression.Progress() or 0
        PlayerStats.levelText.Text = "LEVEL " .. tostring(level); PlayerStats.expText.Text = formatNumber(xp) .. "/" .. formatNumber(requiredXP); PlayerStats.fill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
    end
    local function updateEventUI()
        if textLabels["Tickets"] then textLabels["Tickets"].Text = formatNumber(useEvent.Balance()) local data = frontFrames["Tickets"] if data then updateFrontFrameXSize(data.frame, data.textLabel) end end
    end
    
    table.insert(observeConnections, useCurrency.Observe(updateCurrencyUI))
    table.insert(observeConnections, useProgression.Observe(updateProgressionUI))
    table.insert(observeConnections, useEvent.Observe(updateEventUI))
    updateCurrencyUI(); updateProgressionUI(); updateEventUI()
end

-- ==============================================================================
-- 4. UI WINDUI DARAHUB
-- ==============================================================================
loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/LoadAll.lua"))()
local WindUI = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/WindUI-Moded/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Hub Evade | Hybrid",
    Icon = "rbxassetid://137330250139083",
    Author = "DaraHub Modded",
    Folder = "DaraHub/Games/Evade",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    Acrylic = false,
    HideSearchBar = true,
    SideBarWidth = 180,
    OpenButton = { Enabled = true, Scale = 0.8 }
})

Window:ToggleTransparency(true)
local Tabs = {
    Movement = Window:Tab({ Title = "Movement", Icon = "user" }),
    Visuals = Window:Tab({ Title = "Visuals", Icon = "camera" }),
}

-- TAB MOVEMENT
Tabs.Movement:Section({ Title = "Movement Stats (DaraHub)", TextSize = 18 })
Tabs.Movement:Input({ Title = "Jump Cap", Placeholder = "1", NumbersOnly = true, Value = "1", Callback = function(v) local n=tonumber(v) if n then MovementValueSet("JumpCap", n) end end })
Tabs.Movement:Input({ Title = "Air Strafe Acceleration", Placeholder = "182", NumbersOnly = true, Value = "182", Callback = function(v) local n=tonumber(v) if n then MovementValueSet("AirStrafeAcceleration", n) end end })

Tabs.Movement:Divider()
Tabs.Movement:Section({ Title = "Hybrid Auto Jump (Ramp Bhop)", TextSize = 18 })
Tabs.Movement:Input({ Title = "Friction Value (Accel Mode)", Placeholder = "-0.2", NumbersOnly = true, Value = "-0.2", Callback = function(v) currentFriction = tonumber(v) or -0.2 end })
Tabs.Movement:Dropdown({ Title = "Auto Jump Mode", Values = {"Simulation", "Realistic"}, Value = "Simulation", Callback = function(v) autoJumpType = v end })
Tabs.Movement:Dropdown({ Title = "Bhop Mode", Values = {"Acceleration", "No Acceleration"}, Value = "Acceleration", Callback = function(v) bhopMode = v end })

Tabs.Movement:Divider()
Tabs.Movement:Section({ Title = "Auto Jump Toggles", TextSize = 18 })

Tabs.Movement:Toggle({ Title = "Show Auto Jump Button", Value = false, Callback = function(state)
    if state then
        if not ButtonLib.AutoJumpBtn then
            ButtonLib.AutoJumpBtn = ButtonLib.Create:Toggle({ Text = "Auto Jump", Flag = "AutoJumpBtn", Default = false, Position = UDim2.new(0.5, -125, 0.5, -145), Callback = function(s) autoJumpEnabled = s; updateBhopState() end })
            ButtonLib.AutoJumpBtn:SetVisible(true)
        end
    else
        if ButtonLib.AutoJumpBtn then ButtonLib.AutoJumpBtn:Set(false); ButtonLib.AutoJumpBtn:SetVisible(false) end
    end
end})

Tabs.Movement:Toggle({ Title = "Bhop Hold Jump", Value = false, Callback = function(state)
    bhopHoldEnabled = state
    updateBhopState()
end})

-- TAB VISUALS
Tabs.Visuals:Section({ Title = "World Visuals", TextSize = 18 })
Tabs.Visuals:Toggle({ Title = "Full Bright", Value = false, Callback = function(state)
    if state then
        originalBrightness = Lighting.Brightness; originalAmbient = Lighting.Ambient; originalOutdoorAmbient = Lighting.OutdoorAmbient; originalColorShiftBottom = Lighting.ColorShift_Bottom; originalColorShiftTop = Lighting.ColorShift_Top
        applyFullBright()
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        fullBrightConnection = RunService.Heartbeat:Connect(function() if Lighting.Brightness ~= 1 then applyFullBright() end end)
    else
        if fullBrightConnection then fullBrightConnection:Disconnect(); fullBrightConnection = nil end
        Lighting.Brightness = originalBrightness; Lighting.Ambient = originalAmbient; Lighting.OutdoorAmbient = originalOutdoorAmbient; Lighting.ColorShift_Bottom = originalColorShiftBottom; Lighting.ColorShift_Top = originalColorShiftTop
    end
end})
Tabs.Visuals:Toggle({ Title = "Remove Fog", Value = false, Callback = function(state) if state then startNoFog() else stopNoFog() end end })
Tabs.Visuals:Toggle({ Title = "Disable Fade Effect", Value = false, Callback = function(state) local cs = PlayerGui:FindFirstChild("Global") and PlayerGui.Global:FindFirstChild("CoverScreen") if cs then cs.Visible = not state end end })

local stretchHorizontal, stretchVertical = 0.80, 0.80
local cameraStretchConnection
Tabs.Visuals:Toggle({ Title = "Camera Stretch", Value = false, Callback = function(state)
    if state then
        if cameraStretchConnection then cameraStretchConnection:Disconnect() end
        cameraStretchConnection = RunService.RenderStepped:Connect(function()
            local Cam = workspace.CurrentCamera
            Cam.CFrame = Cam.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
        end)
    else
        if cameraStretchConnection then cameraStretchConnection:Disconnect(); cameraStretchConnection = nil end
    end
end})
Tabs.Visuals:Input({ Title = "Stretch Horizontal", Placeholder = "0.80", NumbersOnly = true, Value = "0.80", Callback = function(v) stretchHorizontal = tonumber(v) or 0.80 end })
Tabs.Visuals:Input({ Title = "Stretch Vertical", Placeholder = "0.80", NumbersOnly = true, Value = "0.80", Callback = function(v) stretchVertical = tonumber(v) or 0.80 end })

Tabs.Visuals:Divider()
Tabs.Visuals:Section({ Title = "Game Displays", TextSize = 18 })
Tabs.Visuals:Toggle({ Title = "Timer Display", Value = false, Callback = function(state) TimerEnabled = state; handleTimerToggles() end })
Tabs.Visuals:Toggle({ Title = "Special Round Display", Value = false, Callback = function(state) SpecialRoundEnabled = state; handleTimerToggles() end })

Tabs.Visuals:Divider()
Tabs.Visuals:Section({ Title = "Player Stats", TextSize = 18 })
Tabs.Visuals:Toggle({ Title = "Show Player Stats", Value = false, Callback = function(state) if state then EnableScanData() else DisableScanData() end end })

Window:SelectTab(1)
