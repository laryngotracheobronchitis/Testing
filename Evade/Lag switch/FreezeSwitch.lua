-- Manual One-Tap Cyber Freeze (REAL LAG SYSTEM)
-- CYBER ICE THEME - DRAG EXACT SEPERTI BLYAT!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuration
local FreezeDuration = 0.4
local Cooldown = 0.2
local LastFreezeTime = 0
local IsFreezing = false
local SettingsOpen = false
local fflagEnabled = false

-- Store original text
local originalMainText = "CYBER FREEZE"
local originalStatusText = "SYSTEM READY"

-- FFlag Function
local function SetFFlag(val)
    pcall(function() 
        setfflag("MaxMissedWorldStepsRemembered", tostring(val)) 
    end)
end

-- Remove old GUI if exists
if PlayerGui:FindFirstChild("LagSwitchUI") then
    PlayerGui.LagSwitchUI:Destroy()
end

-- Create ScreenGui (EXACT SEPERTI BLYAT)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "LagSwitchUI"
ScreenGui.ResetOnSpawn = false

-- Main Frame (EXACT SEPERTI BLYAT - PARENT DI PARAMETER!)
local IceButton = Instance.new("Frame", ScreenGui)
IceButton.Name = "IceButton"
IceButton.Size = UDim2.new(0, 200, 0, 80)
IceButton.Position = UDim2.new(0, 10, 0, 120)
IceButton.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
IceButton.BackgroundTransparency = 0.25
IceButton.Active = true
IceButton.Draggable = true  -- EXACT SEPERTI BLYAT!

-- UICorner (SEPERTI BLYAT)
Instance.new("UICorner", IceButton).CornerRadius = UDim.new(0, 6)

-- Cyber Ice Border
local CyberBorder = Instance.new("UIStroke", IceButton)
CyberBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CyberBorder.Color = Color3.fromRGB(0, 255, 255)
CyberBorder.Thickness = 3

-- RGB Gradient Animation (SEPERTI BLYAT)
local BorderGradient = Instance.new("UIGradient", CyberBorder)
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})

-- Animate RGB Gradient (EXACT SEPERTI BLYAT)
RunService.RenderStepped:Connect(function() 
    BorderGradient.Rotation = (BorderGradient.Rotation + 3) % 360 
end)

-- Holographic Glow Effect
local GlowEffect = Instance.new("ImageLabel", IceButton)
GlowEffect.Name = "GlowEffect"
GlowEffect.Size = UDim2.new(1.2, 0, 1.2, 0)
GlowEffect.Position = UDim2.new(-0.1, 0, -0.1, 0)
GlowEffect.BackgroundTransparency = 1
GlowEffect.Image = "rbxassetid://8992231221"
GlowEffect.ImageColor3 = Color3.fromRGB(0, 100, 255)
GlowEffect.ImageTransparency = 0.8
GlowEffect.ScaleType = Enum.ScaleType.Slice
GlowEffect.SliceCenter = Rect.new(100, 100, 100, 100)

-- Digital Grid Pattern
local GridPattern = Instance.new("Frame", IceButton)
GridPattern.Name = "GridPattern"
GridPattern.Size = UDim2.new(1, 0, 1, 0)
GridPattern.BackgroundTransparency = 1

for i = 1, 3 do
    local VerticalLine = Instance.new("Frame", GridPattern)
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(i/4, 0, 0, 0)
    VerticalLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    VerticalLine.BackgroundTransparency = 0.8
    VerticalLine.BorderSizePixel = 0
    
    local HorizontalLine = Instance.new("Frame", GridPattern)
    HorizontalLine.Size = UDim2.new(1, 0, 0, 1)
    HorizontalLine.Position = UDim2.new(0, 0, i/4, 0)
    HorizontalLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    HorizontalLine.BackgroundTransparency = 0.8
    HorizontalLine.BorderSizePixel = 0
end

-- Scanner Line Effect
local ScannerLine = Instance.new("Frame", IceButton)
ScannerLine.Size = UDim2.new(0, 2, 1, 0)
ScannerLine.Position = UDim2.new(0, -10, 0, 0)
ScannerLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ScannerLine.BorderSizePixel = 0
ScannerLine.Visible = false

-- Border Flow Container
local BorderFlowContainer = Instance.new("Frame", IceButton)
BorderFlowContainer.Name = "BorderFlowContainer"
BorderFlowContainer.Size = UDim2.new(1, 0, 1, 0)
BorderFlowContainer.BackgroundTransparency = 1
BorderFlowContainer.ClipsDescendants = true
BorderFlowContainer.ZIndex = 3

-- Top Border Line
local LineTop = Instance.new("Frame", BorderFlowContainer)
LineTop.Name = "LineTop"
LineTop.Size = UDim2.new(0, 0, 0, 2)
LineTop.Position = UDim2.new(0, 0, 0, 0)
LineTop.AnchorPoint = Vector2.new(0, 0)
LineTop.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineTop.BorderSizePixel = 0
LineTop.ZIndex = 4

local TopGlow = Instance.new("UIStroke", LineTop)
TopGlow.Color = Color3.fromRGB(100, 255, 255)
TopGlow.Thickness = 3
TopGlow.Transparency = 0.3

-- Right Border Line
local LineRight = Instance.new("Frame", BorderFlowContainer)
LineRight.Name = "LineRight"
LineRight.Size = UDim2.new(0, 2, 0, 0)
LineRight.Position = UDim2.new(1, 0, 0, 0)
LineRight.AnchorPoint = Vector2.new(1, 0)
LineRight.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineRight.BorderSizePixel = 0
LineRight.ZIndex = 4

local RightGlow = Instance.new("UIStroke", LineRight)
RightGlow.Color = Color3.fromRGB(100, 255, 255)
RightGlow.Thickness = 3
RightGlow.Transparency = 0.3

-- Bottom Border Line
local LineBottom = Instance.new("Frame", BorderFlowContainer)
LineBottom.Name = "LineBottom"
LineBottom.Size = UDim2.new(0, 0, 0, 2)
LineBottom.Position = UDim2.new(1, 0, 1, 0)
LineBottom.AnchorPoint = Vector2.new(1, 1)
LineBottom.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineBottom.BorderSizePixel = 0
LineBottom.ZIndex = 4

local BottomGlow = Instance.new("UIStroke", LineBottom)
BottomGlow.Color = Color3.fromRGB(100, 255, 255)
BottomGlow.Thickness = 3
BottomGlow.Transparency = 0.3

-- Left Border Line
local LineLeft = Instance.new("Frame", BorderFlowContainer)
LineLeft.Name = "LineLeft"
LineLeft.Size = UDim2.new(0, 2, 0, 0)
LineLeft.Position = UDim2.new(0, 0, 1, 0)
LineLeft.AnchorPoint = Vector2.new(0, 1)
LineLeft.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineLeft.BorderSizePixel = 0
LineLeft.ZIndex = 4

local LeftGlow = Instance.new("UIStroke", LineLeft)
LeftGlow.Color = Color3.fromRGB(100, 255, 255)
LeftGlow.Thickness = 3
LeftGlow.Transparency = 0.3

-- Border Flow Animation Function
local function AnimateBorderFlow()
    local duration = 4
    
    task.spawn(function()
        while IceButton and IceButton.Parent do
            TweenService:Create(LineTop, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)}):Play()
            task.wait(duration)
            TweenService:Create(LineRight, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 2, 1, 0)}):Play()
            task.wait(duration)
            TweenService:Create(LineBottom, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)}):Play()
            task.wait(duration)
            TweenService:Create(LineLeft, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 2, 1, 0)}):Play()
            task.wait(duration)
            
            LineTop.Size = UDim2.new(0, 0, 0, 2)
            LineRight.Size = UDim2.new(0, 2, 0, 0)
            LineBottom.Size = UDim2.new(0, 0, 0, 2)
            LineLeft.Size = UDim2.new(0, 2, 0, 0)
            task.wait(0.5)
        end
    end)
end

-- Text Elements (CENTERED)
local ButtonText = Instance.new("TextLabel", IceButton)
ButtonText.Name = "ButtonText"
ButtonText.Size = UDim2.new(0.85, 0, 0, 30)
ButtonText.Position = UDim2.new(0.5, 0, 0.25, 0)
ButtonText.AnchorPoint = Vector2.new(0.5, 0.5)
ButtonText.BackgroundTransparency = 1
ButtonText.Text = originalMainText
ButtonText.TextColor3 = Color3.fromRGB(0, 255, 255)
ButtonText.TextScaled = true
ButtonText.Font = Enum.Font.SciFi
ButtonText.TextStrokeTransparency = 0.3
ButtonText.TextStrokeColor3 = Color3.fromRGB(0, 100, 255)
ButtonText.ZIndex = 5

local StatusText = Instance.new("TextLabel", IceButton)
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(0.85, 0, 0, 15)
StatusText.Position = UDim2.new(0.5, 0, 0.7, 0)
StatusText.AnchorPoint = Vector2.new(0.5, 0.5)
StatusText.BackgroundTransparency = 1
StatusText.Text = originalStatusText
StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
StatusText.TextScaled = true
StatusText.Font = Enum.Font.Code
StatusText.TextStrokeTransparency = 0.5
StatusText.ZIndex = 5

-- Settings Button
local SettingsButton = Instance.new("TextButton", IceButton)
SettingsButton.Name = "SettingsButton"
SettingsButton.Size = UDim2.new(0, 25, 0, 25)
SettingsButton.Position = UDim2.new(1, -30, 0, 5)
SettingsButton.BackgroundColor3 = Color3.fromRGB(0, 40, 80)
SettingsButton.BackgroundTransparency = 0.2
SettingsButton.Text = "⚙"
SettingsButton.TextColor3 = Color3.fromRGB(0, 255, 255)
SettingsButton.TextSize = 14
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.BorderSizePixel = 0
SettingsButton.ZIndex = 10

local SettingsBorder = Instance.new("UIStroke", SettingsButton)
SettingsBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SettingsBorder.Color = Color3.fromRGB(0, 200, 255)
SettingsBorder.Thickness = 2
SettingsBorder.Transparency = 0.1

local SettingsCorner = Instance.new("UICorner", SettingsButton)
SettingsCorner.CornerRadius = UDim.new(0, 4)

-- Freeze Button (SEPERTI BLYAT)
local FreezeButton = Instance.new("TextButton", IceButton)
FreezeButton.Size = UDim2.new(0.8, 0, 0.4, 0)
FreezeButton.Position = UDim2.new(0.1, 0, 0.35, 0)
FreezeButton.Text = "FREEZE"
FreezeButton.TextColor3 = Color3.fromRGB(0, 255, 255)
FreezeButton.BackgroundTransparency = 1
FreezeButton.TextScaled = true
FreezeButton.Font = Enum.Font.SciFi
FreezeButton.ZIndex = 7

-- Settings Panel (SEPERTI BLYAT)
local SettingsPanel = Instance.new("Frame", IceButton)
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0, 180, 0, 265)
SettingsPanel.Position = UDim2.new(0, -185, 0, 0)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
SettingsPanel.BackgroundTransparency = 0.3
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 20

Instance.new("UIStroke", SettingsPanel).Color = Color3.fromRGB(0, 200, 255)
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 6)

-- Settings Header
local SettingsHeader = Instance.new("Frame", SettingsPanel)
SettingsHeader.Size = UDim2.new(1, 0, 0, 25)
SettingsHeader.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
SettingsHeader.BackgroundTransparency = 0.2
SettingsHeader.BorderSizePixel = 0
SettingsHeader.ZIndex = 21

Instance.new("UICorner", SettingsHeader).CornerRadius = UDim.new(0, 6)

local SettingsTitle = Instance.new("TextLabel", SettingsHeader)
SettingsTitle.Size = UDim2.new(1, 0, 1, 0)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.Font = Enum.Font.SciFi
SettingsTitle.TextSize = 14
SettingsTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.TextStrokeTransparency = 0.3
SettingsTitle.ZIndex = 22

-- Content Container
local SettingsContent = Instance.new("Frame", SettingsPanel)
SettingsContent.Size = UDim2.new(1, 0, 1, -25)
SettingsContent.Position = UDim2.new(0, 0, 0, 25)
SettingsContent.BackgroundTransparency = 1
SettingsContent.ZIndex = 21

-- Duration Input (SEPERTI BLYAT)
local DurationTextBox = Instance.new("TextBox", SettingsContent)
DurationTextBox.Size = UDim2.new(0.8, 0, 0, 30)
DurationTextBox.Position = UDim2.new(0.1, 0, 0.05, 0)
DurationTextBox.Text = tostring(FreezeDuration)
DurationTextBox.PlaceholderText = "Sec"
DurationTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DurationTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DurationTextBox.Font = Enum.Font.Code
DurationTextBox.TextSize = 12
DurationTextBox.ZIndex = 22

-- Drag Lock Button (EXACT SEPERTI BLYAT)
local DragLockButton = Instance.new("TextButton", SettingsContent)
DragLockButton.Size = UDim2.new(0.8, 0, 0, 30)
DragLockButton.Position = UDim2.new(0.1, 0, 0.25, 0)
DragLockButton.Text = "Unlocked"
DragLockButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
DragLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DragLockButton.TextScaled = true
DragLockButton.Font = Enum.Font.SciFi
DragLockButton.ZIndex = 22

-- FFlag Toggle Button (SEPERTI BLYAT)
local FflagButton = Instance.new("TextButton", SettingsContent)
FflagButton.Size = UDim2.new(0.8, 0, 0, 30)
FflagButton.Position = UDim2.new(0.1, 0, 0.45, 0)
FflagButton.Text = "FFlag OFF"
FflagButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FflagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FflagButton.TextScaled = true
FflagButton.Font = Enum.Font.SciFi
FflagButton.ZIndex = 22

Instance.new("UICorner", FflagButton).CornerRadius = UDim.new(0, 4)

-- Bloxstrap Button
local BloxstrapButton = Instance.new("TextButton", SettingsContent)
BloxstrapButton.Size = UDim2.new(0.8, 0, 0, 30)
BloxstrapButton.Position = UDim2.new(0.1, 0, 0.65, 0)
BloxstrapButton.Text = "LAUNCH BLOXSTRAP"
BloxstrapButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
BloxstrapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BloxstrapButton.TextScaled = true
BloxstrapButton.Font = Enum.Font.SciFi
BloxstrapButton.ZIndex = 22

Instance.new("UICorner", BloxstrapButton).CornerRadius = UDim.new(0, 4)

-- Boot-Up Animation
local function PlayBootAnimation()
    for i = 1, 3 do
        IceButton.BackgroundTransparency = 0.5
        task.wait(0.1)
        IceButton.BackgroundTransparency = 0.25
        task.wait(0.1)
    end
    
    ScannerLine.Visible = true
    local scannerSweep = TweenService:Create(ScannerLine, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 10, 0, 0)})
    scannerSweep:Play()
    scannerSweep.Completed:Connect(function()
        ScannerLine.Visible = false
        ScannerLine.Position = UDim2.new(0, -10, 0, 0)
    end)
    
    local function TypeText(textLabel, text, delay)
        textLabel.Text = ""
        for i = 1, #text do
            textLabel.Text = string.sub(text, 1, i)
            task.wait(delay)
        end
    end
    
    task.wait(0.3)
    task.spawn(TypeText, ButtonText, originalMainText, 0.1)
    task.wait(0.5)
    task.spawn(TypeText, StatusText, originalStatusText, 0.05)
end

-- Idle Animation
local function StartIdleAnimation()
    coroutine.wrap(function()
        while IceButton and IceButton.Parent do
            local pulseIn = TweenService:Create(CyberBorder, TweenInfo.new(3, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(100, 255, 255)})
            local pulseOut = TweenService:Create(CyberBorder, TweenInfo.new(3, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(0, 150, 255)})
            pulseIn:Play()
            pulseIn.Completed:Wait()
            pulseOut:Play()
            pulseOut.Completed:Wait()
        end
    end)()
    
    coroutine.wrap(function()
        while IceButton and IceButton.Parent do
            local glowIn = TweenService:Create(ButtonText, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.1})
            local glowOut = TweenService:Create(ButtonText, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.3})
            glowIn:Play()
            glowIn.Completed:Wait()
            glowOut:Play()
            glowOut.Completed:Wait()
        end
    end)()
    
    coroutine.wrap(function()
        while IceButton and IceButton.Parent do
            local tweenIn = TweenService:Create(GlowEffect, TweenInfo.new(3, Enum.EasingStyle.Sine), {ImageTransparency = 0.6})
            local tweenOut = TweenService:Create(GlowEffect, TweenInfo.new(3, Enum.EasingStyle.Sine), {ImageTransparency = 0.8})
            tweenIn:Play()
            tweenIn.Completed:Wait()
            tweenOut:Play()
            tweenOut.Completed:Wait()
        end
    end)()
end

-- Settings Button Click
SettingsButton.Activated:Connect(function()
    SettingsOpen = not SettingsOpen
    SettingsPanel.Visible = SettingsOpen
end)

-- Drag Lock Toggle (EXACT SEPERTI BLYAT!)
DragLockButton.Activated:Connect(function()
    IceButton.Draggable = not IceButton.Draggable
    DragLockButton.Text = IceButton.Draggable and "Unlocked" or "Locked"
    DragLockButton.BackgroundColor3 = IceButton.Draggable and Color3.fromRGB(0, 100, 150) or Color3.fromRGB(150, 50, 50)
end)

-- FFlag Toggle (EXACT SEPERTI BLYAT!)
FflagButton.Activated:Connect(function()
    fflagEnabled = not fflagEnabled
    if fflagEnabled then
        FflagButton.Text = "FFlag ON"
        FflagButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        SetFFlag(1000)
    else
        FflagButton.Text = "FFlag OFF"
        FflagButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SetFFlag(1)
    end
end)

-- Background FFlag loop (SEPERTI BLYAT)
task.spawn(function()
    while ScreenGui.Parent do
        if fflagEnabled then
            SetFFlag(1000)
        end
        task.wait(1)
    end
end)

-- Bloxstrap Button
BloxstrapButton.Activated:Connect(function()
    BloxstrapButton.Text = "LOADING..."
    
    task.spawn(function()
        getgenv().autosetup = {
            path = 'Bloxstrap',
            setup = true
        }
        
        local success = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua'), 'lol')()
        end)
        
        if success then
            BloxstrapButton.Text = "LOADED"
            BloxstrapButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            task.wait(2)
            BloxstrapButton.Text = "LAUNCH BLOXSTRAP"
            BloxstrapButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        else
            BloxstrapButton.Text = "FAILED"
            BloxstrapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            task.wait(2)
            BloxstrapButton.Text = "LAUNCH BLOXSTRAP"
            BloxstrapButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        end
    end)
end)

-- Freeze Logic (SEPERTI BLYAT)
FreezeButton.Activated:Connect(function()
    if IsFreezing then return end
    if tick() - LastFreezeTime < Cooldown then return end
    
    IsFreezing = true
    LastFreezeTime = tick()
    
    local duration = tonumber(DurationTextBox.Text) or FreezeDuration
    
    ButtonText.Text = "FREEZING..."
    StatusText.Text = "BUSY..."
    StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
    CyberBorder.Color = Color3.fromRGB(255, 0, 0)
    
    task.wait(0.05)
    
    local startTime = os.clock()
    while os.clock() - startTime < duration do
    end
    
    ButtonText.Text = originalMainText
    StatusText.Text = originalStatusText
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
    CyberBorder.Color = Color3.fromRGB(0, 255, 255)
    
    IsFreezing = false
end)

-- Keybind (V key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        if not SettingsOpen and not IsFreezing then
            FreezeButton.Activated:Fire()
        end
    end
end)

-- Start animations
PlayBootAnimation()
task.wait(2)
StartIdleAnimation()
AnimateBorderFlow()
