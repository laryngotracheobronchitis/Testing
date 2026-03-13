-- Manual One-Tap Cyber Freeze (REAL LAG SYSTEM)
-- CYBER ICE THEME with FFlag Toggle & Bloxstrap
-- UI: Stealing Lag Switch | Drag: Blyat System (FIXED DRAG FOR MOBILE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

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

-- Display credit
local creditGui = Instance.new("ScreenGui")
creditGui.Name = "CreditGUI"
creditGui.ResetOnSpawn = false
creditGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
creditGui.Parent = PlayerGui

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(0, 300, 0, 50)
creditLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by yar"
creditLabel.TextColor3 = Color3.new(1, 1, 1)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.SciFi
creditLabel.TextStrokeTransparency = 0.5
creditLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
creditLabel.Parent = creditGui

task.spawn(function()
    task.wait(2)
    creditGui:Destroy()
end)

-- Create CYBER ICE THEME GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagSwitchUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Cyber Ice Container
local IceButton = Instance.new("Frame")
IceButton.Name = "IceButton"
IceButton.Size = UDim2.new(0, 200, 0, 80)
IceButton.Position = UDim2.new(0, 10, 0, 120)
IceButton.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
IceButton.BackgroundTransparency = 0.3
IceButton.BorderSizePixel = 0
IceButton.Active = true
IceButton.Visible = true
IceButton.Parent = ScreenGui

-- Variabel untuk drag (dukungan mouse dan touch untuk mobile)
local canDrag = true  -- Default: draggable aktif
local dragging = false
local dragInput
local dragStart
local startPos

-- Fungsi update posisi
local function updateInput(input)
    local delta = input.Position - dragStart
    IceButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Koneksi untuk InputBegan (mouse dan touch)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not canDrag or dragging then return end
    
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local guiUnderMouse = PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        if guiUnderMouse[1] and guiUnderMouse[1]:IsDescendantOf(IceButton) then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = IceButton.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end
end)

-- Koneksi untuk InputChanged (mouse movement dan touch movement)
UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input == dragInput and dragging then
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end
end)

-- Settings Button
local SettingsButton = Instance.new("TextButton")
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
SettingsButton.Parent = IceButton

local SettingsBorder = Instance.new("UIStroke")
SettingsBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SettingsBorder.Color = Color3.fromRGB(0, 200, 255)
SettingsBorder.Thickness = 2
SettingsBorder.Transparency = 0.1
SettingsBorder.Parent = SettingsButton

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 4)
SettingsCorner.Parent = SettingsButton

-- Cyber Ice Border
local CyberBorder = Instance.new("UIStroke")
CyberBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CyberBorder.Color = Color3.fromRGB(0, 255, 255)
CyberBorder.Thickness = 3
CyberBorder.Transparency = 0.1
CyberBorder.Parent = IceButton

-- Holographic Glow Effect
local GlowEffect = Instance.new("ImageLabel")
GlowEffect.Name = "GlowEffect"
GlowEffect.Size = UDim2.new(1.2, 0, 1.2, 0)
GlowEffect.Position = UDim2.new(-0.1, 0, -0.1, 0)
GlowEffect.BackgroundTransparency = 1
GlowEffect.Image = "rbxassetid://8992231221"
GlowEffect.ImageColor3 = Color3.fromRGB(0, 100, 255)
GlowEffect.ImageTransparency = 0.8
GlowEffect.ScaleType = Enum.ScaleType.Slice
GlowEffect.SliceCenter = Rect.new(100, 100, 100, 100)
GlowEffect.Parent = IceButton

-- Digital Grid Pattern
local GridPattern = Instance.new("Frame")
GridPattern.Name = "GridPattern"
GridPattern.Size = UDim2.new(1, 0, 1, 0)
GridPattern.BackgroundTransparency = 1
GridPattern.Parent = IceButton

for i = 1, 3 do
    local VerticalLine = Instance.new("Frame")
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(i/4, 0, 0, 0)
    VerticalLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    VerticalLine.BackgroundTransparency = 0.8
    VerticalLine.BorderSizePixel = 0
    VerticalLine.Parent = GridPattern
    
    local HorizontalLine = Instance.new("Frame")
    HorizontalLine.Size = UDim2.new(1, 0, 0, 1)
    HorizontalLine.Position = UDim2.new(0, 0, i/4, 0)
    HorizontalLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    HorizontalLine.BackgroundTransparency = 0.8
    HorizontalLine.BorderSizePixel = 0
    HorizontalLine.Parent = GridPattern
end

-- Scanner Line Effect
local ScannerLine = Instance.new("Frame")
ScannerLine.Size = UDim2.new(0, 2, 1, 0)
ScannerLine.Position = UDim2.new(0, -10, 0, 0)
ScannerLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ScannerLine.BorderSizePixel = 0
ScannerLine.Visible = false
ScannerLine.Parent = IceButton

-- Border Flow Container
local BorderFlowContainer = Instance.new("Frame")
BorderFlowContainer.Name = "BorderFlowContainer"
BorderFlowContainer.Size = UDim2.new(1, 0, 1, 0)
BorderFlowContainer.BackgroundTransparency = 1
BorderFlowContainer.ClipsDescendants = true
BorderFlowContainer.ZIndex = 3
BorderFlowContainer.Parent = IceButton

-- Top Border Line
local LineTop = Instance.new("Frame")
LineTop.Name = "LineTop"
LineTop.Size = UDim2.new(0, 0, 0, 2)
LineTop.Position = UDim2.new(0, 0, 0, 0)
LineTop.AnchorPoint = Vector2.new(0, 0)
LineTop.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineTop.BorderSizePixel = 0
LineTop.ZIndex = 4
LineTop.Parent = BorderFlowContainer

local TopGlow = Instance.new("UIStroke")
TopGlow.Color = Color3.fromRGB(100, 255, 255)
TopGlow.Thickness = 3
TopGlow.Transparency = 0.3
TopGlow.Parent = LineTop

-- Right Border Line
local LineRight = Instance.new("Frame")
LineRight.Name = "LineRight"
LineRight.Size = UDim2.new(0, 2, 0, 0)
LineRight.Position = UDim2.new(1, 0, 0, 0)
LineRight.AnchorPoint = Vector2.new(1, 0)
LineRight.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineRight.BorderSizePixel = 0
LineRight.ZIndex = 4
LineRight.Parent = BorderFlowContainer

local RightGlow = Instance.new("UIStroke")
RightGlow.Color = Color3.fromRGB(100, 255, 255)
RightGlow.Thickness = 3
RightGlow.Transparency = 0.3
RightGlow.Parent = LineRight

-- Bottom Border Line
local LineBottom = Instance.new("Frame")
LineBottom.Name = "LineBottom"
LineBottom.Size = UDim2.new(0, 0, 0, 2)
LineBottom.Position = UDim2.new(1, 0, 1, 0)
LineBottom.AnchorPoint = Vector2.new(1, 1)
LineBottom.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineBottom.BorderSizePixel = 0
LineBottom.ZIndex = 4
LineBottom.Parent = BorderFlowContainer

local BottomGlow = Instance.new("UIStroke")
BottomGlow.Color = Color3.fromRGB(100, 255, 255)
BottomGlow.Thickness = 3
BottomGlow.Transparency = 0.3
BottomGlow.Parent = LineBottom

-- Left Border Line
local LineLeft = Instance.new("Frame")
LineLeft.Name = "LineLeft"
LineLeft.Size = UDim2.new(0, 2, 0, 0)
LineLeft.Position = UDim2.new(0, 0, 1, 0)
LineLeft.AnchorPoint = Vector2.new(0, 1)
LineLeft.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineLeft.BorderSizePixel = 0
LineLeft.ZIndex = 4
LineLeft.Parent = BorderFlowContainer

local LeftGlow = Instance.new("UIStroke")
LeftGlow.Color = Color3.fromRGB(100, 255, 255)
LeftGlow.Thickness = 3
LeftGlow.Transparency = 0.3
LeftGlow.Parent = LineLeft

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
local ButtonText = Instance.new("TextLabel")
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
ButtonText.Parent = IceButton

local StatusText = Instance.new("TextLabel")
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
StatusText.Parent = IceButton

-- Invisible Click Detector
local ClickDetector = Instance.new("TextButton")
ClickDetector.Name = "ClickDetector"
ClickDetector.Size = UDim2.new(1, 0, 1, 0)
ClickDetector.Position = UDim2.new(0, 0, 0, 0)
ClickDetector.BackgroundTransparency = 1
ClickDetector.Text = ""
ClickDetector.ZIndex = 6
ClickDetector.Parent = IceButton

-- Settings Panel
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0, 180, 0, 265)
SettingsPanel.Position = UDim2.new(0, 210, 0, 0)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
SettingsPanel.BackgroundTransparency = 0.2
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 20
SettingsPanel.Parent = IceButton

local SettingsPanelBorder = Instance.new("UIStroke")
SettingsPanelBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SettingsPanelBorder.Color = Color3.fromRGB(0, 200, 255)
SettingsPanelBorder.Thickness = 2
SettingsPanelBorder.Transparency = 0.2
SettingsPanelBorder.Parent = SettingsPanel

local SettingsPanelCorner = Instance.new("UICorner")
SettingsPanelCorner.CornerRadius = UDim.new(0, 6)
SettingsPanelCorner.Parent = SettingsPanel

-- Settings Header
local SettingsHeader = Instance.new("Frame")
SettingsHeader.Name = "SettingsHeader"
SettingsHeader.Size = UDim2.new(1, 0, 0, 25)
SettingsHeader.Position = UDim2.new(0, 0, 0, 0)
SettingsHeader.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
SettingsHeader.BackgroundTransparency = 0.2
SettingsHeader.BorderSizePixel = 0
SettingsHeader.ZIndex = 21
SettingsHeader.Parent = SettingsPanel

local SettingsHeaderCorner = Instance.new("UICorner")
SettingsHeaderCorner.CornerRadius = UDim.new(0, 6)
SettingsHeaderCorner.Parent = SettingsHeader

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 1, 0)
SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.Font = Enum.Font.SciFi
SettingsTitle.TextSize = 14
SettingsTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.TextStrokeTransparency = 0.3
SettingsTitle.ZIndex = 22
SettingsTitle.Parent = SettingsHeader

-- Content Container
local SettingsContent = Instance.new("Frame")
SettingsContent.Name = "SettingsContent"
SettingsContent.Size = UDim2.new(1, 0, 1, -25)
SettingsContent.Position = UDim2.new(0, 0, 0, 25)
SettingsContent.BackgroundTransparency = 1
SettingsContent.ZIndex = 21
SettingsContent.Parent = SettingsPanel

-- Duration Section
local DurationSection = Instance.new("Frame")
DurationSection.Name = "DurationSection"
DurationSection.Size = UDim2.new(1, -20, 0, 40)
DurationSection.Position = UDim2.new(0, 10, 0, 10)
DurationSection.BackgroundTransparency = 1
DurationSection.ZIndex = 21
DurationSection.Parent = SettingsContent

local DurationLabel = Instance.new("TextLabel")
DurationLabel.Size = UDim2.new(1, 0, 0, 15)
DurationLabel.Position = UDim2.new(0, 0, 0, 0)
DurationLabel.Text = "Duration (0.1-100s):"
DurationLabel.Font = Enum.Font.Code
DurationLabel.TextSize = 11
DurationLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
DurationLabel.BackgroundTransparency = 1
DurationLabel.TextXAlignment = Enum.TextXAlignment.Left
DurationLabel.ZIndex = 22
DurationLabel.Parent = DurationSection

local DurationTextBox = Instance.new("TextBox")
DurationTextBox.Size = UDim2.new(1, 0, 0, 22)
DurationTextBox.Position = UDim2.new(0, 0, 0, 18)
DurationTextBox.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
DurationTextBox.BackgroundTransparency = 0.2
DurationTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DurationTextBox.Text = tostring(FreezeDuration)
DurationTextBox.Font = Enum.Font.Code
DurationTextBox.TextSize = 12
DurationTextBox.PlaceholderText = "seconds"
DurationTextBox.ZIndex = 22
DurationTextBox.ClearTextOnFocus = false
DurationTextBox.Parent = DurationSection

local DurationBoxCorner = Instance.new("UICorner")
DurationBoxCorner.CornerRadius = UDim.new(0, 4)
DurationBoxCorner.Parent = DurationTextBox

local DurationBoxBorder = Instance.new("UIStroke")
DurationBoxBorder.Color = Color3.fromRGB(0, 150, 200)
DurationBoxBorder.Thickness = 1
DurationBoxBorder.Parent = DurationTextBox

-- Size Section
local SizeSection = Instance.new("Frame")
SizeSection.Name = "SizeSection"
SizeSection.Size = UDim2.new(1, -20, 0, 40)
SizeSection.Position = UDim2.new(0, 10, 0, 55)
SizeSection.BackgroundTransparency = 1
SizeSection.ZIndex = 21
SizeSection.Parent = SettingsContent

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, 0, 0, 15)
SizeLabel.Position = UDim2.new(0, 0, 0, 0)
SizeLabel.Text = "Size (100-500px):"
SizeLabel.Font = Enum.Font.Code
SizeLabel.TextSize = 11
SizeLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.ZIndex = 22
SizeLabel.Parent = SizeSection

local SizeTextBox = Instance.new("TextBox")
SizeTextBox.Size = UDim2.new(1, 0, 0, 22)
SizeTextBox.Position = UDim2.new(0, 0, 0, 18)
SizeTextBox.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
SizeTextBox.BackgroundTransparency = 0.2
SizeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeTextBox.Text = tostring(IceButton.Size.X.Offset)
SizeTextBox.Font = Enum.Font.Code
SizeTextBox.TextSize = 12
SizeTextBox.PlaceholderText = "pixels"
SizeTextBox.ZIndex = 22
SizeTextBox.ClearTextOnFocus = false
SizeTextBox.Parent = SizeSection

local SizeBoxCorner = Instance.new("UICorner")
SizeBoxCorner.CornerRadius = UDim.new(0, 4)
SizeBoxCorner.Parent = SizeTextBox

local SizeBoxBorder = Instance.new("UIStroke")
SizeBoxBorder.Color = Color3.fromRGB(0, 150, 200)
SizeBoxBorder.Thickness = 1
SizeBoxBorder.Parent = SizeTextBox

-- Drag Toggle Section (SEPERTI BLYAT)
local DragSection = Instance.new("Frame")
DragSection.Name = "DragSection"
DragSection.Size = UDim2.new(1, -20, 0, 25)
DragSection.Position = UDim2.new(0, 10, 0, 100)
DragSection.BackgroundTransparency = 1
DragSection.ZIndex = 21
DragSection.Parent = SettingsContent

local DragToggleButton = Instance.new("TextButton")
DragToggleButton.Name = "DragToggleButton"
DragToggleButton.Size = UDim2.new(1, 0, 1, 0)
DragToggleButton.Position = UDim2.new(0, 0, 0, 0)
DragToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
DragToggleButton.BackgroundTransparency = 0.2
DragToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DragToggleButton.Text = "Unlocked"
DragToggleButton.TextSize = 11
DragToggleButton.Font = Enum.Font.SciFi
DragToggleButton.ZIndex = 22
DragToggleButton.Parent = DragSection

local DragButtonCorner = Instance.new("UICorner")
DragButtonCorner.CornerRadius = UDim.new(0, 4)
DragButtonCorner.Parent = DragToggleButton

local DragButtonBorder = Instance.new("UIStroke")
DragButtonBorder.Color = Color3.fromRGB(0, 200, 255)
DragButtonBorder.Thickness = 1
DragButtonBorder.Parent = DragToggleButton

-- FFlag Toggle Section (BARU!)
local FflagSection = Instance.new("Frame")
FflagSection.Name = "FflagSection"
FflagSection.Size = UDim2.new(1, -20, 0, 25)
FflagSection.Position = UDim2.new(0, 10, 0, 130)
FflagSection.BackgroundTransparency = 1
FflagSection.ZIndex = 21
FflagSection.Parent = SettingsContent

local FflagToggleButton = Instance.new("TextButton")
FflagToggleButton.Name = "FflagToggleButton"
FflagToggleButton.Size = UDim2.new(1, 0, 1, 0)
FflagToggleButton.Position = UDim2.new(0, 0, 0, 0)
FflagToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FflagToggleButton.BackgroundTransparency = 0.2
FflagToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FflagToggleButton.Text = "FFlag OFF"
FflagToggleButton.TextSize = 11
FflagToggleButton.Font = Enum.Font.SciFi
FflagToggleButton.ZIndex = 22
FflagToggleButton.Parent = FflagSection

local FflagButtonCorner = Instance.new("UICorner")
FflagButtonCorner.CornerRadius = UDim.new(0, 4)
FflagButtonCorner.Parent = FflagToggleButton

local FflagButtonBorder = Instance.new("UIStroke")
FflagButtonBorder.Color = Color3.fromRGB(100, 100, 100)
FflagButtonBorder.Thickness = 1
FflagButtonBorder.Parent = FflagToggleButton

-- Bloxstrap Section
local BloxstrapSection = Instance.new("Frame")
BloxstrapSection.Name = "BloxstrapSection"
BloxstrapSection.Size = UDim2.new(1, -20, 0, 25)
BloxstrapSection.Position = UDim2.new(0, 10, 0, 160)
BloxstrapSection.BackgroundTransparency = 1
BloxstrapSection.ZIndex = 21
BloxstrapSection.Parent = SettingsContent

local BloxstrapButton = Instance.new("TextButton")
BloxstrapButton.Name = "BloxstrapButton"
BloxstrapButton.Size = UDim2.new(1, 0, 1, 0)
BloxstrapButton.Position = UDim2.new(0, 0, 0, 0)
BloxstrapButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
BloxstrapButton.BackgroundTransparency = 0.2
BloxstrapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BloxstrapButton.Text = "LAUNCH BLOXSTRAP"
BloxstrapButton.TextSize = 11
BloxstrapButton.Font = Enum.Font.SciFi
BloxstrapButton.ZIndex = 22
BloxstrapButton.Parent = BloxstrapSection

local BloxstrapButtonCorner = Instance.new("UICorner")
BloxstrapButtonCorner.CornerRadius = UDim.new(0, 4)
BloxstrapButtonCorner.Parent = BloxstrapButton

local BloxstrapButtonBorder = Instance.new("UIStroke")
BloxstrapButtonBorder.Color = Color3.fromRGB(200, 100, 255)
BloxstrapButtonBorder.Thickness = 1
BloxstrapButtonBorder.Parent = BloxstrapButton

-- Apply Button
local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(1, -20, 0, 30)
ApplyButton.Position = UDim2.new(0, 10, 0, 195)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ApplyButton.BorderSizePixel = 0
ApplyButton.Text = "APPLY"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextSize = 12
ApplyButton.Font = Enum.Font.SciFi
ApplyButton.ZIndex = 22
ApplyButton.Parent = SettingsContent

local ApplyButtonCorner = Instance.new("UICorner")
ApplyButtonCorner.CornerRadius = UDim.new(0, 4)
ApplyButtonCorner.Parent = ApplyButton

local ApplyButtonBorder = Instance.new("UIStroke")
ApplyButtonBorder.Color = Color3.fromRGB(0, 255, 255)
ApplyButtonBorder.Thickness = 2
ApplyButtonBorder.Parent = ApplyButton

-- Boot-Up Animation
local function PlayBootAnimation()
    for i = 1, 3 do
        IceButton.BackgroundTransparency = 0.5
        task.wait(0.1)
        IceButton.BackgroundTransparency = 0.3
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

-- Settings Button Click Handler
SettingsButton.Activated:Connect(function()
    SettingsOpen = not SettingsOpen
    SettingsPanel.Visible = SettingsOpen
    
    if SettingsOpen then
        DurationTextBox.Text = tostring(FreezeDuration)
        SizeTextBox.Text = tostring(IceButton.Size.X.Offset)
        
        local openTween = TweenService:Create(SettingsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2})
        openTween:Play()
    end
end)

-- Drag Toggle Handler (EXACT SEPERTI BLYAT - LANGSUNG TOGGLE!)
DragToggleButton.Activated:Connect(function()
    canDrag = not canDrag
    if canDrag then
        DragToggleButton.Text = "Unlocked"
        DragToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        DragButtonBorder.Color = Color3.fromRGB(0, 200, 255)
    else
        DragToggleButton.Text = "Locked"
        DragToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        DragButtonBorder.Color = Color3.fromRGB(255, 100, 100)
    end
end)

-- FFlag Toggle Handler (EXACT SEPERTI BLYAT - LANGSUNG AKTIF!)
FflagToggleButton.Activated:Connect(function()
    fflagEnabled = not fflagEnabled
    if fflagEnabled then
        FflagToggleButton.Text = "FFlag ON"
        FflagToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        FflagButtonBorder.Color = Color3.fromRGB(0, 255, 200)
        SetFFlag(1000)
    else
        FflagToggleButton.Text = "FFlag OFF"
        FflagToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FflagButtonBorder.Color = Color3.fromRGB(100, 100, 100)
        SetFFlag(1)
    end
end)

-- Bloxstrap Button Handler (SEPERTI BLYAT - DENGAN LOADING TEXT!)
BloxstrapButton.Activated:Connect(function()
    BloxstrapButton.Text = "LOADING..."
    BloxstrapButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    
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

-- Apply Settings Handler
ApplyButton.Activated:Connect(function()
    local hasChanges = false
    
    -- Apply Duration
    local newDuration = tonumber(DurationTextBox.Text)
    if newDuration and newDuration >= 0.1 and newDuration <= 100 then
        FreezeDuration = newDuration
        hasChanges = true
    else
        StatusText.Text = "INVALID DURATION"
        StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(2)
        if not IsFreezing then
            StatusText.Text = originalStatusText
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
        end
        return
    end
    
    -- Apply Size
    local newSize = tonumber(SizeTextBox.Text)
    if newSize and newSize >= 100 and newSize <= 500 then
        local newHeight = newSize * 0.4
        IceButton.Size = UDim2.new(0, newSize, 0, newHeight)
        hasChanges = true
    else
        StatusText.Text = "INVALID SIZE"
        StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(2)
        if not IsFreezing then
            StatusText.Text = originalStatusText
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
        end
        return
    end
    
    -- Show confirmation
    if hasChanges then
        StatusText.Text = "SETTINGS APPLIED"
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        task.wait(0.2)
        ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        
        task.wait(1.5)
        if not IsFreezing then
            StatusText.Text = originalStatusText
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
        end
    end
    
    SettingsOpen = false
    SettingsPanel.Visible = false
end)

-- Background FFlag Maintenance Loop
task.spawn(function()
    while ScreenGui.Parent do
        if fflagEnabled then
            SetFFlag(1000)
        end
        task.wait(1)
    end
end)

-- Auto-adjust position when settings panel opens
task.spawn(function()
    while ScreenGui.Parent do
        if SettingsPanel.Visible then
            local viewportSize = workspace.Camera.ViewportSize
            local totalWidth = IceButton.Size.X.Offset + SettingsPanel.Size.X.Offset
            
            if IceButton.Position.X.Offset + totalWidth > viewportSize.X then
                SettingsPanel.Position = UDim2.new(0, -SettingsPanel.Size.X.Offset - 10, 0, 0)
            else
                SettingsPanel.Position = UDim2.new(0, IceButton.Size.X.Offset + 10, 0, 0)
            end
        end
        task.wait(0.1)
    end
end)

-- Freeze Function (SEPERTI BLYAT - LOADING TEXT!)
local function PerformFreeze()
    if IsFreezing then return end
    if tick() - LastFreezeTime < Cooldown then return end
    
    IsFreezing = true
    LastFreezeTime = tick()
    
    ButtonText.Text = "FREEZING..."
    StatusText.Text = "BUSY..."
    StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    CyberBorder.Color = Color3.fromRGB(255, 0, 0)
    
    if fflagEnabled then
        SetFFlag(1000)
    end
    
    task.wait(0.05)
    
    -- Freeze
    local startTime = os.clock()
    while os.clock() - startTime < FreezeDuration do
    end
    
    -- Reset
    ButtonText.Text = originalMainText
    StatusText.Text = originalStatusText
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 255)
    CyberBorder.Color = Color3.fromRGB(0, 255, 255)
    
    if fflagEnabled then
        SetFFlag(1000)
    end
    
    IsFreezing = false
end

-- Click Handler
ClickDetector.Activated:Connect(function()
    if not SettingsOpen then
        PerformFreeze()
    end
end)

-- Keybind (V key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        if not SettingsOpen then
            PerformFreeze()
        end
    end
end)

-- Start animations
PlayBootAnimation()
task.wait(2)
StartIdleAnimation()
AnimateBorderFlow()
