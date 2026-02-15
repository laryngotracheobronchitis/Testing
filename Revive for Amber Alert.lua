-- Revive UI Script with Drag, Resize, Show/Hide
-- Features: Revive Self, Revive Others (Dropdown), Revive All

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Notifikasi saat script di-execute
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "This Script Made by yar";
    Text = "";
    Duration = 3;
})

-- Hapus UI lama jika ada (prevent duplikasi)
if CoreGui:FindFirstChild("ReviveUI") then
    CoreGui:FindFirstChild("ReviveUI"):Destroy()
end
if PlayerGui:FindFirstChild("ReviveUI") then
    PlayerGui:FindFirstChild("ReviveUI"):Destroy()
end

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReviveUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999 -- Pastikan selalu di atas

-- Cek apakah berjalan di executor (gunakan CoreGui) atau normal (gunakan PlayerGui)
-- CoreGui tidak akan reset saat character mati/respawn
local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = PlayerGui
end

-- Proteksi tambahan: Prevent UI dari dihapus
local function protectUI()
    ScreenGui.AncestryChanged:Connect(function()
        if not ScreenGui.Parent then
            wait(0.1)
            local newSuccess = pcall(function()
                ScreenGui.Parent = CoreGui
            end)
            if not newSuccess then
                ScreenGui.Parent = PlayerGui
            end
        end
    end)
end
protectUI()

-- Floating Toggle Button (selalu terlihat, bahkan saat UI di-hide)
local FloatingToggle = Instance.new("TextButton")
FloatingToggle.Name = "FloatingToggle"
FloatingToggle.Size = UDim2.new(0, 50, 0, 50)
FloatingToggle.Position = UDim2.new(1, -60, 0, 10)
FloatingToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
FloatingToggle.BorderSizePixel = 0
FloatingToggle.Text = "👁"
FloatingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingToggle.TextSize = 24
FloatingToggle.Font = Enum.Font.GothamBold
FloatingToggle.ZIndex = 999999
FloatingToggle.Active = true
FloatingToggle.Visible = false -- Mulai hidden, akan muncul saat UI di-hide
FloatingToggle.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0) -- Bulat penuh
FloatingCorner.Parent = FloatingToggle

-- Shadow untuk floating button
local FloatingShadow = Instance.new("ImageLabel")
FloatingShadow.Name = "Shadow"
FloatingShadow.BackgroundTransparency = 1
FloatingShadow.Position = UDim2.new(0, -5, 0, -5)
FloatingShadow.Size = UDim2.new(1, 10, 1, 10)
FloatingShadow.ZIndex = FloatingToggle.ZIndex - 1
FloatingShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
FloatingShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
FloatingShadow.ImageTransparency = 0.5
FloatingShadow.Parent = FloatingToggle

-- Dragging untuk floating button
local floatingDragging = false
local floatingDragInput
local floatingDragStart
local floatingStartPos

local function updateFloating(input)
    local delta = input.Position - floatingDragStart
    FloatingToggle.Position = UDim2.new(floatingStartPos.X.Scale, floatingStartPos.X.Offset + delta.X, floatingStartPos.Y.Scale, floatingStartPos.Y.Offset + delta.Y)
end

FloatingToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatingDragging = true
        floatingDragStart = input.Position
        floatingStartPos = FloatingToggle.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatingDragging = false
            end
        end)
    end
end)

FloatingToggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        floatingDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == floatingDragInput and floatingDragging then
        updateFloating(input)
    end
end)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false -- IMPORTANT: Biarkan dropdown keluar dari frame
MainFrame.Parent = ScreenGui

-- Corner untuk Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Top Bar (untuk drag)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Fix corner bottom
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔄 Revive Manager"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Toggle Button (Hide/Show entire UI)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -70, 0.5, -15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "👁"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = TopBar

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Revive Self Button
local ReviveSelfButton = Instance.new("TextButton")
ReviveSelfButton.Name = "ReviveSelfButton"
ReviveSelfButton.Size = UDim2.new(1, 0, 0, 45)
ReviveSelfButton.Position = UDim2.new(0, 0, 0, 0)
ReviveSelfButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
ReviveSelfButton.BorderSizePixel = 0
ReviveSelfButton.Text = "💚 Revive Self"
ReviveSelfButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReviveSelfButton.TextSize = 16
ReviveSelfButton.Font = Enum.Font.GothamBold
ReviveSelfButton.Parent = ContentFrame

local SelfCorner = Instance.new("UICorner")
SelfCorner.CornerRadius = UDim.new(0, 8)
SelfCorner.Parent = ReviveSelfButton

-- Dropdown Label
local DropdownLabel = Instance.new("TextLabel")
DropdownLabel.Name = "DropdownLabel"
DropdownLabel.Size = UDim2.new(1, 0, 0, 25)
DropdownLabel.Position = UDim2.new(0, 0, 0, 55)
DropdownLabel.BackgroundTransparency = 1
DropdownLabel.Text = "Select Player to Revive:"
DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownLabel.TextSize = 14
DropdownLabel.Font = Enum.Font.Gotham
DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
DropdownLabel.Parent = ContentFrame

-- Dropdown Button
local DropdownButton = Instance.new("TextButton")
DropdownButton.Name = "DropdownButton"
DropdownButton.Size = UDim2.new(1, 0, 0, 40)
DropdownButton.Position = UDim2.new(0, 0, 0, 85)
DropdownButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
DropdownButton.BorderSizePixel = 0
DropdownButton.Text = "  Select Player..."
DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownButton.TextSize = 14
DropdownButton.Font = Enum.Font.Gotham
DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
DropdownButton.Parent = ContentFrame

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 8)
DropdownCorner.Parent = DropdownButton

-- Dropdown Arrow
local DropdownArrow = Instance.new("TextLabel")
DropdownArrow.Size = UDim2.new(0, 30, 1, 0)
DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Text = "▼"
DropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownArrow.TextSize = 12
DropdownArrow.Font = Enum.Font.Gotham
DropdownArrow.Parent = DropdownButton

-- Dropdown List Frame
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Name = "DropdownList"
DropdownList.Size = UDim2.new(1, 0, 0, 0)
DropdownList.Position = UDim2.new(0, 0, 0, 130)
DropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ScrollBarThickness = 4
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ZIndex = 10 -- Set ZIndex lebih tinggi agar di atas button lain
DropdownList.Parent = ContentFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = DropdownList

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = DropdownList

-- Revive Selected Button
local ReviveSelectedButton = Instance.new("TextButton")
ReviveSelectedButton.Name = "ReviveSelectedButton"
ReviveSelectedButton.Size = UDim2.new(1, 0, 0, 45)
ReviveSelectedButton.Position = UDim2.new(0, 0, 0, 240)
ReviveSelectedButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
ReviveSelectedButton.BorderSizePixel = 0
ReviveSelectedButton.Text = "💙 Revive Selected Player"
ReviveSelectedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReviveSelectedButton.TextSize = 16
ReviveSelectedButton.Font = Enum.Font.GothamBold
ReviveSelectedButton.Parent = ContentFrame

local SelectedCorner = Instance.new("UICorner")
SelectedCorner.CornerRadius = UDim.new(0, 8)
SelectedCorner.Parent = ReviveSelectedButton

-- Revive All Button
local ReviveAllButton = Instance.new("TextButton")
ReviveAllButton.Name = "ReviveAllButton"
ReviveAllButton.Size = UDim2.new(1, 0, 0, 45)
ReviveAllButton.Position = UDim2.new(0, 0, 0, 295)
ReviveAllButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
ReviveAllButton.BorderSizePixel = 0
ReviveAllButton.Text = "❤️ Revive All Players"
ReviveAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReviveAllButton.TextSize = 16
ReviveAllButton.Font = Enum.Font.GothamBold
ReviveAllButton.Parent = ContentFrame

local AllCorner = Instance.new("UICorner")
AllCorner.CornerRadius = UDim.new(0, 8)
AllCorner.Parent = ReviveAllButton

-- Resize Handle (bottom-right corner)
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = "⋰"
ResizeHandle.TextColor3 = Color3.fromRGB(200, 200, 200)
ResizeHandle.TextSize = 14
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 5)
ResizeCorner.Parent = ResizeHandle

-- Variables
local selectedPlayer = nil
local isUIHidden = false -- Untuk hide/show seluruh UI
local originalSize = UDim2.new(0, 350, 0, 400) -- Update sesuai ukuran MainFrame baru

-- Functions
local function sendReviveRequest(player)
    if player then
        local args = {
            "Game/RequestRevive",
            player
        }
        pcall(function()
            ReplicatedStorage:WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end)
    end
end

local function updateDropdown()
    -- Clear existing items
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = player.Name
            PlayerButton.Size = UDim2.new(1, -8, 0, 35)
            PlayerButton.Position = UDim2.new(0, 4, 0, yOffset)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
            PlayerButton.BorderSizePixel = 0
            PlayerButton.Text = "  " .. player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 13
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            PlayerButton.ZIndex = 11 -- Set ZIndex lebih tinggi dari DropdownList
            PlayerButton.Parent = DropdownList
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = PlayerButton
            
            PlayerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player
                DropdownButton.Text = "  " .. player.Name
                DropdownList.Visible = false
                DropdownArrow.Text = "▼"
                
                -- Highlight effect
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 120, 200)}):Play()
                wait(0.2)
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 70)}):Play()
            end)
            
            PlayerButton.MouseEnter:Connect(function()
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
            end)
            
            PlayerButton.MouseLeave:Connect(function()
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 70)}):Play()
            end)
            
            yOffset = yOffset + 37
        end
    end
    
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Revive Self
ReviveSelfButton.MouseButton1Click:Connect(function()
    sendReviveRequest(LocalPlayer)
    
    -- Button animation
    TweenService:Create(ReviveSelfButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 200, 130)}):Play()
    wait(0.1)
    TweenService:Create(ReviveSelfButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 100)}):Play()
end)

-- Dropdown Toggle
DropdownButton.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    DropdownArrow.Text = DropdownList.Visible and "▲" or "▼"
    
    if DropdownList.Visible then
        updateDropdown()
        local playerCount = #Players:GetPlayers() - 1
        local listHeight = math.min(playerCount * 37, 100) -- Maksimal 100px tinggi
        TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, listHeight)}):Play()
    else
        TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()
    end
end)

-- Revive Selected
ReviveSelectedButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        sendReviveRequest(selectedPlayer)
        
        -- Button animation
        TweenService:Create(ReviveSelectedButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 150, 230)}):Play()
        wait(0.1)
        TweenService:Create(ReviveSelectedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 120, 200)}):Play()
    else
        -- Error animation
        TweenService:Create(ReviveSelectedButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()
        wait(0.1)
        TweenService:Create(ReviveSelectedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 120, 200)}):Play()
    end
end)

-- Revive All
ReviveAllButton.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        sendReviveRequest(player)
        wait(0.05) -- Small delay to avoid spam
    end
    
    -- Button animation
    TweenService:Create(ReviveAllButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(230, 100, 100)}):Play()
    wait(0.1)
    TweenService:Create(ReviveAllButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()
end)

-- Toggle (Hide/Show entire UI)
local hideNotificationShown = false

local function toggleUI()
    isUIHidden = not isUIHidden
    
    if isUIHidden then
        -- Hide entire UI
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        MainFrame.Visible = false
        
        -- Show floating button
        FloatingToggle.Visible = true
        FloatingToggle.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(FloatingToggle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
        
        -- Show hint notification (only once)
        if not hideNotificationShown then
            hideNotificationShown = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Revive UI Hidden";
                Text = "Click the floating eye button to show";
                Duration = 3;
            })
        end
    else
        -- Hide floating button
        TweenService:Create(FloatingToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        wait(0.3)
        FloatingToggle.Visible = false
        
        -- Show entire UI
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = UDim2.new(0.5, -175, 0.5, -200)
        }):Play()
    end
end

ToggleButton.MouseButton1Click:Connect(toggleUI)
FloatingToggle.MouseButton1Click:Connect(toggleUI)

-- Pulse animation untuk floating button
spawn(function()
    while wait() do
        if FloatingToggle.Visible then
            TweenService:Create(FloatingToggle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 55, 0, 55)
            }):Play()
            wait(0.8)
            TweenService:Create(FloatingToggle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
            wait(0.8)
        else
            wait(1)
        end
    end
end)

-- Keybind untuk Show/Hide UI (Right Ctrl) - Optional untuk PC
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            toggleUI()
        end
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Dragging functionality (FIXED)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Resizing functionality
local resizing = false
local resizeStart, sizeStart

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        sizeStart = MainFrame.Size
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
                originalSize = MainFrame.Size
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
        local delta = input.Position - resizeStart
        local newWidth = math.max(300, sizeStart.X.Offset + delta.X)
        local newHeight = math.max(350, sizeStart.Y.Offset + delta.Y) -- Update minimum height
        
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHoverEffect(ReviveSelfButton, Color3.fromRGB(50, 150, 100), Color3.fromRGB(70, 180, 120))
addHoverEffect(ReviveSelectedButton, Color3.fromRGB(80, 120, 200), Color3.fromRGB(100, 150, 230))
addHoverEffect(ReviveAllButton, Color3.fromRGB(200, 80, 80), Color3.fromRGB(230, 100, 100))
addHoverEffect(ToggleButton, Color3.fromRGB(60, 60, 80), Color3.fromRGB(80, 80, 100))
addHoverEffect(CloseButton, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 80, 80))
addHoverEffect(FloatingToggle, Color3.fromRGB(45, 45, 60), Color3.fromRGB(65, 65, 85))

-- Update dropdown when players join/leave
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

-- Initial dropdown update
updateDropdown()
